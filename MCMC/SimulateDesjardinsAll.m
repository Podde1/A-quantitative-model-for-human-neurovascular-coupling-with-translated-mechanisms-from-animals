function [simulationOutput] = SimulateDesjardinsAll(theta,Con,tend,Data, cutOFF)

    logL = 0;
    
    %% params 
    pOGin=theta(1:36);
    pOGex=[theta(37); theta(3:36)];
    pSensLong=[theta(38:40); theta(3:36)];
    pSensShort=[theta(41:43); theta(3:36)];

    %% simoptions
    options = amioption('sensi',0,...
        'maxsteps',1e5);
    options.sensi = 0;
    options.nmaxevent=1e4;
    % values for initial saturations and pressure
    Ca_start = 10;

    % steady state simulation
    options.atol = 1e-9;
    options.rtol = 1e-16;
    sol = simulate_SSmodel(inf,theta(3:36),[Ca_start,Con],[],options);

    % assaign values to constants and intitaial conditions in the stimulation simulation
    HbO_0 = sol.y(2);
    HbR_0 = sol.y(3);
    SaO2_0 = sol.y(4);
    ScO2_0 = sol.y(5);
    SvO2_0 = sol.y(6);

    options.x0 = sol.x(end,:).';

    tstart = 0.0001;
    TE = 20*10^-3;       B0 = 7;

    Constants = [sol.x(end,[11 9 13]), Ca_start, tstart, tend(1), Con, HbO_0, HbR_0, SaO2_0, ScO2_0, SvO2_0, TE, B0];

    % alter simulation tolerances, DAE solver can not handle the default values
    options.atol = 1e-5;
    options.rtol = 1e-6;
     optionsLong=options;
    optionsLong.maxsteps=1e6;
    %% Simulation
try
    optEx20 = optionsLong;
    optEx20BOLD = optionsLong;
    optIn20 = optionsLong;
    optSens20 = optionsLong;
    optEx = options;
    optIn = options;
    optSens = options;

        simOGin20 = simulate_OGinhibitoryDesjardins2([Data.OGinhibitory20.t(Data.OGinhibitory20.t<=20); tend(1)],pOGin,Constants, [], optIn20);
        optIn20.x0 = simOGin20.x(end,:)';
        simOGin20b = simulate_OGinhibitoryDesjardins2b([0; Data.OGinhibitory20.t(Data.OGinhibitory20.t>20) - tend(1)],pOGin,Constants, [], optIn20);
        OGin20y = [simOGin20.y(1:end-1,:); simOGin20b.y(2:end,:)];
        costin20 = sum(sum((OGin20y - Data.OGinhibitory20.Y).^2./(Data.OGinhibitory20.Sigma_Y.^2)));

    if (simOGin20.status <0 || simOGin20b.status <0)
        throw(Exception);
    end 
        
        timeOGex = unique(sort(cat(1,Data.OGexcitatory20.t, Data.OGexcitatory20BOLD.t)));
    
        simOGex20a = simulate_OGexcitatoryDesjardins2([timeOGex(timeOGex<=20); tend(1)],pOGex,Constants, [], optEx20);
        optEx20.x0 = simOGex20a.x(end,:)';
        simOGex20b = simulate_OGexcitatoryDesjardins2b([0;timeOGex(timeOGex>20) - tend(1)],pOGex,Constants, [], optEx20);

        OGex20y1 = [simOGex20a.y(1:end-1,:); simOGex20b.y(2:end,:)];
        
            indexa = ismember(simOGex20a.t, Data.OGexcitatory20.t);
            indexb = ismember(simOGex20b.t + tend(1), Data.OGexcitatory20.t);
            OGex20y = [simOGex20a.y(indexa,:); simOGex20b.y(indexb,:)];

         costex20 = sum(sum((OGex20y(:,1:3) - Data.OGexcitatory20.Y).^2./(Data.OGexcitatory20.Sigma_Y.^2)));
        
    if (simOGex20a.status <0 || simOGex20b.status <0)
        throw(Exception);
    end 
    
        optEx20BOLD.atol = 1e-4;
        
        simOGex20BOLD = simulate_OGexcitatoryDesjardinsBOLD(timeOGex,pOGex,Constants, [], options);
            indexa = ismember(simOGex20BOLD.t, Data.OGexcitatory20BOLD.t);
            OGex20BOLDy = simOGex20BOLD.y(indexa,:); 
        
    if (simOGex20BOLD.status <0)
        throw(Exception);
    end 
    
    if(sum(abs(OGex20y1(2:end,4)) >= 1.05*abs(simOGex20BOLD.y(2:end,4))))
        throw(Exception);
    end 
    

    
        simSens20 = simulate_SensoryDesjardins2([Data.Sensory20.t(Data.Sensory20.t<=20); tend(1)],pSensLong,Constants, [], optSens20);
        optSens20.x0 = simSens20.x(end,:)';
        simSens20b = simulate_SensoryDesjardins2b([0; Data.Sensory20.t(Data.Sensory20.t>20) - tend(1)],pSensLong,Constants, [], optSens20);
        Sens20y = [simSens20.y(1:end-1,:); simSens20b.y(2:end,:)];
        costsens20 = sum(sum((Sens20y - Data.Sensory20.Y).^2./(Data.Sensory20.Sigma_Y.^2)));
        
    if (simSens20.status <0 || simSens20b.status <0)
        throw(Exception);
    end 

    
    Constants(6) = tend(2);
        %%% 1 instead of tend(2), 0.1 sec is to short to simulate as it
        %%% crashes. instead run to 1 sec as only one stim pulse occurs
        %%% during this period anyways --> no difference for the model
        simOGex01 = simulate_OGexcitatoryDesjardins2(Data.OGexcitatory01.t(Data.OGexcitatory01.t<=1),pOGex,Constants, [], optEx);
        optEx.x0 = simOGex01.x(end,:)';
        simOGex01b = simulate_OGexcitatoryDesjardins2b([0; Data.OGexcitatory01.t(Data.OGexcitatory01.t>1) - 1],pOGex,Constants, [], optEx);
        OGex01y = [simOGex01.y(1:end,:); simOGex01b.y(2:end,:)];
        costex01 = sum(sum((OGex01y(:,1:3) - Data.OGexcitatory01.Y).^2./(Data.OGexcitatory01.Sigma_Y.^2)));

    if (simOGex01.status <0 || simOGex01b.status <0)
        throw(Exception);
    end 
    
    
        simOGin01 = simulate_OGinhibitoryDesjardins2(Data.OGinhibitory01.t(Data.OGinhibitory01.t<=1),pOGin,Constants, [], optIn);
        optIn.x0 = simOGin01.x(end,:)';
        simOGin01b = simulate_OGinhibitoryDesjardins2b([0; Data.OGinhibitory01.t(Data.OGinhibitory01.t>1) - 1],pOGin,Constants, [], optIn);
        OGin01y = [simOGin01.y(1:end,:); simOGin01b.y(2:end,:)];
        costin01 = sum(sum((OGin01y - Data.OGinhibitory01.Y).^2./(Data.OGinhibitory01.Sigma_Y.^2)));

    if (simOGin01.status <0 || simOGin01b.status <0)
        throw(Exception);
    end 
    
    
    Constants(6) = tend(3);

        simSens2 = simulate_SensoryDesjardins2(Data.Sensory2.t(Data.Sensory2.t<=2),pSensShort,Constants, [], optSens);
        optSens.x0 = simSens2.x(end,:)';
        simSens2b = simulate_SensoryDesjardins2b([0; Data.Sensory2.t(Data.Sensory2.t>2) - tend(3)],pSensShort,Constants, [], optSens);
        Sens2y = [simSens2.y(1:end,:); simSens2b.y(2:end,:)];
        costsens2 = sum(sum((Sens2y - Data.Sensory2.Y).^2./(Data.Sensory2.Sigma_Y.^2)));
        
    if (simSens2.status <0 || simSens2b.status <0)
        throw(Exception);
    end 

    
    cost= costex20 + costin20 + costsens20 + costex01 + costin01 + costsens2;
    logL=logL + cost;
    
%% construct output matrix
    if logL < cutOFF
    
        simulationOutput = [OGex20y(:,1).', NaN, NaN, NaN, NaN, NaN
            OGex20y(:,2).', NaN, NaN, NaN, NaN, NaN
            OGex20y(:,3).', NaN, NaN, NaN, NaN, NaN
            OGin20y(:,1).', NaN, NaN, NaN, NaN, NaN
            OGin20y(:,2).', NaN, NaN, NaN, NaN, NaN
            OGin20y(:,3).', NaN, NaN, NaN, NaN, NaN
            Sens20y(:,1).', NaN, NaN, NaN, NaN
            Sens20y(:,2).', NaN, NaN, NaN, NaN
            Sens20y(:,3).', NaN, NaN, NaN, NaN
            OGin01y(:,1).', NaN, NaN
            OGin01y(:,2).', NaN, NaN
            OGin01y(:,3).', NaN, NaN
            OGex01y(:,1).', NaN, NaN
            OGex01y(:,2).', NaN, NaN
            OGex01y(:,3).', NaN, NaN
            Sens2y(:,1).' , NaN, NaN
            Sens2y(:,2).' , NaN, NaN
            Sens2y(:,3).' , NaN, NaN
            OGex20BOLDy(:,4)'
            ];
        
    else
        simulationOutput = NaN(19,23);
        fprintf('larger than cutoff')
    end

catch 
    simulationOutput = NaN(19,23);
    fprintf('failed')
end     
end