%% MCMC sampling using the rampart algorithm in Pesto toolbox

close all
    
addpath(genpath('functions'))
addpath(genpath('OptimizedParameters'))
addpath(genpath('GenerateData'))
addpath(genpath('Costfunctions'))
addpath(genpath('Datamatrixes'))
addpath(genpath('MCMC'))
addpath('mex and sim files')
addpath(genpath('../Toolboxs'))
   
%% Load initial structures
[~, DesjardinsData, Constants, stimend, X] = optsetupfunction(3);

%% Initial setup
for i=1:length(X) %For every parameter
parameters.name{i} = num2str(i);
end
%%
parameters.min = -4.5*ones(length(X),1);
parameters.max = 4.5*ones(length(X),1);

% signalling parameters
parameters.max([3 4 5 6 7 8]) = 2.5;                      %KPF & KPINF. Neuronal interaction parameters
parameters.max(6) = 3.5;
parameters.min([24 36]) = -12;                            %Km saturation parameters, allowed to be small
parameters.min([9 10 11 12 13 14]) =log10(1/0.78);        %ksink for N and Ca2+
parameters.max([1:2,37,38:40,41:43]) = 3;                 %k_u input scale parameters
parameters.min(21) = 0;                                   %sinkNO

% Circuit parameters
parameters.min(29:31) = [1e-4 log10(1.1) 2];              %K123 circuit
parameters.min(32:34) = [0 1 1];                          %vis123 circuit
parameters.max(29:31) = [log10(2) log10(2) 8];            %K123 circuit
parameters.max(32:34) = [2 3 3];                          %vis123 circuit

parameters.number = length(parameters.name);              % number of parameters

%% simulation options 
options=amioption();
options.maxsteps=1e4;

%% Create file where all chi-2 acceptable parameters are saved
FileName=sprintf('MCMC_Desjardins_%s.dat',datestr(now,'yymmdd_HHMMSS'));
FID = fopen(FileName,'wt');

%% set the objective function
objectiveFunction=@(X) Cost_Desjardins(X',DesjardinsData,Constants,stimend,FID);

%% Options
optionsPesto = PestoOptions(); % loads optimization options 

optionsPesto.obj_type = 'negative log-posterior'; 
optionsPesto.n_starts = 1;

optionsPesto.mode = 'visual';
optionsPesto.comp_type = 'sequential'; 

% The algorithm does not need any sensitivities to work, therefore only one output
optionsPesto.objOutNumber=1;

%% Markov Chain Monte Carlo sampling -- Parameters

% Building a struct covering all sampling options:
optionsPesto.MCMC = PestoSamplingOptions();
optionsPesto.MCMC.nIterations = 1e5; %number of iterations
optionsPesto.MCMC.mode = optionsPesto.mode;
%% Rampart settings
      optionsPesto.MCMC.samplingAlgorithm     = 'RAMPART';
      optionsPesto.MCMC.RAMPART.nTemps           = length(X);
      optionsPesto.MCMC.RAMPART.exponentT        = 1000;
      optionsPesto.MCMC.RAMPART.maxT             = 2000;
      optionsPesto.MCMC.RAMPART.alpha            = 0.51;
      optionsPesto.MCMC.RAMPART.temperatureNu    = 1e3;
      optionsPesto.MCMC.RAMPART.memoryLength     = 1;
      optionsPesto.MCMC.RAMPART.regFactor        = 1e-8;
      optionsPesto.MCMC.RAMPART.temperatureEta   = 10;
      
      optionsPesto.MCMC.RAMPART.trainPhaseFrac   = 0.1;
      optionsPesto.MCMC.RAMPART.nTrainReplicates = 5;
      
      optionsPesto.MCMC.RAMPART.RPOpt.rng                  = 1;
      optionsPesto.MCMC.RAMPART.RPOpt.nSample              = floor(optionsPesto.MCMC.nIterations*optionsPesto.MCMC.RAMPART.trainPhaseFrac)-1;
      optionsPesto.MCMC.RAMPART.RPOpt.crossValFraction     = 0.2;
      optionsPesto.MCMC.RAMPART.RPOpt.modeNumberCandidates = 1:20;
      optionsPesto.MCMC.RAMPART.RPOpt.displayMode          = 'text';
      optionsPesto.MCMC.RAMPART.RPOpt.maxEMiterations      = 100;
      optionsPesto.MCMC.RAMPART.RPOpt.nDim                 = parameters.number;
      optionsPesto.MCMC.RAMPART.RPOpt.nSubsetSize          = 1000;
      optionsPesto.MCMC.RAMPART.RPOpt.lowerBound           = parameters.min;
      optionsPesto.MCMC.RAMPART.RPOpt.upperBound           = parameters.max;
      optionsPesto.MCMC.RAMPART.RPOpt.tolMu                = 1e-4 * (parameters.max(1)-parameters.min(1));
      optionsPesto.MCMC.RAMPART.RPOpt.tolSigma             = 1e-2 * (parameters.max(1)-parameters.min(1));
      optionsPesto.MCMC.RAMPART.RPOpt.dimensionsToPlot     = [1,2];
      optionsPesto.MCMC.RAMPART.RPOpt.isInformative        = [1,1,ones(1,optionsPesto.MCMC.RAMPART.RPOpt.nDim-2)];

%% set initial parameters and sigma structure
optionsPesto.MCMC.theta0 = X;
optionsPesto.MCMC.sigma0 = 1e5 * eye(length(X));

%% Run the sampling
warning('off','all')
parameters = getParameterSamples(parameters, objectiveFunction, optionsPesto);
warning('on','all')

%% Create folder with name MCMC_DAY-MONTH-YEAR hour-min-sec
folderStr=datestr(now,'yymmdd_HHMMSS');
folderStr=strrep(folderStr,{':',' '},'_');
folderStr=folderStr{2};
mkdir(pwd,['MCMC/Desjardins_' folderStr])
FolderName=fullfile(pwd,['MCMC/MCMCDesjardins_' folderStr]);
%% Save results to folder
save(fullfile(FolderName,'parameters.mat'),'parameters')
fclose(FID);
movefile(FileName,FolderName);
%% Takes all open figures and saves them
FigList = findobj(allchild(0), 'flat', 'Type', 'figure');
for iFig = 1:length(FigList)
    FigHandle = FigList(iFig);
    FigName   = get(FigHandle, 'Name');
    try
        savefig(FigHandle, fullfile(FolderName,['fig', num2str(iFig), '.fig']));
    catch
    end
end

%% get simulation uncertainty 
GenerateUncertaintyDesjardins(FolderName,FileName);
