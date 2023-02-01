function [simulationOutput] = SimulateDrewAll(theta, Con, stimend,Data,cutOff)
    
    if size(theta,1) > 1
        theta = theta';
    end
    
    if size(theta,1)<=37
        theta(38) = 0; 
    end
    
    theta = 10.^(theta);
    
    options = amioption('sensi',0,...
        'maxsteps',1e4);z
    options.sensi = 0;
    options.nmaxevent = 1e3;
try
    %% SS simulation
    Ca_start = 10;

    % steady state simulation
    sol = simulate_SSModel(inf,theta(4:end),[Ca_start,Con],[],options);

    % assaign values to constants in the stimulation simulation
    HbO_0 = sol.y(2);
    HbR_0 = sol.y(3);
    SaO2_0 = sol.y(4);
    ScO2_0 = sol.y(5);
    SvO2_0 = sol.y(6);
    p1 = 1; 
    p2 = 1; 
    p3 = 1; 
    stim_onoff = 1; 
    
    optionsSS.x0 = sol.x(end,:).';

    TE = 20*10^-3;       B0 = 7;

    Constants = [sol.x(end,[11 9 13]), Ca_start, Con, HbO_0, HbR_0, SaO2_0, ScO2_0, SvO2_0, TE, B0, p1, p2, p3, stim_onoff];

    % alter simulation tolerances, DAE solver can not handle the default values
    optionsSS.atol = 1e-6;
    optionsSS.rtol = 1e-12;

    % Simulations
    %% 20 ms stim
    options = optionsSS; 
    t1 = 0:0.1:stimend(1);
    solReala = simulate_Model(t1,theta, Constants, [], options);
    
    t2 = stimend(1):0.1:Data.D.t(end)-stimend(1);
    Constants(end) = 0;
    options.x0 = solReala.x(end,:)';
    solRealb = simulate_Model(t2,theta, Constants, [], options);
    
    solReal.t = [t1, t2(2:end)+stimend(1)];
    solReal.y = [solReala.y(1,:); solRealb.y(2:end,:)];
    
    if solRealb.status<0
        throw(MException('error'))
    end
    
    %% 10 s stim
    options = optionsSS;
    options.atol = 1e-5;
    options.rtol = 1e-8;
    
    Constants(5) = stimend(2);
    Constants(end) = 1;
    t1 = 0:0.1:stimend(2);
    solReal10a = simulate_Model(t1,theta, Constants, [], options);
    
    t2 = stimend(2):0.1:Data.D10.t(end)-stimend(2);
    Constants(end) = 0;
    options.x0 = solReal10a.x(end,:)';
    solReal10b = simulate_Model(t2,theta, Constants, [], options);
    
    solReal10.t = [t1, t2(2:end)+stimend(2)];
    solReal10.y = [solReal10a.y; solReal10b.y(2:end,:)];
    
    if solReal10b.status<0
        throw(MException('error'))
    end
    
    %% 30 s stim 
    options = optionsSS;
    Constants(5) = stimend(3);
    Constants(end) = 1;
    t1 = 0:0.1:stimend(3); 
    solReal30a = simulate_Model(t1,theta, Constants, [], options);
    
    t2 = stimend(3):0.1:Data.D30.t(end)-stimend(3);
    Constants(end) = 0;
    options.x0 = solReal30a.x(end,:)';
    solReal30b = simulate_Model(t2,theta, Constants, [], options);
    
    solReal30.t = [t1, t2(2:end)+stimend(3)];
    solReal30.y = [solReal30a.y; solReal30b.y(2:end,:)];
    
    if solReal30b.status<0
        throw(MException('error'))
    end
  
    %% extract data time points from high resolution time vector
    [~,dataPosition] = intersect(solReal.t, Data.D.t(2:end));
    [~,dataPosition10] = intersect(solReal10.t, Data.D10.t(2:end));
    [~,dataPosition30] = intersect(solReal30.t, Data.D30.t(2:end));
    
    % chi2 cost
    cost0_02 = sum((solReal.y(dataPosition,1) - Data.D.Y(2:end,1)).^2./(Data.D.Sigma_Y(2:end,1).^2)) + sum((solReal.y(dataPosition,2) - Data.D.Y(2:end,2)).^2./(Data.D.Sigma_Y(2:end,2).^2));
    cost10 = sum((solReal10.y(dataPosition10,1) - Data.D10.Y(2:end,1)).^2./(Data.D10.Sigma_Y(2:end,1).^2)) + sum((solReal10.y(dataPosition10,2) - Data.D10.Y(2:end,2)).^2./(Data.D10.Sigma_Y(2:end,2).^2));
    cost30 = sum((solReal30.y(dataPosition30,1) - Data.D30.Y(2:end,1)).^2./(Data.D30.Sigma_Y(2:end,1).^2)) + sum((solReal30.y(dataPosition30,2) - Data.D30.Y(2:end,2)).^2./(Data.D30.Sigma_Y(2:end,2).^2));

    logL = cost0_02 + cost10 + cost30;
    
    %% construct output matrix
    if logL>cutOff
        simulationOutput = NaN(6,size(solReal30.y,1));
        disp('Larger than cut-off')   
        
    else
        simulationOutput = [[solReal.y(:,1)' nan(1,size(solReal30.y,1)-size(solReal.y,1))]
            [solReal.y(:,2)' nan(1,size(solReal30.y,1)-size(solReal.y,1))]
            [solReal10.y(:,1)' nan(1,size(solReal30.y,1)-size(solReal10.y,1))]
            [solReal10.y(:,2)' nan(1,size(solReal30.y,1)-size(solReal10.y,1))]
            solReal30.y(:,1)'
            solReal30.y(:,2)'
        ];
    end
catch
    simulationOutput = NaN(6,size(solReal30.y,1));
    disp('Failed')
end 
end