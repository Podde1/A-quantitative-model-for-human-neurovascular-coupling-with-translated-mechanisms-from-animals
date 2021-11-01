function [f,c,gf,gc] = Cost_Desjardins(theta,Data,Con,tend, FID)

    logL = 0;
    dlogL = zeros(numel(theta),1);
    
    %params 
    pOGin=theta(1:36);
    pOGex=[theta(37) theta(3:36)];
    pSensLong=[theta(38:40) theta(3:36)];
    pSensShort=[theta(41:43) theta(3:36)];

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
    options.atol = 1e-6;
    options.rtol = 1e-9;
     optionsLong=options;
    optionsLong.maxsteps=1e6;
    %% stimulation simulation
try
    optEx20 = optionsLong;
    optIn20 = optionsLong;
    optSens20 = optionsLong;
    optEx = options;
    optIn = options;
    optSens = options;
    
    % Simulation OptoGenatic Inhibitory 20 sec stim
    simOGin20 = simulate_OGinhibitoryDesjardins2([Data.OGinhibitory20.t(Data.OGinhibitory20.t<=20); tend(1)],pOGin,Constants, [], optIn20);
    optIn20.x0 = simOGin20.x(end,:)';
    simOGin20b = simulate_OGinhibitoryDesjardins2b([0; Data.OGinhibitory20.t(Data.OGinhibitory20.t>20) - tend(1)],pOGin,Constants, [], optIn20);
    OGin20y = [simOGin20.y(1:end-1,:); simOGin20b.y(2:end,:)];
    costin20 = sum(sum((OGin20y - Data.OGinhibitory20.Y).^2./(Data.OGinhibitory20.Sigma_Y.^2)));

    if (simOGin20.status <0 || simOGin20b.status <0)
        throw(Exception);
    end 
    
    % Simulation OptoGenatic Excitatory 20 sec stim
    simOGex20a = simulate_OGexcitatoryDesjardins2([Data.OGexcitatory20.t(Data.OGexcitatory20.t<=20); tend(1)],pOGex,Constants, [], optEx20);
    optEx20.x0 = simOGex20a.x(end,:)';
    simOGex20b = simulate_OGexcitatoryDesjardins2b([0; Data.OGexcitatory20.t(Data.OGexcitatory20.t>20) - tend(1)],pOGex,Constants, [], optEx20);
    OGex20y = [simOGex20a.y(1:end-1,1:3); simOGex20b.y(2:end,1:3)];
    costex20 = sum(sum((OGex20y - Data.OGexcitatory20.Y).^2./(Data.OGexcitatory20.Sigma_Y.^2)));

    if (simOGex20a.status <0 || simOGex20b.status <0)
        throw(Exception);
    end 

    % Simulation Sensory 20 sec stim
    simSens20 = simulate_SensoryDesjardins2([Data.Sensory20.t(Data.Sensory20.t<=20); tend(1)],pSensLong,Constants, [], optSens20);
    optSens20.x0 = simSens20.x(end,:)';
    simSens20b = simulate_SensoryDesjardins2b([0; Data.Sensory20.t(Data.Sensory20.t>20) - tend(1)],pSensLong,Constants, [], optSens20);
    Sens20y = [simSens20.y(1:end-1,:); simSens20b.y(2:end,:)];
    costsens20 = sum(sum((Sens20y - Data.Sensory20.Y).^2./(Data.Sensory20.Sigma_Y.^2)));

    if (simSens20.status <0 || simSens20b.status <0)
        throw(Exception);
    end 

    
    Constants(6) = tend(2);
    % Simulation OptoGenatic Excitatory 0.1 sec stim
    %%% 1 instead of tend(2), 0.1 sec is to short to simulate as it
    %%% crashes. instead run to 1 sec as only one stim pulse occurs
    %%% during this period anyways --> no difference
    simOGex01 = simulate_OGexcitatoryDesjardins2(Data.OGexcitatory01.t(Data.OGexcitatory01.t<=1),pOGex,Constants, [], optEx);
    optEx.x0 = simOGex01.x(end,:)';
    simOGex01b = simulate_OGexcitatoryDesjardins2b([0; Data.OGexcitatory01.t(Data.OGexcitatory01.t>1) - 1],pOGex,Constants, [], optEx);
    OGex01y = [simOGex01.y(1:end,1:3); simOGex01b.y(2:end,1:3)];
    costex01 = sum(sum((OGex01y - Data.OGexcitatory01.Y).^2./(Data.OGexcitatory01.Sigma_Y.^2)));

    if (simOGex01.status <0 || simOGex01b.status <0)
        throw(Exception);
    end 
    
    % Simulation OptoGenatic Inhibitory 0.1 sec stim
    simOGin01 = simulate_OGinhibitoryDesjardins2(Data.OGinhibitory01.t(Data.OGinhibitory01.t<=1),pOGin,Constants, [], optIn);
    optIn.x0 = simOGin01.x(end,:)';
    simOGin01b = simulate_OGinhibitoryDesjardins2b([0; Data.OGinhibitory01.t(Data.OGinhibitory01.t>1) - 1],pOGin,Constants, [], optIn);
    OGin01y = [simOGin01.y(1:end,:); simOGin01b.y(2:end,:)];
    costin01 = sum(sum((OGin01y - Data.OGinhibitory01.Y).^2./(Data.OGinhibitory01.Sigma_Y.^2)));

    if (simOGin01.status <0 || simOGin01b.status <0)
        throw(Exception);
    end 
    
    
    Constants(6) = tend(3);

    % Simulation Sensory 2 sec stim
    simSens2 = simulate_SensoryDesjardins2(Data.Sensory2.t(Data.Sensory2.t<=2),pSensShort,Constants, [], optSens);
    optSens.x0 = simSens2.x(end,:)';
    simSens2b = simulate_SensoryDesjardins2b([0; Data.Sensory2.t(Data.Sensory2.t>2) - tend(3)],pSensShort,Constants, [], optSens);
    Sens2y = [simSens2.y(1:end,:); simSens2b.y(2:end,:)];
    costsens2 = sum(sum((Sens2y - Data.Sensory2.Y).^2./(Data.Sensory2.Sigma_Y.^2)));
        
    if (simSens2.status <0 || simSens2b.status <0)
        throw(Exception);
    end 

    % Behaviour demands Sensory 
    Sens20x = [simSens20.x(1:end-1,[11,9,13]); simSens20b.x(2:end,[11,9,13])];
    
    NOVSM = 10^pSensLong(27)*(Sens20x(:,1)-Sens20x(1,1));
    PGEVSM = 10^pSensLong(28)*(Sens20x(:,2)-Sens20x(1,2));
    Sensplateu = 1e3*sum(NOVSM(4:11) > PGEVSM(4:11));     %the plateu (second peak) should be from PGE2        
    Senspeak = 1e3*sum(NOVSM(1:2) < PGEVSM(1:2));         %first peak should be from NO 

    straffSens = Senspeak + Sensplateu;

    % Behaviour demands Optogentic Excitatory 
    OGex20x = [simOGex20a.x(1:end-1,[11,9,13]); simOGex20b.x(2:end,[11,9,13])];
    
    NOVSM2 = 10^pOGex(25)*(OGex20x(:,1)-OGex20x(1,1));    
    PGEVSM2 = 10^pOGex(26)*(OGex20x(:,2)-OGex20x(1,2));
    NPYVSM2 = 10^pOGex(27)*(OGex20x(:,3)-OGex20x(1,3));
    straff21 = 1e3*sum(NOVSM2(4:end) > PGEVSM2(4:end));  %PGE2 should be the main part of the dilation
    straff22 = 1e3*sum(-NPYVSM2 > PGEVSM2);              %Negative NPY should not drive the dilation
    straff23 = 1e3*sum(-NPYVSM2(1:6) > NOVSM2(1:6));     %Negative NPY should not drive the dilation
    
    straffOGex = straff21 + straff22 + straff23;

    % Behaviour demands Optogenetic INhibitory 
    OGin20x = [simOGin20.x(1:end-1,[11,9,13]); simOGin20b.x(2:end,[11,9,13])];
    
    NOVSM3 = 10^pOGin(26)*(OGin20x(:,1)-OGin20x(1,1));
    PGEVSM3 = 10^pOGin(27)*(OGin20x(:,2)-OGin20x(1,2));
    NPYVSM3 = 10^pOGin(28)*(OGin20x(:,3)-OGin20x(1,3));
    straff31 = 1e3*sum(NOVSM3(1:10) < PGEVSM3(1:10));       %solves dilation with PGE2 instead of NO
    straff32 = 1e3*sum(-NPYVSM3(1:7) > NOVSM3(1:7));        %solves dilation with negative NPY instead of NO
    straff33 = 1e3*sum(NPYVSM3(1:8) < 0.1.*NOVSM3(1:8));    %to not ignores NPY    

    straffOGin = straff31 + straff32 + straff33; 

    % total cost 
    straff = straffOGex + straffOGin + straffSens;

    cost= costex20 + costin20 + costsens20 + costex01 + costin01 + costsens2;

    logL=logL + cost + straff;

catch 
    logL = 9999999;
end
       
f = logL;   
gf = dlogL;
c = [];
gc = [];

%% MCMC related, save parameters to file 
if nargin == 6 && logL < chi2inv(0.95,354)
    fprintf(FID, '%4.10f %10.10f ', [f, theta]); fprintf(FID, '\n');
end

end