%% Ploting script that generates figure 7 from the article
load('GenerateData\GeneratedModelUncertainties\HuberStructs.mat')
Data = HuberData;
Res = HuberSimulation;

ylab_BOLD={'Fractional change'};
ylab_CBV={'Percentual change (\Delta%)'};
ylab_Vasc={'VSM effect (AU)'};

xlab={'Time (seconds)'};

FontSize=16;
x0=0;
y0=0;
width=48;
height=26;
simScale=1.5;

titleY=340;
startTime=0;
timeV=startTime:simScale:60;

fieldNames = fieldnames(Res);

CBOLD = [207 17 220]./255;
CBOLDneg = [131 105 233]./255;
CCBV = [119 15 15]./255;
CCBVneg = [29 23 108]./255;
CLFP = [229 150 226]./255;
CLFPneg = [102 51 153]./255;
CNOVSM = [113 246 108]./255;
CNPYVSM = [165 168 120]./255;
CPGE2VSM = [242 184 70]./255;
CHbT = [8 128 60]./255;
CHbO = [174 26 26]./255;
CHbR = [95 207 229]./255;

Colour = {CCBV;CCBVneg};



figure()
    set(gcf,'units','centimeters')
        set(gcf,'position',[x0,y0,width,height])
        set(gcf,'Color',[1 1 1])
        sizebar=0.02;
        
        
        
hCBV= subplot(4,3,1);
        %% positive CBV + unc
        hold on
        fieldIdx =1; 
        CBVPosP=plot(timeV,Res.(fieldNames{fieldIdx}).sim,'-','color',Colour{1},'linewidth',2);
        CBVPosCI=ciplot(Res.(fieldNames{fieldIdx}).min,Res.(fieldNames{fieldIdx}).max,timeV,'r');
        CBVPosE= errorbar(Data.(fieldNames{fieldIdx}).t,Data.(fieldNames{fieldIdx}).Y,Data.(fieldNames{fieldIdx}).Sigma_Y,'*','color',Colour{1});
        set(CBVPosCI,{'FaceColor','EdgeColor','FaceAlpha'},{Colour{1},Colour{1},0.2})
        uistack(CBVPosCI,'bottom');
        
        %% Negative CBV + unc
        fieldIdx = 2;
        CBVNegP=plot(timeV,Res.(fieldNames{fieldIdx}).sim,'-','color',Colour{2},'linewidth',2);
        CBVNegCI=ciplot(Res.(fieldNames{fieldIdx}).min,Res.(fieldNames{fieldIdx}).max,timeV,'b');
        CBVNegE=errorbar(Data.(fieldNames{fieldIdx}).t,Data.(fieldNames{fieldIdx}).Y,Data.(fieldNames{fieldIdx}).Sigma_Y,'*','color',Colour{2});
        set(CBVNegCI,{'FaceColor','EdgeColor','FaceAlpha'},{Colour{2},Colour{2},0.2})
        uistack(CBVNegCI,'bottom');

       axis tight
       hCBV.FontSize=FontSize;
            rectangle('Position',[0,hCBV.YLim(1)-2,30,sizebar*sum(abs(hCBV.YLim))],'FaceColor','k')

            ax=gca;
            pXlim=[0 timeV(end)];
            set(gca,'Xlim',pXlim)
         
            pos=get(ax,'Position');
            set(ax,'Position',[pos(1)-0.02 pos(2)+0.02 pos(3) pos(4)])

        [ax_x,ax_y]=TufteStyle(ax);
        ax_x.XTickLabel = [0 20 40 60];
        ax_x.XTick = [0 20 40 60];

        ylabel(ax_y,ylab_CBV,'FontSize',FontSize,'Interpreter','tex')
        % Title
        Htitle=title(ax_x,'CBV','FontSize',FontSize);
        pos=get(Htitle,'Position');
        titlepos=pos(1);
        set(Htitle,'Position',[titlepos titleY-50]);
        [~,hCBVa]=suplabel('A','t',[.09 .11 0 .85]);
        hCBVa.FontSize=16;
        hold off
        
        
hCBVExc= subplot(4,3,2);
        hold on
        %% Total CBV Excitatory + unc 
        fieldIdx = 3;
        CBVExTotP=plot(timeV,Res.(fieldNames{fieldIdx}).sim,'k-','linewidth',2);
        CBVExTotCI=ciplot(Res.(fieldNames{fieldIdx}).min,Res.(fieldNames{fieldIdx}).max,timeV,'k');
        CBVExTotE= errorbar(Data.(fieldNames{fieldIdx}).t,Data.(fieldNames{fieldIdx}).Y,Data.(fieldNames{fieldIdx}).Sigma_Y,'k*');
        set(CBVExTotCI,{'EdgeColor','FaceAlpha'},{[0 0 0],0.2})
        uistack(CBVExTotCI,'bottom');
        %% Arteriole CBV Excitatory + unc
        fieldIdx = 4;
        CBVExArtCI=ciplot(Res.(fieldNames{fieldIdx}).min,Res.(fieldNames{fieldIdx}).max,timeV,'r');
        CBVExArtE= errorbar(Data.(fieldNames{fieldIdx}).t,Data.(fieldNames{fieldIdx}).Y,Data.(fieldNames{fieldIdx}).Sigma_Y,'r*');
        set(CBVExArtCI,{'EdgeColor','FaceAlpha'},{[1 0 0],0.2})
        uistack(CBVExArtCI,'bottom');
        %% Venule CBV Excitatory + unc
        fieldIdx = 5;
        CBVExVenCI=ciplot(Res.(fieldNames{fieldIdx}).min,Res.(fieldNames{fieldIdx}).max,timeV,'b');
        CBVExVenE= errorbar(Data.(fieldNames{fieldIdx}).t,Data.(fieldNames{fieldIdx}).Y,Data.(fieldNames{fieldIdx}).Sigma_Y,'b*');
        set(CBVExVenCI,{'EdgeColor','FaceAlpha'},{[0 0 1],0.2})
        uistack(CBVExVenCI,'bottom');
        
        axis tight
        hCBVExc.FontSize=FontSize;
        
        rectangle('Position',[0,hCBVExc.YLim(1)-1,30,sizebar*sum(abs(hCBVExc.YLim))],'FaceColor','k')
       
        ax=gca;
        pXlim=[0 timeV(end)];
        set(gca,'Xlim',pXlim)        
        
        % Increase width
        pos=get(ax,'Position');
        set(ax,'Position',[pos(1)+0.04 pos(2)+0.02 pos(3) pos(4)])
        [ax_x,ax_y]=TufteStyle(ax);
        ax_x.XTickLabel = [0 20 40 60];
        ax_x.XTick = [0 20 40 60];
        
        % Title
        Htitle=title(ax_x,'CBV changes excitatory task','FontSize',FontSize);
        pos=get(Htitle,'Position');
        titlepos=pos(1);
        set(Htitle,'Position',[titlepos titleY-50]);

        hold off
        %correct x pos
        hCBVExc.Position(1)=0.3908;
        ax_x.Position(1) = 0.3908;
        ax_y.Position(1) = 0.3808;
        
%% Total CBV Inhibitatory + unc 
    hCBVInhib1= subplot(12,3,3);
        hold on
        fieldIdx = 6;
        CBVInTotP=plot(timeV,Res.(fieldNames{fieldIdx}).sim,'k-','linewidth',2);
        CBVInTotCI=ciplot(Res.(fieldNames{fieldIdx}).min,Res.(fieldNames{fieldIdx}).max,timeV,'k');
        CBVInTotE= errorbar(Data.(fieldNames{fieldIdx}).t,Data.(fieldNames{fieldIdx}).Y,Data.(fieldNames{fieldIdx}).Sigma_Y,'k*');
        set(CBVInTotCI,{'EdgeColor','FaceAlpha'},{[0 0 0],0.2})
        uistack(CBVInTotCI,'bottom');
        
        axis tight
        hCBVInhib1.FontSize=FontSize;
        
        ax=gca;
        pXlim=[0 timeV(end)];
        set(gca,'Xlim',pXlim)
        set(gca, 'XTick', []);
                
        % Increase width
        pos=get(ax,'Position');
        set(ax,'Position',[pos(1)+0.04 pos(2)+0.02 pos(3) pos(4)])
        
        [ax_x,ax_y]=TufteStyle(ax);
        ax_x.XColor = [1 1 1];
        
        % Title
        Htitle=title(ax_x,'CBV changes inhibitatory task','FontSize',FontSize);
        pos=get(Htitle,'Position');
        titlepos=pos(1);
        set(Htitle,'Position',[titlepos (1/3)*titleY+12]);

        hold off   
        
        hCBVInhib1.Position(1)=0.6716;
        ax_x.Position(1) = 0.6716;
        ax_y.Position(1) = 0.6616;
        

        %% Arteriole CBV Inhibitatory + unc
        hCBVInhib2= subplot(12,3,6);
        hold on
        fieldIdx = 7;
        CBVInArtCI=ciplot(Res.(fieldNames{fieldIdx}).min,Res.(fieldNames{fieldIdx}).max,timeV,'r');
        CBVInArtE= errorbar(Data.(fieldNames{fieldIdx}).t,Data.(fieldNames{fieldIdx}).Y,Data.(fieldNames{fieldIdx}).Sigma_Y,'r*');
        set(CBVInArtCI,{'EdgeColor','FaceAlpha'},{[1 0 0],0.2})
        uistack(CBVInArtCI,'bottom');
        
        axis tight
        hCBVInhib2.FontSize=FontSize;
        
        ax=gca;
        pXlim=[0 timeV(end)];
        set(gca,'Xlim',pXlim)
        set(gca, 'XTick', []);     
        
        % Increase width
        pos=get(ax,'Position');
        set(ax,'Position',[pos(1)+0.04 pos(2)+0.02 pos(3) pos(4)])
        
        [ax_x,ax_y]=TufteStyle(ax);
        ax_x.XColor = [1 1 1];
        ax_y.YTick = [-15 -5 5];
        ax_y.YTickLabel = {'-15', '-5', '5'};
        
        
        hCBVInhib2.Position(1)=0.6716;
        ax_x.Position(1) = 0.6716;
        ax_y.Position(1) = 0.6616;
        
        
        %% Venule CBV Inhibitatory + unc
        hCBVInhib3= subplot(12,3,9);
        hold on
        fieldIdx = 8;
        CBVInVenCI=ciplot(Res.(fieldNames{fieldIdx}).min,Res.(fieldNames{fieldIdx}).max,timeV,'b');
        CBVInArtE= errorbar(Data.(fieldNames{fieldIdx}).t,Data.(fieldNames{fieldIdx}).Y,Data.(fieldNames{fieldIdx}).Sigma_Y,'b*');
        set(CBVInVenCI,{'EdgeColor','FaceAlpha'},{[0 0 1],0.2})
        uistack(CBVInVenCI,'bottom');
        
        axis tight
        hCBVInhib3.FontSize=FontSize;
        
        rectangle('Position',[0,hCBVInhib3.YLim(1)-2,30,3*sizebar*sum(abs(hCBVInhib3.YLim))],'FaceColor','k')
        
        xlabel(xlab,'FontSize',FontSize)
        
        ax=gca;
        pXlim=[0 timeV(end)];
        set(gca,'Xlim',pXlim)        
        
        % Increase width
        pos=get(ax,'Position');
        set(ax,'Position',[pos(1)+0.04 pos(2)+0.02 pos(3) pos(4)])
        
        [ax_x,ax_y]=TufteStyle(ax);
        ax_x.XTickLabel = [0 20 40 60];
        ax_x.XTick = [0 20 40 60];
        
        hCBVInhib3.Position(1)=0.6716;
        ax_x.Position(1) = 0.6716;
        ax_y.Position(1) = 0.6616;
        
       
hBOLD= subplot(4,3,4);
        %% positive BOLD + unc
        hold on
        fieldIdx =9; 
        BOLDPosP=plot(timeV,Res.(fieldNames{fieldIdx}).sim,'-','color',CBOLD,'linewidth',2);
        BOLDPosCI=ciplot(Res.(fieldNames{fieldIdx}).min,Res.(fieldNames{fieldIdx}).max,timeV, CBOLD);
        BOLDPosE= errorbar(Data.(fieldNames{fieldIdx}).t,Data.(fieldNames{fieldIdx}).Y,Data.(fieldNames{fieldIdx}).Sigma_Y,'*','color',CBOLD);
        set(BOLDPosCI,{'FaceColor','EdgeColor','FaceAlpha'},{CBOLD,CBOLD,0.2})
        uistack(BOLDPosCI,'bottom');
        
        %% Negative BOLD + unc
        fieldIdx = 10;
        BOLDNegP=plot(timeV,Res.(fieldNames{fieldIdx}).sim,'-','color',CBOLDneg,'linewidth',2);
        BOLDNegCI=ciplot(Res.(fieldNames{fieldIdx}).min,Res.(fieldNames{fieldIdx}).max,timeV, CBOLDneg);
        BOLDNegE=errorbar(Data.(fieldNames{fieldIdx}).t,Data.(fieldNames{fieldIdx}).Y,Data.(fieldNames{fieldIdx}).Sigma_Y,'*','color',CBOLDneg);
        set(BOLDNegCI,{'FaceColor','EdgeColor','FaceAlpha'},{CBOLDneg,CBOLDneg,0.2})
        uistack(BOLDNegCI,'bottom');

       axis tight
       hBOLD.FontSize=FontSize;
        
        rectangle('Position',[0,hBOLD.YLim(1),30,0.03*sizebar*sum(abs(hBOLD.YLim))],'FaceColor','k')
            
        ax=gca;
        pXlim=[0 timeV(end)];
        set(gca,'Xlim',pXlim)

        pos=get(ax,'Position');
        set(ax,'Position',[pos(1)-0.02 pos(2)+0.02 pos(3) pos(4)])

        [ax_x,ax_y]=TufteStyle(ax);
        ax_x.XTickLabel = [0 20 40 60];
        ax_x.XTick = [0 20 40 60];
        
        set(ax_y,'YLim',[0.96,1.06])

        ylabel(ax_y,ylab_BOLD,'FontSize',FontSize,'Interpreter','tex')
        xlabel(ax_x,xlab,'FontSize',FontSize)
        % Title
        Htitle=title(ax_x,'BOLD response','FontSize',FontSize);
        pos=get(Htitle,'Position');
        titlepos=pos(1);
        set(Htitle,'Position',[titlepos titleY-95]);
        [~,hBOLDa]=suplabel('D','t',[.09 -0.13 0 .85]);
        hBOLDa.FontSize=16;            
        hold off    
        
                
hCBF= subplot(4,3,5);
        %% positive CBF + unc
        hold on
        fieldIdx =11; 
        CBFPosCI=ciplot(Res.(fieldNames{fieldIdx}).min,Res.(fieldNames{fieldIdx}).max,timeV, Colour{1});
        CBFPosE= errorbar(Data.(fieldNames{fieldIdx}).t,Data.(fieldNames{fieldIdx}).Y,Data.(fieldNames{fieldIdx}).Sigma_Y,'*','color',Colour{1});
        set(CBFPosCI,{'FaceColor','EdgeColor','FaceAlpha'},{Colour{1},Colour{1},0.2})
        uistack(CBFPosCI,'bottom');
        
        %% Negative CBF + unc
        fieldIdx = 12;
        CBFNegCI=ciplot(Res.(fieldNames{fieldIdx}).min,Res.(fieldNames{fieldIdx}).max,timeV, Colour{2});
        CBFNegE=errorbar(Data.(fieldNames{fieldIdx}).t,Data.(fieldNames{fieldIdx}).Y,Data.(fieldNames{fieldIdx}).Sigma_Y,'*','color',Colour{2});
        set(CBFNegCI,{'FaceColor','EdgeColor','FaceAlpha'},{Colour{2},Colour{2},0.2})
        uistack(CBFNegCI,'bottom');
        
        axis tight
        hCBF.FontSize=FontSize;
        
        rectangle('Position',[0,hCBF.YLim(1)-0.1,30,0.5*sizebar*sum(abs(hCBF.YLim))],'FaceColor','k')
            
        ax=gca;
        pXlim=[0 timeV(end)];
        set(gca,'Xlim',pXlim)

        pos=get(ax,'Position');
        set(ax,'Position',[pos(1)-0.02 pos(2)+0.02 pos(3) pos(4)])

        [ax_x,ax_y]=TufteStyle(ax);
        ax_x.XTickLabel = [0 20 40 60];
        ax_x.XTick = [0 20 40 60];
        
        set(ax_y,'YLim',[0.5,2])
        
        xlabel(ax_x,xlab,'FontSize',FontSize)

        % Title
        Htitle=title(ax_x,'CBF','FontSize',FontSize);
        pos=get(Htitle,'Position');
        titlepos=pos(1);
        set(Htitle,'Position',[titlepos titleY-95]);
       
        hold off
        
        
        
        
        
        
        
%% test vascular contributions 
[~, Data, Con, tend, theta] = optsetupfunction(5);

%%% Negative BOLD
 thetaneg = theta(1:37);
 thetaneg([1 2 3]) = theta(43:45);
 thetaneg(4:9)=theta(46:51);
 thetaneg(10:12) = theta(end-2:end);

%%
options = amioption('sensi',0,...
    'maxsteps',1e3);
options.sensi = 0;

%% SS simulation
Ca_start = 10;

% steady state simulation
sol = simulate_SSmodel(inf,theta(4:37),[Ca_start,Con],[],options);
% assaign values to constants in the stimulation simulation

options.x0 = sol.x(end,:).';

TE = 20*10^-3;       B0 = 7;

HbO_0 = sol.y(2);
HbR_0 = sol.y(3);
SaO2_0 = sol.y(4);
ScO2_0 = sol.y(5);
SvO2_0 = sol.y(6);

Constants = [sol.x(end,[11 9 13]), Ca_start, tend(1), Con, HbO_0, HbR_0, SaO2_0, ScO2_0, SvO2_0, TE, B0];
% alter simulation tolerances, DAE solver can not handle the default values
options.atol = 1e-5;
options.rtol = 1e-6;
     
PosSim_CBV_BOLD = simulate_Huber(0:0.2:timeV(end), theta(1:37), Constants, [], options);
    NOVSM1 = 10^theta(27)*(PosSim_CBV_BOLD.x(:,11)-PosSim_CBV_BOLD.x(1,11));
    PGEVSM1 = 10^theta(28)*(PosSim_CBV_BOLD.x(:,9)-PosSim_CBV_BOLD.x(1,9));
    NPYVSM1 = 10^theta(29)*(PosSim_CBV_BOLD.x(:,13)-PosSim_CBV_BOLD.x(1,13));
    
NegSim_CBV_BOLD = simulate_HuberNeg(0:0.2:timeV(end), thetaneg, [Constants,theta(41), theta(42)], [], options);
    NOVSM2 = 10^thetaneg(27)*(NegSim_CBV_BOLD.x(:,11)-NegSim_CBV_BOLD.x(1,11));
    PGEVSM2 = 10^thetaneg(28)*(NegSim_CBV_BOLD.x(:,9)-NegSim_CBV_BOLD.x(1,9));
    NPYVSM2 = 10^thetaneg(29)*(NegSim_CBV_BOLD.x(:,13)-NegSim_CBV_BOLD.x(1,13));
    

 
        
        
%% positive Vascular
    hVasc1= subplot(4,4,9);
        hold on
        VascPosNO=plot(PosSim_CBV_BOLD.t,NOVSM1,'-','color',CNOVSM,'linewidth',2);
        VascPosPGE2=plot(PosSim_CBV_BOLD.t,PGEVSM1,'-','color',CPGE2VSM,'linewidth',2);
        VascPosNPY=plot(PosSim_CBV_BOLD.t,NPYVSM1,'-','color',CNPYVSM,'linewidth',2);
        
        axis tight
        hVasc1.FontSize=FontSize;
        
        ax=gca;
        pXlim=[0 timeV(end)];
        set(gca,'Xlim',pXlim)
        
        rectangle('Position',[0,hVasc1.YLim(1),30,1*sizebar*sum(abs(hVasc1.YLim))],'FaceColor','k')
                
        pos=get(ax,'Position');
        set(ax,'Position',[pos(1)-0.02 pos(2)+0.02 pos(3) pos(4)])
       
        [ax_x,ax_y]=TufteStyle(ax);
        ax_x.XTickLabel = [0 20 40 60];
        ax_x.XTick = [0 20 40 60];
        
        hVasc1.Position(2) = hVasc1.Position(2) - 0.04;
        ax_x.Position(2) = ax_x.Position(2) - 0.04;
        ax_y.Position(2) = ax_y.Position(2) - 0.04;
        
        % Title
        Htitle=title(ax_x,'Positive Vasoactivity','FontSize',FontSize);
        pos=get(Htitle,'Position');
        titlepos=pos(1);
        set(Htitle,'Position',[titlepos titleY-85]);
        
        [~,hVasc1a]=suplabel('F','t',[.09 -0.37 0 .85]);
        hVasc1a.FontSize=16;
        
        ylabel(ax_y,ylab_Vasc,'FontSize',FontSize,'Interpreter','tex');                
       
        
%% Hb 
    hHb= subplot(4,4,10);
        hold on
        HbT=plot(PosSim_CBV_BOLD.t,PosSim_CBV_BOLD.y(:,6),'-','color',CHbT,'linewidth',2);
        HbO=plot(PosSim_CBV_BOLD.t,PosSim_CBV_BOLD.y(:,7),'-','color',CHbO,'linewidth',2);
        HbR=plot(PosSim_CBV_BOLD.t,PosSim_CBV_BOLD.y(:,8),'-','color',CHbR,'linewidth',2);
        
        axis tight
        hHb.FontSize=FontSize;
        
        ax=gca;
        pXlim=[0 timeV(end)];
        set(gca,'Xlim',pXlim)
        
        rectangle('Position',[0,hHb.YLim(1)-2,30,1*sizebar*sum(abs(hHb.YLim))],'FaceColor','k')
                
        pos=get(ax,'Position');
        set(ax,'Position',[pos(1)-0.02 pos(2)+0.02 pos(3) pos(4)])
       
        [ax_x,ax_y]=TufteStyle(ax);
        ax_x.XTickLabel = [0 20 40 60];
        ax_x.XTick = [0 20 40 60];
        
        hHb.Position(2) = hHb.Position(2) - 0.04;
        ax_x.Position(2) = ax_x.Position(2) - 0.04;
        ax_y.Position(2) = ax_y.Position(2) - 0.04;
        
        % Title
        Htitle=title(ax_x,'Positive Hb','FontSize',FontSize);
        pos=get(Htitle,'Position');
        titlepos=pos(1);
        set(Htitle,'Position',[titlepos titleY-85]);
        
        [~,hHba]=suplabel('G','t',[.295 -0.37 0 .85]);
        hHba.FontSize=16;
        
        ylabel(ax_y,'Hb changes (AU)','FontSize',FontSize,'Interpreter','tex');
        
%% LFP
        hLFP= subplot(4,4,11); 
        hold on
        LFPpos=plot([-3;-2;-1;PosSim_CBV_BOLD.t],[0;0;0;PosSim_CBV_BOLD.x(:,3)],'-','color',CLFP,'linewidth',2);
        
        axis tight
        hLFP.FontSize=FontSize;
        
        ax=gca;
        pXlim=[-3 timeV(end)];
        set(gca,'Xlim',pXlim)
        
        rectangle('Position',[0,hLFP.YLim(1)-2,30,1*sizebar*sum(abs(hLFP.YLim))],'FaceColor','k')
                
        pos=get(ax,'Position');
        set(ax,'Position',[pos(1)-0.02 pos(2)+0.02 pos(3) pos(4)])
       
        [ax_x,ax_y]=TufteStyle(ax);
        ax_x.XTickLabel = [0 20 40 60];
        ax_x.XTick = [0 20 40 60];
        
        hLFP.Position(2) = hLFP.Position(2) - 0.04;
        ax_x.Position(2) = ax_x.Position(2) - 0.04;
        ax_y.Position(2) = ax_y.Position(2) - 0.04;
        
        % Title
        Htitle=title(ax_x,'Positive LFP','FontSize',FontSize);
        pos=get(Htitle,'Position');
        titlepos=pos(1);
        set(Htitle,'Position',[titlepos titleY-85]);
        [~,hLFPa]=suplabel('H','t',[.50 -0.37 0 .85]);
        hLFPa.FontSize=16;
        hold off
        
        ylabel(ax_y,'LFP signal (AU)','FontSize',FontSize,'Interpreter','tex');
        
        
%% negative Vascular
    hVasc2= subplot(4,4,13);
        hold on
        VascNegNO=plot(NegSim_CBV_BOLD.t,NOVSM2,'-','color',CNOVSM,'linewidth',2);
        VascNegPGE2=plot(NegSim_CBV_BOLD.t,PGEVSM2,'-','color',CPGE2VSM,'linewidth',2);
        VascNegNPY=plot(NegSim_CBV_BOLD.t,NPYVSM2,'-','color',CNPYVSM,'linewidth',2);
        
        axis tight
        hVasc2.FontSize=FontSize;
        
        ax=gca;
        pXlim=[0 timeV(end)];
        set(gca,'Xlim',pXlim)
        
        rectangle('Position',[0,hVasc2.YLim(1)-0.05,30,1*sizebar*sum(abs(hVasc2.YLim))],'FaceColor','k')              

        pos=get(ax,'Position');
        set(ax,'Position',[pos(1)-0.02 pos(2)+0.02 pos(3) pos(4)])
       
        [ax_x,ax_y]=TufteStyle(ax);
        ax_x.XTickLabel = [0 20 40 60];
        ax_x.XTick = [0 20 40 60];
        ax_y.YLim(2) = 0.3; 
        
        hVasc2.Position(2) = hVasc2.Position(2) - 0.05;
        ax_x.Position(2) = ax_x.Position(2) - 0.05;
        ax_y.Position(2) = ax_y.Position(2) - 0.05;
        
        % Title
        Htitle=title(ax_x,'Negative Vasoactivity','FontSize',FontSize);
        pos=get(Htitle,'Position');
        titlepos=pos(1);
        set(Htitle,'Position',[titlepos titleY-95]);
        
        [~,hVasc2a]=suplabel('I','t',[.09 -0.6 0 .85]);
        hVasc2a.FontSize=16;
        
            xlabel(ax_x,xlab,'FontSize',FontSize)
        ylabel(ax_y,ylab_Vasc,'FontSize',FontSize,'Interpreter','tex');                
       
        
%% Hb negative
    hHb2= subplot(4,4,14);
        hold on
        HbTneg=plot(NegSim_CBV_BOLD.t,NegSim_CBV_BOLD.y(:,6),'-','color',CHbT,'linewidth',2);
        HbOneg=plot(NegSim_CBV_BOLD.t,NegSim_CBV_BOLD.y(:,7),'-','color',CHbO,'linewidth',2);
        HbRneg=plot(NegSim_CBV_BOLD.t,NegSim_CBV_BOLD.y(:,8),'-','color',CHbR,'linewidth',2);
        
        axis tight
        hHb2.FontSize=FontSize;
        
        ax=gca;
        pXlim=[0 timeV(end)];
        set(gca,'Xlim',pXlim)
        
        rectangle('Position',[0,hHb2.YLim(1)-1,30,2*sizebar*sum(abs(hHb2.YLim))],'FaceColor','k')
                
        pos=get(ax,'Position');
        set(ax,'Position',[pos(1)-0.02 pos(2)+0.02 pos(3) pos(4)])
       
        [ax_x,ax_y]=TufteStyle(ax);
        ax_x.XTickLabel = [0 20 40 60];
        ax_x.XTick = [0 20 40 60];
        ax_x.YTickLabel = [-8 -6 -4 -2 0 2];
        ax_x.YTick = [-8 -6 -4 -2 0 2];
        ax_y.YLim(2) = 3;
        
        hHb2.Position(2) = hHb2.Position(2) - 0.05;
        ax_x.Position(2) = ax_x.Position(2) - 0.05;
        ax_y.Position(2) = ax_y.Position(2) - 0.05;
        
        % Title
        Htitle=title(ax_x,'Negative Hb','FontSize',FontSize);
        pos=get(Htitle,'Position');
        titlepos=pos(1);
        set(Htitle,'Position',[titlepos titleY-95]);
        
        [~,hHba2]=suplabel('J','t',[.295 -0.6 0 .85]);
        hHba2.FontSize=16;
        
        xlabel(ax_x,xlab,'FontSize',FontSize)
        ylabel(ax_y,'Hb changes (AU)','FontSize',FontSize,'Interpreter','tex');
        
%% LFP negative
        hLFP2= subplot(4,4,15); 
        hold on
        LFPneg=plot([-3;-2;-1; NegSim_CBV_BOLD.t],[0;0;0;NegSim_CBV_BOLD.x(:,3)],'-','color',CLFPneg,'linewidth',2);
        
        axis tight
        hLFP2.FontSize=FontSize;
        
        ax=gca;
        pXlim=[-3 timeV(end)];
        set(gca,'Xlim',pXlim)
        
        rectangle('Position',[0,hLFP2.YLim(1)-1,30,1*sizebar*sum(abs(hLFP2.YLim))],'FaceColor','k')
                
        pos=get(ax,'Position');
        set(ax,'Position',[pos(1)-0.02 pos(2)+0.02 pos(3) pos(4)])
       
        [ax_x,ax_y]=TufteStyle(ax);
        ax_x.XTickLabel = [0 20 40 60];
        ax_x.XTick = [0 20 40 60];
        ax_y.YLim(2) = 4;
        
        hLFP2.Position(2) = hLFP2.Position(2) - 0.05;
        ax_x.Position(2) = ax_x.Position(2) - 0.05;
        ax_y.Position(2) = ax_y.Position(2) - 0.05;
        % Title
        Htitle=title(ax_x,'Negative LFP','FontSize',FontSize);
        pos=get(Htitle,'Position');
        titlepos=pos(1);
        set(Htitle,'Position',[titlepos titleY-95]);
        
        [~,hLFPa2]=suplabel('K','t',[.50 -0.6 0 .85]);
        hLFPa2.FontSize=16;
        hold off
        
        xlabel(ax_x,xlab,'FontSize',FontSize)
        ylabel(ax_y,'LFP signal (AU)','FontSize',FontSize,'Interpreter','tex');

        
        

    %% extra y-label
        hTx1=text(18,-0.2,'New Data','horizontalalign','right','rotation',90,'verticalalign','Top');
        hTx1.FontSize = 20;
        hTx1.Position = [-800 43 0];
        hTx2=text(18,0.2,'Translated mechanisms','horizontalalign','left','rotation',90,'verticalalign','Top');
        hTx2.FontSize = 20;
        hTx2.Position = [-800 -5 0];
        
        % Lost annotations
        [~,hCBVExca]=suplabel('B','t',[.36 .11 0 .85]);
        hCBVExca.FontSize = 16;
        [~,hCBVInhiba]=suplabel('C','t',[0.64 .11 0 .85]);
        hCBVInhiba.FontSize = 16;
        [~,hCBFa]=suplabel('E','t',[.36 -0.13 0 .85]);
        hCBFa.FontSize = 16;
        
        %% Legend
        hold on
        [hlegSim]=legend([CBVPosP,CBVNegP,CBVExTotP,CBVPosCI,CBVNegCI,CBVExTotCI], {'Positive BOLD & CBV','Negative BOLD & CBV','Total CBV','Positive BOLD & CBV uncertainty','Negative BOLD & CBV uncertainty','Total CBV uncertainty'}, 'FontSize',16,'Location','best');

        hlegSim.ItemTokenSize=[10 10];
        hlegSim.Box='off';
        hlegSim.Position(1)=hlegSim.Position(1)+0.06;
        hlegSim.Position(1:2)=[0.66 0.45];
        title(hlegSim, 'Model Estimation' );

        [hlegPred]=legend([CBVExArtCI,CBVExVenCI,CBFPosCI,CBFNegCI], {'Arteriolar CBV','Venous CBV','CBF Positive','CBF Negative'}, 'FontSize',16,'Location','best');

        hlegPred.ItemTokenSize=[10 10];
        hlegPred.Box='off';
        hlegPred.Position(1)=hlegPred.Position(1)+0.06;
        hlegPred.Position(1:2)=[0.87 0.505];
        title(hlegPred,{'Model Prediction'...
                        'Uncertainity'});

        ah1=axes('position',get(gca,'position'),'visible','off'); 
        [hlegData]=legend(ah1,[CBVPosE,CBVNegE,CBVExTotE,CBVExArtE,CBVExVenE], {'Positive BOLD, CBV & CBF Data','Negative BOLD, CBV & CBF Data','Total CBV Data','Arterial CBV Data','Venous CBV Data'}, 'FontSize',16);%,'Location','best');

        hlegData.ItemTokenSize=[10 10];
        hlegData.Box='off';
        hlegData.Position(1)=hlegData.Position(1)+0.06;
        hlegData.Position(1:2)=[0.74 0.26];    
        title(hlegData, 'Experimental Data');
        
        
        ah2=axes('position',get(gca,'position'),'visible','off'); 
        [hlegVSM]=legend(ah2,[VascPosNO, VascPosNPY, VascPosPGE2], {'NO_{VSM}', 'NPY_{VSM}', 'PGE2_{VSM}'}, 'FontSize',16);
        
        hlegVSM.ItemTokenSize=[10 10];
        hlegVSM.Box='off';
        hlegVSM.Position(1)=hlegVSM.Position(1)+0.06;
        hlegVSM.Position(1:2)=[0.72 0.10];
        title(hlegVSM, 'Vasoactive substance');
        
        
        ah3=axes('position',get(gca,'position'),'visible','off'); 
        [hlegLFP]=legend(ah3,[LFPpos, LFPneg], {'Positive', 'Negative'}, 'FontSize',16);
        
        hlegLFP.ItemTokenSize=[10 10];
        hlegLFP.Box='off';
        hlegLFP.Position(1)=hlegLFP.Position(1)+0.06;
        hlegLFP.Position(1:2)=[0.82 0.15];
        title(hlegLFP, 'LFP');
        
        
        ah4=axes('position',get(gca,'position'),'visible','off'); 
        [hlegHb]=legend(ah4,[HbT, HbO, HbR], {'HbT', 'HbO', 'HbR'}, 'FontSize',16);
        
        hlegHb.ItemTokenSize=[10 10];
        hlegHb.Box='off';
        hlegHb.Position(1)=hlegHb.Position(1)+0.06;
        hlegHb.Position(1:2)=[0.90 0.12];
        title(hlegHb, 'Hb');
