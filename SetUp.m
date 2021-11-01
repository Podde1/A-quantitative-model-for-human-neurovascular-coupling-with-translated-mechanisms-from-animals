%% Set up file for the project
% Adding folders to path
% Setting up a folder for storing mex and simulation files
% Generating the model files needed
% if error is thrown, alert user that needed toolboxes might be missing

addpath(genpath('Costfunctions'))
addpath(genpath('Datamatrixes'))
addpath(genpath('functions'))
addpath(genpath('Functions_needed_for_plotting_(AddToPath)'))
addpath(genpath('GenerateData'))
addpath(genpath('MCMC'))
addpath('Model files (_syms)')
addpath(genpath('OptimizedParameters'))

if not(isfolder('mex and sim files'))
    mkdir('mex and sim files')
end

try 
    GenerateModels;
    PlotArticleFigures;
catch ME
    fprintf(1,'The identifier was:\n%s',ME.identifier);
    fprintf(1,'There was an error! The message was:\n%s',ME.message);
    fprintf(['\nNote! Following toolboxes needs to be added to path, and if not already done, perform the initial setup required for each tool:', '\n', 'Amici', '\n', 'Meigo', '\n', 'Pesto', '\n']);
end