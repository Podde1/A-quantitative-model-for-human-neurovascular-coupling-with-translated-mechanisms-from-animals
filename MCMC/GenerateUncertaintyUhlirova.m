function [] = GenerateUncertaintyUhlirova(FileName, FolderName)
%% Initial setup
[~, Data, Con, ~, X] = optsetupfunction(2);

ds = datastore([FolderName,'/',FileName]);
alldata = tall(ds);

SPparams = table2array(alldata(:,2:(length(X)+1)));  
Samples = gather(SPparams);

Samples=[0 X.'; Samples];
simScale=0.5;
startTime=0;
 %% Number of iterations
 iter=size(Samples,1);
 
  h = waitbar(0,'Please wait...');

 %% Setup matrixes for saving simulations
 
 %% Uncertainty of estimations
M_solOGex=zeros(iter,size(startTime:simScale:Data(1).t(end),2));
M_solOGin=zeros(iter,size(startTime:simScale:Data(2).t(end),2));
M_solSens=zeros(iter,size(startTime:simScale:Data(3).t(end),2));
M_solOGinAw=zeros(iter,size(startTime:simScale:Data(4).t(end),2));
M_solSensAw=zeros(iter,size(startTime:simScale:Data(5).t(end),2));

    %% Uncertainty of predictions
    M_solOGexP=zeros(iter,size(startTime:simScale:Data(1).t(42),2));
    M_solOGinP=zeros(iter,size(startTime:simScale:Data(2).t(end),2));
    M_solSensP=zeros(iter,size(startTime:simScale:Data(3).t(end),2));

     t1=startTime:simScale:Data(1).t(end);
     t2=startTime:simScale:Data(2).t(end);
     t3=startTime:simScale:Data(3).t(end);
     t4=startTime:simScale:Data(4).t(end);
     t5=startTime:simScale:Data(5).t(end);
     t6=startTime:simScale:Data(1).t(42);


    Samples=[0 X; Samples];

    warning('off','all');
    %% Simulation options
    options = amioption('sensi',0,...
    'maxsteps',1e4);
    options.sensi = 0;
    optionsMain=options;
    optionsMain.atol = 1e-6;
    optionsMain.rtol = 1e-12;
    tstart = 0.0001;
    TE = 20*10^-3;       B0 = 7;
    Ca_start = 10;
    %% MAIN LOOP
    steps=iter;
for i=1:iter

    theta=Samples(i,2:end).'; % Select new parameters
    waitbar(i/steps) % update waitbar

    pOGinAnes=[theta(1:2); theta(4:37)];
    pOGexAnes=[theta(3); theta(4:37)];
    pSensAnes=[theta(38:40); theta(4:37)];
    thetaAwake=theta(4:37);
    thetaAwake(1:9)=theta(41:49);
    pOGinAwake=[theta(50:51); thetaAwake];
    pSensAwake=[theta(52:54); thetaAwake];

    pOGexAnesP=pOGexAnes; pOGexAnesP([2,3])=-30;
    pSensAnesP=pSensAnes; pSensAnesP(29)=-15;

    %% SS simulation

    sol = simulate_SSmodel_2(inf,theta(4:37),[Ca_start,Con],[],options);

    % assaign values to constants in the stimulation simulation
    HbO_0 = sol.y(2);
    HbR_0 = sol.y(3);
    SaO2_0 = sol.y(4);
    ScO2_0 = sol.y(5);
    SvO2_0 = sol.y(6);

    optionsMain.x0 = sol.x(end,:).';

    %Constants = [ssArt, Ca_start, tstart, stimend(1), Con, HbO_0, HbR_0, SaO2_0, ScO2_0, SvO2_0, TE, B0];
    Constants = [sol.x(end,[11 9 13]), Ca_start, tstart, 1, Con, HbO_0, HbR_0, SaO2_0, ScO2_0, SvO2_0, TE, B0];

    Constants(5:6)=[0.9, 1];
    simOGex = simulate_Uhli_OGex(t1,pOGexAnes,Constants,[], optionsMain);
    simOGexP = simulate_Uhli_OGex(t6,pOGexAnesP,Constants, [], optionsMain);

    Constants(5:6)=[0.55 1];
    simOGin = simulate_Uhli_OGin(t2,pOGinAnes,Constants, [], optionsMain);
    simOGinP = simulate_Uhli_OGinP(t2,pOGinAnes,Constants, [], optionsMain);

    Constants(5:6)=[tstart 2];
    simSens = simulate_Uhli_Sens(t3,pSensAnes,Constants,[],optionsMain);
    simSensP = simulate_Uhli_Sens(t3,pSensAnesP,Constants,[],optionsMain);

    % %% Awake
    Constants(6)=1;
    simSensAw = simulate_Uhli_Sens(t5,pSensAwake,Constants,[],optionsMain);
    Constants(5:6)=[tstart 0.4];
    simOGinAw = simulate_Uhli_OGin(t4,pOGinAwake,Constants, [], optionsMain);

  if simOGex.status<0 && simOGexP.status<0 && simOGin.status<0 && simOGinP.status<0 && simSens.status<0 && simSensP.status<0 && simSensAw.status<0 && simOGinAw.status<0
        M_solOGex(i,:)=NaN;
        M_solOGin(i,:)=NaN;
        M_solSens(i,:)=NaN;
        M_solOGinAw(i,:)=NaN;
        M_solSensAw(i,:)=NaN;

        %% Uncertainty of predictions
        M_solOGexP(i,:)=NaN;
        M_solOGinP(i,:)=NaN;
        M_solSensP(i,:)=NaN;
  else

       %    if cost <109.2353
        M_solOGex(i,:)=simOGex.y;
        M_solOGin(i,:)=simOGin.y;
        M_solSens(i,:)=simSens.y;
        M_solOGinAw(i,:)=simOGinAw.y;
        M_solSensAw(i,:)=simSensAw.y;

        %% Uncertainty of predictions
        M_solOGexP(i,:)=simOGexP.y;
        M_solOGinP(i,:)=simOGinP.y;
        M_solSensP(i,:)=simSensP.y;

  end
      
end

close(h);
warning('on','all');
Res=[];

Res.solOGex.min=min(M_solOGex);
Res.solOGex.max=max(M_solOGex);
Res.solOGex.sim=M_solOGex(1,:);

Res.solOGexP.min=min(M_solOGexP);
Res.solOGexP.max=max(M_solOGexP);
Res.solOGexP.sim=M_solOGexP(1,:);

Res.solOGin.min=min(M_solOGin);
Res.solOGin.max=max(M_solOGin);
Res.solOGin.sim=M_solOGin(1,:);

Res.solOGinP.min=min(M_solOGinP);
Res.solOGinP.max=max(M_solOGinP);
Res.solOGinP.sim=M_solOGinP(1,:);

Res.solSens.min=min(M_solSens);
Res.solSens.max=max(M_solSens);
Res.solSens.sim=M_solSens(1,:);

Res.solSensP.min=min(M_solSensP);
Res.solSensP.max=max(M_solSensP);
Res.solSensP.sim=M_solSensP(1,:);

Res.solOGinAw.min=min(M_solOGinAw);
Res.solOGinAw.max=max(M_solOGinAw);
Res.solOGinAw.sim=M_solOGinAw(1,:);

Res.solSensAw.min=min(M_solSensAw);
Res.solSensAw.max=max(M_solSensAw);
Res.solSensAw.sim=M_solSensAw(1,:);

%% Save results
save(fullfile(FolderName,'UhlirovaStructs.mat'),'Data','Res')
end