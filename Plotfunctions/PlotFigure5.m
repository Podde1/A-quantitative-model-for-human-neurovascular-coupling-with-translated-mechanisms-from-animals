%% Ploting script that generates figure 5 from the article
load('GenerateData\GeneratedModelUncertainties\DesjardinsStructs.mat')
Data = DesjardinsData;
Res = DesjardinsSimulation;

ylab={'\DeltaHb\it{X} \rm(\muM)'};
ylab_2={'\DeltaHb\it{X} \rm(\muM) / BOLD (\Delta%)'};
ylab_Vasc={'VSM effect (AU)'};
xlab={'Time (seconds)'};

FontSize=16;
x0=0;
y0=0;
width=44.45;
height=25.85;
titleY=245;

CBOLD = [207 17 220]./255;
CHbT = [8 128 60]./255;
CHbO = [174 26 26]./255;
CHbR = [95 207 229]./255;
CNOVSM = [113 246 108]./255;
CNPYVSM = [165 168 120]./255;
CPGE2VSM = [242 184 70]./255;

timeV = 1:size(Data.OGinhibitory20.t,1);
timeV2= 1:size(Data.OGinhibitory01.t,1);
timeV3= 1:size(Data.OGexcitatory01.t,1);
timeV4= 1:size(Data.OGexcitatory20.t,1);
timeV5= 1:size(Data.Sensory20.t,1);
timeV6= 1:size(Data.Sensory2.t,1);
timeV7= 1:size(Data.OGexcitatory20BOLD.t,1);


figure()
    set(gcf,'units','centimeters')
        set(gcf,'position',[x0,y0,width,height])
        set(gcf,'Color',[1 1 1])
        sizebar=0.02;
        
 
        
    hOGin01 = subplot(3,4,1);
    hOGin01.FontSize=FontSize;

        %% Unc plot
        hold on               
        c=ciplot(Res.OGinhibitory01.HbT.min(timeV2),Res.OGinhibitory01.HbT.max(timeV2),Data.OGinhibitory01.t,CHbT);
        c.EdgeColor=CHbT;
        c2=ciplot(Res.OGinhibitory01.HbO.min(timeV2),Res.OGinhibitory01.HbO.max(timeV2),Data.OGinhibitory01.t,CHbO);
        c2.EdgeColor=CHbO;
        c3=ciplot(Res.OGinhibitory01.HbR.min(timeV2),Res.OGinhibitory01.HbR.max(timeV2),Data.OGinhibitory01.t,CHbR);
        c3.EdgeColor=CHbR;

        alpha(c,.2);
        uistack(c,'bottom');
        alpha(c2,.2);
        uistack(c2,'bottom');
        alpha(c3,.2);
        uistack(c3,'bottom');

        %% Simulation and Data Plotting
        plot(Data.OGinhibitory01.t,Res.OGinhibitory01.HbT.sim(timeV2),'-','linewidth',2,'Color',CHbT);
        errorbar(Data.OGinhibitory01.t,Data.OGinhibitory01.Y(:,1),Data.OGinhibitory01.Sigma_Y(:,1),'*','Color',CHbT);
        plot(Data.OGinhibitory01.t,Res.OGinhibitory01.HbO.sim(timeV2),'-', 'color', CHbO,'linewidth',2);
        errorbar(Data.OGinhibitory01.t,Data.OGinhibitory01.Y(:,2),Data.OGinhibitory01.Sigma_Y(:,2),'*', 'color', CHbO);
        plot(Data.OGinhibitory01.t,Res.OGinhibitory01.HbR.sim(timeV2),'-', 'color', CHbR,'linewidth',2);
        errorbar(Data.OGinhibitory01.t,Data.OGinhibitory01.Y(:,3),Data.OGinhibitory01.Sigma_Y(:,3),'*', 'color', CHbR');
        rectangle('Position',[0,-1.5,0.1,sizebar*sum(abs(hOGin01.YLim))],'FaceColor','k');

        hold off

        axis tight
        ax=gca;
        pXlim=[0 Data.OGinhibitory01.t(end)];
        set(gca,'Xlim',pXlim)
        set(gca,'Ylim',[-2 4]);
        
        % Increase width
        pos=get(ax,'Position');
        set(ax,'Position',[pos(1)-0.06 pos(2)-0.04 pos(3)+0.02 pos(4)+0.04])

        [~,ax_y]=TufteStyle(ax);
        hold off

        ylabel(ax_y,ylab,'FontSize',FontSize)

        %% Add overaching title
        Htitle1 = title({'\fontsize{14} OG inhibitory'...
            '\fontsize{12} 0.1s stimulation'},'interpreter','tex');
        Htitle1.Visible = 'on';
        Htitle1.Position(1) = 275;   
        Htitle1.Position(2) = 3.5; 


%% OG excitatory 0.1s 
    hOGex01 = subplot(3,4,2);
    hOGex01.FontSize=FontSize;
        hold on
        c=ciplot(Res.OGexcitatory01.HbT.min(timeV3),Res.OGexcitatory01.HbT.max(timeV3),Data.OGexcitatory01.t,CHbT);
        c.EdgeColor=CHbT;              
        c2=ciplot(Res.OGexcitatory01.HbO.min(timeV3),Res.OGexcitatory01.HbO.max(timeV3),Data.OGexcitatory01.t,CHbO);
        c2.EdgeColor=CHbO;
        c3=ciplot(Res.OGexcitatory01.HbR.min(timeV3),Res.OGexcitatory01.HbR.max(timeV3),Data.OGexcitatory01.t,CHbR);
        c3.EdgeColor=CHbR;

        alpha(c,.2);
        uistack(c,'bottom');
        alpha(c2,.2);
        uistack(c2,'bottom');
        alpha(c3,.2);
        uistack(c3,'bottom');

        plot(Data.OGexcitatory01.t,Res.OGexcitatory01.HbT.sim(timeV3),'-','linewidth',2,'Color',CHbT)
        errorbar(Data.OGexcitatory01.t,Data.OGexcitatory01.Y(:,1),Data.OGexcitatory01.Sigma_Y(:,1),'*','Color',CHbT)
        plot(Data.OGexcitatory01.t,Res.OGexcitatory01.HbO.sim(timeV3),'-', 'color', CHbO,'linewidth',2)
        errorbar(Data.OGexcitatory01.t,Data.OGexcitatory01.Y(:,2),Data.OGexcitatory01.Sigma_Y(:,2),'*', 'color', CHbO)
        plot(Data.OGexcitatory01.t,Res.OGexcitatory01.HbR.sim(timeV3),'-', 'color', CHbR,'linewidth',2)
        errorbar(Data.OGexcitatory01.t,Data.OGexcitatory01.Y(:,3),Data.OGexcitatory01.Sigma_Y(:,3),'*', 'color', CHbR')
        axis([0 10 -5 16.5])
        rectangle('Position',[0,-2.5,0.1,sizebar*sum(abs(hOGex01.YLim))*0.6],'FaceColor','k')
        hold off

        axis tight
        ax=gca;
        set(gca,'Ylim',[-3 8]);


        % Increase width
        pos=get(ax,'Position');
        set(ax,'Position',[pos(1)-0.03 pos(2)-0.04 pos(3)+0.02 pos(4)+0.04])

        [~,~]=TufteStyle(ax);
        hold off
   
    Htitle2 = title({'\fontsize{14} OG excitatory'...
        '\fontsize{12} 0.1s stimulation'},'interpreter','tex');
    Htitle2.Position(1) = 275;   
    Htitle2.Position(2) = 7; 
    


%% Sensory Short
    hSens2 = subplot(3,4,3);
    hSens2.FontSize = 1.4;
        hold on
        c=ciplot(Res.Sensory2.HbT.min(timeV6),Res.Sensory2.HbT.max(timeV6),Data.Sensory2.t,CHbT);
        c.EdgeColor=CHbT;
        c2=ciplot(Res.Sensory2.HbO.min(timeV6),Res.Sensory2.HbO.max(timeV6),Data.Sensory2.t,CHbO);
        c2.EdgeColor=CHbO;
        c3=ciplot(Res.Sensory2.HbR.min(timeV6),Res.Sensory2.HbR.max(timeV6),Data.Sensory2.t,CHbR);
        c3.EdgeColor=CHbR;

        alpha(c,.2);
        uistack(c,'bottom');
        alpha(c2,.2);
        uistack(c2,'bottom');
        alpha(c3,.2);
        uistack(c3,'bottom');

        p1=plot(Data.Sensory2.t,Res.Sensory2.HbT.sim(timeV6),'-','linewidth',2,'Color',CHbT);
        e1=errorbar(Data.Sensory2.t,Data.Sensory2.Y(:,1),Data.Sensory2.Sigma_Y(:,1),'*','Color',CHbT);
        p2=plot(Data.Sensory2.t,Res.Sensory2.HbO.sim(timeV6),'-', 'color', CHbO,'linewidth',2);
        e2=errorbar(Data.Sensory2.t,Data.Sensory2.Y(:,2),Data.Sensory2.Sigma_Y(:,2),'*', 'color', CHbO);
        p3=plot(Data.Sensory2.t,Res.Sensory2.HbR.sim(timeV6),'-', 'color', CHbR,'linewidth',2);
        e3=errorbar(Data.Sensory2.t,Data.Sensory2.Y(:,3),Data.Sensory2.Sigma_Y(:,3),'*', 'color', CHbR');
        axis([0 10 -3 6.5])
        rectangle('Position',[0,-1.2,2,sizebar*sum(abs(hSens2.YLim))*0.5],'FaceColor','k')
        hold off

        axis tight
        ax=gca;
        set(gca,'Ylim',[-1.5 2])

        % Increase width
        pos=get(ax,'Position');
        set(ax,'Position',[pos(1)+0 pos(2)-0.04 pos(3)+0.02 pos(4)+0.04])

        [ax_x,~]=TufteStyle(ax);
        ax_x.XTick = [0 5 10];
        ax_x.XTickLabel = [0 5 10];

        % Title
        Htitle3 = title({'\fontsize{14} Sensory' ...
            '\fontsize{12} 2s stimulation'},'interpreter','tex');
        Htitle3.Position(1) = 275;   
        Htitle3.Position(2) = 1.5; 
        
        
        
%% OG INhibitory 20
    hOGin20= subplot(3,4,5);
    hOGin20.FontSize=FontSize;
        hold on     
        c=ciplot(Res.OGinhibitory20.HbT.min(timeV),Res.OGinhibitory20.HbT.max(timeV),Data.OGinhibitory20.t,CHbT);
        c.EdgeColor=CHbT;
          
        c2=ciplot(Res.OGinhibitory20.HbO.min(timeV),Res.OGinhibitory20.HbO.max(timeV),Data.OGinhibitory20.t,CHbO);
        c2.EdgeColor=CHbO;

        c3=ciplot(Res.OGinhibitory20.HbR.min(timeV),Res.OGinhibitory20.HbR.max(timeV),Data.OGinhibitory20.t,CHbR);
        c3.EdgeColor=CHbR;

        alpha(c,.2);
        uistack(c,'bottom');
        alpha(c2,.2);
        uistack(c2,'bottom');
        alpha(c3,.2);
        uistack(c3,'bottom');

        plot(Data.OGinhibitory20.t,Res.OGinhibitory20.HbT.sim(timeV),'-','linewidth',2,'Color',CHbT)
        errorbar(Data.OGinhibitory20.t,Data.OGinhibitory20.Y(:,1),Data.OGinhibitory20.Sigma_Y(:,1),'*','Color',CHbT)
        plot(Data.OGinhibitory20.t,Res.OGinhibitory20.HbO.sim(timeV),'-', 'color', CHbO,'linewidth',2)
        errorbar(Data.OGinhibitory20.t,Data.OGinhibitory20.Y(:,2),Data.OGinhibitory20.Sigma_Y(:,2),'*', 'color', CHbO)
        plot(Data.OGinhibitory20.t,Res.OGinhibitory20.HbR.sim(timeV),'-', 'color', CHbR,'linewidth',2)
        errorbar(Data.OGinhibitory20.t,Data.OGinhibitory20.Y(:,3),Data.OGinhibitory20.Sigma_Y(:,3),'*', 'color', CHbR')

        rectangle('Position',[0,-2.1,20,sizebar*sum(abs(hOGin20.YLim))],'FaceColor','k')

        hold off

        axis tight
        ax=gca;
        pXlim=[0 Data.OGinhibitory20.t(end)];
        set(gca,'Xlim',pXlim)
        set(gca,'Ylim',[-2.2 5.1]);

        % Increase width
        pos=get(ax,'Position');
        set(ax,'Position',[pos(1)-0.06 pos(2)-0.04 pos(3)+0.02 pos(4)+0.04])

        [ax_x,ax_y]=TufteStyle(ax);
        ax_x.XTick = [0 20 40 60];
        ax_x.XTickLabel = [0 20 40 60];
        hold off

        ylabel(ax_y,ylab_2,'FontSize',FontSize,'Interpreter','tex')
        
        % Title
        Htitle=title(ax_x,'20s stimulation','FontSize',12);
        pos=get(Htitle,'Position');
        titlepos=pos(1);
        set(Htitle,'Position',[titlepos titleY+120]);

%% OG EXCITATORY 20s
    hOGex20 = subplot(3,4,6);
    hOGex20.FontSize=FontSize;
        hold on
        c=ciplot(Res.OGexcitatory20.HbT.min(timeV4),Res.OGexcitatory20.HbT.max(timeV4),Data.OGexcitatory20.t,CHbT);
        c.EdgeColor=CHbT;
        hold on               
        c2=ciplot(Res.OGexcitatory20.HbO.min(timeV4),Res.OGexcitatory20.HbO.max(timeV4),Data.OGexcitatory20.t,CHbO);
        c2.EdgeColor=CHbO;
        c3=ciplot(Res.OGexcitatory20.HbR.min(timeV4),Res.OGexcitatory20.HbR.max(timeV4),Data.OGexcitatory20.t,CHbR);
        c3.EdgeColor=CHbR;

        alpha(c,.2);
        uistack(c,'bottom');
        alpha(c2,.2);
        uistack(c2,'bottom');
        alpha(c3,.2);
        uistack(c3,'bottom');

        plot(Data.OGexcitatory20.t,Res.OGexcitatory20.HbT.sim(timeV4),'-','linewidth',2,'Color',CHbT)
        errorbar(Data.OGexcitatory20.t,Data.OGexcitatory20.Y(:,1),Data.OGexcitatory20.Sigma_Y(:,1),'*','Color',CHbT)
        plot(Data.OGexcitatory20.t,Res.OGexcitatory20.HbO.sim(timeV4),'-', 'color', CHbO,'linewidth',2)
        errorbar(Data.OGexcitatory20.t,Data.OGexcitatory20.Y(:,2),Data.OGexcitatory20.Sigma_Y(:,2),'*', 'color', CHbO)
        plot(Data.OGexcitatory20.t,Res.OGexcitatory20.HbR.sim(timeV4),'-', 'color', CHbR,'linewidth',2)
        errorbar(Data.OGexcitatory20.t,Data.OGexcitatory20.Y(:,3),Data.OGexcitatory20.Sigma_Y(:,3),'*', 'color', CHbR')
        
        rectangle('Position',[0,-5,20,sizebar*sum(abs(hOGex20.YLim))*0.6],'FaceColor','k')

        hold off
        axis([0 60 -6 18])

        ax=gca;

        % Increase width
        pos=get(ax,'Position');
        set(ax,'Position',[pos(1)-0.03 pos(2)-0.04 pos(3)+0.02 pos(4)+0.04])

        [ax_x,~]=TufteStyle(ax);
        ax_x.XTick = [0 20 40 60];
        ax_x.XTickLabel = [0 20 40 60];
        hold off

        % Title
        Htitle=title(ax_x,'20s stimulation','FontSize',12);
        pos=get(Htitle,'Position');
        titlepos=pos(1);
        set(Htitle,'Position',[titlepos+2 titleY+120]);
              
  

%% Sensory long
    hSens20 = subplot(3,4,7);
    hSens20.FontSize = 1.4;
        hold on
        c=ciplot(Res.Sensory20.HbT.min(timeV5),Res.Sensory20.HbT.max(timeV5),Data.Sensory20.t,CHbT);
        c.EdgeColor=CHbT;              
        c2=ciplot(Res.Sensory20.HbO.min(timeV5),Res.Sensory20.HbO.max(timeV5),Data.Sensory20.t,CHbO);
        c2.EdgeColor=CHbO;
        c3=ciplot(Res.Sensory20.HbR.min(timeV5),Res.Sensory20.HbR.max(timeV5),Data.Sensory20.t,CHbR);
        c3.EdgeColor=CHbR;

        alpha(c,.2);
        uistack(c,'bottom');
        alpha(c2,.2);
        uistack(c2,'bottom');
        alpha(c3,.2);
        uistack(c3,'bottom');


        errorbar(Data.Sensory20.t,Data.Sensory20.Y(:,1),Data.Sensory20.Sigma_Y(:,1),'*','Color',CHbT)
        plot(Data.Sensory20.t,Res.Sensory20.HbT.sim(timeV5),'-','linewidth',2,'Color',CHbT)
        plot(Data.Sensory20.t,Res.Sensory20.HbO.sim(timeV5),'-', 'color', CHbO,'linewidth',2)
        errorbar(Data.Sensory20.t,Data.Sensory20.Y(:,2),Data.Sensory20.Sigma_Y(:,2),'*', 'color', CHbO)
        plot(Data.Sensory20.t,Res.Sensory20.HbR.sim(timeV5),'-', 'color', CHbR,'linewidth',2)
        errorbar(Data.Sensory20.t,Data.Sensory20.Y(:,3),Data.Sensory20.Sigma_Y(:,3),'*', 'color', CHbR')
        
        rectangle('Position',[0,-3,20,sizebar*sum(abs(hSens20.YLim))*0.7],'FaceColor','k')
        hold off
        axis([0 60 -3.5 7])

        axis tight
        ax=gca;
        
        pos=get(ax,'Position');
        set(ax,'Position',[pos(1)+0 pos(2)-0.04 pos(3)+0.02 pos(4)+0.04])

        [ax_x,ax_y]=TufteStyle(ax);
        ax_x.XTick = [0 20 40 60];
        ax_x.XTickLabel = [0 20 40 60];
        ax_y.YLim(2) = 7;
        ax_y.YTick = [-2 0 2 4 6]; 
        ax_y.YTickLabel = [-2 0 2 4 6];
        hold off

        % Title
        Htitle=title(ax_x,'20s stimulation','FontSize',12);
        pos=get(Htitle,'Position');
        titlepos=pos(1);
        set(Htitle,'Position',[titlepos titleY+120]);
    
        
%% BOLD 
    hBOLDval = subplot(3,4,8);
        hold on
        c4=ciplot(Res.OGexcitatory20BOLD.BOLD.min(timeV7),Res.OGexcitatory20BOLD.BOLD.max(timeV7),Data.OGexcitatory20BOLD.t,CBOLD);
        c4.EdgeColor=CBOLD;
        alpha(c4,.2);
        uistack(c4,'bottom');
        d4=errorbar(Data.OGexcitatory20BOLD.t,Data.OGexcitatory20BOLD.Y(:,:),Data.OGexcitatory20BOLD.Sigma_Y(:,:),'*','color', CBOLD);

        hold off
        xlabel(xlab,'FontSize',FontSize)
        axis([0 60 -1 4.1])
        rectangle('Position',[0,-0.5,20,sizebar*sum(abs(hBOLDval.YLim))*0.7],'FaceColor','k')

        ax=gca;
        pos=get(ax,'Position');
        set(ax,'Position',[pos(1)+0.01 pos(2)-0.04 pos(3)+0.02 pos(4)+0.04])
        
        % Increase width
        [ax_xBOLD,~]=TufteStyle(ax);
        ax_xBOLD.XTick = [0 20 40 60];
        ax_xBOLD.XTickLabel = [0 20 40 60];
        
        hold off      

        % Title  
        Htitle=title(ax_xBOLD,'20s stimulation','FontSize',12);
        pos=get(Htitle,'Position');
        titlepos=pos(1);
        set(Htitle,'Position',[titlepos titleY+130]);
        
        
%% Vascular plots - simulation 
    [~, Data, Con, tend, ~] = optsetupfunction(3);
    bestParams = load('theta_Desjardins_VSM.mat');
    theta = bestParams.X';
    
    %params 
    pOGin=theta(1:36);
    pOGex=[theta(37) theta(3:36)];
    pSensLong=[theta(38:40) theta(3:36)];

    % simoptions
    options = amioption('sensi',0,...
        'maxsteps',1e5);
    options.sensi = 0;
    options.nmaxevent=1e4;
    % values for initial saturations and pressure
    Ca_start = 10;

    % steady state simulation
    options.atol = 1e-9;
    options.rtol = 1e-16;
    sol = simulate_SSmodel(inf,theta(3:36),[Ca_start,Con],[],options);

    % assaign values to constants and intitaial conditions in the stimulation simulation
    HbO_0 = sol.y(2);
    HbR_0 = sol.y(3);
    SaO2_0 = sol.y(4);
    ScO2_0 = sol.y(5);
    SvO2_0 = sol.y(6);

    options.x0 = sol.x(end,:).';

    TE = 20*10^-3;       B0 = 7;

    Constants = [sol.x(end,[11 9 13]), Ca_start, tend(1), Con, HbO_0, HbR_0, SaO2_0, ScO2_0, SvO2_0, TE, B0];

    % alter simulation tolerances, DAE solver can not handle the default values
    options.atol = 1e-6;
    options.rtol = 1e-9;
     optionsLong=options;
    optionsLong.maxsteps=1e6;    


    Constants(5) = tend(1);
        simOGin20 = simulate_OGinhibitoryDesjardins(0:1:Data.OGinhibitory20.t(end),pOGin,Constants,[] , optionsLong);
        simOGex20 = simulate_OGexcitatoryDesjardins(0:1:Data.OGexcitatory20.t(end),pOGex,Constants, [], optionsLong);
        simSens20 = simulate_SensoryDesjardins(0:1:Data.Sensory20.t(end),pSensLong,Constants,[],optionsLong);
     
    NOVSM = 10^pOGin(26)*(simOGin20.x(:,11)-simOGin20.x(1,11));
    PGEVSM = 10^pOGin(27)*(simOGin20.x(:,9)-simOGin20.x(1,9));
    NPYVSM = 10^pOGin(28)*(simOGin20.x(:,13)-simOGin20.x(1,13));
        
    NOVSM2 = 10^pOGex(25)*(simOGex20.x(:,11)-simOGex20.x(1,11));    
    PGEVSM2 = 10^pOGex(26)*(simOGex20.x(:,9)-simOGex20.x(1,9));
    NPYVSM2 = 10^pOGex(27)*(simOGex20.x(:,13)-simOGex20.x(1,13));
    
    NOVSM3 = 10^pSensLong(27)*(simSens20.x(:,11)-simSens20.x(1,11));
    PGEVSM3 = 10^pSensLong(28)*(simSens20.x(:,9)-simSens20.x(1,9));
    NPYVSM3 = 10^pSensLong(29)*(simSens20.x(:,13)-simSens20.x(1,13));    
%% Vascular stimuli OG in
    hVascOGin = subplot(3,4,9);
        hold on 
        NO = plot(simOGin20.t, NOVSM, '-', 'color', CNOVSM, 'linewidth', 2);
        NPY = plot(simOGin20.t, NPYVSM, '-', 'color', CNPYVSM, 'linewidth', 2);
        PGE = plot(simOGin20.t, PGEVSM, '-', 'color', CPGE2VSM, 'linewidth', 2);
        
        axis([0 60 min([NOVSM; NPYVSM; PGEVSM]) max([NOVSM; NPYVSM; PGEVSM])])
        rectangle('Position',[0, (min([NOVSM; NPYVSM; PGEVSM])-0.03),20,sizebar*sum(abs(hVascOGin.YLim))*1],'FaceColor','k')
        axis tight
        hold off
        
        ylabel(ylab_Vasc, 'FontSize', FontSize)
        xlabel(xlab,'FontSize',FontSize)
        
        ax=gca;
        pos=get(ax,'Position');
        set(ax,'Position',[pos(1)-0.06 pos(2)-0.04 pos(3)+0.02 pos(4)+0.04])

        [ax_x,ax_y]=TufteStyle(ax);
        ax_x.XTick = [0 20 40 60];
        ax_x.XTickLabel = [0 20 40 60];
        ax_y.YLim = [(min([NOVSM; NPYVSM; PGEVSM])-0.03), max([NOVSM; NPYVSM; PGEVSM])];

%% Vascular stimuli OG ex
    hVascOGex = subplot(3,4,10);
        hold on 
        NO2 = plot(simOGex20.t, NOVSM2, '-', 'color', CNOVSM, 'linewidth', 2);
        NPY2 = plot(simOGex20.t, NPYVSM2, '-', 'color', CNPYVSM, 'linewidth', 2);
        PGE2 = plot(simOGex20.t, PGEVSM2, '-', 'color', CPGE2VSM, 'linewidth', 2);
        
        axis([0 60 min([NOVSM2; NPYVSM2; PGEVSM2]) max([NOVSM2; NPYVSM2; PGEVSM2])])
        rectangle('Position',[0, (min([NOVSM2; NPYVSM2; PGEVSM2])-0.05) ,20,sizebar*sum(abs(hVascOGex.YLim))*1.2],'FaceColor','k')
        hold off      
        
        xlabel(xlab,'FontSize',FontSize)
        ax=gca;
        pos=get(ax,'Position');
        set(ax,'Position',[pos(1)-0.03 pos(2)-0.04 pos(3)+0.02 pos(4)+0.04])

        [ax_x,ax_y]=TufteStyle(ax);
        ax_x.XTick = [0 20 40 60];
        ax_x.XTickLabel = [0 20 40 60];
        ax_y.YLim = [(min([NOVSM2; NPYVSM2; PGEVSM2])-0.05), max([NOVSM2; NPYVSM2; PGEVSM2])];

%% Vascular stimuli Sens
    hVascSens = subplot(3,4,11);
        hold on 
        NO3 = plot(simSens20.t, NOVSM3, '-', 'color', CNOVSM, 'linewidth', 2);
        NPY3 = plot(simSens20.t, NPYVSM3, '-', 'color', CNPYVSM, 'linewidth', 2);
        PGE3 = plot(simSens20.t, PGEVSM3, '-', 'color', CPGE2VSM, 'linewidth', 2);
        
        axis([0 60 min([NOVSM3; NPYVSM3; PGEVSM3]) max([NOVSM3; NPYVSM3; PGEVSM3])])
        rectangle('Position',[0,(min([NOVSM3; NPYVSM3; PGEVSM3])-0.03),20,sizebar*sum(abs(hVascSens.YLim))*1.2],'FaceColor','k')
        hold off      

        xlabel(xlab,'FontSize',FontSize)

        ax=gca;
        pos=get(ax,'Position');
        set(ax,'Position',[pos(1)+0 pos(2)-0.04 pos(3)+0.02 pos(4)+0.04])

        [ax_x,ax_y]=TufteStyle(ax);
        ax_x.XTick = [0 20 40 60];
        ax_x.XTickLabel = [0 20 40 60];
        ax_y.YLim = [(min([NOVSM3; NPYVSM3; PGEVSM3])-0.03), max([NOVSM3; NPYVSM3; PGEVSM3])];
        
        
        
        
%% extra y-label
    hTx1=text(18,-0.2,'New Data','horizontalalign','right','rotation',90,'verticalalign','Top');
    hTx1.FontSize = 20;
    hTx1.Position = [-1530 0.85 0];
    hTx2=text(18,0.2,'Preserved mechanisms','horizontalalign','left','rotation',90,'verticalalign','Top');
    hTx2.FontSize = 20;
    hTx2.Position = [-1530 -0.15 0];
%% numbering of subplots
        [~,hA]=suplabel('A','t',[.02 .08 0 .85]);
        hA.FontSize=14;
        hA.Position(1) = 65;
        
        [~,hB]=suplabel('B','t',[.02 .08 0.52 .85]);
        hB.FontSize=14;

        [~,hC]=suplabel('C','t',[.08 .08 0.87 .85]);
        hC.FontSize=14;

        [~,hD]=suplabel('D','t',[.02 .08 0 .55]);
        hD.FontSize=14;
        hD.Position(1) = 65;
        
        [~,hE]=suplabel('E','t',[.02 .08 0.52 .55]);
        hE.FontSize=14;
        
        [~,hF]=suplabel('F','t',[.08 .08 0.87 .55]);
        hF.FontSize=14;
        
        [~,hG]=suplabel('G','t',[.08 .08 1.29 .54]);
        hG.FontSize=14;
        hG.Position(1) = 0.505;
        
        [~,hH]=suplabel('H','t',[.02 .08 0 .24]);
        hH.FontSize=14;
        hH.Position(1) = 60;
        
        [~,hI]=suplabel('I','t',[.08 .08 0.4 .24]);
        hI.FontSize=14;
        
        [~,hJ]=suplabel('J','t',[.08 .08 0.86 .24]);
        hJ.FontSize=14;

        
        
  %% Legends
  
    [hlegSim]=legend([p2,p3,p1],{'Oxygenated Hemoglobin (HbO)','Deoxygenated Hemoglobin (HbR)','Total Hemoglobin (HbT)'},'FontSize',14,'Location','best');
    hlegSim.ItemTokenSize=[10 8];
    hlegSim.Box='off';
    hlegSim.Position(1:2)= [0.73,0.85];
    title(hlegSim, 'Model simulations')
      
     ah1=axes('position',get(gca,'position'),'visible','off'); 
        [hlegData]=legend(ah1,[e2,e3,e1], {'HbO', 'HbR', 'HbT'}, 'FontSize',14);
        hlegData.ItemTokenSize=[10 8];
        hlegData.Box='off';
        hlegData.Position(1)=hlegData.Position(1)+0.06;
        hlegData.Position(1:2)=[0.91 0.85];
        title(hlegData, 'Experimental Data');
          
     ah2=axes('position',get(gca,'position'),'visible','off'); 
        [hlegData2]=legend(ah2,[c2,c3,c], {'HbO', 'HbR', 'HbT'}, 'FontSize',14);
        hlegData2.ItemTokenSize=[10 8];
        hlegData2.Box='off';
        hlegData2.Position(1:2)=[0.77 0.72];
        title(hlegData2, 'Model Uncertanties');
        
     ah3=axes('position',get(gca,'position'),'visible','off'); 
        [hlegData3]=legend(ah3,[d4,c4], {'Validation data','Prediction'}, 'FontSize',14);
        hlegData3.ItemTokenSize=[10 8];
        hlegData3.Box='off';
        hlegData3.Position(1:2)=[0.87 0.74];
        title(hlegData3, 'Model Precition');
        
     ah4=axes('position',get(gca,'position'),'visible','off'); 
        [hlegVasc]=legend(ah4,[NO3,NPY3,PGE3], {'NO vasoactive substance', 'NPY vasoactivesubstance', 'PGE2 vasoactive substance'}, 'FontSize',14);
        hlegVasc.ItemTokenSize=[10 8];
        hlegVasc.Box='off';
        hlegVasc.Position(1:2)=[0.77 0.17];
        title(hlegVasc, 'Artery stimulation');
    