%% MCMC sampling using the rampart algorithm in Pesto toolbox

close all
    
%% Data fetching    
[~, Data, Constants, ~, X] = optsetupfunction(2);

for i=1:length(X)
parameters.name{i} = num2str(i);
end

parameters.min = -3.52*ones(46,1);
parameters.max = 3.1*ones(46,1);
parameters.max([4 5 6 7 8 9 37 38 42 43 44 45])=1.02;
parameters.max([1 2 3 30 31 32 33 34 39 40 41])=2.1;
parameters.min([10 11 12 13 14 15 35 36 46])=log10(1/0.78);
parameters.min(22)=0;
parameters.min(25)=-6;

parameters.number = length(parameters.name); % number of parameters

%% Create file where all chi-2 acceptable parameters are saved
FileName=sprintf('MCMC_Uhlirova_%s.dat',datestr(now,'yymmdd_HHMMSS'));
FID = fopen(FileName,'wt');

objectiveFunction = @(X) CostFunction_EstimationData_MCMC(X,Data,Constants,FID);

%% Options
optionsPesto = PestoOptions(); 

optionsPesto.obj_type = 'negative log-posterior';  
optionsPesto.comp_type = 'sequential';
optionsPesto.objOutNumber=1;


%% Markov Chain Monte Carlo sampling -- Parameters

% Building a struct covering all sampling options:
optionsPesto.MCMC = PestoSamplingOptions();
optionsPesto.MCMC.nIterations = 1e5;
optionsPesto.MCMC.mode = optionsPesto.mode;
%% RAMPART options
      optionsPesto.MCMC.samplingAlgorithm     = 'RAMPART';
      optionsPesto.MCMC.RAMPART.nTemps           = 40;
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
      
optionsPesto.MCMC.theta0 = X;
optionsPesto.MCMC.sigma0 = 1e5 * eye(length(X));

% Run the sampling
warning('off','all')
parameters = getParameterSamples(parameters, objectiveFunction, optionsPesto);
warning('on','all')

%% Create folder with name MCMC_DAY-MONTH-YEAR hour-min-sec
folderStr=datestr(now,'yymmdd_HHMMSS');
folderStr=strrep(folderStr,{':',' '},'_');
folderStr=folderStr{2};
mkdir(pwd,['MCMC/Uhlirova_' folderStr])
FolderName=fullfile(pwd,['MCMC/Uhlirova_' folderStr]);

%% Save results to folder
save(fullfile(FolderName,'parameters.mat'),'parameters')
fclose(FID);
movefile(FileName,FolderName);

%% Takes all open figures and saves them
FigList = findobj(allchild(0), 'flat', 'Type', 'figure');
for iFig = 1:length(FigList)
  FigHandle = FigList(iFig);
  FigName   = get(FigHandle, 'Name');
  savefig(FigHandle, fullfile(pwd,['fig', num2str(iFig), '.fig']));
end

% GenerateUncertainties 
GenerateUncertaintyUhlirova(FileName, FolderName)
