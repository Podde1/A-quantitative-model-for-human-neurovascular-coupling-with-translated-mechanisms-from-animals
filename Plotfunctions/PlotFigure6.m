%% Ploting script that generates figure 6 from the article
load('GenerateData\GeneratedModelUncertainties/ShmuelStructs.mat')
Res = ShmuelSimulation;

ylab_BOLD={'BOLD signal change (\Delta%)'};
ylab_ACT={'Neural Response (\Delta%)'};
ylab_Vasc={'VSM effect (AU)'};
ylab_Hb = {'Hb Changes (AU)'};
xlab={'Time (seconds)'};

FontSize=16;
x0=0;
y0=0;
width=50;
height=26;

titleY=460;
startTime=0.5;
simScale=1;
timeV=startTime:simScale:40;

fieldNames = fieldnames(Res);

CBOLD = [207 17 220]./255;
CBOLDneg = [131 105 233]./255;
CLFP = [229 150 226]./255;
CLFPneg = [102 51 153]./255;
CNOVSM = [113 246 108]./255;
CNPYVSM = [165 168 120]./255;
CPGE2VSM = [242 184 70]./255;
CHbT = [8 128 60]./255;
CHbO = [174 26 26]./255;
CHbR = [95 207 229]./255;

figure()
    set(gcf,'units','centimeters')
        set(gcf,'position',[x0,y0,width,height])
        set(gcf,'Color',[1 1 1])
        sizebar=0.02;     
   
hBOLD= subplot(2,2,1);
        fieldIdx =1; 
        %% positive BOLD + unc 
        l1= plot(timeV,Res.(fieldNames{fieldIdx}).sim,'-','color',CBOLD,'linewidth',2);
                  hold on

        c1=ciplot(Res.(fieldNames{fieldIdx}).min,Res.(fieldNames{fieldIdx}).max,timeV, CBOLD);
        c1.EdgeColor=CBOLD;
        alpha(c1,.2);
        uistack(c1,'bottom');          
        e1=errorbar(Data.BOLD.t,Data.BOLD.Y(:,1),Data.BOLD.Sigma_Y(:,1),'*','color', CBOLD);
        
        %% Negative BOLD + unc
        fieldIdx =3;
        l2=plot(timeV,Res.(fieldNames{fieldIdx}).sim,'-','color',CBOLDneg,'linewidth',2);
        c2=ciplot(Res.(fieldNames{fieldIdx}).min,Res.(fieldNames{fieldIdx}).max,timeV,CBOLDneg);
        c2.EdgeColor=CBOLDneg;
        alpha(c2,.2);
        uistack(c2,'bottom'); 
        e2=errorbar(Data.BOLDneg.t,Data.BOLDneg.Y(:,1),Data.BOLDneg.Sigma_Y(:,1),'*','color',CBOLDneg');
       
        axis tight
        hBOLD.FontSize=FontSize;

        rectangle('Position',[0,-1,20,sizebar*sum(abs(hBOLD.YLim))],'FaceColor','k')
        hold off

        hBOLD.XTick = [0 10 20 30];
        hBOLD.XTickLabel = [0 10 20 30];
        
        ax=gca;
        pXlim=[0 Data.BOLD.t(end)];
        set(gca,'Xlim',pXlim)

        pos=get(ax,'Position');
        set(ax,'Position',[pos(1)-0.02 pos(2)+0.02 pos(3) pos(4)])

        [ax_x,ax_y]=TufteStyle(ax);
        hold off

        ylabel(ax_y,ylab_BOLD,'FontSize',FontSize,'Interpreter','tex')
        % Title
        Htitle=title(ax_x,'BOLD response','FontSize',FontSize);
        pos=get(Htitle,'Position');
        titlepos=pos(1);
        set(Htitle,'Position',[titlepos titleY+70]);
        
        [~,hBOLDa]=suplabel('A','t',[.08 .08 0 .85]);
        hBOLDa.FontSize=FontSize;
        
    
     hACT= subplot(2,2,2);
        %% positive Act + unc 
        fieldIdx =2; 
        
        l1= plot(Data.act.t,[0,0,0,0,0, Res.(fieldNames{fieldIdx}).sim],'-','color',CLFP,'linewidth',2);
        hold on

        c1=ciplot([0,0,0,0,0,Res.(fieldNames{fieldIdx}).min], [0,0,0,0,0,Res.(fieldNames{fieldIdx}).max],Data.act.t, CLFP);
        c1.EdgeColor=CLFP;
        alpha(c1,.2);
        uistack(c1,'bottom');          
        e1=errorbar(Data.act.t,Data.act.Y(:,1),Data.act.Sigma_Y(:,1),'*','color',CLFP);
        
        %% Negative Act + unc
        fieldIdx =4; 
        l2=plot(Data.actneg.t,[0,0,0,0,0,Res.(fieldNames{fieldIdx}).sim],'-','color',CLFPneg,'linewidth',2);
        c2=ciplot([0,0,0,0,0, Res.(fieldNames{fieldIdx}).min],[0,0,0,0,0, Res.(fieldNames{fieldIdx}).max],Data.actneg.t, CLFPneg);
        c2.EdgeColor=CLFPneg;
        alpha(c2,.2);
        uistack(c2,'bottom'); 
        e2=errorbar(Data.actneg.t,Data.actneg.Y(:,1),Data.actneg.Sigma_Y(:,1),'*','color',CLFPneg);
        axis tight
        hACT.FontSize=FontSize;
        hACT.XTick = [0 10 20 30];
        hACT.XTickLabel = [0 10 20 30];

        rectangle('Position',[0,hACT.YLim(1),21,sizebar*sum(abs(hACT.YLim))],'FaceColor','k')

        ax=gca;
        pXlim=[-5 Data.act.t(end)];
        set(gca,'Xlim',pXlim)

        % Increase width
        pos=get(ax,'Position');
        set(ax,'Position',[pos(1) pos(2)+0.02 pos(3) pos(4)])
       
        [ax_x,ax_y]=TufteStyle(ax);

        % Title
        Htitle=title(ax_x,'Neuronal response','FontSize',FontSize);
        pos=get(Htitle,'Position');
        titlepos=pos(1);
        set(Htitle,'Position',[titlepos titleY+60]);
        
        [~,hActa]=suplabel('B','t',[.04 .08 1 .85]);
        hActa.FontSize=FontSize;
        
        hold off; 
        ylabel(ax_y,ylab_ACT,'FontSize',FontSize,'Interpreter','tex')

        %Legend 
        hold on
        [hleg]=legend([e1,l1,c1],{'Experimental Data','Model Simulation','Model uncertainty'},'FontSize',12,'Location','best');
        hleg.ItemTokenSize=[10 10];
        hleg.Box='off';
        hleg.Position(1)=hleg.Position(1)+0.06;
        hleg.Position(1:2)=[0.85 0.85];
        
        ah1=axes('position',get(gca,'position'),'visible','off'); 
        [hleg2]=legend(ah1,[e2,l2,c2],{'','',''},'FontSize',12,'Location','best');
        hleg2.ItemTokenSize=[10 10];
        hleg2.Box='off';
        hleg2.Position(1)=hleg.Position(1)+0.06;
        hleg2.Position(1:2)=[0.84 0.85];
        
        
        
        
%% test vascular contributions 
[~,  ~, Con, tend, theta] = optsetupfunction(4);

options = amioption('sensi',0,...
    'maxsteps',1e3);
options.sensi = 0;

%% SS simulation
thetaneg = theta(1:38);
thetaneg([1 2 3]) = theta(39:41);
thetaneg(4:12)=theta(44:end);

options = amioption('sensi',0,...
    'maxsteps',1e3);
options.sensi = 0;

%% SS simulation
Ca_start = 10;

% steady state simulation
sol = simulate_SSmodel(inf,theta(4:37),[Ca_start,Con],[],options);

% assaign values to constants in the stimulation simulation
options.x0 = sol.x(end,:).';

tstart = 0.0001;
TE = 20*10^-3;       B0 = 4.7;

Constants = [sol.x(end,[11 9 13]), Ca_start, tstart, tend(1), Con, sol.y(end, 2:6), TE, B0];
Constants_neg = [sol.x(end,[11 9 13]), Ca_start, tstart, tend(1) + 1, Con, sol.y(end, 2:6), TE, B0]; %LFP neg is set to have 21 sec stim length

% alter simulation tolerances, DAE solver can not handle the default values
options.atol = 1e-6;
options.rtol = 1e-12;

%% Simulations
   solReal = simulate_SensoryShmuel(0:0.2:40, theta(1:38), Constants, [], options);
   solRealneg = simulate_SensorynegativeShmuel(0:0.2:40, thetaneg, [Constants_neg,theta(42), theta(43)], [], options);
    
    % POS
    NOVSM = 10^theta(27)*(solReal.x(:,11)-solReal.x(1,11));
    PGEVSM = 10^theta(28)*(solReal.x(:,9)-solReal.x(1,9));
    NPYVSM = 10^theta(29)*(solReal.x(:,13)-solReal.x(1,13));

    % NEG
    NOVSM1 = 10^theta(27)*(solRealneg.x(:,11)-solRealneg.x(1,11));
    PGEVSM1 = 10^theta(28)*(solRealneg.x(:,9)-solRealneg.x(1,9));
    NPYVSM1 = 10^theta(29)*(solRealneg.x(:,13)-solRealneg.x(1,13));

    

    hVasc1= subplot(4,2,5);
        %% positive Vascular
        hold on
        VascPosNO=plot(solReal.t,NOVSM,'-','color',CNOVSM,'linewidth',2);
        VascPosPGE2=plot(solReal.t,PGEVSM,'-','color',CPGE2VSM,'linewidth',2);
        VascPosNPY=plot(solReal.t,NPYVSM,'-','color',CNPYVSM,'linewidth',2);
        
        axis tight
        hVasc1.FontSize=FontSize;
        hVasc1.XTick = [0 10 20 30];
        hVasc1.XTickLabel = [0 10 20 30];
        
        ax=gca;
        pXlim=[0 timeV(end)];
        set(gca,'Xlim',pXlim)
        ylim=get(gca,'Ylim');
        
        rectangle('Position',[0,ylim(1)-0.1,20,2.5*sizebar*sum(abs(hVasc1.YLim))],'FaceColor','k')
                        
        pos=get(ax,'Position');
        set(ax,'Position',[pos(1)-0.02 pos(2)+0.02 pos(3) pos(4)])
       
        [ax_x,ax_y]=TufteStyle(ax);
        set(ax_y,'YLim',[-0.3,0.8])
        
        % Title
        Htitle=title(ax_x,'Positive Vasoactivity','FontSize',FontSize);
        pos=get(Htitle,'Position');
        titlepos=pos(1);
        set(Htitle,'Position',[titlepos titleY-180]);
        
        [~,hVasc1a]=suplabel('C','t',[.08 -0.32 0 .85]);
        hVasc1a.FontSize=FontSize;
        hold off
        
        ylabel(ax_y,ylab_Vasc,'FontSize',FontSize,'Interpreter','tex');
        
       
        
    hVasc2= subplot(4,2,6);
         %% Negative Vascular
        hold on
        VascNegNO=plot(solRealneg.t,NOVSM1,'-','color',CNOVSM,'linewidth',2);
        VascNegPGE2=plot(solRealneg.t,PGEVSM1,'-','color',CPGE2VSM,'linewidth',2);
        VascNegNPY=plot(solRealneg.t,NPYVSM1,'-','color',CNPYVSM,'linewidth',2);

        axis tight
        hVasc2.FontSize=FontSize;
        hVasc2.XTick = [0 10 20 30];
        hVasc2.XTickLabel = [0 10 20 30];
            
            ax=gca;
            pXlim=[0 timeV(end)];
            set(gca,'Xlim',pXlim)
            ylim=get(gca,'Ylim');
            
            rectangle('Position',[0,ylim(1)-0.02,21,2.5*sizebar*sum(abs(hVasc2.YLim))],'FaceColor','k')
          
            pos=get(ax,'Position');
            set(ax,'Position',[pos(1) pos(2)+0.02 pos(3) pos(4)])

        [ax_x,ax_y]=TufteStyle(ax);
        set(ax_y,'YLim',[-0.12,0.05])
        
        ylabel(ax_y,ylab_Vasc,'FontSize',FontSize,'Interpreter','tex');

        % Title
        Htitle=title(ax_x,'Negative Vasoactivity','FontSize',FontSize);
        pos=get(Htitle,'Position');
        titlepos=pos(1);
        set(Htitle,'Position',[titlepos titleY-180]);
        
        [~,hVasc1a]=suplabel('D','t',[0.54 -0.32 0 .85]);
        hVasc1a.FontSize=FontSize;
        hold off
        
    hHb= subplot(4,2,7);
         %% Negative Vascular
        hold on
        PHbT=plot(solReal.t,solReal.y(:,8),'-','color',CHbT,'linewidth',2);
        PHbO=plot(solReal.t,solReal.y(:,9),'-','color',CHbO,'linewidth',2);
        PHbR=plot(solReal.t,solReal.y(:,10),'-','color',CHbR,'linewidth',2);

        axis tight
        hHb.FontSize=FontSize;
        hHb.XTick = [0 10 20 30];
        hHb.XTickLabel = [0 10 20 30];
            
            xlabel(xlab,'FontSize',FontSize)
            ylabel(ylab_Hb,'FontSize',FontSize)
            axis tight
            ax=gca;
            pXlim=[0 timeV(end)];
            set(gca,'Xlim',pXlim)
            ylim=get(gca,'Ylim');
            
            rectangle('Position',[0,ylim(1)-2,20,2*sizebar*sum(abs(hHb.YLim))],'FaceColor','k')
          
            pos=get(ax,'Position');
            set(ax,'Position',[pos(1)-0.02 pos(2)+0.02 pos(3) pos(4)])

        [ax_x,ax_y]=TufteStyle(ax);
        set(ax_y,'YLim',[-5,15])
        
        % Title
        Htitle=title(ax_x,'Positive Hb','FontSize',FontSize);
        pos=get(Htitle,'Position');
        titlepos=pos(1);
        set(Htitle,'Position',[titlepos titleY-210]);
        
        [~,hHbA]=suplabel('E','t',[0.08 -0.545 0 .85]);
        hHbA.FontSize=FontSize;
        hold off
        
    hHb2= subplot(4,2,8);
         %% Negative Vascular
        hold on
        PHbT=plot(solRealneg.t,solRealneg.y(:,8),'-','color',CHbT,'linewidth',2);
        PHbO=plot(solRealneg.t,solRealneg.y(:,9),'-','color',CHbO,'linewidth',2);
        PHbR=plot(solRealneg.t,solRealneg.y(:,10),'-','color',CHbR,'linewidth',2);

        axis tight
        hHb2.FontSize=FontSize;
        hHb2.XTick = [0 10 20 30];
        hHb2.XTickLabel = [0 10 20 30];
        
        xlabel(xlab,'FontSize',FontSize)
        ylabel(ylab_Hb,'FontSize',FontSize)
        
            ax=gca;
            pXlim=[0 timeV(end)];
            set(gca,'Xlim',pXlim)
            ylim=get(gca,'Ylim');
            
            rectangle('Position',[0,ylim(1)-1,21,2*sizebar*sum(abs(hHb2.YLim))],'FaceColor','k')
          
            pos=get(ax,'Position');
            set(ax,'Position',[pos(1) pos(2)+0.02 pos(3) pos(4)])

        [ax_x,~]=TufteStyle(ax);
        
        % Title
        Htitle=title(ax_x,'Negative Hb','FontSize',FontSize);
        pos=get(Htitle,'Position');
        titlepos=pos(1);
        set(Htitle,'Position',[titlepos titleY-210]);
        
        [~,hHb2A]=suplabel('F','t',[0.54 -0.55 0 .85]);
        hHb2A.FontSize=FontSize;
        hold off
        
     %reprint B notation as it disappears    
    [~,hActa]=suplabel('B','t',[.54 0.08 0 .85]);
    hActa.FontSize=FontSize;
    
%% extra y-label
    hTx1=text(18,-0.2,'New Data','horizontalalign','right','rotation',90,'verticalalign','Top');
    hTx1.FontSize = 20;
    hTx1.Position = [-1530 17 0];
    hTx2=text(18,0.2,'Translated mechanisms','horizontalalign','left','rotation',90,'verticalalign','Top');
    hTx2.FontSize = 20;
    hTx2.Position = [-1530 -2 0];
       
        
%% Legend
ah2=axes('position',get(gca,'position'),'visible','off'); 
[hlegVSM]=legend(ah2,[VascNegNO, VascNegNPY, VascNegPGE2], {'NO_{VSM}', 'NPY_{VSM}', 'PGE2_{VSM}'}, 'FontSize',12);

hlegVSM.ItemTokenSize=[10 10];
hlegVSM.Box='off';
hlegVSM.Position(1)=hlegVSM.Position(1)+0.06;
hlegVSM.Position(1:2)=[0.88 0.35];
title(hlegVSM, 'Vasoactive substance');


ah3=axes('position',get(gca,'position'),'visible','off'); 
[hlegVSM2]=legend(ah3,[PHbT, PHbO, PHbR], {'HbT', 'HbO', 'HbR'}, 'FontSize',12);

hlegVSM2.ItemTokenSize=[10 10];
hlegVSM2.Box='off';
hlegVSM2.Position(1)=hlegVSM2.Position(1)+0.06;
hlegVSM2.Position(1:2)=[0.88 0.15];
title(hlegVSM2, 'Hemoglobin (Hb)');
