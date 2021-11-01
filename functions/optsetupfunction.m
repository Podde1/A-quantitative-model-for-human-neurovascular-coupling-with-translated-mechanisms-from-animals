function [objectiveFunction, Data, Constants, stimend, X] = optsetupfunction(choice)
%% input: choice of which data to load

%% Outputs:
%   objectiveFunction - callable pointer to the cost-function, with all
%   additional input arguments specified

pO2_01 = 81.2;      pO2_12 = 59.7;      pO2_23 = 39.6;      pO2_34 = 41.3;
pO2_t = 22.4;       pO2_femart = 85.6;

[g1,g2,g3,gs,CMRO2_0,CO2_l] = BarretPO2constants(pO2_01, pO2_12, pO2_23, pO2_34, pO2_t, pO2_femart);
Constants = [g1,g2,g3,gs,CMRO2_0,CO2_l,pO2_femart];

switch choice
    case 1
        X = load('theta_Drew.mat');
        X = X.X;
        stimend = [0.125 10 30];
        Data = GenerateData_Drew;
        objectiveFunction=@(X) Cost_Drew(X,Data,Constants,stimend);
        
    case 2
        X = load('theta_Uhlirova.mat');
        X=X.X';
        Data = GenerateData_Uhlirova(2);
        stimend=NaN;
        objectiveFunction=@(X) Cost_Uhlirova(X,Data,Constants);
        
    case 3   
        X = load('theta_Desjardins');
        X=X.X';
        Data = load('DesjardinsData.mat');
        Data = Data.DesjardinsData;
        stimend=[20 0.1 2];
        objectiveFunction=@(X) Cost_Desjardins(X,Data,Constants,stimend);
    
             
    case 4
        X = load('theta_Shmuel.mat'); 
        X = X.X'; 
        stimend = 20;
        Data = load('ShmuelData.mat');
        Data = Data.Data;
        objectiveFunction=@(X) Cost_Shmuel(X,Data,Constants,stimend);
        
    
    case 5
        X = load('theta_Huber.mat');
        X=X.X';
        Data = load('HuberData.mat');
        Data = Data.HuberData;
        stimend=30;
        objectiveFunction=@(X) Cost_Huber(X,Data,Constants,stimend);
        
    case 6
        X = load('theta_DrewTimeVariant.mat');
        X = X.X;
        stimend = [0.125 10 30];
        Data = GenerateData_Drew;
        objectiveFunction=@(X) Cost_Drew_TimeVariant(X,Data,Constants,stimend);
end
end