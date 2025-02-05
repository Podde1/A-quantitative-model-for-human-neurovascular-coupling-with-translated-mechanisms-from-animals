function [f,c,gf,gc] = Cost_Huber(theta,Data,Con,tend,FID)

    if size(theta,1) > 1
            theta = theta';
    end

    % obs theta(41:42) are the sign parameters
    thetapos = theta(1:37);
    
    if size(thetapos,1) <= 37
        thetapos(38) = 0;
    end
    
    thetaneg = theta(1:37);
    thetaneg([1 2 3]) = theta(43:45);
    thetaneg(4:9)=theta(46:51);
    thetaneg(10:12) = theta(55:57);
    
    if size(thetaneg,1) <= 37
        thetaneg(38) = 0;
    end
    
    % Excitatory
    theta2 = theta(1:37);
    theta2([1 2 3]) = theta(38:40);
    
    if size(theta2,1) <= 37
        theta2(38) = 0;
    end
    
    % Inhibitory 
    theta3 = thetaneg(1:37);
    theta3([1 2 3]) = theta(52:54);
    
    if size(theta3,1) <= 37
        theta3(38) = 0;
    end
    
    thetapos = 10.^(thetapos);
    thetaneg = 10.^(thetaneg);
    theta2 = 10.^(theta2);
    theta3 = 10.^(theta3);
    
    % simulation settings
    logL=0;
    dlogL = zeros(numel(theta),1);

    optionsSS = amioption('sensi',0,...
        'maxsteps',1e3);
    optionsSS.sensi = 0;
    
    try
    %% Steady state simulation
    Ca_start = 10;

    sol = simulate_SSModel(inf,thetapos(4:38),[Ca_start,Con],[],optionsSS);

    % assaign values to constants in the stimulation simulation
    optionsSS.x0 = sol.x(end,:).';

    TE = 20*10^-3;       B0 = 7;

    HbO_0 = sol.y(2);
    HbR_0 = sol.y(3);
    SaO2_0 = sol.y(4);
    ScO2_0 = sol.y(5);
    SvO2_0 = sol.y(6);
    p1 = 1; 
    p2 = 1; 
    p3 = 1; 
    stim_onoff = 1; 
    
    Constants = [sol.x(end,[11 9 13]), Ca_start, Con, HbO_0, HbR_0, SaO2_0, ScO2_0, SvO2_0, TE, B0, p1, p2, p3, stim_onoff];
    
    p1_neg = theta(41); 
    p2_neg = theta(42); 
    p3_neg = -1; 
    
    Constants_neg = [sol.x(end,[11 9 13]), Ca_start, Con, HbO_0, HbR_0, SaO2_0, ScO2_0, SvO2_0, TE, B0, p1_neg, p2_neg, p3_neg, stim_onoff];
    
    % alter simulation tolerances, DAE solver can not handle the default values
    optionsSS.atol = 1e-5;
    optionsSS.rtol = 1e-6;

    optionsPos = optionsSS;
    optionsNeg = optionsSS;
    optionsExc = optionsSS;
    optionsInh = optionsSS;

    %% Simulations
    %positive
    t1 = [0,0.5, 1.5:1.5:tend(1)];
    PosSim_CBV_BOLD = simulate_Model(t1, thetapos, Constants, [], optionsPos);
    
    optionsPos.x0 = PosSim_CBV_BOLD.x(end,:)';
    Constants(end) = 0;
    t2 = (tend(1):1.5:60) -tend(1);
    PosSim_CBV_BOLD2 = simulate_Model(t2, thetapos, Constants, [], optionsPos); 
    
    SimPos.y = [PosSim_CBV_BOLD.y ; PosSim_CBV_BOLD2.y(2:end,:)];
    SimPos.x = [PosSim_CBV_BOLD.x ; PosSim_CBV_BOLD2.x(2:end,:)];

    if PosSim_CBV_BOLD.status<0
        throw(MException('error'))
    end
    
    %negative
    t1 = [0,0.5, 1.5:1.5:tend(1)];
    NegSim_CBV_BOLD = simulate_Model(t1, thetaneg, Constants_neg, [], optionsNeg);
    
    optionsNeg.x0 = NegSim_CBV_BOLD.x(end,:)';
    Constants_neg(end) = 0;
    t2 = (tend(1):1.5:60) -tend(1);
    NegSim_CBV_BOLD2 = simulate_Model(t2, thetaneg, Constants_neg, [], optionsNeg);
    
    SimNeg.y = [NegSim_CBV_BOLD.y ; NegSim_CBV_BOLD2.y(2:end,:)];
    SimNeg.x = [NegSim_CBV_BOLD.x ; NegSim_CBV_BOLD2.x(2:end,:)];

    if NegSim_CBV_BOLD2.status<0
        throw(MException('error'))
    end
    
    %excitatory
    Constants(end) = 1;
    t1 = [0,0.5, 1.5:1.5:tend(1)];
    ExcitatorySim = simulate_Model(t1, theta2, Constants, [], optionsExc);
    
    optionsExc.x0 = ExcitatorySim.x(end,:)';
    Constants(end) = 0;
    t2 = (tend(1):1.5:60) - tend(1);
    ExcitatorySim2 = simulate_Model(t2, theta2, Constants, [], optionsExc);
    
    SimExc.y = [ExcitatorySim.y ; ExcitatorySim2.y(2:end,:)];
    SimExc.x = [ExcitatorySim.x ; ExcitatorySim2.x(2:end,:)];
     
    if ExcitatorySim.status<0
        throw(MException('error'))
    end
    
    %inhibitory
    Constants_neg(end) = 1;
    t1 = [0,0.5, 1.5:1.5:tend(1)];
    InhibitatorySim = simulate_Model(t1, theta3, Constants_neg, [], optionsInh);
    
    optionsInh.x0 = InhibitatorySim.x(end,:)'; 
    Constants_neg(end) = 0;
    t2 = (tend(1):1.5:60) - tend(1);
    InhibitatorySim2 = simulate_Model(t2, theta3, Constants_neg, [], optionsInh);
    
    SimInh.y = [InhibitatorySim.y ; InhibitatorySim2.y(2:end,:)];
    SimInh.x = [InhibitatorySim.x ; InhibitatorySim2.x(2:end,:)];
   
    if InhibitatorySim2.status<0
     throw(MException('error'))
    end
    
    %% costs 
    costCBVpos1 = sum((SimPos.y([1,4:2:end-2],9) - Data.CBVPos.Y).^2./(Data.CBVPos.Sigma_Y.^2));
    costBOLDpos1 = sum((SimPos.y([1, 3:2:end-1],7) - Data.BOLDPos.Y).^2./(Data.BOLDPos.Sigma_Y.^2));
    
    costCBVneg1 = sum((SimNeg.y([1,4:2:end-2],9) - Data.CBVNeg.Y).^2./(Data.CBVNeg.Sigma_Y.^2));
    costBOLDneg1 = sum((SimNeg.y([1, 3:2:end-1],7) - Data.BOLDNeg.Y).^2./(Data.BOLDNeg.Sigma_Y.^2));

    %BOLD % CBV, positive and negative
    cost1 =   costBOLDpos1+ costCBVpos1+ costCBVneg1 + costBOLDneg1;

    % excitatory CBV total
    cost2 = sum((SimExc.y([1,4:2:end-2],9) - Data.CBVExcitatoryTotal.Y).^2./(Data.CBVExcitatoryTotal.Sigma_Y.^2));
    
    % inhibitory CBV total
    cost3 = sum((SimInh.y([1,4:2:end-2],9) - Data.CBVIhibitatoryTotal.Y).^2./(Data.CBVIhibitatoryTotal.Sigma_Y.^2));
    
    %% penalty Postive simulation
    NOVSM1  = thetapos(27)*(SimPos.x(:,11)-SimPos.x(1,11));
    PGEVSM1 = thetapos(28)*(SimPos.x(:,9)-SimPos.x(1,9));
    NPYVSM1 = thetapos(29)*(SimPos.x(:,13)-SimPos.x(1,13));

    straff11 = 1e2*sum(NPYVSM1(2:35) < 0);
    straff12 = 0e1*sum(NOVSM1(2) < PGEVSM1(2));                     %force NO to contribute
    straff13 = 1e2*sum(NPYVSM1(30:end-2) < abs(PGEVSM1(30:end-2))); %force NPY to contribute   
    straff14 = 1e2*sum(NOVSM1(5:12) > -0.1.*abs(PGEVSM1(5:12)));
    straff15 = 1e2*sum(NPYVSM1(5:20) > PGEVSM1(5:20));

    straff1 = straff11 + straff12 + straff13 + straff14 + straff15;

    %% penalty Excitatory simulation
    NOVSM3  = theta2(27)*(SimExc.x(:,11)-SimExc.x(1,11));
    PGEVSM3 = theta2(28)*(SimExc.x(:,9)-SimExc.x(1,9));
    NPYVSM3 = theta2(29)*(SimExc.x(:,13)-SimExc.x(1,13));

    straff31 = 1e2*sum(NPYVSM3(2:35) < 0);
    straff32 = 0e1*sum(NOVSM3(2) < PGEVSM3(2));                     %force NO to contribute
    straff33 = 1e2*sum(NPYVSM3(30:end-2) < abs(PGEVSM3(30:end-2))); %force NPY to contribute   
    straff34 = 1e2*sum(NOVSM3(5:12) > -0.1.*abs(PGEVSM3(5:12)));
    straff35 = 1e2*sum(NPYVSM3(5:20) > PGEVSM3(5:20));

    straff3 = straff31 + straff32 + straff33 + straff34 + straff35;

    %% penalty Negative simulation
    NOVSM2  = thetaneg(27)*(SimNeg.x(:,11)-SimNeg.x(1,11));
    PGEVSM2 = thetaneg(28)*(SimNeg.x(:,9)-SimNeg.x(1,9));
    NPYVSM2 = thetaneg(29)*(SimNeg.x(:,13)-SimNeg.x(1,13));

    straff21 = 1e2*sum(PGEVSM2(29:end-2) > -NPYVSM2(29:end-2));
    straff22 = 1e2*sum(NOVSM2(15:20) > -NPYVSM2(15:20));
    straff23 = 1e2*sum(NOVSM2(15:20) < 0);

    straff2 = straff21 + straff22 + straff23; 

    %% penalty Inhibitory simulation
    NOVSM4  = theta3(27)*(SimInh.x(:,11)-SimInh.x(1,11));
    PGEVSM4 = theta3(28)*(SimInh.x(:,9)-SimInh.x(1,9));
    NPYVSM4 = theta3(29)*(SimInh.x(:,13)-SimInh.x(1,13));

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
    straff61 = 1e0*sum((abs(SimPos.y(4:23,4)) < 2*abs(SimPos.y(4:23,5))).*(abs(SimPos.y(4:23,4)) - 2*abs(SimPos.y(4:23,5))));
    straff62 = 1e-1*sum((abs(SimPos.y(4:23,4)) > 4*abs(SimPos.y(4:23,5))).*(abs(SimPos.y(4:23,4)) - 4*abs(SimPos.y(4:23,5))));

    straffHb = straff61 + straff62;


    %% total cost
    straff = straff1 + straff2 + straff3 + straff4 + straffLFP + straffHb;
    cost = cost1+ cost2 + cost3;% + cost4;

    logL = logL + cost + straff;
    
    f = logL;
    gf = dlogL;
    c = [];
    gc = [];

    %% MCMC related, save parameters to file
   if nargin == 5 && logL < chi2inv(0.95,122) 
        fprintf(FID,'%4.10f %10.10f ',[f, theta']); fprintf(FID,'\n');
   end
   
   catch
        f = 1e20;
        gf = dlogL;
        c = [];
        gc = [];
    end
end