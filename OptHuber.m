%% eSS Optimization
close all

% add nececery folders to path
addpath(genpath('Functions'))
addpath(genpath('GenerateData'))
addpath(genpath('CostFunctions'))
addpath(genpath('Datamatrixes'))
addpath(genpath('OptimizedParameters'))
addpath('mex and sim files')

%% Script to perform an optimization using ESS-opt

% Load inital data structures
[objectiveFunction, Data, Constants, stimend, X] = optsetupfunction(5);

%% attach startGuess to problem structure  
startGuess=X;
problem.x_0=startGuess;

%% Generate parameter bounds
lb = -4.5*ones(size(startGuess));
ub =4.5*ones(size(startGuess));

ub([4:9, 46:51]) = 3.5;  
lb([25 37]) = -12;                         %Km saturation parameters, allowed to be small
lb([10 11 12 13 14 15]) =log10(1/0.78);    %ksink for N and Ca2+	  
lb([55 56 57]) =log10(1/0.78);
ub([1:3,38:40,43:45,52:54]) = 3; 
lb(22) = 0;                                 %sinkNO 

 % Circuit parameters
 lb(30:32) = [0.001 log(1.1) 2];            %K123 circuit
 lb(33:35) = [0 1 1];                       %vis123 circuit
 ub(30:32) = [log10(2) log(2) 8];           %K123 circuit
 ub(33:35) = [2 3 3];                       %vis123 circuit
 
ub(41:42)=1;                                % sign parameters
lb(41:42)=-1;                               % sign parameters

problem.x_L       = lb; % essOPT uses a problem structure where crucial information is specified
problem.x_U       = ub;
problem.vtr=-100; % Value to reach, can be useful in PL analysis if you are only curious about bounds and not the exact curvature of the profile.
%% MEIGO OPTIONS I (COMMON TO ALL SOLVERS):
opts.ndiverse   = 100;      %100; %500; %5; %
opts.maxtime    =500;       % MAX-Time of optmization, i.e how long the optimization will last
opts.maxeval    = 1e8;      % max number of evals, i.e cost function calls
opts.log_var    = [];       %skip this

opts.local.solver = 'dhc';  %dhc'; %'fmincon'; %'nl2sol'; %'mix'; 
opts.local.finish = opts.local.solver; %uses the local solver to check the best p-vector
opts.local.bestx = 0;       %read the documentation, think it's best to leave at zero for now.
opts.local.balance = 0.5;   %how far from startguess the local search will push the params, 0.5 default
opts.local.n1   = 2;        %Number of iterations before applying local search for the 1st time (Default 1)
opts.local.n2   = 2;        %Minimum number of iterations in the global phase between 2 local calls (Default 10) 

problem.f       = 'meigoDummy'; % calls function that sets up the cost function call

%% MEIGO OPTIONS II (FOR ESS AND MULTISTART):
opts.local.iterprint = 1; % prints what going on during optimization

%% MEIGO OPTIONS III (FOR ESS ONLY):
opts.dim_refset   = 10; 

%% OPTIONS AUTOMATICALLY SET AS A RESULT OF PREVIOUS OPTIONS:
if(strcmp(opts.local.solver,'fmincon'))
    opts.local.use_gradient_for_finish = 1; %DW: provide gradient to fmincon
else
    opts.local.use_gradient_for_finish = 0; %DW: provide gradient to fmincon
end
opts.local.check_gradient_for_finish = 0; %DW: gradient checker

%% Solve
warning('off','all') 
optim_algorithm = 'ess'; % 'multistart'; %  'cess'; 

Results = MEIGO(problem,opts,optim_algorithm,objectiveFunction); % Run the optimization

%% Save results
fitting_speed     = Results.time(end);
best_fs           = Results.fbest;
parameters_ess    = Results.xbest';

% best parameter vector stored in X
X=parameters_ess;

w = warning ('on','all'); 
