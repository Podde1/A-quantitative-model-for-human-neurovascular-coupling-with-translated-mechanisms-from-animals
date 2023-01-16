%% Set up file for the project
% Adding folders to path
% Setting up a folder for storing mex and simulation files
% Generating the model files needed
% if error is thrown, alert user that needed toolboxes might be missing

addpath(genpath('Costfunctions'))
addpath(genpath('Datamatrixes'))
addpath(genpath('functions'))
addpath(genpath('GenerateData'))
addpath(genpath('MCMC'))
addpath('Model files (_syms)')
addpath(genpath('OptimizedParameters'))

if not(isfolder('mex and sim files'))
    mkdir('mex and sim files')
end

try 
    %% Sanity checks for versions and required add-ons 
    %Matlab
    version = ver('MATLAB');
    year = str2double(version.Release(3:6));

    if year > 2017
        throw(MException('ME:MatlabVersion', 'The Amici toolbox do not work with Matlab versions newer than Matlab 2017b \n'));
    end
    
    %Symbolic math toolbox
    if ~ismember("Symbolic Math Toolbox", matlab.addons.installedAddons{:,1})
        throw(MException('ME:Addon', 'Missing add-on: Symbolic Math Toolbox \n'));
    end 
    
    %mex compiler installed 
    mexCompilerInfo = mex.getCompilerConfigurations('C', 'Selected');
    
    if contains(mexCompilerInfo.Name, "Microsoft Visual")
        throw(MException('ME:mex', 'Microsoft Visual studio will not work as a mex-compiler, recomended mex-compiler Matlab add-on: MinGw-64 \n'));
    end
    
    %% Check installation of AMICI     
    try
        addpath(genpath('tools/AMICI-0.10.11-fix/matlab/'))
        installAMICI; 
    catch ME
        switch ME.identifier
            case 'ME:UndefinedFunction'
                warning('AMICI seems to be missing in the working directory, please add it (see README) \n');
            otherwise
                disp(ME)
        end
    end
    
    %% Generate model files and Plot the artcile results
    GenerateModels;
    PlotArticleFigures;
    
    
    
    %% Check other external tools
    if contains(pathStr,'MEIGO')
        install_MEIGO; 
    else
       warning('MEIGO seems to be missing in the working directory, Optimizations will not work without it');
    end
    
    if ~contains(pathStr,'PESTO')
       warning('PESTO seems to be missing in the working directory, MCMC samplings will not work without it');
    end

catch ME
    switch ME.identifier
        case 'ME:Addon'
            fprintf(ME.message)
            
        case 'ME:mex'
            fprintf(ME.message)
            
        case 'ME:MatlabVersion'
            fprintf(ME.message)
            
        case 'ME:tool'
            fprintf(ME.message)
            
        otherwise
            errormsg = sprintf('%s %s %s', string(ME.identifier), " - error was caught!", newline);
            for index=1:length(ME.stack)
                errormsg = sprintf('%s %s %s %s %s %s %s', errormsg, newline, string(ME.stack(index).name), " (line ", num2str(ME.stack(index).line), "): ", string(ME.message));
            end
            errorstruct.identifier = ME.identifier; 
            errorstruct.message = errormsg; 
            error(errorstruct);
    end
end