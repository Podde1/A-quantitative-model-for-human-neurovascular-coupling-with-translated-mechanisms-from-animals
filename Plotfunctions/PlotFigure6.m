%% Plotting script that generates figure 6 from the article
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
width=19.05;
height=22.23;

titleY=185;
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
CHbR = [32 170 197]./255;

figure('Name', 'Figure 6_plots')
    set(gcf,'units','centimeters')
        set(gcf,'position',[x0,y0,width,height])
        set(gcf,'Color',[1 1 1])
        sizebar=0.02;     
   
hBOLD= subplot(3,2,1);
        fieldIdx =1; 
        %% positive BOLD + unc 
        l1 = plot(timeV,Res.(fieldNames{fieldIdx}).sim,'-','color',CBOLD,'linewidth',2);
                  hold on

        c1=ciplot(Res.(fieldNames{fieldIdx}).min,Res.(fieldNames{fieldIdx}).max,timeV, CBOLD);
        c1.EdgeColor='w';
        alpha(c1,.2);
        uistack(c1,'bottom');          
        e1 = errorbar(Data.BOLD.t,Data.BOLD.Y(:,1),Data.BOLD.Sigma_Y(:,1),'*','color', CBOLD);
        
        %% Negative BOLD + unc
        fieldIdx =3;
        l2 = plot(timeV,Res.(fieldNames{fieldIdx}).sim,'-','color',CBOLDneg,'linewidth',2);
        c2=ciplot(Res.(fieldNames{fieldIdx}).min,Res.(fieldNames{fieldIdx}).max,timeV,CBOLDneg);
        c2.EdgeColor='w';
        alpha(c2,.2);
        uistack(c2,'bottom'); 
        e2 = errorbar(Data.BOLDneg.t,Data.BOLDneg.Y(:,1),Data.BOLDneg.Sigma_Y(:,1),'*','color',CBOLDneg');
       
        axis tight
        hBOLD.FontSize=FontSize;

        rectangle('Position',[0,-1,20,sizebar*sum(abs(hBOLD.YLim))],'FaceColor','k')
        hold off

        hBOLD.XTick = [0 10 20 30 40];
        hBOLD.XTickLabel = [0 10 20 30 40];
        
        ax=gca;
        set(gca,'Xlim',[0 40])

        pos=get(ax,'Position');
        set(ax,'Position',[pos(1) pos(2)+0.015 pos(3)+0.01 pos(4)])

        [ax_x,ax_y]=TufteStyle(ax);
        ax_x.FontSize = 13;
        ax_y.FontSize = 13;
        hold off

        ylabel(ax_y,ylab_BOLD,'FontSize',FontSize,'Interpreter','tex')
        % Title
        Htitle=title(ax_x,'BOLD response','FontSize',FontSize-2);
        pos=get(Htitle,'Position');
        titlepos=pos(1);
        set(Htitle,'Position',[titlepos titleY+10]);
        
        [~,hBOLDa]=suplabel('A','t',[.10 .08 0 .88]);
        hBOLDa.FontSize=FontSize;
        
    
     hACT= subplot(3,2,2);
        %% positive Act + unc 
        fieldIdx =2; 
        
        l3= plot(Data.act.t,[0,0,0,0,0, Res.(fieldNames{fieldIdx}).sim],'-','color',CLFP,'linewidth',2);
        hold on

        c3=ciplot([0,0,0,0,0,Res.(fieldNames{fieldIdx}).min], [0,0,0,0,0,Res.(fieldNames{fieldIdx}).max],Data.act.t, CLFP);
        c3.EdgeColor='w';
        alpha(c3,.2);
        uistack(c3,'bottom');          
        e3=errorbar(Data.act.t,Data.act.Y(:,1),Data.act.Sigma_Y(:,1),'*','color',CLFP);
        
        %% Negative Act + unc
        fieldIdx =4; 
        l4=plot(Data.actneg.t,[0,0,0,0,0,Res.(fieldNames{fieldIdx}).sim],'-','color',CLFPneg,'linewidth',2);
        c4=ciplot([0,0,0,0,0, Res.(fieldNames{fieldIdx}).min],[0,0,0,0,0, Res.(fieldNames{fieldIdx}).max],Data.actneg.t, CLFPneg);
        c4.EdgeColor='w';
        alpha(c4,.2);
        uistack(c4,'bottom'); 
        e4=errorbar(Data.actneg.t,Data.actneg.Y(:,1),Data.actneg.Sigma_Y(:,1),'*','color',CLFPneg);
        axis tight
        axis([-5 40 -40 95])
        hACT.FontSize=FontSize;
        hACT.XTick = [0 10 20 30 40];
        hACT.XTickLabel = [0 10 20 30 40];

        rectangle('Position',[0,hACT.YLim(1),21,sizebar*sum(abs(hACT.YLim))],'FaceColor','k')

        ax=gca;
        set(gca,'Xlim',[-5 40])

        % Increase width
        pos=get(ax,'Position');
        set(ax,'Position',[pos(1)+0.03 pos(2)+0.015 pos(3)+0.01 pos(4)])
       
        [ax_x,ax_y]=TufteStyle(ax);
        ax_x.FontSize = 13;
        ax_y.FontSize = 13;

        % Title
        Htitle=title(ax_x,'Neuronal response','FontSize',FontSize-2);
        pos=get(Htitle,'Position');
        titlepos=pos(1);
        set(Htitle,'Position',[titlepos titleY+10]);
        
        hold off; 
        ylabel(ax_y,ylab_ACT,'FontSize',FontSize,'Interpreter','tex')

        %Legend 
        hold on
        [hleg]=legend([l1,l2,l3,l4],{'Pos BOLD','Neg BOLD','Pos LFP','Neg LFP'},'FontSize',12,'Location','best');
        hleg.ItemTokenSize=[10 10];
        hleg.Box='off';
        hleg.Position(1:2)=[0.86 0.80];
        
        ahLEG=axes('position',get(gca,'position'),'visible','off'); 
        titleLEG = title(ahLEG,{'\fontsize{12}' 'Model simulations,'... 
            'data, uncertainties'},'interpreter','tex');
        titleLEG.Visible = 'on';
        titleLEG.Position(1:2) = [222 0.82]; 
        
            ah1=axes('position',get(gca,'position'),'visible','off'); 
            [hleg2]=legend(ah1,[e1,e2,e3,e4],{'','','',''},'FontSize',12,'Location','best');
            hleg2.ItemTokenSize=[10 10];
            hleg2.Box='off';
            hleg2.Position(1:2)=[0.842 0.80];
            
            ah2=axes('position',get(gca,'position'),'visible','off'); 
            [hleg3]=legend(ah2,[c1,c2,c3,c4],{'','','',''},'FontSize',12,'Location','best');
            hleg3.ItemTokenSize=[10 10];
            hleg3.Box='off';
            hleg3.Position(1:2)=[0.820 0.80];
        
        
        
%% test vascular contributions 
[~,  ~, Con, tend, theta] = optsetupfunction(4);

thetapos = theta(1:38);
% obs theta(42:43) are the signs parameters 
thetaneg = theta(1:38);
thetaneg([1 2 3]) = theta(39:41);
thetaneg(4:12)=theta(44:end);

thetapos = 10.^(thetapos);
thetaneg = 10.^(thetaneg);

options = amioption('sensi',0,...
    'maxsteps',1e3);
options.sensi = 0;

%% SS simulation
Ca_start = 10;

% steady state simulation
sol = simulate_SSModel(inf,thetapos(4:38),[Ca_start,Con],[],options);

% assaign values to constants in the stimulation simulation
options.x0 = sol.x(end,:).';
p1 = 1; 
p2 = 1; 
p3 = 1; 
stim_onoff = 1; 

TE = 20*10^-3;       B0 = 4.7;

Constants = [sol.x(end,[11 9 13]), Ca_start, Con, sol.y(end, 2:6), TE, B0, p1, p2, p3, stim_onoff];

p1_neg = theta(42); 
p2_neg = theta(43); 
p3_neg = -1; 

Constants_neg = [sol.x(end,[11 9 13]), Ca_start, Con, sol.y(end, 2:6), TE, B0, p1_neg, p2_neg, p3_neg, stim_onoff]; %Neg stimulation set to 21 sec

% alter simulation tolerances, DAE solver can not handle the default values
options.atol = 1e-6;
options.rtol = 1e-12;
optionsPos = options;
optionsNeg = options;

%% Simulations
    t1 = 0:0.5:tend(1);
    solReal = simulate_Model(t1, thetapos, Constants, [], optionsPos);
    optionsPos.x0 = solReal.x(end,:)';

    t2 = (tend(1):0.5:40) - tend(1);
    Constants(end) = 0; 
    solReal2 = simulate_Model(t2, thetapos, Constants, [], optionsPos);
    
    simPos.t = [t1, t2(2:end)+tend(1)];
    simPos.x = [solReal.x ; solReal2.x(2:end,:)];
    simPos.y = [solReal.y ; solReal2.y(2:end,:)];
    
    % 
    t1 = 0:0.5:(tend(1)+1);
    solRealneg = simulate_ModelNegative(t1, thetaneg, Constants_neg, [], optionsNeg);
    
    optionsNeg.x0 = solRealneg.x(end,:)';
    Constants_neg(end) = 0;
    t2 = ((tend(1)+1):0.5:40) - (tend(1)+1);
    solRealneg2 = simulate_ModelNegative(t2, thetaneg, Constants_neg, [], optionsNeg);
    
    simNeg.t = [t1, t2(2:end)+(tend(1)+1)];
    simNeg.x = [solRealneg.x ; solRealneg2.x(2:end,:)];
    simNeg.y = [solRealneg.y ; solRealneg2.y(2:end,:)];

    % POS
    NOVSM  = thetapos(27)*(simPos.x(:,11)-simPos.x(1,11));
    PGEVSM = thetapos(28)*(simPos.x(:,9)-simPos.x(1,9));
    NPYVSM = thetapos(29)*(simPos.x(:,13)-simPos.x(1,13));

    % NEG
    NOVSM1  = thetaneg(27)*(simNeg.x(:,11)-simNeg.x(1,11));
    PGEVSM1 = thetaneg(28)*(simNeg.x(:,9)-simNeg.x(1,9));
    NPYVSM1 = thetaneg(29)*(simNeg.x(:,13)-simNeg.x(1,13));

    

    hVasc1= subplot(3,2,3);
        %% positive Vascular
        hold on
        VascPosNO   = plot(simPos.t,NOVSM,'-','color',CNOVSM,'linewidth',2);
        VascPosPGE2 = plot(simPos.t,PGEVSM,'-','color',CPGE2VSM,'linewidth',2);
        VascPosNPY  = plot(simPos.t,NPYVSM,'-','color',CNPYVSM,'linewidth',2);
        
        axis tight
        axis([0 40 -0.3 0.7])
        hVasc1.FontSize=FontSize;
        hVasc1.XTick = [0 10 20 30 40];
        hVasc1.XTickLabel = [0 10 20 30 40];
        
        ax=gca;
        set(gca,'Xlim',[0 40])
        ylim=get(gca,'Ylim');
        
        rectangle('Position',[0,ylim(1),20,1.4*sizebar*sum(abs(hVasc1.YLim))],'FaceColor','k')
                        
        pos=get(ax,'Position');
        set(ax,'Position',[pos(1) pos(2) pos(3)+0.01 pos(4)])
       
        [ax_x,ax_y]=TufteStyle(ax);
        ax_x.FontSize = 13;
        ax_y.FontSize = 13;
        set(ax_y,'YLim',[-0.3,0.8])
        
        % Title
        Htitle=title(ax_x,'Positive Vasoactivity','FontSize',FontSize-2);
        pos=get(Htitle,'Position');
        titlepos=pos(1);
        set(Htitle,'Position',[titlepos titleY-5]);
        
        [~,hVasc1a]=suplabel('C','t',[.10 -0.22 0 .85]);
        hVasc1a.FontSize=FontSize;
        hold off
        
        yC = ylabel(ax_y,ylab_Vasc,'FontSize',FontSize,'Interpreter','tex');
        yC.Position(1) = yC.Position(1)+4;
       
        
    hVasc2= subplot(3,2,4);
         %% Negative Vascular
        hold on
        VascNegNO   = plot(simNeg.t,NOVSM1,'-','color',CNOVSM,'linewidth',2);
        VascNegPGE2 = plot(simNeg.t,PGEVSM1,'-','color',CPGE2VSM,'linewidth',2);
        VascNegNPY  = plot(simNeg.t,NPYVSM1,'-','color',CNPYVSM,'linewidth',2);

        axis tight
        axis([0 40 -0.12 0.1])
        hVasc2.FontSize=FontSize;
        hVasc2.XTick = [0 10 20 30 40];
        hVasc2.XTickLabel = [0 10 20 30 40];
            
            ax=gca;
            set(gca,'Xlim',[0 40])
            ylim=get(gca,'Ylim');
            
            rectangle('Position',[0,ylim(1)-0.02,21,1.2*sizebar*sum(abs(hVasc2.YLim))],'FaceColor','k')
          
            pos=get(ax,'Position');
            set(ax,'Position',[pos(1)+0.03 pos(2) pos(3)+0.01 pos(4)])

        [ax_x,ax_y]=TufteStyle(ax);
        ax_x.FontSize = 13;
        ax_y.FontSize = 13;
        set(ax_y,'YLim',[ylim(1)-0.02,0.04])

        % Title
        Htitle=title(ax_x,'Negative Vasoactivity','FontSize',FontSize-2);
        pos=get(Htitle,'Position');
        titlepos=pos(1);
        set(Htitle,'Position',[titlepos titleY-5]);
        
        [~,hVasc1a]=suplabel('D','t',[0.565 -0.22 0 .85]);
        hVasc1a.FontSize=FontSize;
        hold off
        
    hHb= subplot(3,2,5);
         %% Negative Vascular
        hold on
        plot(simPos.t,simPos.y(:,3),'-','color',CHbT,'linewidth',2);
        plot(simPos.t,simPos.y(:,4),'-','color',CHbO,'linewidth',2);
        plot(simPos.t,simPos.y(:,5),'-','color',CHbR,'linewidth',2);

        axis tight
        hHb.FontSize=FontSize;
        hHb.XTick = [0 10 20 30 40];
        hHb.XTickLabel = [0 10 20 30 40];
            
            xlabel(xlab,'FontSize',FontSize)
            
            axis tight
            ax=gca;
            set(gca,'Xlim',[0 40])
            ylim=get(gca,'Ylim');
            
            rectangle('Position',[0,ylim(1)-2,20,2*sizebar*sum(abs(hHb.YLim))],'FaceColor','k')
          
            pos=get(ax,'Position');
            set(ax,'Position',[pos(1) pos(2)-0.02 pos(3)+0.01 pos(4)])

        [ax_x,ax_y]=TufteStyle(ax);
        ax_x.FontSize = 13;
        ax_y.FontSize = 13;
        set(ax_y,'YLim',[-5,15])
        
        yE = ylabel(ax_y, ylab_Hb,'FontSize',FontSize);
        yE.Position(1) = yE.Position(1)+4;
        
        % Title
        Htitle=title(ax_x,'Positive Hb','FontSize',FontSize-2);
        pos=get(Htitle,'Position');
        titlepos=pos(1);
        set(Htitle,'Position',[titlepos titleY]);
        
        [~,hHbA]=suplabel('E','t',[0.10 -0.535 0 .85]);
        hHbA.FontSize=FontSize;
        hold off
        
    hHb2= subplot(3,2,6);
         %% Negative Vascular
        hold on
        PHbT=plot(simNeg.t,simNeg.y(:,3),'-','color',CHbT,'linewidth',2);
        PHbO=plot(simNeg.t,simNeg.y(:,4),'-','color',CHbO,'linewidth',2);
        PHbR=plot(simNeg.t,simNeg.y(:,5),'-','color',CHbR,'linewidth',2);

        axis tight
        hHb2.FontSize=FontSize;
        hHb2.XTick = [0 10 20 30 40];
        hHb2.XTickLabel = [0 10 20 30 40];
        
        xlabel(xlab,'FontSize',FontSize)
        
            ax=gca;
            set(gca,'Xlim',[0 40])
            ylim=get(gca,'Ylim');
            
            rectangle('Position',[0,ylim(1)-1,21,2*sizebar*sum(abs(hHb2.YLim))],'FaceColor','k')
          
            pos=get(ax,'Position');
            set(ax,'Position',[pos(1)+0.03 pos(2)-0.02 pos(3)+0.01 pos(4)])

        [ax_x,ax_y]=TufteStyle(ax);
        ax_x.FontSize = 13;
        ax_y.FontSize = 13;
        
        % Title
        Htitle=title(ax_x,'Negative Hb','FontSize',FontSize-2);
        pos=get(Htitle,'Position');
        titlepos=pos(1);
        set(Htitle,'Position',[titlepos titleY]);
        
        [~,hHb2A]=suplabel('F','t',[0.565 -0.535 0 .85]);
        hHb2A.FontSize=FontSize;
        hold off
        
     %reprint B notation as it disappears    
    [~,hActa]=suplabel('B','t',[.565 0.08 0 .88]);
    hActa.FontSize=FontSize;
    
%% extra y-label
    hTx1=text(18,-0.2,'New Data','horizontalalign','right','rotation',90,'verticalalign','Top');
    hTx1.FontSize = 18;
    hTx1.Position = [-430 13.5 0];
    
    hTx2=text(18,0.2,'Translated mechanisms','horizontalalign','left','rotation',90,'verticalalign','Top');
    hTx2.FontSize = 18;
    hTx2.Position = [-430 -0.7 0];
       
%% Titels
    ahHb=axes('position',get(gca,'position'),'visible','off'); 

    HtitleHb = title(ahHb,{'\fontsize{16} BOLD/LFP dynamics upon excitatory/inhibitory stimuli'},'interpreter','tex');
    HtitleHb.Visible = 'on';
    HtitleHb.Position(1:2) = [-40 4.105]; 
    
    ahVasc=axes('position',get(gca,'position'),'visible','off'); 

    ahVasc = title(ahVasc,{'\fontsize{16} Predicted vasoactive effect of the three neuron types'},'interpreter','tex');
    ahVasc.Visible = 'on';
    ahVasc.Position(1:2) = [-40 2.58];
    
    ahBOLD=axes('position',get(gca,'position'),'visible','off'); 

    HtitleBOLD = title(ahBOLD,{'\fontsize{16} Predicted hemoglobin dynamics'},'interpreter','tex');
    HtitleBOLD.Visible = 'on';
    HtitleBOLD.Position(1:2) = [-40 1.12];   

    
%% Legend
ah2=axes('position',get(gca,'position'),'visible','off'); 
[hlegVSM]=legend(ah2,[VascNegNO, VascNegNPY, VascNegPGE2], {'NO_{VSM}', 'NPY_{VSM}', 'PGE2_{VSM}'}, 'FontSize',12);

hlegVSM.ItemTokenSize=[10 10];
hlegVSM.Box='off';
title(hlegVSM, {'Vasoactive'...
    'substance'});
hlegVSM.Position(1:2)=[0.86 0.40];

ah3=axes('position',get(gca,'position'),'visible','off'); 
[hlegVSM2]=legend(ah3,[PHbT, PHbO, PHbR], {'HbT', 'HbO', 'HbR'}, 'FontSize',12);

hlegVSM2.ItemTokenSize=[10 10];
hlegVSM2.Box='off';
title(hlegVSM2, 'Hemoglobin (Hb)');
hlegVSM2.Position(1:2)=[0.81 0.11];
