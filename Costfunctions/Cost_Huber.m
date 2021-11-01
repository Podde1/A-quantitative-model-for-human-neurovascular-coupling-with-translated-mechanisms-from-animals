function [f,c,gf,gc] = Cost_Huber(theta,Data,Con,tend,FID)

% %% Negative BOLD
% obs theta(41:42) are the sign parameters sent in with the Constatns
% vector
 thetaneg = theta(1:37);
 thetaneg([1 2 3]) = theta(43:45);
 thetaneg(4:9)=theta(46:51);
 thetaneg(10:12) = theta(55:57);

%% Excitatory CBVa, v, t
theta2 = theta(1:37);
theta2([1 2 3]) = theta(38:40);

%% Inhibitory CBVa, v, t
  theta3 = thetaneg(1:37);
  theta3([1 2 3]) = theta(52:54);
  
%% simulation settings
logL=0;
dlogL = zeros(numel(theta),1);

options = amioption('sensi',0,...
    'maxsteps',1e3);
options.sensi = 0;

%% Steady state simulation
Ca_start = 10;

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

optionsPos = options;
optionsNeg = options;
optionsExc = options;
optionsInh = options;

%% Simulations
    PosSim_CBV_BOLD = simulate_Huber2([0,0.5, 1.5:1.5:tend(1)], theta(1:37), [Constants, 1], [], optionsPos);
    optionsPos.x0 = PosSim_CBV_BOLD.x(end,:)';
    PosSim_CBV_BOLD2 = simulate_Huber2((tend(1):1.5:60) -tend(1), theta(1:37), [Constants, 0], [], optionsPos); 
        SimPos.y = [PosSim_CBV_BOLD.y ; PosSim_CBV_BOLD2.y(2:end,:)];
        SimPos.x = [PosSim_CBV_BOLD.x ; PosSim_CBV_BOLD2.x(2:end,:)];
    
        costCBVpos1 = sum((SimPos.y([1,4:2:end-2],2) - Data.CBVPos.Y).^2./(Data.CBVPos.Sigma_Y.^2));
        costBOLDpos1 = sum((SimPos.y([1, 3:2:end-1],1) - Data.BOLDPos.Y).^2./(Data.BOLDPos.Sigma_Y.^2));

        

    NegSim_CBV_BOLD = simulate_HuberNeg2([0,0.5, 1.5:1.5:tend(1)], thetaneg, [Constants,theta(41), theta(42), 1], [], optionsNeg);
    optionsNeg.x0 = NegSim_CBV_BOLD.x(end,:)';
    NegSim_CBV_BOLD2 = simulate_HuberNeg2([tend(1):1.5:60] -tend(1), thetaneg, [Constants,theta(41), theta(42), 0], [], optionsNeg);
        SimNeg.y = [NegSim_CBV_BOLD.y ; NegSim_CBV_BOLD2.y(2:end,:)];
        SimNeg.x = [NegSim_CBV_BOLD.x ; NegSim_CBV_BOLD2.x(2:end,:)];
    
        costCBVneg1 = sum((SimNeg.y([1,4:2:end-2],2) - Data.CBVNeg.Y).^2./(Data.CBVNeg.Sigma_Y.^2));
        costBOLDneg1 = sum((SimNeg.y([1, 3:2:end-1],1) - Data.BOLDNeg.Y).^2./(Data.BOLDNeg.Sigma_Y.^2));

        %BOLD % CBV, positive and negative
        cost1 =   costBOLDpos1+ costCBVpos1+ costCBVneg1 + costBOLDneg1;

    

    ExcitatorySim = simulate_Huber2([0,0.5, 1.5:1.5:tend(1)], theta2, [Constants, 1], [], optionsExc);
    optionsExc.x0 = ExcitatorySim.x(end,:)';
    ExcitatorySim2 = simulate_Huber2([tend(1):1.5:60] - tend(1), theta2, [Constants, 0], [], optionsExc);
        SimExc.y = [ExcitatorySim.y ; ExcitatorySim2.y(2:end,:)];
        SimExc.x = [ExcitatorySim.x ; ExcitatorySim2.x(2:end,:)];
    
        costCBVpos2 = sum((SimExc.y([1,4:2:end-2],2) - Data.CBVExcitatoryTotal.Y).^2./(Data.CBVExcitatoryTotal.Sigma_Y.^2));
%              costCBVpos2art = sum((100*((SimExc.x([1,4:2:end-2],14) -0.29)./1) - Data.CBVExcitatoryArteriole.Y).^2./(Data.CBVExcitatoryArteriole.Sigma_Y.^2));
%              costCBVpos2ven = sum((100*((SimExc.x([1,4:2:end-2],16) -0.27)./1) - Data.CBVExcitatoryVenule.Y).^2./(Data.CBVExcitatoryVenule.Sigma_Y.^2));

         %pos CBV total, art venule
         cost2 = costCBVpos2;% + costCBVpos2art + costCBVpos2ven;
        


    InhibitatorySim = simulate_HuberNeg2([0,0.5, 1.5:1.5:tend(1)], theta3, [Constants,theta(41), theta(42), 1], [], optionsInh);
    optionsInh.x0 = InhibitatorySim.x(end,:)'; 
    InhibitatorySim2 = simulate_HuberNeg2((tend(1):1.5:60) -tend(1), theta3, [Constants,theta(41), theta(42), 0], [], optionsInh);
        SimInh.y = [InhibitatorySim.y ; InhibitatorySim2.y(2:end,:)];
        SimInh.x = [InhibitatorySim.x ; InhibitatorySim2.x(2:end,:)];
        costCBVneg3 = sum((SimInh.y([1,4:2:end-2],2) - Data.CBVIhibitatoryTotal.Y).^2./(Data.CBVIhibitatoryTotal.Sigma_Y.^2));
%             costCBVneg3art = sum((100*((SimInh.x([1,4:2:end-2],14)-0.29)./1) - Data.CBVInhibitatoryArteriole.Y).^2./(Data.CBVInhibitatoryArteriole.Sigma_Y.^2));
%             costCBVneg3ven = sum((100*((SimInh.x([1,4:2:end-2],16)-0.27)./1) - Data.CBVInhibitatoryVenule.Y).^2./(Data.CBVInhibitatoryVenule.Sigma_Y.^2));
           
             
        % neg CBV total, art, venule
         cost3 = costCBVneg3;% + costCBVneg3art + costCBVneg3ven;
             
%              CBFP = sum((SimPos.y([1,4:2:end-2],5)-Data.CBFPos.Y).^2./(Data.CBFPos.Sigma_Y.^2));
%              CBFN = sum((SimNeg.y([1,4:2:end-2],5)-Data.CBFNeg.Y).^2./(Data.CBFNeg.Sigma_Y.^2));
             
%              %CBF pos and neg
%              cost4 = CBFP + CBFN;
             
     if (PosSim_CBV_BOLD.status<0 || NegSim_CBV_BOLD2.status<0 || ExcitatorySim.status<0 || InhibitatorySim2.status<0)
         logL=NaN;
     else

        % penalty Postive simulation

        NOVSM1 = 10^theta(27)*(SimPos.x(:,11)-SimPos.x(1,11));
        PGEVSM1 = 10^theta(28)*(SimPos.x(:,9)-SimPos.x(1,9));
        NPYVSM1 = 10^theta(29)*(SimPos.x(:,13)-SimPos.x(1,13));
        
        straff11 = 1e2*sum(NPYVSM1(2:35) < 0);
        straff12 = 0e1*sum(NOVSM1(2) < PGEVSM1(2));                     %force NO to contributate
        straff13 = 1e2*sum(NPYVSM1(30:end-2) < abs(PGEVSM1(30:end-2))); %force NPY to contributate   
        straff14 = 1e2*sum(NOVSM1(5:12) > -0.1.*abs(PGEVSM1(5:12)));
        straff15 = 1e2*sum(NPYVSM1(5:20) > PGEVSM1(5:20));
    
        straff1 = straff11 + straff12 + straff13 + straff14 + straff15;
        
        %% penalty Excitatory simulation
        NOVSM3 = 10^theta2(27)*(SimExc.x(:,11)-SimExc.x(1,11));
        PGEVSM3 = 10^theta2(28)*(SimExc.x(:,9)-SimExc.x(1,9));
        NPYVSM3 = 10^theta2(29)*(SimExc.x(:,13)-SimExc.x(1,13));
        
        straff31 = 1e2*sum(NPYVSM3(2:35) < 0);
        straff32 = 0e1*sum(NOVSM3(2) < PGEVSM3(2));                     %force NO to contributate
        straff33 = 1e2*sum(NPYVSM3(30:end-2) < abs(PGEVSM3(30:end-2))); %force NPY to contributate   
        straff34 = 1e2*sum(NOVSM3(5:12) > -0.1.*abs(PGEVSM3(5:12)));
        straff35 = 1e2*sum(NPYVSM3(5:20) > PGEVSM3(5:20));
    
        straff3 = straff31 + straff32 + straff33 + straff34 + straff35;
        
        %% penalty Negative simulation
        NOVSM2 = 10^thetaneg(27)*(SimNeg.x(:,11)-SimNeg.x(1,11));
        PGEVSM2 = 10^thetaneg(28)*(SimNeg.x(:,9)-SimNeg.x(1,9));
        NPYVSM2 = 10^thetaneg(29)*(SimNeg.x(:,13)-SimNeg.x(1,13));
        
        straff21 = 1e2*sum(PGEVSM2(29:end-2) > -NPYVSM2(29:end-2));
        straff22 = 1e2*sum(NOVSM2(15:20) > -NPYVSM2(15:20));
        straff23 = 1e2*sum(NOVSM2(15:20) < 0);
        
        straff2 = straff21 + straff22 + straff23; 
        
        %% penalty Inhibitory simulation
        NOVSM4 = 10^theta3(27)*(SimInh.x(:,11)-SimInh.x(1,11));
        PGEVSM4 = 10^theta3(28)*(SimInh.x(:,9)-SimInh.x(1,9));
        NPYVSM4 = 10^theta3(29)*(SimInh.x(:,13)-SimInh.x(1,13));
        
        straff41 = 1e2*sum(PGEVSM4(30:end-2) > -NPYVSM4(30:end-2));
        straff42 = 1e2*sum(NOVSM4(15:20) > -NPYVSM4(15:20));
        straff43 = 1e2*sum(NOVSM4(15:20) < 0);
        
        straff4 = straff41 + straff42 + straff43; 
         
        %% LFP penalty
        straff51 = 1e2*(SimPos.x(2,3) < 8)*abs((SimPos.x(2,3) - 8));
        straff52 = 1e2*(SimPos.x(2,3) < 1.2*SimPos.x(12,3))*abs((SimPos.x(2,3) - 1.5*SimPos.x(12,3)));
        straff53 = 1e2*(SimPos.x(12,3) < 4)*abs((SimPos.x(12,3) - 4));
        straff54 = 1e2*(SimPos.x(23,3) > -0.05*SimPos.x(2,3))*abs((SimPos.x(23,3) + 0.4*SimPos.x(2,3)));  
        straff55 = 1e2*(SimPos.x(23,3) > -3)*abs((SimPos.x(23,3) - (-3) ));  
       
        straffN51 = 1e2*(SimNeg.x(2,3) > -1.2)*abs((SimNeg.x(2,3) - (-1.2)));
        straffN52 = 1e2*(SimNeg.x(2,3) > 1.2*SimNeg.x(12,3))*abs((SimNeg.x(2,3) - 1.5*SimNeg.x(12,3)));
        straffN53 = 1e2*(SimNeg.x(12,3) > -0.8)*abs((SimNeg.x(12,3) - (-0.8)));
        straffN54 = 1e2*(SimNeg.x(23,3) < -0.20*SimNeg.x(2,3))*abs((SimNeg.x(23,3) + 0.25*SimNeg.x(2,3)));  
        straffN55 = 1e2*(SimNeg.x(23,3) < 0)*abs((SimNeg.x(23,3)));  
        
        LFPPos = straff51 + straff52 + straff53 + straff54 + straff55;
        LFPNeg = straffN51 + straffN52 + straffN53 + straffN54 + straffN55;
        straffLFP = LFPPos + LFPNeg;
        
        %% Hb penalty
        straff61 = 1e0*sum((abs(SimPos.y(4:23,7)) < 2*abs(SimPos.y(4:23,8))).*(abs(SimPos.y(4:23,7)) - 2*abs(SimPos.y(4:23,8))));
        straff62 = 1e-1*sum((abs(SimPos.y(4:23,7)) > 4*abs(SimPos.y(4:23,8))).*(abs(SimPos.y(4:23,7)) - 4*abs(SimPos.y(4:23,8))));
        
        straffHb = straff61 + straff62;

        
        %% total cost
        straff = straff1 + straff3 + straff2 + straff4 + straffLFP + straffHb;
        cost = cost1+ cost2 + cost3;% + cost4;
        
    logL = logL + cost + straff;
     end
f = logL;
gf = dlogL;
c = [];
gc = [];

%% MCMC related, save parameters to file
   if nargin == 6 && logL < chi2inv(0.95,122) 
        fprintf(FID,'%4.10f %10.10f ',[f, theta']); fprintf(FID,'\n');
   end
   
end