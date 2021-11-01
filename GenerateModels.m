%compile model files into callable mexfiles

path = [pwd, '/mex and sim files/'];
%% Steady state model
amiwrap('SSmodel','SteadyStateModel_syms',path); % steady state model

%% Drew model, sensory stimulation
amiwrap('Drew','Drew_syms',path);

%% Desjardins model, stimulation with altered stimulus paradigm (pulse sequences)
amiwrap('OGexcitatoryDesjardins','OGexcitatoryDesjardins_syms',path);
amiwrap('OGexcitatoryDesjardinsBOLD','OGexcitatoryDesjardinsBOLD_syms',path);
amiwrap('OGinhibitoryDesjardins','OGinhibitoryDesjardins_syms',path);
amiwrap('SensoryDesjardins','SensoryDesjardins_syms',path); 

% Desjardins models, where stimulus events are replaced with 
% a stimulus-on and a stimulus-off model. 
% Runned in a loop for greatly incresed optimization speed
amiwrap('OGexcitatoryDesjardinsBOLD2','OGexcitatoryDesjardinsBOLD2_syms',path);
amiwrap('OGexcitatoryDesjardinsBOLD2b','OGexcitatoryDesjardinsBOLD2b_syms',path);
amiwrap('OGexcitatoryDesjardins2','OGexcitatoryDesjardins2_syms',path);
amiwrap('OGexcitatoryDesjardins2b','OGexcitatoryDesjardins2b_syms',path);
amiwrap('OGinhibitoryDesjardins2','OGinhibitoryDesjardins2_syms',path);
amiwrap('OGinhibitoryDesjardins2b','OGinhibitoryDesjardins2b_syms',path);
amiwrap('SensoryDesjardins2','SensoryDesjardins2_syms',path); 
amiwrap('SensoryDesjardins2b','SensoryDesjardins2b_syms',path); 

%% Sensory positive and negative stimulation describing LFP for Shmuel data
amiwrap('SensoryShmuel','SensoryShmuel_syms',path); 
amiwrap('SensorynegativeShmuel','SensorynegativeShmuel_syms',path); 

% additional models with a constant that switches between [0,1] 
% replacing stimulation events, speeding up optimization
amiwrap('SensoryShmuel2','SensoryShmuel2_syms',path); 
amiwrap('SensorynegativeShmuel2','SensorynegativeShmuel2_syms',path);

%% Sensory positive and negative stimulation describing Huber data
amiwrap('Huber','Huber_syms',path);
amiwrap('HuberNeg','HuberNeg_syms',path);

% additional models with a constant that switches between [0,1] 
% replacing stimulation events, speeding up optimization
amiwrap('Huber2','Huber2_syms',path);
amiwrap('HuberNeg2','HuberNeg2_syms',path);
 
%% Generate model to describe the neural signalling behaviour of awake and anesthetized mice 
amiwrap('Uhli_OGin','Uhli_OGin_syms',path);
amiwrap('Uhli_OGex','Uhli_OGex_syms',path);
amiwrap('Uhli_Sens','Uhli_Sens_syms',path);
amiwrap('Uhli_OGinP','Uhli_OGinP_syms',path);