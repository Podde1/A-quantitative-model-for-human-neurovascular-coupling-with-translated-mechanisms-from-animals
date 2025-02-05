function [f] = Cost_Uhlirova(theta,Data,Con,FID)
    
    if size(theta,1) > 1
        theta = theta';
    end
    
    theta = 10.^(theta);
    %parameter assignment
    pOGinAnes=[theta(1:2), 0, theta(4:37), 0];  % add dummy ku3 and ky4 value
    pOGexAnes=[0, 0, theta(3), theta(4:37), 0]; % add dummy ku1, ku2 and ky4 value
    pSensAnes=[theta(38:40), theta(4:37), 0];   % add dummy ky4 value
    
    thetaAwake=theta(4:37);
    thetaAwake(1:9)=theta(41:49);
    pOGinAwake=[theta(50:51), 0, thetaAwake, 0]; % add dummy ku3 and ky4 value
    pSensAwake=[theta(52:54), thetaAwake, 0];    % add dummy ky4 value   
    
    logL = 0;
    %% simulation options
    optionsSS = amioption('sensi',0,...
     'maxsteps',3e3);
    optionsSS.atol = 1e-9;
    optionsSS.rtol = 1e-18;

    % values for initial parameters
    Ca_start = 10;
    TE = 20*10^-3;       B0 = 7; % Magnetic field parameters for the Uhlirova study

    try
    %% steady state simulation
    sol = simulate_SSModel(inf,pOGinAnes(4:38),[Ca_start,Con],[],optionsSS);

    % Assign values to constants and initial conditions taken from the SS simulation
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
    
    optionsSS.x0 = sol.x(end,:).'; % set initial conditions from SS simulation
    % alter simulation tolerances, DAE solver can not handle the default values
    optionsSS.atol = 1e-6;
    optionsSS.rtol = 1e-12;
    optionsSS.maxsteps=3e3;

    optionsLong=optionsSS; % For the longer paradigm, we allow for more integration steps

    %% Simulations
    % anaesthetized OGexcitatory
    Constants(end) = 0;
    t1 = 0:0.1:0.9;
    simOGex1 = simulate_Model(t1,pOGexAnes,Constants, [], optionsLong);
    
    optionsLong.x0 = simOGex1.x(end,:)';
    Constants(end) = 1;
    t2 = [0.9 1.0] - 0.9;
    simOGex2 = simulate_Model(t2,pOGexAnes,Constants, [], optionsLong);
    
    optionsLong.x0 = simOGex2.x(end,:)';
    Constants(end) = 0;
    t3 = (1.0:1.0:Data(1).t(end)) - 1.0;
    simOGex3 = simulate_Model(t3,pOGexAnes,Constants, [], optionsLong);
    
    simOGex.t = [t1 t2(2:end)+0.9 t3(2:end)+1.0];
    simOGex.y = [simOGex1.y; simOGex2.y(2:end,:); simOGex3.y(2:end,:)];
    idx = ismember(simOGex.t, Data(1).t);
    
    cOGex = sum( (Data(1).Y - simOGex.y(idx,1)).^2 ./ Data(1).Sigma_Y.^2 );
    
    if simOGex3.status < 0
        throw(MException('error'))
    end
    
    % anaesthetized OGinhibitory
    optionsLong = optionsSS;
    Constants(end) = 0;
    t1 = 0:0.05:0.55;
    simOGin1 = simulate_Model(t1,pOGinAnes,Constants, [], optionsLong);
    
    optionsLong.x0 = simOGin1.x(end,:)';
    Constants(end) = 1;
    t2 = (0.55:0.05:1.0) - 0.55;
    simOGin2 = simulate_Model(t2,pOGinAnes,Constants, [], optionsLong);
    
    optionsLong.x0 = simOGin2.x(end,:)';
    Constants(end) = 0;
    t3 = (1.0:1.0:Data(2).t(end)) - 1.0;
    simOGin3 = simulate_Model(t3,pOGinAnes,Constants, [], optionsLong);
    
    SimOGin.t = [t1 t2(2:end)+0.55 t3(2:end)+1.0];
    SimOGin.y = [simOGin1.y; simOGin2.y(2:end,:); simOGin3.y(2:end,:)];
    idx = ismember(SimOGin.t, Data(2).t);
    
    cOGin = sum( (Data(2).Y - SimOGin.y(idx,1)).^2 ./ Data(2).Sigma_Y.^2 );
    
    if simOGin3.status < 0
        throw(MException('error'))
    end
    
    % anaesthetized sensory
    optionsLong = optionsSS;
    Constants(end) = 1;
    t1 = 0:0.1:2;
    simSens1 = simulate_Model(t1,pSensAnes,Constants,[],optionsLong);
    
    Constants(end)=0;
    optionsLong.x0 = simSens1.x(end,:)';
    t2 = (2:0.1:Data(3).t(end)) - 2;
    simSens2 = simulate_Model(t2,pSensAnes,Constants,[],optionsLong);
    
    SimSens.t = [t1 t2(2:end)+2];
    SimSens.y = [simSens1.y; simSens2.y(2:end,:)];
    idx = ismembertol(SimSens.t, Data(3).t, 1e-15);
    
    cSens = sum( (Data(3).Y - SimSens.y(idx,1)).^2 ./ Data(3).Sigma_Y.^2 );
    
    if simSens2.status < 0
        throw(MException('error'))
    end
    
    % Awake sensory
    optionsLong = optionsSS;
    Constants(end) = 1;
    t1 = 0:0.1:1.0;
    simSensAw1 = simulate_Model(t1,pSensAwake,Constants,[],optionsLong);
    
    optionsLong.x0 = simSensAw1.x(end,:)';
    Constants(end)=0;
    t2 = (1.0:0.1:Data(5).t(end)) - 1.0;
    simSensAw2 = simulate_Model(t2,pSensAwake,Constants,[],optionsLong);
    
    SimSensAw.t = [t1 t2(2:end)+1.0];
    SimSensAw.y = [simSensAw1.y; simSensAw2.y(2:end,:)];
    idx = ismembertol(SimSensAw.t, Data(5).t, 1e-15);
    
    cSensAw = sum( (Data(5).Y - SimSensAw.y(idx,1)).^2 ./ Data(5).Sigma_Y.^2 );
    
    if simSensAw2.status < 0
        throw(MException('error'))
    end
    
    % Awake OGinhibitory
    optionsLong = optionsSS;
    Constants(end) = 1;
    t1 = 0:0.1:0.4;
    simOGinAw1 = simulate_Model(t1,pOGinAwake,Constants, [], optionsLong);
    
    optionsLong.x0 = simOGinAw1.x(end,:)';
    Constants(end)=0;
    t2 = (0.4:0.1:Data(4).t(end)) -0.4;
    simOGinAw2 = simulate_Model(t2,pOGinAwake,Constants, [], optionsLong);
    
    simOGinAw.t = [t1 t2(2:end)+0.4];
    simOGinAw.y = [simOGinAw1.y; simOGinAw2.y(2:end,:)];
    idx = ismembertol(simOGinAw.t, Data(4).t, 1e-15);
    
    cOGinAw = sum( (Data(4).Y - simOGinAw.y(idx,1)).^2 ./ Data(4).Sigma_Y.^2 );
    
    if simOGinAw2.status < 0
        throw(MException('error'))
    end
    
    f=logL + cOGex + cOGin + cSens + cSensAw + cOGinAw;

    %% MCMC related, save parameters to file
    if nargin == 4 && logL  < chi2inv(0.95,190) %% 190 data points in estimation data
        fprintf(FID,'%4.10f %10.10f ',[f, theta']); fprintf(FID,'\n');
    end
    
    catch 
        f = 1e20; 
    end
end