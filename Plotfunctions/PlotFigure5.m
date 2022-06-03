%% Ploting script that generates figure 5 from the article
load('GenerateData\GeneratedModelUncertainties\DesjardinsStructs.mat')
Data = DesjardinsData;
Res = DesjardinsSimulation;

ylab={'\DeltaHb\it{X} \rm(\muM)'};
ylab_2={'BOLD (\Delta%)'};
ylab_Vasc={'VSM effect (AU)'};
xlab={'Time (seconds)'};

FontSize=16;
x0=0;
y0=0;
width=19.05;
height=22.23;
titleY=245;

CBOLD = [207 17 220]./255;
CHbT = [8 128 60]./255;
CHbO = [174 26 26]./255;
CHbR = [32 170 197]./255;
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


figure('Name', 'Figure 5_plots')
    set(gcf,'units','centimeters')
        set(gcf,'position',[x0,y0,width,height])
        set(gcf,'Color',[1 1 1])
        sizebar=0.02;
        
    hOGin01 = subplot(4,3,1);
    hOGin01.FontSize=FontSize;
    
        %% Unc plot
        hold on               
        c=ciplot(Res.OGinhibitory01.HbT.min(timeV2),Res.OGinhibitory01.HbT.max(timeV2),Data.OGinhibitory01.t,CHbT);
        c.EdgeColor='w';
        c2=ciplot(Res.OGinhibitory01.HbO.min(timeV2),Res.OGinhibitory01.HbO.max(timeV2),Data.OGinhibitory01.t,CHbO);
        c2.EdgeColor='w';
        c3=ciplot(Res.OGinhibitory01.HbR.min(timeV2),Res.OGinhibitory01.HbR.max(timeV2),Data.OGinhibitory01.t,CHbR);
        c3.EdgeColor='w';

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
        set(ax,'Position',[pos(1)+0.02 pos(2)+0.02 pos(3)+0.02 pos(4)])

        [ax_x,ax_y]=TufteStyle(ax);
        ax_x.FontSize = 13;
        ax_y.FontSize = 13;
        hold off

        ylabel(ax_y,ylab,'FontSize',FontSize)

        %% Add overaching title
        Htitle1 = title({'\fontsize{14} OG inhibitory'...
            '\fontsize{12} 0.1s stimulation'},'interpreter','tex');
        Htitle1.Visible = 'on';
        Htitle1.Position(1) = 110;   
        Htitle1.Position(2) = 3.0; 


%% OG excitatory 0.1s 
    hOGex01 = subplot(4,3,2);
    hOGex01.FontSize=FontSize;
    
        hold on
        c=ciplot(Res.OGexcitatory01.HbT.min(timeV3),Res.OGexcitatory01.HbT.max(timeV3),Data.OGexcitatory01.t,CHbT);
        c.EdgeColor='w';             
        c2=ciplot(Res.OGexcitatory01.HbO.min(timeV3),Res.OGexcitatory01.HbO.max(timeV3),Data.OGexcitatory01.t,CHbO);
        c2.EdgeColor='w';
        c3=ciplot(Res.OGexcitatory01.HbR.min(timeV3),Res.OGexcitatory01.HbR.max(timeV3),Data.OGexcitatory01.t,CHbR);
        c3.EdgeColor='w';

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
        set(ax,'Position',[pos(1)+0.04 pos(2)+0.02 pos(3)+0.02 pos(4)])

        [ax_x,ax_y]=TufteStyle(ax);
        ax_x.FontSize = 13;
        ax_y.FontSize = 13;
        hold off
   
    Htitle2 = title({'\fontsize{14} OG excitatory'...
        '\fontsize{12} 0.1s stimulation'},'interpreter','tex');
    Htitle2.Position(1) = 110;   
    Htitle2.Position(2) = 6.5; 
    


%% Sensory Short
    hSens2 = subplot(4,3,3);
    hSens2.FontSize = 1.4;
        hold on
        c=ciplot(Res.Sensory2.HbT.min(timeV6),Res.Sensory2.HbT.max(timeV6),Data.Sensory2.t,CHbT);
        c.EdgeColor='w';
        c2=ciplot(Res.Sensory2.HbO.min(timeV6),Res.Sensory2.HbO.max(timeV6),Data.Sensory2.t,CHbO);
        c2.EdgeColor='w';
        c3=ciplot(Res.Sensory2.HbR.min(timeV6),Res.Sensory2.HbR.max(timeV6),Data.Sensory2.t,CHbR);
        c3.EdgeColor='w';

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
        set(ax,'Position',[pos(1)+0.06 pos(2)+0.02 pos(3)+0.02 pos(4)])

        [ax_x,ax_y]=TufteStyle(ax);
        ax_x.FontSize = 13;
        ax_y.FontSize = 13;
        ax_x.XTick = [0 5 10];
        ax_x.XTickLabel = [0 5 10];
        ax_y.YTick = [-1 0 1 2];
        ax_y.YTickLabel = [-1 0 1 2];

        % Title
        Htitle3 = title({'\fontsize{14} Sensory' ...
            '\fontsize{12} 2s stimulation'},'interpreter','tex');
        Htitle3.Position(1) = 110;   
        Htitle3.Position(2) = 1.60; 
        
        
        
%% OG Inhibitory 20
    hOGin20= subplot(4,3,4);
    hOGin20.FontSize=FontSize;
        hold on     
        c=ciplot(Res.OGinhibitory20.HbT.min(timeV),Res.OGinhibitory20.HbT.max(timeV),Data.OGinhibitory20.t,CHbT);
        c.EdgeColor='w';
          
        c2=ciplot(Res.OGinhibitory20.HbO.min(timeV),Res.OGinhibitory20.HbO.max(timeV),Data.OGinhibitory20.t,CHbO);
        c2.EdgeColor='w';

        c3=ciplot(Res.OGinhibitory20.HbR.min(timeV),Res.OGinhibitory20.HbR.max(timeV),Data.OGinhibitory20.t,CHbR);
        c3.EdgeColor='w';

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
        set(ax,'Position',[pos(1)+0.02 pos(2)+0.03 pos(3)+0.02 pos(4)])

        [ax_x,ax_y]=TufteStyle(ax);
        ax_x.FontSize = 13;
        ax_y.FontSize = 13;
        ax_x.XTick = [0 20 40 60];
        ax_x.XTickLabel = [0 20 40 60];
        hold off

        ylabel(ax_y,ylab,'FontSize',FontSize,'Interpreter','tex')
%         xlabel(ax_x,xlab,'FontSize',FontSize,'Interpreter','tex')
        
        % Title
        Htitle=title(ax_x,'20s stimulation','FontSize',12);
        pos=get(Htitle,'Position');
        titlepos=pos(1);
        set(Htitle,'Position',[titlepos+5 titleY-115]);

%% OG EXCITATORY 20s
    hOGex20 = subplot(4,3,5);
    hOGex20.FontSize=FontSize;
        hold on
        c=ciplot(Res.OGexcitatory20.HbT.min(timeV4),Res.OGexcitatory20.HbT.max(timeV4),Data.OGexcitatory20.t,CHbT);
        c.EdgeColor='w';
        hold on               
        c2=ciplot(Res.OGexcitatory20.HbO.min(timeV4),Res.OGexcitatory20.HbO.max(timeV4),Data.OGexcitatory20.t,CHbO);
        c2.EdgeColor='w';
        c3=ciplot(Res.OGexcitatory20.HbR.min(timeV4),Res.OGexcitatory20.HbR.max(timeV4),Data.OGexcitatory20.t,CHbR);
        c3.EdgeColor='w';

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
        set(ax,'Position',[pos(1)+0.04 pos(2)+0.03 pos(3)+0.02 pos(4)])
        [ax_x,ax_y]=TufteStyle(ax);
        ax_x.FontSize = 13;
        ax_y.FontSize = 13;
        ax_x.XTick = [0 20 40 60];
        ax_x.XTickLabel = [0 20 40 60];
        hold off
        
%         xlabel(ax_x,xlab,'FontSize',FontSize,'Interpreter','tex')
        % Title
        Htitle=title(ax_x,'20s stimulation','FontSize',12);
        pos=get(Htitle,'Position');
        titlepos=pos(1);
        set(Htitle,'Position',[titlepos+5 titleY-115]);
              
  

%% Sensory long
    hSens20 = subplot(4,3,6);
    hSens20.FontSize = 1.4;
        hold on
        c=ciplot(Res.Sensory20.HbT.min(timeV5),Res.Sensory20.HbT.max(timeV5),Data.Sensory20.t,CHbT);
        c.EdgeColor='w';             
        c2=ciplot(Res.Sensory20.HbO.min(timeV5),Res.Sensory20.HbO.max(timeV5),Data.Sensory20.t,CHbO);
        c2.EdgeColor='w';
        c3=ciplot(Res.Sensory20.HbR.min(timeV5),Res.Sensory20.HbR.max(timeV5),Data.Sensory20.t,CHbR);
        c3.EdgeColor='w';

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
        set(ax,'Position',[pos(1)+0.06 pos(2)+0.03 pos(3)+0.02 pos(4)])
        [ax_x,ax_y]=TufteStyle(ax);
        ax_x.FontSize = 13;
        ax_y.FontSize = 13;
        ax_x.XTick = [0 20 40 60];
        ax_x.XTickLabel = [0 20 40 60];
        ax_y.YLim(2) = 7;
        ax_y.YTick = [-2 0 2 4 6]; 
        ax_y.YTickLabel = [-2 0 2 4 6];
        hold off
        
%         xlabel(ax_x,xlab,'FontSize',FontSize,'Interpreter','tex')
        % Title
        Htitle=title(ax_x,'20s stimulation','FontSize',12);
        pos=get(Htitle,'Position');
        titlepos=pos(1);
        set(Htitle,'Position',[titlepos+5 titleY-115]);
        
        
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
    hVascOGin = subplot(4,3,7);
        hold on 
        NO = plot(simOGin20.t, NOVSM, '-', 'color', CNOVSM, 'linewidth', 2);
        NPY = plot(simOGin20.t, NPYVSM, '-', 'color', CNPYVSM, 'linewidth', 2);
        PGE = plot(simOGin20.t, PGEVSM, '-', 'color', CPGE2VSM, 'linewidth', 2);
        
        axis([0 60 min([NOVSM; NPYVSM; PGEVSM]) max([NOVSM; NPYVSM; PGEVSM])])
        rectangle('Position',[0, (min([NOVSM; NPYVSM; PGEVSM])-0.03),20,sizebar*sum(abs(hVascOGin.YLim))*1],'FaceColor','k')
        axis tight
        hold off
        
        ax = gca;
        pos=get(ax,'Position');
        set(ax,'Position',[pos(1)+0.02 pos(2)+0.01 pos(3)+0.02 pos(4)])

        [ax_x,ax_y]=TufteStyle(ax);
        ax_x.FontSize = 13;
        ax_y.FontSize = 13;
        ax_x.XTick = [0 20 40 60];
        ax_x.XTickLabel = [0 20 40 60];
        ax_y.YLim = [(min([NOVSM; NPYVSM; PGEVSM])-0.03), max([NOVSM; NPYVSM; PGEVSM])];
        
        ylabel(ylab_Vasc, 'FontSize', FontSize,'Interpreter','tex')
        x11 = xlabel(ax_x,xlab,'FontSize',FontSize);
        x11.Position(2) = x11.Position(2) + 10;

%% Vascular stimuli OG ex
    hVascOGex = subplot(4,3,8);
        hold on 
        NO2 = plot(simOGex20.t, NOVSM2, '-', 'color', CNOVSM, 'linewidth', 2);
        NPY2 = plot(simOGex20.t, NPYVSM2, '-', 'color', CNPYVSM, 'linewidth', 2);
        PGE2 = plot(simOGex20.t, PGEVSM2, '-', 'color', CPGE2VSM, 'linewidth', 2);
        
        axis([0 60 min([NOVSM2; NPYVSM2; PGEVSM2]) max([NOVSM2; NPYVSM2; PGEVSM2])])
        rectangle('Position',[0, (min([NOVSM2; NPYVSM2; PGEVSM2])-0.05) ,20,sizebar*sum(abs(hVascOGex.YLim))*1.2],'FaceColor','k')
        hold off      

        ax=gca;
        pos=get(ax,'Position');
        set(ax,'Position',[pos(1)+0.04 pos(2)+0.01 pos(3)+0.02 pos(4)])

        [ax_x,ax_y]=TufteStyle(ax);
        ax_x.FontSize = 13;
        ax_y.FontSize = 13;
        ax_x.XTick = [0 20 40 60];
        ax_x.XTickLabel = [0 20 40 60];
        ax_y.YLim = [(min([NOVSM2; NPYVSM2; PGEVSM2])-0.05), max([NOVSM2; NPYVSM2; PGEVSM2])];
        
        x12 = xlabel(ax_x,xlab,'FontSize',FontSize,'Interpreter','tex');
        x12.Position(2) = x12.Position(2) + 10;

%% Vascular stimuli Sens
    hVascSens = subplot(4,3,9);
        hold on 
        NO3 = plot(simSens20.t, NOVSM3, '-', 'color', CNOVSM, 'linewidth', 2);
        NPY3 = plot(simSens20.t, NPYVSM3, '-', 'color', CNPYVSM, 'linewidth', 2);
        PGE3 = plot(simSens20.t, PGEVSM3, '-', 'color', CPGE2VSM, 'linewidth', 2);
        
        axis([0 60 min([NOVSM3; NPYVSM3; PGEVSM3]) max([NOVSM3; NPYVSM3; PGEVSM3])])
        rectangle('Position',[0,(min([NOVSM3; NPYVSM3; PGEVSM3])-0.03),20,sizebar*sum(abs(hVascSens.YLim))*1.2],'FaceColor','k')
        hold off      

        ax=gca;
        pos=get(ax,'Position');
        set(ax,'Position',[pos(1)+0.06 pos(2)+0.01 pos(3)+0.02 pos(4)])

        [ax_x,ax_y]=TufteStyle(ax);
        ax_x.FontSize = 13;
        ax_y.FontSize = 13;
        ax_x.XTick = [0 20 40 60];
        ax_x.XTickLabel = [0 20 40 60];
        ax_y.YTick = [-0.1 0 0.1 0.2];
        ax_y.YTickLabel = [-0.1 0 0.1 0.2];
        ax_y.YLim = [(min([NOVSM3; NPYVSM3; PGEVSM3])-0.03), max([NOVSM3; NPYVSM3; PGEVSM3])];
        
        x13 = xlabel(ax_x,xlab,'FontSize',FontSize,'Interpreter','tex');
        x13.Position(2) = x13.Position(2) + 10;
       
%% BOLD 
    hBOLDval = subplot(4,3,10);
        hold on
        c4=ciplot(Res.OGexcitatory20BOLD.BOLD.min(timeV7),Res.OGexcitatory20BOLD.BOLD.max(timeV7),Data.OGexcitatory20BOLD.t,CBOLD);
        c4.EdgeColor='w';
        alpha(c4,.2);
        uistack(c4,'bottom');
        d4=errorbar(Data.OGexcitatory20BOLD.t,Data.OGexcitatory20BOLD.Y(:,:),Data.OGexcitatory20BOLD.Sigma_Y(:,:),'*','color', CBOLD);

        hold off
        axis([0 60 -1 4.1])
        rectangle('Position',[0,-0.5,20,sizebar*sum(abs(hBOLDval.YLim))*0.7],'FaceColor','k')

        ax=gca;
        pos=get(ax,'Position');
        set(ax,'Position',[pos(1)+0.02 pos(2)-0.04 pos(3)+0.02 pos(4)])
        
        % Increase width
        [ax_xBOLD,ax_yBOLD]=TufteStyle(ax);
        ax_xBOLD.FontSize = 13;
        ax_yBOLD.FontSize = 13;
        ax_xBOLD.XTick = [0 20 40 60];
        ax_xBOLD.XTickLabel = [0 20 40 60];
        
        ylabel(ax_yBOLD,ylab_2,'FontSize',FontSize,'Interpreter','tex')
        x1 = xlabel(ax_xBOLD,xlab,'FontSize',FontSize,'Interpreter','tex');
        x1.Position(2) = x1.Position(2) + 10;    

        % Title  
        Htitle=title(ax_xBOLD,'20s stimulation','FontSize',12);
        pos=get(Htitle,'Position');
        titlepos=pos(1);
        set(Htitle,'Position',[titlepos titleY-112]);
        
        
%% extra y-label
    hTx11=text(-100,23.50,'New data','horizontalalign','right','rotation',90,'verticalalign','Top');
    hTx11.FontSize = 18;
    
%     hTx12=text(-100,19.65,'New data','horizontalalign','right','rotation',90,'verticalalign','Top');
%     hTx12.FontSize = 20;
    
    hTx13=text(-100,3.3,'New data','horizontalalign','right','rotation',90,'verticalalign','Top');
    hTx13.FontSize = 18;

    hTx2=text(-100,5.8,'Preserved mechanisms','horizontalalign','left','rotation',90,'verticalalign','Top');
    hTx2.FontSize = 18;
    
%% Titels
    ahHb=axes('position',get(gca,'position'),'visible','off'); 

    HtitleHb = title(ahHb,{'\fontsize{14} Hemoglobin dynamics upon short and long sensory/OG challenge'},'interpreter','tex');
    HtitleHb.Visible = 'on';
    HtitleHb.Position(1:2) = [300 5.77];    
    
    ahBOLD=axes('position',get(gca,'position'),'visible','off'); 

    HtitleBOLD = title(ahBOLD,{'\fontsize{14} Predicted BOLD response'},'interpreter','tex');
    HtitleBOLD.Visible = 'on';
    HtitleBOLD.Position(1:2) = [90 1.1];   
    
    ahVasc=axes('position',get(gca,'position'),'visible','off'); 

    ahVasc = title(ahVasc,{'\fontsize{14} Predicted vasoactive effect of the three neuron types'},'interpreter','tex');
    ahVasc.Visible = 'on';
    ahVasc.Position(1:2) = [310 2.79];   
%% numbering of subplots
        [~,hA]=suplabel('A','t',[.02 .08 0 .88]);
        hA.FontSize=14;
        hA.Position(1) = 60;
        
        [~,hB]=suplabel('B','t',[.02 .08 0.77 .88]);
        hB.FontSize=14;

        [~,hC]=suplabel('C','t',[.08 .08 1.26 .88]);
        hC.FontSize=14;

        [~,hD]=suplabel('D','t',[.02 .08 0 .655]);
        hD.FontSize=14;
        hD.Position(1) = 60;
        
        [~,hE]=suplabel('E','t',[.02 .08 0.77 .655]);
        hE.FontSize=14;
        
        [~,hF]=suplabel('F','t',[.08 .08 1.26 .655]);
        hF.FontSize=14;
     
        [~,hG]=suplabel('G','t',[.02 .08 0 .415]);
        hG.FontSize=14;
        hG.Position(1) = 60;
        
        [~,hH]=suplabel('H','t',[.02 .08 0.77 .415]);
        hH.FontSize=14;
        
        [~,hI]=suplabel('I','t',[.08 .08 1.26 .415]);
        hI.FontSize=14;
        
        [~,hJ]=suplabel('J','t',[.02 .08 0 .15]);
        hJ.FontSize=14;
        hJ.Position(1) = 60;
%         
        
  %% Legends
    
        [hleg]=legend([p2,p1,p3],{'HbT','HbO','HbR'},'FontSize',14,'Location','best');
        hleg.ItemTokenSize=[10 10];
        hleg.Box='off';
        hleg.Position(1)=hleg.Position(1)+0.06;
        hleg.Position(1:2)=[0.55 0.11];
        
        ahLEG=axes('position',get(gca,'position'),'visible','off'); 
        titleLEG = title(ahLEG,{'\fontsize{14}' 'Model simulations,'... 
            'data, uncertainties'},'interpreter','tex');
        titleLEG.Visible = 'on';
        titleLEG.Position(1:2) = [320 0.82]; 
        
            ah0=axes('position',get(gca,'position'),'visible','off'); 
            [hleg2]=legend(ah0,[e2,e1,e3],{'','',''},'FontSize',14,'Location','best');
            hleg2.ItemTokenSize=[10 10];
            hleg2.Box='off';
            hleg2.Position(1)=hleg.Position(1)+0.06;
            hleg2.Position(1:2)=[0.532 0.11];
            
            ah01=axes('position',get(gca,'position'),'visible','off'); 
            [hleg3]=legend(ah01,[c2,c,c3],{'','',''},'FontSize',14,'Location','best');
            hleg3.ItemTokenSize=[10 10];
            hleg3.Box='off';
            hleg3.Position(1)=hleg.Position(1)+0.06;
            hleg3.Position(1:2)=[0.51 0.11];
  
        
     ah3=axes('position',get(gca,'position'),'visible','off'); 
        [hlegData3]=legend(ah3,[d4,c4], {'Validation data','Prediction'}, 'FontSize',14);
        hlegData3.ItemTokenSize=[10 8];
        hlegData3.Box='off';
        hlegData3.Position(1:2)=[0.48 0.025];
        title(hlegData3, 'Model Prediction');
        
     ah4=axes('position',get(gca,'position'),'visible','off'); 
        [hlegVasc]=legend(ah4,[NO3,NPY3,PGE3], {'NO_{VSM}', 'NPY_{VSM}', 'PGE2_{VSM}'}, 'FontSize',14);
        hlegVasc.ItemTokenSize=[10 8];
        hlegVasc.Box='off';
        hlegVasc.Position(1:2)=[0.77 0.11];
        title(hlegVasc, {'Arteriole'...
            'stimulation'});
   