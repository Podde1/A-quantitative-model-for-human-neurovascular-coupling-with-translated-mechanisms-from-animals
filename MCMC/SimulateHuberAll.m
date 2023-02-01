function [simulationOutput] = SimulateHuberAll(theta, Con, tend,Data,cutOff)

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
    
    logL=0;

    optionsSS = amioption('sensi',0,...
        'maxsteps',1e3);
    optionsSS.sensi = 0;
    try
    %% SS simulation
    Ca_start = 10;

    % steady state simulation
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
    
    logL = logL + cost1+ cost2+ cost3;

    %% construct output matrix
    if logL>cutOff
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
    
    catch
        simulationOutput = NaN(12,41);
        disp('Failed')
    end
end