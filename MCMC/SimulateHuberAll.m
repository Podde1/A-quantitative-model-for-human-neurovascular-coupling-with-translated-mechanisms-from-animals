function [simulationOutput] = SimulateHuberAll(theta, Con, tend,Data,cutOff)

%% THETA 41 42 are called in constants - ALREADY USED!!!

% %% Negative BOLD
 thetaneg = theta(1:37);
 thetaneg([1 2 3]) = theta(43:45);
 thetaneg(4:9)=theta(46:51);
 thetaneg(10:12) = theta(55:57);

%% Excitatory CBVa, v, t
theta2 = theta(1:37);
theta2([1 2 3]) = theta(38:40);

% %% Inhibitory CBVa, v, t
  theta3 = thetaneg(1:37);
  theta3([1 2 3]) = theta(52:54);
  
logL=0;
dlogL = zeros(numel(theta),1);

options = amioption('sensi',0,...
    'maxsteps',1e3);
options.sensi = 0;

%% SS simulation
Ca_start = 10;

% steady state simulation
sol = simulate_SSmodel(inf,theta(4:37),[Ca_start,Con],[],options);
% assaign values to constants in the stimulation simulation

options.x0 = sol.x(end,:).';

tstart = 0.0001;
TE = 20*10^-3;       B0 = 7;

HbO_0 = sol.y(2);
HbR_0 = sol.y(3);
SaO2_0 = sol.y(4);
ScO2_0 = sol.y(5);
SvO2_0 = sol.y(6);

Constants = [sol.x(end,[11 9 13]), Ca_start, tstart, tend(1), Con, HbO_0, HbR_0, SaO2_0, ScO2_0, SvO2_0, TE, B0];

% alter simulation tolerances, DAE solver can not handle the default values
options.atol = 1e-5;
options.rtol = 1e-6;
%% Simulations

PosSim_CBV_BOLD = simulate_Huber(0:1.5:60, theta(1:37), Constants, [], options);
NegSim_CBV_BOLD = simulate_HuberNeg(0:1.5:60, thetaneg, [Constants,theta(41), theta(42)], [], options);
    costCBVpos1 = sum((PosSim_CBV_BOLD.y(1:2:end-2,2) - Data.CBVPos.Y).^2./(Data.CBVPos.Sigma_Y.^2));
    costBOLDpos1 = sum((PosSim_CBV_BOLD.y([1 2:2:end-1],1) - Data.BOLDPos.Y).^2./(Data.BOLDPos.Sigma_Y.^2));

    costCBVneg1 = sum((NegSim_CBV_BOLD.y(1:2:end-2,2) - Data.CBVNeg.Y).^2./(Data.CBVNeg.Sigma_Y.^2));
    costBOLDneg1 = sum((NegSim_CBV_BOLD.y([1 2:2:end-1],1) - Data.BOLDNeg.Y).^2./(Data.BOLDNeg.Sigma_Y.^2));
        cost1 =   costBOLDpos1+ costCBVpos1+ costCBVneg1 + costBOLDneg1;

ExcitatorySim = simulate_Huber(0:1.5:60, theta2, Constants, [], options);
    costCBVpos2 = sum((ExcitatorySim.y(1:2:end-2,2) - Data.CBVExcitatoryTotal.Y).^2./(Data.CBVExcitatoryTotal.Sigma_Y.^2));

InhibitatorySim = simulate_HuberNeg(0:1.5:60, theta3, [Constants,theta(41), theta(42)], [], options);
    costCBVneg3 = sum((InhibitatorySim.y(1:2:end-2,2) - Data.CBVIhibitatoryTotal.Y).^2./(Data.CBVIhibitatoryTotal.Sigma_Y.^2));
    
    
    logL = logL + cost1+ costCBVpos2+ costCBVneg3;

%% construct output matrix
    if (PosSim_CBV_BOLD.status<0 || NegSim_CBV_BOLD.status<0 || ExcitatorySim.status<0 || InhibitatorySim.status<0)
        simulationOutput = NaN(12,41);
        disp('Failed')
    elseif logL>cutOff
        simulationOutput = NaN(12,41);
        disp('Larger than cut-off')    
    else
        simulationOutput = [PosSim_CBV_BOLD.y(:,2).'
                            NegSim_CBV_BOLD.y(:,2).'
                            ExcitatorySim.y(:,2).'
                            100*((ExcitatorySim.x(:,14) - 0.29)./1).'
                            100*((ExcitatorySim.x(:,16) - 0.27)./1).'
                            InhibitatorySim.y(:,2).'
                            100*((InhibitatorySim.x(:,14) - 0.29)./1).'
                            100*((InhibitatorySim.x(:,16)- 0.27)./1).'
                            PosSim_CBV_BOLD.y(:,1).'
                            NegSim_CBV_BOLD.y(:,1).'
                            PosSim_CBV_BOLD.y(:,5).'
                            NegSim_CBV_BOLD.y(:,5).'
                            ];
    end
end