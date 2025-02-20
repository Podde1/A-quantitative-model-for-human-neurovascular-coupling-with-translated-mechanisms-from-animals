function [model] = ModelDesjardinsSensory_syms()

%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Could be replaced with an nested for loop in Cost_Desjardins (like the
%%% implementation for OGinhibitatory/OGexcitatory 20 sec stim duration. 
%%% However, it is convenient to do it within this model file instead. 
%%%%%%%%%%%%%%%%%%%%%%%%%

% set the parametrisation of the problem options are 'log', 'log10' and 'lin'

model.param = 'lin';

%%
% STATES
% create state syms 
syms N_NO N_NPY N_Pyr Ca_NO Ca_NPY Ca_Pyr AA PGE2 PGE2vsm NO NOvsm NPY NPYvsm V1 V2 V3 f1 f2 f3 nO2_1 nO2_2 nO2_3 nO2_t
% create state vector
model.sym.x = [N_NO, N_NPY, N_Pyr, Ca_NO, Ca_NPY, Ca_Pyr, AA, PGE2, PGE2vsm, NO, NOvsm, NPY, NPYvsm, V1, V2, V3, f1, f2, f3, nO2_1, nO2_2, nO2_3, nO2_t ];
%%
% PARAMETERS ( for these sensitivities will be computed )

% create parameter syms                                                                
syms k_u1 k_u2 k_u3 kPF1 kPF2 kIN kIN2 kINF kINF2 sinkN_NO sinkN_NPY sinkN_Pyr sinkCa_NO sinkCa_NPY sinkCa_Pyr kPL kCOX kPGE2 sinkPGE2 kNOS kNO sinkNO kNPY Vmax Km sinkNPY ky1 ky2 ky3 K1 K2 K3 vis1 vis2 vis3 kscalemet Km2 ky4

% create parameter vector 
model.sym.p = [k_u1, k_u2, k_u3, kPF1, kPF2, kIN, kIN2, kINF, kINF2, sinkN_NO, sinkN_NPY, sinkN_Pyr, sinkCa_NO, sinkCa_NPY, sinkCa_Pyr, kPL, kCOX, kPGE2, sinkPGE2, kNOS, kNO, sinkNO, kNPY, Vmax, Km, sinkNPY, ky1, ky2, ky3, K1, K2, K3, vis1, vis2, vis3, kscalemet, Km2, ky4];
%%  
% CONSTANTS ( for these no sensitivities will be computed )
% this part is optional and can be omitted

% create parameter syms
syms NOvsm0 PGE2vsm0 NPYvsm0 kCa g_1 g_2 g_3 g_s CMRO2_0 CO2_l pO2_femart HbO_0 HbR_0 SaO2_0 ScO2_0 SvO2_0 TE B0 p1 p2 p3 stim_onoff
% create parameter vector 
model.sym.k = [NOvsm0, PGE2vsm0, NPYvsm0, kCa, g_1, g_2, g_3 ,g_s , CMRO2_0, CO2_l, pO2_femart, HbO_0, HbR_0, SaO2_0, ScO2_0, SvO2_0, TE, B0, p1, p2, p3, stim_onoff];

%%
% SYSTEM EQUATIONS
% create symbolic variable for time
syms t
model.sym.xdot = sym(zeros(size(model.sym.x)));

u = stim_onoff * ( am_if(am_lt(t-floor(t),0.1),1,0)    +    am_if(am_lt(t-floor(t),0.43),1,0)*am_if(am_gt(t-floor(t),0.33),1,0)       +     am_if(am_lt(t-floor(t),0.76),1,0)*am_if(am_gt(t-floor(t),0.66),1,0) );

model.sym.xdot(1) = p1*k_u1*u +kPF1*am_max(0,N_Pyr) -kIN*am_max(0,N_NPY) -sinkN_NO*N_NO;
model.sym.xdot(2) = p2*k_u2*u +kPF2*am_max(0,N_Pyr) -kIN2*am_max(0,N_NO) -sinkN_NPY*N_NPY;
model.sym.xdot(3) = p3*k_u3*u -kINF*N_NO -kINF2*N_NPY -sinkN_Pyr*N_Pyr;


%% Calcium dynamics
model.sym.xdot(4) = kCa*(1+N_NO)-sinkCa_NO*Ca_NO;
model.sym.xdot(5) = kCa*(1+N_NPY)-sinkCa_NPY*Ca_NPY;
model.sym.xdot(6) = kCa*(1+N_Pyr)-sinkCa_Pyr*Ca_Pyr;

%% Pyramidal intracellular signaling AA->PGE2
model.sym.xdot(7) = kPL*Ca_Pyr-kCOX*AA/(Km2+AA);
model.sym.xdot(8) = kCOX*AA/(Km2+AA)-kPGE2*PGE2;
model.sym.xdot(9) = kPGE2*PGE2-sinkPGE2*PGE2vsm;

%% GABAergic NO signaling
model.sym.xdot(10) = kNOS*Ca_NO-kNO*NO;
model.sym.xdot(11) = kNO*NO-sinkNO*NOvsm;

%% GABAergic NPY signaling
model.sym.xdot(12) = kNPY*Ca_NPY-Vmax*NPY/(Km+NPY);
model.sym.xdot(13) = Vmax*NPY/(Km+NPY)-sinkNPY*NPYvsm;

Artdia = ky1*(NOvsm-NOvsm0) +ky2*(PGE2vsm-PGE2vsm0) -ky3*(NPYvsm-NPYvsm0);

%% circuit
syms C1 C2 C3 f0 R1 R2 R3

V1ss = 0.29;     V2ss = 0.44;     V3ss = 0.27; 
R1ss = 0.74;     R2ss = 0.08;     R3ss = 0.18; 

stim_circ = Artdia;

p1=1;                           p2=1-R1ss;                      p3=1-(R1ss+R2ss);
C1ss = V1ss/(p1 - 0.5*R1ss);    C2ss = V2ss/(p2 - 0.5*R2ss);    C3ss = V3ss/(p3 - 0.5*R3ss);
L1=(R1ss*(V1ss^2))^(1/3);       L2=(R2ss*(V2ss^2))^(1/3);       L3=(R3ss*(V3ss^2))^(1/3);
R1=(L1^3)/(V1^2);               R2=(L2^3)/(V2^2);               R3=(L3^3)/(V3^2);


model.sym.xdot(14) = (1/vis1)*(((K1 -(V1/V1ss))/(K1-1)) + stim_circ - 2*(V1/(C1ss*((R1+R2)*f1+(R2+R3)*f2+R3*f3))));
model.sym.xdot(15) = (1/vis2)*(((K2 -(V2/V2ss))/(K2-1))- 2*(V2/(C2ss*((R2+R3)*f2+R3*f3))));
model.sym.xdot(16) = (1/vis3)*(((K3 -(V3/V3ss))/(K3-1))- 2*(V3/(C3ss*(R3*f3))));

f0 = (2/R1)-((R1+R2)*f1 + (R2+R3)*f2 +R3*f3)/R1;
model.sym.xdot(17) = f0-(1/vis1)*(((K1 -(V1/V1ss))/(K1-1)) + stim_circ - 2*(V1/(C1ss*((R1+R2)*f1+(R2+R3)*f2+R3*f3))))-f1;
model.sym.xdot(18) = f1-(1/vis2)*(((K2 -(V2/V2ss))/(K2-1))- 2*(V2/(C2ss*((R2+R3)*f2+R3*f3))))-f2;
model.sym.xdot(19) = f2-(1/vis3)*(((K3 -(V3/V3ss))/(K3-1))- 2*(V3/(C3ss*(R3*f3))))-f3;

%% Barret Hb and pressure 
CO2_max = 9.26;
V_t = 34.8;
p50 = 36;           h = 2.6;
sigma_O2 = 1.46*10^-3;   

CO2_0 = CO2_max/(10^(log10(pO2_femart/p50)/(-1/h))+1);
CO2_01 = CO2_0 - CO2_l;
CO2_12 = nO2_1/V1;
CO2_23 = nO2_2/V2;
CO2_34 = nO2_3/V3;
CO2_t = nO2_t/V_t;

pO2_01 = p50*((CO2_max/CO2_01) -1)^(-1/h);
pO2_12 = p50*((CO2_max/CO2_12) -1)^(-1/h);
pO2_23 = p50*((CO2_max/CO2_23) -1)^(-1/h);
pO2_34 = p50*((CO2_max/CO2_34) -1)^(-1/h);

pO2_1 = (pO2_01 + pO2_12)/2;
pO2_2 = (pO2_12 + pO2_23)/2;
pO2_3 = (pO2_23 + pO2_34)/2;
pO2_t = CO2_t/sigma_O2;

jO2_1 = g_1*(pO2_1 - pO2_t);
jO2_2 = g_2*(pO2_2 - pO2_t);
jO2_3 = g_3*(pO2_3 - pO2_t);
jO2_s = g_s*(pO2_1 - pO2_3);

CMRO2 = CMRO2_0*(1+ kscalemet*(N_NO+N_NPY+N_Pyr));

model.sym.xdot(20) = f0*CO2_01 - f1*CO2_12 - jO2_1 - jO2_s;
model.sym.xdot(21) = f1*CO2_12 - f2*CO2_23 - jO2_2;
model.sym.xdot(22) = f2*CO2_23 - f3*CO2_34 - jO2_3 + jO2_s;
model.sym.xdot(23) = jO2_1 + jO2_2 + jO2_3 - CMRO2;

SaO2 = ((CO2_01 + CO2_12)/2)/(CO2_max);
ScO2 = ((CO2_12 + CO2_23)/2)/(CO2_max);
SvO2 = ((CO2_23 + CO2_34)/2)/(CO2_max);

HbOa = V1*SaO2;     HbRa = V1*(1-SaO2);          
HbOc = V2*ScO2;     HbRc = V2*(1-ScO2);           
HbOv = V3*SvO2;     HbRv = V3*(1-SvO2);        

HbO = HbOa + HbOc + HbOv;
HbR = HbRa + HbRc + HbRv;

%% BOLD Buxton  
VI = 0.05;
Va0 = V1ss*VI;      Vc0 = V2ss*VI;      Vv0 = V3ss*VI;
Va = V1*VI;         Vc = V2*VI;         Vv = V3*VI;
Ve = 1 - (Va+Vc+Vv);

% Constants
Hct=0.44;           Hct_c=0.33;                 deltaChi=2.64*10^-7;        
gamma=2.68*10^8;    Cav=302.06*Hct + 41.83;     Cc=302.06*Hct_c + 41.83; 
 Aav=14.87*Hct+14.686; Ac=14.87*Hct_c+14.686; 
R2e0=25.1; R2a0=Aav+Cav*((1-SaO2_0).^2); R2c0=Ac+Cc*((1-ScO2_0).^2); R2v0=Aav+Cav*((1-SvO2_0).^2);
lambda=1.15; Se0=exp(-TE*R2e0); Sa0=exp(-TE*R2a0); Sc0=exp(-TE*R2c0); Sv0=exp(-TE*R2v0);
epsA=lambda*(Sa0/Se0); epsC=lambda*(Sc0/Se0); epsV=lambda*(Sv0/Se0);
%epsA=1.3;           epsC=1.02;          epsV=0.5;
preAV=4*pi*Hct*deltaChi*gamma*B0/3;     preC=0.04*((deltaChi*Hct_c*gamma*B0).^2);

% saturation for equal tissue�blood susceptibility
Yoff=0.95;

%Vascular
deltaR2a=Cav*((1-SaO2).^2-((1-SaO2_0).^2));
deltaR2c=Cc*((1-ScO2).^2-((1-ScO2_0).^2));
deltaR2v=Cav*((1-SvO2).^2-((1-SvO2_0).^2));

% Extravascular R2
deltaR2ea=Va*(abs(Yoff-SaO2))-Va0*(abs(Yoff-SaO2_0));
deltaR2ev=Vv*(abs(Yoff-SvO2))-Vv0*(abs(Yoff-SvO2_0));
deltaR2ec=Vc*((abs(Yoff-ScO2)).^2)-Vc0*((abs(Yoff-ScO2_0)).^2);
deltaR2e=preAV*(deltaR2ea+deltaR2ev)+preC*deltaR2ec;

%Signal from each compartment
Sa=epsA*Va*exp(-TE*deltaR2a);
Sc=epsC*Vc*exp(-TE*deltaR2c);
Sv=epsV*Vv*exp(-TE*deltaR2v);
Se=Ve*exp(-TE*deltaR2e);

H=((1 - VI) + epsA*Va0 + epsC*Vc0 + epsV*Vv0);

%% M matrix
    matris = eye(size(model.sym.x,2),size(model.sym.x,2));
    matris(17,17) = 0;  matris(18,18) = 0; matris(19,19) = 0;   
    
    model.sym.M= matris;

%% output simplifications

OutArtdia=(V1/L1).^(1/2);
ssOutArtdia =(V1ss/L1).^(1/2);

OutVendia=(V3/L3).^(1/2);
ssOutVendia =(V3ss/L3).^(1/2);

CBV = V1 + V2 + V3;
CBF = (V1*(f0 + f1) + V2*(f1 + f2) + V3*(f2 + f3))/(2*(V1 + V2 + V3));

BOLDfractional = (1/H)*(Se+Sa+Sc+Sv);
BOLDpercent = 100*((1/H)*(Se+Sa+Sc+Sv)-1);

HbTout = ((V1-V1ss) + (V2-V2ss) + (V3-V3ss))*100; 
HbOout = (HbO - HbO_0)*100;                   
HbRout = (HbR - HbR_0)*100;                   

%%
% INITIAL CONDITIONS
model.sym.x0(1:13) = 0;
model.sym.x0(14:19) = [0.29; 0.44; 0.27; 1; 1; 1];
model.sym.x0(20:23) = 1;

model.sym.dx0 = sym(zeros(size(model.sym.x)));

% OBSERVALES
model.sym.y = sym(zeros(12,1));
model.sym.y(1)=100*(OutArtdia - ssOutArtdia)/ssOutArtdia;
model.sym.y(2)=100*(OutVendia - ssOutVendia)/ssOutVendia;
model.sym.y(3)=HbTout;
model.sym.y(4)=HbOout;
model.sym.y(5)=HbRout;
model.sym.y(6)=BOLDpercent;
model.sym.y(7)=BOLDfractional;
model.sym.y(8)=ky4*N_Pyr;
model.sym.y(9)=100*(CBV-1);
model.sym.y(10)=100*((V1-V1ss)/V1ss + 0.5*(V2-V2ss)/V2ss);
model.sym.y(11)=100*((V3-V3ss)/V3ss + 0.5*(V2-V2ss)/V2ss);
model.sym.y(12)=CBF;
end