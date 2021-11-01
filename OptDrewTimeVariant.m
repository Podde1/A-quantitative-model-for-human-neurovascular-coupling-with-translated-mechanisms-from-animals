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
[objectiveFunction, Data, Constants, stimend, X] = optsetupfunction(6);

startGuess=X;
problem.x_0=startGuess;

%% Generate parameter bounds
lb = -4.5*ones(size(startGuess));
ub =4.5*ones(size(startGuess));

ub([4 5 6 7 8 9]) = 3;                       %KPF & KPINF
lb([25 37]) = -12;                           %km borde få va liten
lb([10 11 12 13 14 15]) = log10(1/0.78);     %ksink 	    
ub(1:3) = 2.5;  
lb(22) = 0;                                  %sinkNO
 
lb(30:32) = [0.01 log10(1.3) log10(1.4)];    %K123 circuit
lb(33:35) = [1 1 1];                         %vis123 circuit
ub(30:32) = [log10(2) log10(2) 8];           %K123 circuit
ub(33:35) = [2 2.7 2.7];                     %vis123 circuit

% different set of vascular param for long stimulation
lb(38:39) = [log10(1.3) log10(1.4)];
lb(40:41) = [1 1];
ub(38:39) = [log10(2) 8];
ub(40:41) = [2.7 2.7];

problem.x_L       = lb; % essOPT uses a problem structure where crucial information is specified
problem.x_U       = ub;
problem.vtr=-100;
%% MEIGO OPTIONS I (COMMON TO ALL SOLVERS):
opts.ndiverse   =100;       %100; %500; %5; %
opts.maxtime    = 200;      % MAX-Time of optmization, i.e how long the optimization will last
opts.maxeval    = 1e8;      % max number of evals, i.e cost function calls
opts.log_var    = [];    

opts.local.solver = 'dhc';  %dhc'; %'fmincon'; %'nl2sol'; %'mix'; 
opts.local.finish = opts.local.solver; %uses the local solver to check the best p-vector
opts.local.bestx = 0;      
opts.local.balance = 0.3;   %how far from startguess the local search will push the params, 0.5 default
opts.local.n1   = 2;        %Number of iterations before applying local search for the 1st time (Default 1)
opts.local.n2   = 1;        %Minimum number of iterations in the global phase between 2 local calls (Default 10) 

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
