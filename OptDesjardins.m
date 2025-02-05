%% eSS Optimization
close all

% add necessary folders to path
addpath(genpath('Functions'))
addpath(genpath('GenerateData'))
addpath(genpath('CostFunctions'))
addpath(genpath('Datamatrixes'))
addpath(genpath('OptimizedParameters'))
addpath('mex and sim files')

%% Script to perform an optimization using ESS-opt

% Load initial data structures
[objectiveFunction, Data, Constants, stimend, X] = optsetupfunction(3);

%% attach startGuess to problem structure  
startGuess=X;

problem.x_0=startGuess;
problem.f_0 = Cost_Desjardins(startGuess',Data, Constants, stimend);

%% Generate parameter bounds
lb = -4.5*ones(size(startGuess));
ub =4.5*ones(size(startGuess));

 ub(1:2) = 3;                       %k_u input scale parameter
 ub(37) = 3;                        %k_u input scale parameter
 ub(38:40) = 3;                     %k_u input scale parameter
 ub(41:43) = 3;                     %k_u input scale parameter

% signaling parameters
 ub(3:8) = 2.5;                     %KPF & KPINF. Neuronal interaction parameters
 ub(6) = 3.5;
 lb([24 36]) = -12;                 %Km saturation parameters, allowed to be small
 lb([9 10 11 12 13 14]) =log10(1/0.78);    %ksink for N and Ca2+	                                 
 lb(21) = 0;                        %sinkNO 
 

 lb(29:31) = [0.001 log10(1.1) 2];         %K123 circuit
 lb(32:34) = [0 1 1];                      %vis123 circuit
 ub(29:31) = [log10(2) log10(2) 8];        %K123 circuit
 ub(32:34) = [2 3 3];                      %vis123 circuit

 
problem.x_L       = lb; % essOPT uses a problem structure where crucial information is specified
problem.x_U       = ub;

%% MEIGO OPTIONS I (COMMON TO ALL SOLVERS):
opts.ndiverse   = 100; %100; %500; %5; %
opts.maxtime    =100;    % MAX-Time of optimization, i.e how long the optimization will last
opts.maxeval    = 1e8;    % max number of evals, i.e cost function calls
opts.log_var    = [];     %skip this

opts.local.solver = 'dhc';  %dhc'; %'fmincon'; %'nl2sol'; %'mix'; % local solvers
opts.local.finish = opts.local.solver; %uses the local solver to check the best p-vector
opts.local.bestx = 0;       
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
    opts.local.use_gradient_for_finish = 1; %provide gradient to fmincon
else
    opts.local.use_gradient_for_finish = 0; %provide gradient to fmincon
end
opts.local.check_gradient_for_finish = 0; %gradient checker

%% Solve
warning('off','all') % AMICI prints error-messages for all simulations (if they fail) so this will fix that annoying orange text form appearing
optim_algorithm = 'ess'; % 'multistart'; %  'cess';

Results = MEIGO(problem,opts,optim_algorithm,objectiveFunction); % Run the optimization

%% Save results
fitting_speed     = Results.time(end);
best_fs           = Results.fbest;
parameters_ess    = Results.xbest';

% best parameter vector stored in X
X=parameters_ess;

w = warning ('on','all'); % error messages is enabled again
