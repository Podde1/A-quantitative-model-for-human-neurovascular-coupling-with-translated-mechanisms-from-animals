function []=GenerateUncertaintyDesjardins(FolderName,FileName)

[~, ~, Constants, stimend] = optsetupfunction(3);
Data = load('DesjardinsData.mat'); 
DesjardinsData = Data.DesjardinsData;
cutoff = chi2inv(0.95, 354); %354 data points for the model to fit against

ds = datastore([FolderName,'/',FileName]);
alldata = tall(ds);

SPcost = table2array(alldata(:,1));
SPparams = table2array(alldata(:,2:44));  


%% get best simulation
fprintf('best simulation')

[miniCost,minIndex] = min(gather(SPcost));
bestParams = gather(SPparams(minIndex,:));

bestSimulatedOutPut = SimulateDesjardinsAll(bestParams', Constants, stimend, DesjardinsData,cutoff);

%% Filter to the ones the are bleow minCost+chi2(#params)
filterIdx = SPcost < miniCost+chi2inv(0.95,length(bestParams));

%% return the parameters and the cost, which fullfills the demand, into memory
fprintf('params and cost')
[sampledCost, sampledParameters] = gather(SPcost(filterIdx), SPparams(filterIdx,:));

SPsize = size(sampledCost,1);
%% run simulations
fprintf('Finding Simulation uncertainty boundaries....\n')
warning('off','all')

outputUB = nan(size(bestSimulatedOutPut,1),size(bestSimulatedOutPut,2));
outputLB = nan(size(bestSimulatedOutPut,1),size(bestSimulatedOutPut,2));

for i = 1:SPsize

    if mod(i,1000)==0
        fprintf('%d of %d.\n',i,SPsize); 
    end
    
    simoutput = SimulateDesjardinsAll(sampledParameters(i,:)', Constants, stimend, DesjardinsData, cutoff);

    outputUB = max(outputUB, simoutput);
    outputLB = min(outputLB, simoutput);    
end

%%
warning('on','all')
fprintf('Simulation uncertainty boundary search completed\n')

%% Genarate stuct
fieldNames = fieldnames(DesjardinsData);
fields = [fieldNames';cell(1,length(fieldNames))];
DesjardinsSimulation = struct(fields{:});
for i = 1:length(fieldNames)
    if i <7
    j = (i-1)*3 +1;
    DesjardinsSimulation.(fieldNames{i}).HbT = struct('min',outputLB(j,:)  ,'max',outputUB(j,:)  ,'sim',bestSimulatedOutPut(j,:));
    DesjardinsSimulation.(fieldNames{i}).HbO = struct('min',outputLB(j+1,:),'max',outputUB(j+1,:),'sim',bestSimulatedOutPut(j+1,:));
    DesjardinsSimulation.(fieldNames{i}).HbR = struct('min',outputLB(j+2,:),'max',outputUB(j+2,:),'sim',bestSimulatedOutPut(j+2,:));
    
    elseif strcmp(fieldNames{i},'OGexcitatory20BOLD')
        DesjardinsSimulation.(fieldNames{i}).BOLD = struct('min',outputLB(19,:),'max',outputUB(19,:),'sim',bestSimulatedOutPut(19,:));
    end
end

save(fullfile(FolderName,'DesjardinsStructs.mat'),'DesjardinsData','DesjardinsSimulation')
save(fullfile(FolderName,'p_bestDesjardins.mat'), 'bestParams')

end
