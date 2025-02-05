%% Ploting script that generates figure 7 from the article

load('GenerateData\GeneratedModelUncertainties\HuberStructs.mat')
Data = HuberData;
Res = HuberSimulation;

ylab_BOLD={'Fractional'... 
    'change'};
ylab_CBV={'Percentual'... 
    'change (\Delta%)'};
ylab_Vasc={'VSM effect (AU)'};

xlab={'Time (seconds)'};

FontSize=14;
x0=0;
y0=0;
width=19.05;
height=22.23;
simScale=1.5;

titleY=115;
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
CHbR = [32 170 197]./255;

Colour = {CCBV;CCBVneg};



figure('Name', 'Figure 7_plot')
    set(gcf,'units','centimeters')
        set(gcf,'position',[x0,y0,width,height])
        set(gcf,'Color',[1 1 1])
        sizebar=0.02;
        
        
        
hCBV= subplot(5,3,1);
        %% positive CBV + unc
        hold on
        fieldIdx =1; 
        CBVPosP=plot(timeV,Res.(fieldNames{fieldIdx}).sim,'-','color',Colour{1},'linewidth',2);
        CBVPosCI=ciplot(Res.(fieldNames{fieldIdx}).min,Res.(fieldNames{fieldIdx}).max,timeV,'r');
        CBVPosE= errorbar(Data.(fieldNames{fieldIdx}).t,Data.(fieldNames{fieldIdx}).Y,Data.(fieldNames{fieldIdx}).Sigma_Y,'*','color',Colour{1});
        set(CBVPosCI,{'FaceColor','EdgeColor','FaceAlpha'},{Colour{1},'w',0.2})
        uistack(CBVPosCI,'bottom');
        
        %% Negative CBV + unc
        fieldIdx = 2;
        CBVNegP=plot(timeV,Res.(fieldNames{fieldIdx}).sim,'-','color',Colour{2},'linewidth',2);
        CBVNegCI=ciplot(Res.(fieldNames{fieldIdx}).min,Res.(fieldNames{fieldIdx}).max,timeV,'b');
        CBVNegE=errorbar(Data.(fieldNames{fieldIdx}).t,Data.(fieldNames{fieldIdx}).Y,Data.(fieldNames{fieldIdx}).Sigma_Y,'*','color',Colour{2});
        set(CBVNegCI,{'FaceColor','EdgeColor','FaceAlpha'},{Colour{2},'w',0.2})
        uistack(CBVNegCI,'bottom');

       axis tight
       hCBV.FontSize=FontSize;
            rectangle('Position',[0,hCBV.YLim(1)-2,30,sizebar*sum(abs(hCBV.YLim))],'FaceColor','k')

            ax=gca;
            pXlim=[0 timeV(end)];
            set(gca,'Xlim',pXlim)
         
            pos=get(ax,'Position');
            set(ax,'Position',[pos(1)+0.03 pos(2)+0.05 pos(3)+0.01 pos(4)])

        [ax_x,ax_y]=TufteStyle(ax);
        ax_x.FontSize = 13;
        ax_y.FontSize = 13;
        ax_x.XTickLabel = [0 20 40 60];
        ax_x.XTick = [0 20 40 60];

        y1 = ylabel(ax_y,ylab_CBV,'FontSize',FontSize,'Interpreter','tex');
        y1.Position(1) = y1.Position(1) + 4;
        % Title
        Htitle=title(ax_x,'CBV','FontSize',FontSize-2);
        pos=get(Htitle,'Position');
        titlepos=pos(1);
        set(Htitle,'Position',[titlepos titleY]);
        
        hold off
        
        
hCBVExc= subplot(5,3,2);
        hold on
        %% Total CBV Excitatory + unc 
        fieldIdx = 3;
        CBVExTotP=plot(timeV,Res.(fieldNames{fieldIdx}).sim,'k-','linewidth',2);
        CBVExTotCI=ciplot(Res.(fieldNames{fieldIdx}).min,Res.(fieldNames{fieldIdx}).max,timeV,'k');
        CBVExTotE= errorbar(Data.(fieldNames{fieldIdx}).t,Data.(fieldNames{fieldIdx}).Y,Data.(fieldNames{fieldIdx}).Sigma_Y,'k*');
        set(CBVExTotCI,{'EdgeColor','FaceAlpha'},{'w',0.2})
        uistack(CBVExTotCI,'bottom');
        %% Arteriole CBV Excitatory + unc
        fieldIdx = 4;
        CBVExArtCI=ciplot(Res.(fieldNames{fieldIdx}).min,Res.(fieldNames{fieldIdx}).max,timeV,'r');
        CBVExArtE= errorbar(Data.(fieldNames{fieldIdx}).t,Data.(fieldNames{fieldIdx}).Y,Data.(fieldNames{fieldIdx}).Sigma_Y,'r*');
        set(CBVExArtCI,{'EdgeColor','FaceAlpha'},{'w',0.2})
        uistack(CBVExArtCI,'bottom');
        %% Venule CBV Excitatory + unc
        fieldIdx = 5;
        CBVExVenCI=ciplot(Res.(fieldNames{fieldIdx}).min,Res.(fieldNames{fieldIdx}).max,timeV,'b');
        CBVExVenE= errorbar(Data.(fieldNames{fieldIdx}).t,Data.(fieldNames{fieldIdx}).Y,Data.(fieldNames{fieldIdx}).Sigma_Y,'b*');
        set(CBVExVenCI,{'EdgeColor','FaceAlpha'},{'w',0.2})
        uistack(CBVExVenCI,'bottom');
        
        axis tight
        hCBVExc.FontSize=FontSize;
        
        rectangle('Position',[0,hCBVExc.YLim(1)-1,30,sizebar*sum(abs(hCBVExc.YLim))],'FaceColor','k')
       
        ax=gca;
        pXlim=[0 timeV(end)];
        set(gca,'Xlim',pXlim)        
        
        % Increase width
        pos=get(ax,'Position');
        set(ax,'Position',[pos(1)+0.045 pos(2)+0.05 pos(3)+0.01 pos(4)])
        [ax_x,ax_y]=TufteStyle(ax);
        ax_x.FontSize = 13;
        ax_y.FontSize = 13;
        ax_x.XTickLabel = [0 20 40 60];
        ax_x.XTick = [0 20 40 60];
        
        % Title
        Htitle=title(ax_x,'CBV excitatory task','FontSize',FontSize-2);
        pos=get(Htitle,'Position');
        titlepos=pos(1);
        set(Htitle,'Position',[titlepos titleY]);

        hold off

        
%% Total CBV Inhibitatory + unc 
    hCBVInhib1= subplot(15,3,3);
        hold on
        fieldIdx = 6;
        CBVInTotP=plot(timeV,Res.(fieldNames{fieldIdx}).sim,'k-','linewidth',2);
        CBVInTotCI=ciplot(Res.(fieldNames{fieldIdx}).min,Res.(fieldNames{fieldIdx}).max,timeV,'k');
        CBVInTotE= errorbar(Data.(fieldNames{fieldIdx}).t,Data.(fieldNames{fieldIdx}).Y,Data.(fieldNames{fieldIdx}).Sigma_Y,'k*');
        set(CBVInTotCI,{'EdgeColor','FaceAlpha'},{'w',0.2})
        uistack(CBVInTotCI,'bottom');
        
        axis tight
        hCBVInhib1.FontSize=FontSize;
        
        ax=gca;
        pXlim=[0 timeV(end)];
        set(gca,'Xlim',pXlim)
        set(gca, 'XTick', []);
                
        % Increase width
        pos=get(ax,'Position');
        set(ax,'Position',[pos(1)+0.06 pos(2)+0.05 pos(3)+0.01 pos(4)])
        
        [ax_x,ax_y]=TufteStyle(ax);
        ax_x.XColor = [1 1 1];
        ax_x.FontSize = 12;
        ax_y.FontSize = 12;
        
        % Title
        Htitle=title(ax_x,'CBV inhibitatory task','FontSize',FontSize-2);
        pos=get(Htitle,'Position');
        titlepos=pos(1);
        set(Htitle,'Position',[titlepos (1/3)*titleY+5]);

        hold off   
        

        %% Arteriole CBV Inhibitatory + unc
        hCBVInhib2= subplot(15,3,6);
        hold on
        fieldIdx = 7;
        CBVInArtCI=ciplot(Res.(fieldNames{fieldIdx}).min,Res.(fieldNames{fieldIdx}).max,timeV,'r');
        errorbar(Data.(fieldNames{fieldIdx}).t,Data.(fieldNames{fieldIdx}).Y,Data.(fieldNames{fieldIdx}).Sigma_Y,'r*');
        set(CBVInArtCI,{'EdgeColor','FaceAlpha'},{'w',0.2})
        uistack(CBVInArtCI,'bottom');
        
        axis tight
        hCBVInhib2.FontSize=FontSize;
        
        ax=gca;
        pXlim=[0 timeV(end)];
        set(gca,'Xlim',pXlim)
        set(gca, 'XTick', []);     
        
        % Increase width
        pos=get(ax,'Position');
        set(ax,'Position',[pos(1)+0.06 pos(2)+0.05 pos(3)+0.01 pos(4)])
        
        [ax_x,ax_y]=TufteStyle(ax);
        ax_x.FontSize = 12;
        ax_y.FontSize = 12;
        ax_x.XColor = [1 1 1];
        ax_y.YTick = [-15 -5 5];
        ax_y.YTickLabel = {'-15', '-5', '5'};
        
        hCBVInhib2.Position(2) = hCBVInhib2.Position(2) + 0.015;
        ax_x.Position(2) = ax_x.Position(2) + 0.015;
        ax_y.Position(2) = ax_y.Position(2) + 0.015;
        
        
        
        %% Venule CBV Inhibitatory + unc
        hCBVInhib3= subplot(15,3,9);
        hold on
        fieldIdx = 8;
        CBVInVenCI=ciplot(Res.(fieldNames{fieldIdx}).min,Res.(fieldNames{fieldIdx}).max,timeV,'b');
        CBVInArtE= errorbar(Data.(fieldNames{fieldIdx}).t,Data.(fieldNames{fieldIdx}).Y,Data.(fieldNames{fieldIdx}).Sigma_Y,'b*');
        set(CBVInVenCI,{'EdgeColor','FaceAlpha'},{'w',0.2})
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
        set(ax,'Position',[pos(1)+0.06 pos(2)+0.05 pos(3)+0.01 pos(4)])
        
        [ax_x,ax_y]=TufteStyle(ax);
        ax_x.FontSize = 12;
        ax_y.FontSize = 12;
        ax_x.XTickLabel = [0 20 40 60];
        ax_x.XTick = [0 20 40 60];
        ax_y.YTickLabel = {'-5', '5'};
        ax_y.YTick = [-5 5];
        
        hCBVInhib3.Position(2) = hCBVInhib3.Position(2) + 0.026;
        ax_x.Position(2) = ax_x.Position(2) + 0.026;
        ax_y.Position(2) = ax_y.Position(2) + 0.026;
       
hBOLD= subplot(5,3,4);
        %% positive BOLD + unc
        hold on
        fieldIdx =9; 
        BOLDPosP=plot(timeV,Res.(fieldNames{fieldIdx}).sim,'-','color',CBOLD,'linewidth',2);
        BOLDPosCI=ciplot(Res.(fieldNames{fieldIdx}).min,Res.(fieldNames{fieldIdx}).max,timeV, CBOLD);
        BOLDPosE= errorbar(Data.(fieldNames{fieldIdx}).t,Data.(fieldNames{fieldIdx}).Y,Data.(fieldNames{fieldIdx}).Sigma_Y,'*','color',CBOLD);
        set(BOLDPosCI,{'FaceColor','EdgeColor','FaceAlpha'},{CBOLD,'w',0.2})
        uistack(BOLDPosCI,'bottom');
        
        %% Negative BOLD + unc
        fieldIdx = 10;
        BOLDNegP=plot(timeV,Res.(fieldNames{fieldIdx}).sim,'-','color',CBOLDneg,'linewidth',2);
        BOLDNegCI=ciplot(Res.(fieldNames{fieldIdx}).min,Res.(fieldNames{fieldIdx}).max,timeV, CBOLDneg);
        BOLDNegE=errorbar(Data.(fieldNames{fieldIdx}).t,Data.(fieldNames{fieldIdx}).Y,Data.(fieldNames{fieldIdx}).Sigma_Y,'*','color',CBOLDneg);
        set(BOLDNegCI,{'FaceColor','EdgeColor','FaceAlpha'},{CBOLDneg,'w',0.2})
        uistack(BOLDNegCI,'bottom');

       axis tight
       hBOLD.FontSize=FontSize;
        
        rectangle('Position',[0,hBOLD.YLim(1),30,0.03*sizebar*sum(abs(hBOLD.YLim))],'FaceColor','k')
            
        ax=gca;
        pXlim=[0 timeV(end)];
        set(gca,'Xlim',pXlim)

        pos=get(ax,'Position');
        set(ax,'Position',[pos(1)+0.03 pos(2)+0.04 pos(3)+0.01 pos(4)])

        [ax_x,ax_y]=TufteStyle(ax);
        ax_x.FontSize = 13;
        ax_y.FontSize = 13;
        ax_x.XTickLabel = [0 20 40 60];
        ax_x.XTick = [0 20 40 60];
        
        set(ax_y,'YLim',[0.96,1.06])
        ax_y.YTickLabel = [0.97 1 1.03];
        ax_y.YTick = [0.97 1 1.03];

        y2 = ylabel(ax_y,ylab_BOLD,'FontSize',FontSize,'Interpreter','tex');
        y2.Position(1) = y2.Position(1) +4;

        % Title
        Htitle=title(ax_x,'BOLD response','FontSize',FontSize-2);
        pos=get(Htitle,'Position');
        titlepos=pos(1);
        set(Htitle,'Position',[titlepos titleY-10]);
           
        hold off    
        
                
hCBF= subplot(5,3,5);
        %% positive CBF + unc
        hold on
        fieldIdx =11; 
        CBFPosCI=ciplot(Res.(fieldNames{fieldIdx}).min,Res.(fieldNames{fieldIdx}).max,timeV, Colour{1});
        CBFPosE= errorbar(Data.(fieldNames{fieldIdx}).t,Data.(fieldNames{fieldIdx}).Y,Data.(fieldNames{fieldIdx}).Sigma_Y,'*','color',Colour{1});
        set(CBFPosCI,{'FaceColor','EdgeColor','FaceAlpha'},{Colour{1},'w',0.2})
        uistack(CBFPosCI,'bottom');
        
        %% Negative CBF + unc
        fieldIdx = 12;
        CBFNegCI=ciplot(Res.(fieldNames{fieldIdx}).min,Res.(fieldNames{fieldIdx}).max,timeV, Colour{2});
        CBFNegE=errorbar(Data.(fieldNames{fieldIdx}).t,Data.(fieldNames{fieldIdx}).Y,Data.(fieldNames{fieldIdx}).Sigma_Y,'*','color',Colour{2});
        set(CBFNegCI,{'FaceColor','EdgeColor','FaceAlpha'},{Colour{2},'w',0.2})
        uistack(CBFNegCI,'bottom');
        
        axis tight
        hCBF.FontSize=FontSize;
        
        rectangle('Position',[0,hCBF.YLim(1)-0.1,30,0.5*sizebar*sum(abs(hCBF.YLim))],'FaceColor','k')
            
        ax=gca;
        pXlim=[0 timeV(end)];
        set(gca,'Xlim',pXlim)

        pos=get(ax,'Position');
        set(ax,'Position',[pos(1)+0.045 pos(2)+0.04 pos(3)+0.01 pos(4)])

        [ax_x,ax_y]=TufteStyle(ax);
        ax_x.FontSize = 13;
        ax_y.FontSize = 13;
        ax_x.XTickLabel = [0 20 40 60];
        ax_x.XTick = [0 20 40 60];
        
        set(ax_y,'YLim',[0.5,2])
        ax_y.YTickLabel = [0.5 1 1.5];
        ax_y.YTick = [0.5 1 1.5];
        
%         xlabel(ax_x,xlab,'FontSize',FontSize)

        % Title
        Htitle=title(ax_x,'CBF','FontSize',FontSize-2);
        pos=get(Htitle,'Position');
        titlepos=pos(1);
        set(Htitle,'Position',[titlepos titleY-10]);
       
        hold off
        
        
        
        
        
        
        
%% test vascular contributions 
[~, ~, Con, tend, theta] = optsetupfunction(5);

% obs theta(41:42) are the sign parameters
thetapos = theta(1:37);

thetaneg = theta(1:37);
thetaneg([1 2 3]) = theta(43:45);
thetaneg(4:9)=theta(46:51);
thetaneg(10:12) = theta(55:57);


thetapos = [10.^(thetapos); 0];
thetaneg = [10.^(thetaneg); 0];

%%
options = amioption('sensi',0,...
    'maxsteps',1e3);
options.sensi = 0;

%% SS simulation
Ca_start = 10;

% steady state simulation
sol = simulate_SSModel(inf,thetapos(4:38),[Ca_start,Con],[],options);
% assaign values to constants in the stimulation simulation

options.x0 = sol.x(end,:).';

TE = 20*10^-3;       B0 = 7;

HbO_0 = sol.y(2);
HbR_0 = sol.y(3);
SaO2_0 = sol.y(4);
ScO2_0 = sol.y(5);
SvO2_0 = sol.y(6);
p1 = 1; 
p2 = 1; 
p3 = 1; 
stim_onoff = 1; 

Constants = [sol.x(end,[11 9 13]), Ca_start, Con, HbO_0, HbR_0, SaO2_0, ScO2_0, SvO2_0, TE, B0, p1, p2, p3, stim_onoff];

p1_neg = theta(41); 
p2_neg = theta(42); 
p3_neg = -1; 

Constants_neg = [sol.x(end,[11 9 13]), Ca_start, Con, HbO_0, HbR_0, SaO2_0, ScO2_0, SvO2_0, TE, B0, p1_neg, p2_neg, p3_neg, stim_onoff];

% alter simulation tolerances, DAE solver can not handle the default values
options.atol = 1e-5;
options.rtol = 1e-6;

optionsPos = options;
optionsNeg = options;

%% Simulations
    %positive
    t1 = [0,0.5, 1.5:1.5:tend(1)];
    PosSim_CBV_BOLD = simulate_Model(t1, thetapos, Constants, [], optionsPos);
    
    optionsPos.x0 = PosSim_CBV_BOLD.x(end,:)';
    Constants(end) = 0;
    t2 = (tend(1):1.5:60) -tend(1);
    PosSim_CBV_BOLD2 = simulate_Model(t2, thetapos, Constants, [], optionsPos); 
    
    SimPos.t = [t1, t2(2:end)+tend(1)];
    SimPos.y = [PosSim_CBV_BOLD.y ; PosSim_CBV_BOLD2.y(2:end,:)];
    SimPos.x = [PosSim_CBV_BOLD.x ; PosSim_CBV_BOLD2.x(2:end,:)];

    
    %negative
    t1 = [0,0.5, 1.5:1.5:tend(1)];
    NegSim_CBV_BOLD = simulate_Model(t1, thetaneg, Constants_neg, [], optionsNeg);
    
    optionsNeg.x0 = NegSim_CBV_BOLD.x(end,:)';
    Constants_neg(end) = 0;
    t2 = (tend(1):1.5:60) -tend(1);
    NegSim_CBV_BOLD2 = simulate_Model(t2, thetaneg, Constants_neg, [], optionsNeg);
    
    SimNeg.t = [t1, t2(2:end)+tend(1)];
    SimNeg.y = [NegSim_CBV_BOLD.y ; NegSim_CBV_BOLD2.y(2:end,:)];
    SimNeg.x = [NegSim_CBV_BOLD.x ; NegSim_CBV_BOLD2.x(2:end,:)];

    %
    NOVSM1  = thetapos(27)*(SimPos.x(:,11)-SimPos.x(1,11));
    PGEVSM1 = thetapos(28)*(SimPos.x(:,9)-SimPos.x(1,9));
    NPYVSM1 = thetapos(29)*(SimPos.x(:,13)-SimPos.x(1,13));
    
    NOVSM2  = thetaneg(27)*(SimNeg.x(:,11)-SimNeg.x(1,11));
    PGEVSM2 = thetaneg(28)*(SimNeg.x(:,9)-SimNeg.x(1,9));
    NPYVSM2 = thetaneg(29)*(SimNeg.x(:,13)-SimNeg.x(1,13));
    
        
%% positive Vascular
    hVasc1= subplot(5,3,7);
        hold on
        VascPosNO=plot(SimPos.t,NOVSM1,'-','color',CNOVSM,'linewidth',2);
        VascPosPGE2=plot(SimPos.t,PGEVSM1,'-','color',CPGE2VSM,'linewidth',2);
        VascPosNPY=plot(SimPos.t,NPYVSM1,'-','color',CNPYVSM,'linewidth',2);
        
        axis tight
        hVasc1.FontSize=FontSize;
        
        ax=gca;
        pXlim=[0 timeV(end)];
        set(gca,'Xlim',pXlim)
        
        rectangle('Position',[0,hVasc1.YLim(1),30,1*sizebar*sum(abs(hVasc1.YLim))],'FaceColor','k')
                
        pos=get(ax,'Position');
        set(ax,'Position',[pos(1)+0.03 pos(2) pos(3)+0.01 pos(4)])
       
        [ax_x,ax_y]=TufteStyle(ax);
        ax_x.FontSize = 13;
        ax_y.FontSize = 13;
        ax_x.XTickLabel = [0 20 40 60];
        ax_x.XTick = [0 20 40 60];
        
        % Title
        Htitle=title(ax_x,'Excitatory task','FontSize',FontSize-2);
        pos=get(Htitle,'Position');
        titlepos=pos(1);
        set(Htitle,'Position',[titlepos titleY-5]);
        y0 = ylabel(ax_y,ylab_Vasc,'FontSize',FontSize,'Interpreter','tex');
        y0.Position(1) = y0.Position(1) + 3; 
                
%% negative Vascular
    hVasc2= subplot(5,3,8);
        hold on
        VascNegNO=plot(SimNeg.t,NOVSM2,'-','color',CNOVSM,'linewidth',2);
        VascNegPGE2=plot(SimNeg.t,PGEVSM2,'-','color',CPGE2VSM,'linewidth',2);
        VascNegNPY=plot(SimNeg.t,NPYVSM2,'-','color',CNPYVSM,'linewidth',2);
        
        axis tight
        hVasc2.FontSize=FontSize;
        
        ax=gca;
        pXlim=[0 timeV(end)];
        set(gca,'Xlim',pXlim)
        
        rectangle('Position',[0,hVasc2.YLim(1)-0.05,30,1*sizebar*sum(abs(hVasc2.YLim))],'FaceColor','k')              

        pos=get(ax,'Position');
        set(ax,'Position',[pos(1)+0.045 pos(2) pos(3)+0.01 pos(4)])
       
        [ax_x,ax_y]=TufteStyle(ax);
        ax_x.FontSize = 13;
        ax_y.FontSize = 13;
        ax_x.XTickLabel = [0 20 40 60];
        ax_x.XTick = [0 20 40 60];
        ax_y.YLim(2) = 0.3; 
        
        % Title
        Htitle=title(ax_x,'Inhibitory task','FontSize',FontSize-2);
        pos=get(Htitle,'Position');
        titlepos=pos(1);
        set(Htitle,'Position',[titlepos titleY-5]); 
        
        
%% Hb 
    hHb= subplot(5,3,10);
        hold on
        HbT=plot(SimPos.t,SimPos.y(:,3),'-','color',CHbT,'linewidth',2);
        HbO=plot(SimPos.t,SimPos.y(:,4),'-','color',CHbO,'linewidth',2);
        HbR=plot(SimPos.t,SimPos.y(:,5),'-','color',CHbR,'linewidth',2);
        
        axis tight
        hHb.FontSize=FontSize;
        
        ax=gca;
        pXlim=[0 timeV(end)];
        set(gca,'Xlim',pXlim)
        
        rectangle('Position',[0,hHb.YLim(1)-2,30,1*sizebar*sum(abs(hHb.YLim))],'FaceColor','k')
                
        pos=get(ax,'Position');
        set(ax,'Position',[pos(1)+0.03 pos(2)-0.02 pos(3)+0.01 pos(4)])
       
        [ax_x,ax_y]=TufteStyle(ax);
        ax_x.FontSize = 13;
        ax_y.FontSize = 13;
        ax_x.XTickLabel = [0 20 40 60];
        ax_x.XTick = [0 20 40 60];
        
        y1 = ylabel(ax_y,'Hb changes (AU)','FontSize',FontSize,'Interpreter','tex');
        y1.Position(1) = y1.Position(1) - 3;
                
%% Hb negative
    hHb2= subplot(5,3,11);
        hold on
        HbTneg=plot(SimNeg.t,SimNeg.y(:,3),'-','color',CHbT,'linewidth',2);
        HbOneg=plot(SimNeg.t,SimNeg.y(:,4),'-','color',CHbO,'linewidth',2);
        HbRneg=plot(SimNeg.t,SimNeg.y(:,5),'-','color',CHbR,'linewidth',2);
        
        axis tight
        hHb2.FontSize=FontSize;
        
        ax=gca;
        pXlim=[0 timeV(end)];
        set(gca,'Xlim',pXlim)
        
        rectangle('Position',[0,hHb2.YLim(1)-1,30,1.5*sizebar*sum(abs(hHb2.YLim))],'FaceColor','k')
                
        pos=get(ax,'Position');
        set(ax,'Position',[pos(1)+0.045 pos(2)-0.02 pos(3)+0.01 pos(4)])
       
        [ax_x,ax_y]=TufteStyle(ax);
        ax_x.FontSize = 13;
        ax_y.FontSize = 13;
        ax_x.XTickLabel = [0 20 40 60];
        ax_x.XTick = [0 20 40 60];
        ax_x.YTickLabel = [-8 -6 -4 -2 0 2];
        ax_x.YTick = [-8 -6 -4 -2 0 2];
        ax_y.YLim(2) = 3;     
        
%% LFP
        hLFP= subplot(5,3,13); 
        hold on
        LFPpos=plot([-3;-2;-1;SimPos.t'],[0;0;0;SimPos.x(:,3)],'-','color',CLFP,'linewidth',2);
        
        axis tight
        hLFP.FontSize=FontSize;
        
        ax=gca;
        pXlim=[-3 timeV(end)];
        set(gca,'Xlim',pXlim)
        
        rectangle('Position',[0,hLFP.YLim(1)-2,30,1*sizebar*sum(abs(hLFP.YLim))],'FaceColor','k')
                
        pos=get(ax,'Position');
        set(ax,'Position',[pos(1)+0.03 pos(2)-0.045 pos(3)+0.01 pos(4)])
       
        [ax_x,ax_y]=TufteStyle(ax);
        ax_x.FontSize = 13;
        ax_y.FontSize = 13;
        ax_x.XTickLabel = [0 20 40 60];
        ax_x.XTick = [0 20 40 60];

        x1 = xlabel(ax_x,xlab,'FontSize',FontSize);
        x1.Position(2) = x1.Position(2) + 8;
        y1 = ylabel(ax_y,'LFP signal (AU)','FontSize',FontSize,'Interpreter','tex');
        y2.Position(1) = y2.Position(1) - 3;
        
        hold off
        
%% LFP negative
        hLFP2= subplot(5,3,14); 
        hold on
        LFPneg=plot([-3;-2;-1; SimNeg.t'],[0;0;0;SimNeg.x(:,3)],'-','color',CLFPneg,'linewidth',2);
        
        axis tight
        hLFP2.FontSize=FontSize;
        
        ax=gca;
        pXlim=[-3 timeV(end)];
        set(gca,'Xlim',pXlim)
        
        rectangle('Position',[0,hLFP2.YLim(1)-1,30,1*sizebar*sum(abs(hLFP2.YLim))],'FaceColor','k')
                
        pos=get(ax,'Position');
        set(ax,'Position',[pos(1)+0.045 pos(2)-0.045 pos(3)+0.01 pos(4)])
       
        [ax_x,ax_y]=TufteStyle(ax);
        ax_x.FontSize = 13;
        ax_y.FontSize = 13;
        ax_x.XTickLabel = [0 20 40 60];
        ax_x.XTick = [0 20 40 60];
        ax_y.YLim(2) = 4;

        x2 = xlabel(ax_x,xlab,'FontSize',FontSize);
        x2.Position(2) = x2.Position(2) + 8;
        hold off
        
      

    %% extra y-label
    hTx1=text(18,-0.2,'New data','horizontalalign','right','rotation',90,'verticalalign','Top');
        hTx1.FontSize = 18;
        hTx1.Position = [-327 69 0];
        
    hTx2=text(18,0.2,'Translated mechanisms','horizontalalign','left','rotation',90,'verticalalign','Top');
        hTx2.FontSize = 18;
        hTx2.Position = [-327 4 0];
    
    %% extra titels
    ahNeuron=axes('position',get(gca,'position'),'visible','off'); 
    hTx3=title(ahNeuron,{'\fontsize{14} Predicted vasoactive effect of three neuron types'},'interpreter','tex');
        hTx3.Visible = 'on';
        hTx3.Position(1:2) = [-40 4.30];
    
        
    ahHb=axes('position',get(gca,'position'),'visible','off');     
    hTx4=title(ahHb,{'\fontsize{14} Predicted Hb dynamics'},'interpreter','tex');
        hTx4.Visible = 'on';
        hTx4.Position(1:2) = [-20 2.60];
    
    ahLFP=axes('position',get(gca,'position'),'visible','off');     
    hTx5=title(ahLFP,{'\fontsize{14} Predicted LFP dynamics'},'interpreter','tex');
        hTx5.Visible = 'on';
        hTx5.Position(1:2) = [-20 1.04];
    %% annotations
        [~,hCBVa]=suplabel('A','t',[.125 .127 0 .85]);
        hCBVa.FontSize=16;
        [~,hCBVExca]=suplabel('B','t',[.405 .127 0 .85]);
        hCBVExca.FontSize = 16;
        [~,hCBVInhiba]=suplabel('C','t',[0.695 .127 0 .85]);
        hCBVInhiba.FontSize = 16;
        [~,hBOLDa]=suplabel('D','t',[.125 -0.060 0 .85]);
        hBOLDa.FontSize=16; 
        [~,hCBFa]=suplabel('E','t',[.405 -0.060 0 .85]);
        hCBFa.FontSize = 16;
        [~,hVasc1a]=suplabel('F','t',[.125 -0.265 0 .85]);
        hVasc1a.FontSize=16;
        [~,hHba]=suplabel('G','t',[.405 -0.265 0 .85]);
        hHba.FontSize=16;
        [~,hLFPa]=suplabel('H','t',[.125 -0.47 0 .85]);
        hLFPa.FontSize=16;
        [~,hVasc2a]=suplabel('I','t',[.40 -0.47 0 .85]);
        hVasc2a.FontSize=16;
        [~,hHba2]=suplabel('J','t',[.125 -0.65 0 .85]);
        hHba2.FontSize=16;
        [~,hLFPa2]=suplabel('K','t',[.405 -0.665 0 .85]);
        hLFPa2.FontSize=16;
        
        %% Legend
        hold on
        [hlegSim]=legend([CBVPosCI,CBVNegCI,CBVExTotCI,BOLDPosCI,BOLDNegCI,CBVExArtCI,CBVExVenCI,CBFPosCI,CBFNegCI], {'Pos CBV','Neg CBV','Total CBV', 'Pos BOLD', 'Neg BOLD','Arteriolar CBV','Venous CBV','CBF Positive','CBF Negative'}, 'FontSize',FontSize-2,'Location','best');

        hlegSim.ItemTokenSize=[10 10];
        hlegSim.Box='off';
        hlegSim.Position(1:2)=[0.77 0.48];
        
        HeightScaleFactor = 1.3;
        NewHeight = hlegSim.Position(4) * HeightScaleFactor;
        hlegSim.Position(2) = hlegSim.Position(2) - (NewHeight - hlegSim.Position(4));
        hlegSim.Position(4) = NewHeight;
        
            ahLEG=axes('position',get(gca,'position'),'visible','off'); 
            titleLEG = title(ahLEG,{'\fontsize{14}' 'Model simulations,'... 
                'data, uncertainties'},'interpreter','tex');
            titleLEG.Visible = 'on';
            titleLEG.Position(1:2) = [285 5.25]; 
            
            ah0=axes('position',get(gca,'position'),'visible','off'); 
            [hleguncertainty]=legend(ah0,[CBVPosP,CBVNegP,CBVExTotP,BOLDPosP,BOLDNegP],{'','','','',''},'FontSize',FontSize-2,'Location','best');
            hleguncertainty.ItemTokenSize=[10 10];
            hleguncertainty.Box='off';
            hleguncertainty.Position(1:2)=[0.73 0.582];
            
            NewHeight = hleguncertainty.Position(4) * HeightScaleFactor;
            hleguncertainty.Position(2) = hleguncertainty.Position(2) - (NewHeight - hleguncertainty.Position(4));
            hleguncertainty.Position(4) = NewHeight;
            
            ah01=axes('position',get(gca,'position'),'visible','off'); 
            [hlegdata]=legend(ah01,[CBVPosE,CBVNegE,CBVExTotE,BOLDPosE,BOLDNegE,CBVExArtE,CBVExVenE,CBFPosE,CBFNegE],{'','','','','','','','',''},'FontSize',FontSize-2,'Location','best');
            hlegdata.ItemTokenSize=[10 10];
            hlegdata.Box='off';
            hlegdata.Position(1:2)=[0.75 0.48];
            
            NewHeight = hlegdata.Position(4) * HeightScaleFactor;
            hlegdata.Position(2) = hlegdata.Position(2) - (NewHeight - hlegdata.Position(4));
            hlegdata.Position(4) = NewHeight;
            
     
        
        ah2=axes('position',get(gca,'position'),'visible','off'); 
        [hlegVSM]=legend(ah2,[VascPosNO, VascPosNPY, VascPosPGE2], {'NO_{VSM}', 'NPY_{VSM}', 'PGE2_{VSM}'}, 'FontSize',FontSize-2);
        
        hlegVSM.ItemTokenSize=[10 10];
        hlegVSM.Box='off';
        title(hlegVSM, {'Vasoactive'...
            'substance'});
        hlegVSM.Position(1:2)=[0.73 0.25];
        
        ah4=axes('position',get(gca,'position'),'visible','off'); 
        [hlegHb]=legend(ah4,[HbT, HbO, HbR], {'HbT', 'HbO', 'HbR'}, 'FontSize',FontSize-2);
        
        hlegHb.ItemTokenSize=[10 10];
        hlegHb.Box='off';
        title(hlegHb, 'Hb');
        hlegHb.Position(1:2)=[0.73 0.13];
        
        ah3=axes('position',get(gca,'position'),'visible','off'); 
        [hlegLFP]=legend(ah3,[LFPpos, LFPneg], {'Positive', 'Negative'}, 'FontSize',FontSize-2);
        
        hlegLFP.ItemTokenSize=[10 10];
        hlegLFP.Box='off';
        title(hlegLFP, 'LFP');
        hlegLFP.Position(1:2)=[0.72 0.03];        
             