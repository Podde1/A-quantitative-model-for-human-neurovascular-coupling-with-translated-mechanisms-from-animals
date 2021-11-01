function []= GenerateUncertaintyShmuel(FolderName,FileName)

[~, ShmuelData, Constants, stimend] = optsetupfunction(4);

cutoff = chi2inv(0.95, 160); %160 data points for the model to fit against

ds = datastore([FolderName,'/',FileName]);
alldata = tall(ds);

SPcost = table2array(alldata(:,1));
SPparams = table2array(alldata(:,2:53));

%% get best simulation
[miniCost,minIndex] = min(gather(SPcost));
bestParams = gather(SPparams(minIndex,:));
bestSimulatedOutPut = SimulateShmuelAll(bestParams, Constants, stimend, ShmuelData,cutoff);

%% Filter to the ones the are bleow minCost+chi2(#params)
filterIdx = SPcost < miniCost+chi2inv(0.95,length(bestParams));

%% return the parameters and the cost, which fullfills the demand, into memory
[sampledCost, sampledParameters] = gather(SPcost(filterIdx), SPparams(filterIdx,:));

SPsize = size(sampledCost,1);

%% run simulations
fprintf('Finding Simulation uncertainty boundaries....\n')
warning('off','all')

outputUB = -1e6*ones(4,40);
outputLB = 1e6*ones(4,40);

for i = 1:SPsize
    if mod(i,1000) == 0
        fprintf('%d of %d.\n',i,SPsize);
    end
    
    simoutput = SimulateShmuelAll(sampledParameters(i,:), Constants, stimend, ShmuelData, cutoff);
    
    outputUB = max(outputUB, simoutput);
    outputLB = min(outputLB, simoutput);
end

warning('on','all')
fprintf('Simulation uncertainty boundary search completed\n')
     
%% Genarate stuct
fieldNames = fieldnames(ShmuelData);
fields = [fieldNames';cell(1,length(fieldNames))];
ShmuelSimulation = struct(fields{:});
for i = 1:length(fieldNames)
    ShmuelSimulation.(fieldNames{i}) = struct('min',outputLB(i,:),'max',outputUB(i,:),'sim',bestSimulatedOutPut(i,:));
end

save(fullfile(FolderName,'ShmuelStructs.mat'),'ShmuelData','ShmuelSimulation')
save(fullfile(FolderName,'p_bestShmuel.mat'), 'bestParams')

end