% add folders to path
addpath(genpath('Functions'))
addpath(genpath('GenerateData'))
addpath(genpath('CostFunctions'))
addpath(genpath('Datamatrixes'))
addpath(genpath('OptimizedParameters'))
addpath('mex and sim files')
addpath('PlotFunctions')

% plot model estimation figures from manuscript
fprintf('Manuscript model estimation figures')
PlotFigure3;
PlotFigure5;
PlotFigure6;
PlotFigure7;

% plot model estimation figures from supplementary material
fprintf('Supplementary material model estimation figures')
PlotFigureS2;
PlotUhlirovaS4; 