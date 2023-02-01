function [f,c,gf,gc] = Cost_Drew_TimeVariant(theta,Data,Con,stimend, FID)

    if size(theta,1) > 1
        theta = theta';
    end
    
    %add ky4 param not used in model
    if size(theta,1)<=41
        theta(42) = 0; 
    end
    theta = 10.^(theta);
    
    %put togheter param vectors
    theta30=theta([1:37, end]);
    theta30(31:32)=theta(38:39);
    theta30(34:35)=theta(40:41);
    
    theta = theta([1:37, end]);
        
    logL=0;
    dlogL = zeros(numel(theta),1);

    optionsSS = amioption('sensi',0,...
        'maxsteps',5e3);
    optionsSS.sensi = 0;
    try 
    %% SS simulation
    Ca_start = 10;

    % steady state simulation
    sol = simulate_SSModel(inf,theta(4:end),[Ca_start,Con],[],optionsSS);

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
    t1 = [Data.D.t(1); stimend(1)];
    solReala = simulate_Model(t1,theta, Constants, [], options);
    
    t2 = [stimend(1); Data.D.t(2:end)]-stimend(1);
    Constants(end) = 0;
    options.x0 = solReala.x(end,:)';
    solRealb = simulate_Model(t2,theta, Constants, [], options);
    
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
    t1 = Data.D10.t(Data.D10.t<=stimend(2));
    solReal10a = simulate_Model(t1,theta, Constants, [], options);
    
    t2 = Data.D10.t(Data.D10.t>=stimend(2))-stimend(2);
    Constants(end) = 0;
    options.x0 = solReal10a.x(end,:)';
    solReal10b = simulate_Model(t2,theta, Constants, [], options);
    
    solReal10.y = [solReal10a.y; solReal10b.y(2:end,:)];
    
    if solReal10b.status<0
        throw(MException('error'))
    end
    
    %% 30 s stim 
    options = optionsSS;
    Constants(5) = stimend(3);
    Constants(end) = 1;
    t1 = Data.D30.t(1:3);
    solReal30a = simulate_Model(t1,theta, Constants, [], options);
    
    options.x0 = solReal30a.x(end,:)';
    t2 = Data.D30.t(3:end);
    t2 = t2(t2<=stimend(3)) - Data.D30.t(3); 
    solReal30b = simulate_Model(t2,theta30, Constants, [], options);
    
    Constants(end) = 0;
    options.x0 = solReal30b.x(end,:)';
    t3 = Data.D30.t(Data.D30.t>=stimend(3))-stimend(3);
    solReal30c = simulate_Model(t3,theta30, Constants, [], options);
    
    solReal30.y = [solReal30a.y; solReal30b.y(2:end,:); solReal30c.y(2:end,:)];
    
    if solReal30c.status<0
        throw(MException('error'))
    end
    
    %%

    cost0_02 = sum((solReal.y(2:end,1) - Data.D.Y(2:end,1)).^2./(Data.D.Sigma_Y(2:end,1).^2)) + sum((solReal.y(2:end,2) - Data.D.Y(2:end,2)).^2./(Data.D.Sigma_Y(2:end,2).^2));
    cost10 = sum((solReal10.y(2:end,1) - Data.D10.Y(2:end,1)).^2./(Data.D10.Sigma_Y(2:end,1).^2)) + sum((solReal10.y(2:end,2) - Data.D10.Y(2:end,2)).^2./(Data.D10.Sigma_Y(2:end,2).^2));
    cost30 = sum((solReal30.y(2:end,1) - Data.D30.Y(2:end,1)).^2./(Data.D30.Sigma_Y(2:end,1).^2)) + 1*sum((solReal30.y(2:end,2) - Data.D30.Y(2:end,2)).^2./(Data.D30.Sigma_Y(2:end,2).^2));

    cost = cost0_02 + cost10 + cost30;
    logL = logL + cost;

    f = logL;
    gf = dlogL;
    c = [];
    gc = [];

    %% MCMC related, save parameters to file
    if nargin == 5 && logL < chi2inv(0.95,288) 
        fprintf(FID,'%4.10f %10.10f ',[f, theta']); fprintf(FID,'\n');
    end

    catch
        f = 1e20;
        gf = dlogL;
        c = [];
        gc = [];    
    end
end