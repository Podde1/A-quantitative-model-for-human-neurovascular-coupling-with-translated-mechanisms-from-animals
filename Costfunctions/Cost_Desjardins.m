function [f,c,gf,gc] = Cost_Desjardins(theta,Data,Con,tend, FID)

    logL = 0;
    dlogL = zeros(numel(theta),1);
    
    if size(theta,1) > 1
        theta = theta';
    end
    
    theta = 10.^(theta); 
    
    pOGin = [theta(1:2) 0 theta(3:36) 0];       % add dummy ku3 and ky4
    pOGex = [0 0 theta(37) theta(3:36) 0];      % add dummy ku1, ku2 and ky4
    pSensLong = [theta(38:40) theta(3:36) 0];   % add dummy ky4
    pSensShort = [theta(41:43) theta(3:36) 0];  % add dummy ky4

    % simoptions
    options = amioption('sensi',0,...
        'maxsteps',1e5);
    options.sensi = 0;
    options.nmaxevent=1e4;
    
    % inital value of Calcium
    Ca_start = 10;

    % steady state simulation
    options.atol = 1e-9;
    options.rtol = 1e-16;
    sol = simulate_SSModel(inf,pOGin(4:38),[Ca_start,Con],[],options);

    % assaign values to constants and intitaial conditions in the stimulation simulation
    HbO_0 = sol.y(2);
    HbR_0 = sol.y(3);
    SaO2_0 = sol.y(4);
    ScO2_0 = sol.y(5);
    SvO2_0 = sol.y(6);
    p1 = 1; 
    p2 = 1;  
    p3 = 1; 
    stim_onoff = 1; 
    
    options.x0 = sol.x(end,:).';

    TE = 20*10^-3;       B0 = 7;

    Constants = [sol.x(end,[11 9 13]), Ca_start, Con, HbO_0, HbR_0, SaO2_0, ScO2_0, SvO2_0, TE, B0, p1, p2, p3, stim_onoff];

    % alter simulation tolerances, DAE solver can not handle the default values
    options.atol = 1e-6;
    options.rtol = 1e-9;
    optionsLong=options;
    optionsLong.maxsteps=1e6;
    
    %% stimulation simulation
    optEx20 = optionsLong;
    optIn20 = optionsLong;
    optSens20 = optionsLong;
    optEx = options;
    optIn = options;
    optSens = options;
    
    try
        % Simulation OptoGenatic Inhibitory 20 sec stim
        time = [];
        OGIn20y = [];
        OGIn20x = [];

        for i=1:1:tend(1)
            Constants(end) = 1;
            t1 = [(i-1) (i-1+0.1)] - (i-1);
            simOGin20 = simulate_Model(t1 ,pOGin,Constants, [], optIn20);

            optIn20.x0 = simOGin20.x(end,:)';
            Constants(end) = 0;
            if i==tend(1)
                t2 = ((i-1+0.1):0.1:Data.OGinhibitory20.t(end))-(i-1+0.1);
            else
                t2 = ((i-1+0.1):0.1:i) - (i-1+0.1);
            end
            simOGin20b = simulate_Model(t2,pOGin,Constants, [], optIn20);
            optIn20.x0 = simOGin20b.x(end,:)';
            
            if i>1
                time = [time t1(2)+(i-1) t2(2:end)+(i-1+0.1)];
                OGIn20y = [OGIn20y; simOGin20.y(2,3:5); simOGin20b.y(2:end,3:5)];
                OGIn20x = [OGIn20x; simOGin20.x(2,[11,9,13]); simOGin20b.x(2:end,[11,9,13])];
            else
                time = [time t1+(i-1) t2(2:end)+(i-1+0.1)];
                OGIn20y = [OGIn20y; simOGin20.y(:,3:5); simOGin20b.y(2:end,3:5)];
                OGIn20x = [OGIn20x; simOGin20.x(:,[11,9,13]); simOGin20b.x(2:end,[11,9,13])];
            end
        end
        idx = ismembertol(time, Data.OGinhibitory20.t, 1e-10);
        OGIn20x = OGIn20x(idx,:);
        costin20 = sum(sum((OGIn20y(idx,:) - Data.OGinhibitory20.Y).^2./(Data.OGinhibitory20.Sigma_Y.^2)));
        
        if simOGin20b.status <0
            throw(MException('error'));
        end 

        % Simulation OptoGenatic Excitatory 20 sec stim
        time = [];
        OGEx20y = [];
        OGEx20x = [];

        for i=1:1:tend(1)
            Constants(end) = 1;
            t1 = [(i-1) (i-1+0.1)] - (i-1);
            simOGEx20 = simulate_Model(t1 ,pOGex,Constants, [], optEx20);

            optEx20.x0 = simOGEx20.x(end,:)';
            Constants(end) = 0;
            if i==tend(1)
                t2 = ((i-1+0.1):0.1:Data.OGexcitatory20.t(end))-(i-1+0.1);
            else
                t2 = ((i-1+0.1):0.1:i) - (i-1+0.1);
            end
            simOGEx20b = simulate_Model(t2,pOGex,Constants, [], optEx20);
            optEx20.x0 = simOGEx20b.x(end,:)';
            
            if i>1
                time = [time t1(2)+(i-1) t2(2:end)+(i-1+0.1)];
                OGEx20y = [OGEx20y; simOGEx20.y(2,3:5); simOGEx20b.y(2:end,3:5)];
                OGEx20x = [OGEx20x; simOGEx20.x(2,[11,9,13]); simOGEx20b.x(2:end,[11,9,13])];
            else
                time = [time t1+(i-1) t2(2:end)+(i-1+0.1)];
                OGEx20y = [OGEx20y; simOGEx20.y(:,3:5); simOGEx20b.y(2:end,3:5)];
                OGEx20x = [OGEx20x; simOGEx20.x(:,[11,9,13]); simOGEx20b.x(2:end,[11,9,13])];
            end
        end
        idx = ismembertol(time, Data.OGexcitatory20.t, 1e-10);
        OGEx20x = OGEx20x(idx,:);
        costex20 = sum(sum((OGEx20y(idx,:) - Data.OGexcitatory20.Y).^2./(Data.OGexcitatory20.Sigma_Y.^2)));
        
        if simOGEx20b.status <0
            throw(MException('error'));
        end 

        % Simulation Sensory 20 sec stim
        Constants(end) = 1;
        t1 = unique([Data.Sensory20.t(Data.Sensory20.t<=tend(1)); tend(1)]);
        simSens20 = simulate_ModelDesjardinsSensory(t1 ,pSensLong,Constants, [], optSens20);
        
        optSens20.x0 = simSens20.x(end,:)';
        Constants(end) = 0;
        t2 = [tend(1); Data.Sensory20.t(Data.Sensory20.t>tend(1))] - tend(1);
        simSens20b = simulate_ModelDesjardinsSensory(t2,pSensLong,Constants, [], optSens20);
        
        Sens20y = [simSens20.y(:,3:5); simSens20b.y(2:end,3:5)];
        Sens20x = [simSens20.x(:,[11,9,13]); simSens20b.x(2:end,[11,9,13])];
        costsens20 = sum(sum((Sens20y - Data.Sensory20.Y).^2./(Data.Sensory20.Sigma_Y.^2)));
        
        if simSens20b.status <0
            throw(MException('error'));
        end 

        %% Simulation OptoGenatic Excitatory 0.1 sec stim
        Constants(end) = 1;
        t1 = [0 tend(2)];
        simOGex01 = simulate_Model(t1 ,pOGex,Constants, [], optEx);
        
        optEx.x0 = simOGex01.x(end,:)';
        Constants(end) = 0;
        t2 = [tend(2); Data.OGexcitatory01.t(Data.OGexcitatory01.t>0)]- tend(2);
        simOGex01b = simulate_Model(t2,pOGex,Constants, [], optEx);
        
        OGex01y = [simOGex01.y(1:end-1,3:5); simOGex01b.y(2:end,3:5)];
        costex01 = sum(sum((OGex01y - Data.OGexcitatory01.Y).^2./(Data.OGexcitatory01.Sigma_Y.^2)));

        if simOGex01b.status <0
            throw(MException('error'));
        end 

        %Simulation OptoGenatic Inhibitory 0.1 sec stim
        Constants(end) = 1;
        t1 = [0 tend(2)];
        simOGin01 = simulate_Model(t1,pOGin,Constants, [], optIn);
        
        optIn.x0 = simOGin01.x(end,:)';
        Constants(end) = 0;
        t2 = [tend(2); Data.OGinhibitory01.t(Data.OGinhibitory01.t>0)] - tend(2);
        simOGin01b = simulate_Model(t2,pOGin,Constants, [], optIn);
        
        OGin01y = [simOGin01.y(1:end-1,3:5); simOGin01b.y(2:end,3:5)];
        costin01 = sum(sum((OGin01y - Data.OGinhibitory01.Y).^2./(Data.OGinhibitory01.Sigma_Y.^2)));

        if simOGin01b.status <0
            throw(MException('error'));
        end 
        
        %% Simulation Sensory 2 sec stim
        Constants(end) = 1;
        t1 = Data.Sensory2.t(Data.Sensory2.t<=tend(3));
        simSens2 = simulate_ModelDesjardinsSensory(t1,pSensShort,Constants, [], optSens);
        
        optSens.x0 = simSens2.x(end,:)';
        Constants(end) = 0;
        t2 = [tend(3); Data.Sensory2.t(Data.Sensory2.t>tend(3))] - tend(3);
        simSens2b = simulate_ModelDesjardinsSensory(t2,pSensShort,Constants, [], optSens);
        
        Sens2y = [simSens2.y(:,3:5); simSens2b.y(2:end,3:5)];
        costsens2 = sum(sum((Sens2y - Data.Sensory2.Y).^2./(Data.Sensory2.Sigma_Y.^2)));
        
        if simSens2b.status <0
            throw(MException('error'));
        end 
        
        %% Behaviour demands Sensory 
        NOVSM = pSensLong(27)*(Sens20x(:,1)-Sens20x(1,1));
        PGEVSM = pSensLong(28)*(Sens20x(:,2)-Sens20x(1,2));
        Sensplateu = 5e0*sum(NOVSM(4:11) > PGEVSM(4:11));     %the plateu (second peak) should be from PGE2        
        Senspeak = 5e0*sum(NOVSM(1:2) < PGEVSM(1:2));         %first peak should be from NO 

        straffSens = Senspeak + Sensplateu;

        % Behaviour demands Optogentic Excitatory 
        NOVSM2 = pOGex(27)*(OGEx20x(:,1)-OGEx20x(1,1));    
        PGEVSM2 = pOGex(28)*(OGEx20x(:,2)-OGEx20x(1,2));
        NPYVSM2 = pOGex(29)*(OGEx20x(:,3)-OGEx20x(1,3));
        straff21 = 5e0*sum(NOVSM2(4:end) > PGEVSM2(4:end));  %PGE2 should be the main part of the dilation
        straff22 = 5e0*sum(-NPYVSM2 > PGEVSM2);              %Negative NPY should not drive the dilation
        straff23 = 5e0*sum(-NPYVSM2(1:6) > NOVSM2(1:6));     %Negative NPY should not drive the dilation

        straffOGex = straff21 + straff22 + straff23;

        % Behaviour demands Optogenetic INhibitory 
        NOVSM3 = pOGin(27)*(OGIn20x(:,1)-OGIn20x(1,1));
        PGEVSM3 = pOGin(28)*(OGIn20x(:,2)-OGIn20x(1,2));
        NPYVSM3 = pOGin(29)*(OGIn20x(:,3)-OGIn20x(1,3));
        straff31 = 5e0*sum(NOVSM3(1:10) < PGEVSM3(1:10));       %solves dilation with PGE2 instead of NO
        straff32 = 5e0*sum(-NPYVSM3(1:7) > NOVSM3(1:7));        %solves dilation with negative NPY instead of NO
        straff33 = 5e0*sum(NPYVSM3(1:8) < 0.1.*NOVSM3(1:8));    %to not ignores NPY    

        straffOGin = straff31 + straff32 + straff33; 

        %% total cost 
        straff = straffOGex + straffOGin + straffSens;

        cost= costex20 + costin20 + costsens20 + costex01 + costin01 + costsens2;

        logL=logL + cost + straff;

    catch 
        logL = 1e20;
    end

    f = logL;   
    gf = dlogL;
    c = [];
    gc = [];

    %% MCMC related, save parameters to file 
    if nargin == 5 && logL < chi2inv(0.95,354)
        fprintf(FID, '%4.10f %10.10f ', [f, theta]); fprintf(FID, '\n');
    end
end