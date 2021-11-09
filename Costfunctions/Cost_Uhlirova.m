function [f] = Cost_Uhlirova(theta,Data,Con,FID)
logL = 0;

%parameter assignment
pOGinAnes=[theta(1:2); theta(4:37)];
pOGexAnes=[theta(3); theta(4:37)];
pSensAnes=[theta(38:40); theta(4:37)];
thetaAwake=theta(4:37);
thetaAwake(1:9)=theta(41:49);
pOGinAwake=[theta(50:51); thetaAwake];
pSensAwake=[theta(52:54); thetaAwake];

%% simulation options
options = amioption('sensi',0,...
 'maxsteps',3e3);
options.atol = 1e-9;
options.rtol = 1e-18;

% values for initial parameters
Ca_start = 10;
tstart = 0.0001; % start of stimulation
TE = 20*10^-3;       B0 = 7; % Magnetic field parameters for the Uhlirova study

%% steady state simulation
sol = simulate_SSmodel(inf,theta(4:37),[Ca_start,Con],[],options);

%% Assign values to constants and intitaial conditions taken from the SS simulation
HbO_0 = sol.y(2);
HbR_0 = sol.y(3);
SaO2_0 = sol.y(4);
ScO2_0 = sol.y(5);
SvO2_0 = sol.y(6);

options.x0 = sol.x(end,:).'; % set initial conditions from SS simulation
Constants = [sol.x(end,[11 9 13]), Ca_start, tstart, 1, Con, HbO_0, HbR_0, SaO2_0, ScO2_0, SvO2_0, TE, B0];

% alter simulation tolerances, DAE solver can not handle the default values
options.atol = 1e-6;
options.rtol = 1e-12;

optionsLong=options; % For the longer paradigm, we allow for more integration steps
optionsLong.maxsteps=3e3;

%% Simulations
% anesthetized
Constants(5:6)=[0.9, 1];
simOGex = simulate_Uhli_OGex([],pOGexAnes,Constants, Data(1), optionsLong);

Constants(5:6)=[0.55 1];
simOGin = simulate_Uhli_OGin([],pOGinAnes,Constants, Data(2), optionsLong);

Constants(5:6)=[tstart 2];
simSens = simulate_Uhli_Sens([],pSensAnes,Constants,Data(3),optionsLong);

% Awake
Constants(6)=1;
simSensAw = simulate_Uhli_Sens([],pSensAwake,Constants,Data(5),optionsLong);

Constants(5:6)=[tstart 0.4];
simOGinAw = simulate_Uhli_OGin([],pOGinAwake,Constants, Data(4), optionsLong);


if (simSens.status<0 && simOGin.status<0 && simOGex.status<0 && simOGinAw.status<0 && simSensAw.status<0)
    logL = inf;
else
    % cost calculation
    logL=logL+ simSens.chi2 + simOGin.chi2 + simOGex.chi2 +simOGinAw.chi2 +simSensAw.chi2;
end

f=logL;

%% MCMC related, save parameters to file
if nargin == 4 && logL  < chi2inv(0.95,190) %% 190 data points in estimation data
    fprintf(FID,'%4.10f %10.10f ',[f, theta']); fprintf(FID,'\n');
end

end