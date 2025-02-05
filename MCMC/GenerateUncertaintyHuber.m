function []=GenerateUncertaintyHuber(FolderName,FileName)

[~, HuberData, Constants, stimend] = optsetupfunction(5);

cutoff = chi2inv(0.95, 122); %122 data points for the model to fit against

ds = datastore([FolderName,'/',FileName]);
alldata = tall(ds);

SPcost = table2array(alldata(:,1));
SPparams = table2array(alldata(:,2:58));

%% get best simulation
fprintf('best simulation \n')

[miniCost,minIndex] = min(gather(SPcost));
bestParams = gather(SPparams(minIndex,:));
bestSimulatedOutPut = SimulateHuberAll(bestParams, Constants, stimend, HuberData,cutoff);

%% Filter to the ones the are below minCost+chi2(#params)
filterIdx = SPcost < miniCost+chi2inv(0.95,length(bestParams));

%% return the parameters and the cost, which fulfils the demand, into memory
fprintf('params and cost \n')
[sampledCost, sampledParameters] = gather(SPcost(filterIdx), SPparams(filterIdx,:));

SPsize = size(sampledCost,1);

%% run simulations
fprintf('Finding Simulation uncertainty boundaries....\n')
warning('off','all')

outputUB =  -1e6*ones(12,41);
outputLB = 1e6*ones(12,41);

parfor i = 1:SPsize
    if mod(i,1000) == 0
        fprintf('%d of %d.\n',i,SPsize);
    end
    
    simoutput = SimulateHuberAll(sampledParameters(i,:), Constants, stimend, HuberData, cutoff);
    
     outputUB = max(outputUB, simoutput);
     outputLB = min(outputLB, simoutput);
end

warning('on','all')
fprintf('Simulation uncertainty boundary search completed\n')
     
%% Generate huber struct
fieldNames = fieldnames(HuberData);
fields = [fieldNames';cell(1,length(fieldNames))];
HuberSimulation = struct(fields{:});
for i = 1:length(fieldNames)
    HuberSimulation.(fieldNames{i}) = struct('min',outputLB(i,:),'max',outputUB(i,:),'sim',bestSimulatedOutPut(i,:));
end

save(fullfile(FolderName,'HuberStructs.mat'),'HuberData','HuberSimulation')
save(fullfile(FolderName,'p_bestHuber.mat'), 'bestParams')

end