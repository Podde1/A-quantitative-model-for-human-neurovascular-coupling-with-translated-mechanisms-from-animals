function [simulationOutput] = SimulateDrewTimeVariantAll(theta, Con, stimend,Data,cutOff)

    options = amioption('sensi',0,...
        'maxsteps',1e4);
    options.sensi = 0;
    options.nmaxevent = 1e3;

    %% SS simulation
    Ca_start = 10;

    % steady state simulation
    sol = simulate_SSmodel(inf,theta(4:end),[Ca_start,Con],[],options);

    % assaign values to constants in the stimulation simulation
    HbO_0 = sol.y(2);
    HbR_0 = sol.y(3);
    SaO2_0 = sol.y(4);
    ScO2_0 = sol.y(5);
    SvO2_0 = sol.y(6);

    options.x0 = sol.x(end,:).';

    TE = 20*10^-3;       B0 = 7;

    Constants = [sol.x(end,[11 9 13]), Ca_start, stimend(1), Con, HbO_0, HbR_0, SaO2_0, ScO2_0, SvO2_0, TE, B0];

    % alter simulation tolerances, DAE solver can not handle the default values
    options.atol = 1e-6;
    options.rtol = 1e-12;
    
    % create resolution time vectors 
    timeV = 0:0.1:Data.D.t(end);
    timeV2 = 0:0.1:Data.D10.t(end);
    timeV3 = 0:0.1:Data.D30.t(3);
    timeV3b = 0:0.1:Data.D30.t(end-2);

    %% Simulations
    solReal = simulate_Drew(timeV,theta(1:37), Constants, [], options);

    Constants(5) = stimend(2);
    theta10 = theta(1:37);
    options.atol = 1e-5;
    options.rtol = 1e-8;
    solReal10 = simulate_Drew(timeV2,theta, Constants, [], options);

    Constants(5) = stimend(3);
    solReal30_1 = simulate_Drew(timeV3,theta10, Constants, [], options);
    options.x0 = solReal30_1.x(end,:).';

    theta30=theta(1:37);
    theta30(31:32)=theta(38:39);
    theta30(34:35)=theta(40:41);

    Constants(5)=stimend(3) - solReal30_1.t(end);
    solReal30_2 = simulate_Drew(timeV3b,theta30, Constants, [], options);
    
    % concatinate the 2 parts of the 30 s stimulation simulation
    solReal30.t=[solReal30_1.t; solReal30_2.t(1:end)+2];
    solReal30.y=[solReal30_1.y; solReal30_2.y(1:end,:)];
    solReal30.x=[solReal30_1.x; solReal30_2.x(1:end,:)];
    
    % extract the data time points from high resolution time vector
    [~,dataPosition] = intersect(solReal.t, Data.D.t(2:end));
    [~,dataPosition10] = intersect(solReal10.t, Data.D10.t(2:end));
    [~,dataPosition30] = intersect(solReal30.t, Data.D30.t(2:end));

    % chi2 cost
    cost0_02 = sum((solReal.y(dataPosition,1) - Data.D.Y(2:end,1)).^2./(Data.D.Sigma_Y(2:end,1).^2)) + sum((solReal.y(dataPosition,2) - Data.D.Y(2:end,2)).^2./(Data.D.Sigma_Y(2:end,2).^2));
    cost10 = sum((solReal10.y(dataPosition10,1) - Data.D10.Y(2:end,1)).^2./(Data.D10.Sigma_Y(2:end,1).^2)) + sum((solReal10.y(dataPosition10,2) - Data.D10.Y(2:end,2)).^2./(Data.D10.Sigma_Y(2:end,2).^2));
    cost30 = sum((solReal30.y(dataPosition30,1) - Data.D30.Y(2:end,1)).^2./(Data.D30.Sigma_Y(2:end,1).^2)) + sum((solReal30.y(dataPosition30,2) - Data.D30.Y(2:end,2)).^2./(Data.D30.Sigma_Y(2:end,2).^2));

    logL = cost0_02 + cost10 +cost30;
    
    %% construct output matrix
    if (solReal.status<0 || solReal10.status<0 || solReal30_1.status<0)
        simulationOutput = NaN(6,size(solReal30.t,1));
        disp('Failed')
        
    elseif logL>cutOff
        simulationOutput = NaN(6,size(solReal30.t,1));
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
end