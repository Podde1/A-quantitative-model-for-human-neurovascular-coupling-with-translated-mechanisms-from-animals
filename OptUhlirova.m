%% Optimization routine using essOPT
% add necessary folders to path
addpath(genpath('Functions'))
addpath(genpath('GenerateData'))
addpath(genpath('CostFunctions'))
addpath(genpath('Datamatrixes'))
addpath(genpath('OptimizedParameters'))
addpath('mex and sim files')

%% Generate DATA
[objectiveFunction, Data, Constants, stimend, X] = optsetupfunction(2);

startGuess = X;
%% Setting up parameter bounds
lb = -4*ones(size(startGuess));
ub = 4*ones(size(startGuess));

ub([4 5 6 7 8 9 38 39 40])=2.5;
lb(25)=-6;
lb([10 11 12 13 14 15])=log10(1/0.78); 
ub([1 2 3 44 5 51 52 53 54])=2.5; 
lb(22)=0;
lb([25 37]) = -12;

problem.x_L = lb;
problem.x_U = ub; 

%% Simulation settings
options=amioption();
options.maxsteps=1e4;

%% MEIGO OPTIONS I (COMMON TO ALL SOLVERS):
opts.ndiverse     = 'auto'; %100; %500; %5; %
opts.maxtime      = 300; % In cess this option will be overwritten
opts.maxeval      = 1e8;
opts.log_var      = []; 

opts.local.solver = 'dhc'; %'dhc'; %'fmincon'; %'nl2sol'; %'mix'; %
opts.local.finish = opts.local.solver; 
opts.local.bestx = 0;
opts.local.n2=2;
opts.local.balance=0;
opts.local.n1=3;
problem.f         = 'meigoDummy';
problem.x_0=startGuess;
problem.vtr=-100;
%% MEIGO OPTIONS II (FOR ESS AND MULTISTART):
opts.local.iterprint = 1;

%% MEIGO OPTIONS III (FOR ESS ONLY):
opts.dim_refset   = 'auto'; %
optim_algorithm = 'ess'; % 'multistart'; %  'cess'; %

%% OPTIONS AUTOMATICALLY SET AS A RESULT OF PREVIOUS OPTIONS:
if(strcmp(opts.local.solver,'fmincon'))
	opts.local.use_gradient_for_finish = 1; %provide gradient to fmincon
else
	opts.local.use_gradient_for_finish = 0; %provide gradient to fmincon 
end
opts.local.check_gradient_for_finish = 0; %gradient checker

%% Solve
warning('off','all')
Results = MEIGO(problem,opts,optim_algorithm,objectiveFunction); 
%% Save results
fitting_speed     = Results.time(end);
best_fs           = Results.fbest;
parameters_ess    = Results.xbest'; 

% best parameter vector stored in X
X=parameters_ess;

w = warning ('on','all'); % error messages is enabled again
