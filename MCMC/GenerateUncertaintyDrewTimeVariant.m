function []=GenerateUncertaintyDrewTimeVariant(FolderName,FileName)

[~, Data, Constants, stimend, ~] = optsetupfunction(1);

cutoff = chi2inv(0.95, 288); %288 data points for the model to fit against

ds = datastore([FolderName,'/',FileName]);
alldata = tall(ds);

SPcost = table2array(alldata(:,1));
SPparams = table2array(alldata(:,2:42));  


%% get best simulation
fprintf('best simulation')

[miniCost,minIndex] = min(gather(SPcost));
bestParams = gather(SPparams(minIndex,:));

bestSimulatedOutPut = SimulateDrewTimeVariantAll(bestParams', Constants, stimend, Data,cutoff);

%% Filter to the ones the are bleow minCost+chi2(#params)
filterIdx = SPcost < miniCost+chi2inv(0.95,length(bestParams));

%% return the parameters and the cost, which fullfills the demand, into memory
fprintf('params and cost')
[sampledCost, sampledParameters] = gather(SPcost(filterIdx), SPparams(filterIdx,:));

SPsize = size(sampledCost,1);

%% run simulations
fprintf('Finding Simulation uncertainty boundaries....\n')
warning('off','all')

outputUB = NaN*ones(size(bestSimulatedOutPut,1),size(bestSimulatedOutPut,2));
outputLB = NaN*ones(size(bestSimulatedOutPut,1),size(bestSimulatedOutPut,2));

parfor i = 1:SPsize
    if mod(i,1000)==0
        fprintf('%d of %d.\n',i,SPsize); 
    end

    simoutput = SimulateDrewTimeVariantAll(sampledParameters(i,:)', Constants, stimend, Data, cutoff);
    outputUB = max(outputUB, simoutput);
    outputLB = min(outputLB, simoutput);       
end

warning('on','all')
fprintf('Simulation uncertainty boundary search completed\n')

%% Genarate stuct
fieldNames = fieldnames(Data);
fields = [fieldNames';cell(1,length(fieldNames))];
DrewSimulation = struct(fields{:});
for i = 1:length(fieldNames)
    j = (i-1)*2 + 1;
    DrewSimulation.(fieldNames{i}).Art = struct('min',outputLB(j,:)  ,'max',outputUB(j,:)  ,'sim',bestSimulatedOutPut(j,:));
    DrewSimulation.(fieldNames{i}).Ven = struct('min',outputLB(j+1,:),'max',outputUB(j+1,:),'sim',bestSimulatedOutPut(j+1,:));
end

save(fullfile(FolderName,'DrewTimeVariantStructs.mat'),'Data','DrewSimulation')
save(fullfile(FolderName,'p_bestDrewTimeVariant.mat'), 'bestParams')

end
