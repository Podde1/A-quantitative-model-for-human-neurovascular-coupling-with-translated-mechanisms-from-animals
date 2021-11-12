Readme 

OBS, the acronym DATASTUDY includes DREW/Uhlirova/Desjardins/Shmuel/Huber and will be used to avoid repeating descriptions 


To execute the code, the following is required

- Matlab R2017b, with add ons: 
    - mex compiler (preferably MinGw-64): https://www.mathworks.com/matlabcentral/fileexchange/52848-matlab-support-for-mingw-w64-c-c-compiler
    - Symbolic Math Toolbox: https://www.mathworks.com/products/symbolic.html

- Advanced Multilanguage Interface to CVODES and IDAS https://github.com/AMICI-dev/AMICI

- PESTO: Parameter EStimation TOolbox https://github.com/ICB-DCM/PESTO

Furthermore, to run the optimization (OptDATASTUDY) the MEIGO toolbox in needed: https://bitbucket.org/jrbanga_/meigo64/src/master/

Before being able to run the code, SetUp.m must be exectuted, to generate the executable model simulation files (this requires the AMICI toolbox) and add needed folders to MATLAB path.



The following scripts are included:
SetUp.m - calls GenerateModels.m to generates the executable model files, sets up MATLAB path and add a new folder named "mex and sim files".

GenerateModels.m - is called by SetUp.m and is the file that generates the executable model files and store the executable model files "mex and sim files/".

PlotArticleFigures.m - plots all model estimation figures from the manusscript (Figure 3,5,6,7,S2,S4).

OptDATASTUDY - ESS Optimization sctipt for each data set. 

MCMCDATASTUDY - Rampart algorithm for each data set.

Costfunctions/ - Model evaluation function for Chi2 to every data set.

Datamatrixes/ - Contain files with raw data from each study. Not froamted in the right way to be directly used.

functions/ - functions used by various scripts. Needs to be on path.
functions/optsetupfunction - loads best objectivefunction,  datastructure, simulation constants, end time for stimulation and parameters for each study by user input [1-Drew, 2-Uhlirova, 3-Desjardins, 4-Shmuel, 5-Huber, 6-DrewTimeVariant].

functions_needed_for_plotting(AddToPath)/ - functions needed for plotting. Needs to be on path.

GenerateData/ - functions that create data field structure (Data) containing the experimental data to each data set/study from the raw data in /Datamatrixes

MCMC/ - functions called during MCMCDATASTUDY is stored here (GenerateUncertaintyDATASTUDY and SimulateDATASTUDYAll). Also, the results from the MCMC run is directed here. 

Model files (_syms)/ - includes .m files ending with _syms --> model structure information that is used to build the executable model files.

OptimizedParameters/ - best parameter sets found.

Plotfunctions/ - the script that generates the figures presented in the manusscript is stored here. 
