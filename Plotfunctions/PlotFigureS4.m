%% Ploting script that generates figure S4 from the article
load('GenerateData\GeneratedModelUncertainties\UhlirovaStructs')
D = Data;
%% Initial setup of common stuff
ylab={'\Delta Dilation (%)'};
xlab={'Time (seconds)'};
FontSize=10;
x0=0;
y0=0;
width=18;
height=20;
simScale=0.5;
uncColor=[1 0 0];
simColor=[0.8 0 0];
titlePosY=150;
lw=2;
%% Sens awake -  Row 1
figure()
    subplot(5,2,1)
        set(gcf,'units','centimeters')
        set(gcf,'position',[x0,y0,width,height])
        set(gcf,'Color',[1 1 1])

        h1=errorbar(D(5).t,D(5).Y(:,1),D(5).Sigma_Y(:,1),'k*','LineWidth',1);
        hold on
            l1=plot(0:simScale:D(5).t(end),Res.solSensAw.sim,'-','LineWidth',lw,'Color',simColor);
            c=ciplot(Res.solSensAw.min,Res.solSensAw.max,0:simScale:D(5).t(end),uncColor);
            alpha(c,.2);
            uistack(c,'bottom');
            axis tight
            ax=gca;
            pXlim=[0 D(1).t(end)];
            set(gca,'Xlim',pXlim)
            set(gca,'Ylim',[-10 19]);
                    yticks([-10 -5 0 5 10 15])

            p=get(gca,'Ylim');
            % stimulus bar
            r=rectangle('Position',[0 p(1) 1 0.5]);
            r.FaceColor=[0 0 0];
            % legend
            [hleg]=legend([h1,c,l1],{'Experimental data','Model uncertainty','Best model simulation'},'FontSize',FontSize,'Location','best');
            hleg.Box='off';
            
            % Increase width
            pos=get(ax,'Position');
            set(ax,'Position',[pos(1)+0.02 pos(2)+0.03 pos(3) pos(4)])

        [ax_x,ax_y]=TufteStyle(ax);
        hold off

        ylabel(ax_y,ylab,'FontSize',FontSize)
        % Title
        Htitle=title(ax_x,'Sensory stimulation (awake)','FontSize',FontSize);
        pos=get(Htitle,'Position');
        titlepos=pos(1);
        set(Htitle,'Position',[titlepos titlePosY]);
        
        [~,ha]=suplabel('A','t',[.1 .11 0 .85]);
        ha.FontSize=FontSize;

%% GABAergic OG awake - Row 2
    subplot(5,2,3)
    h1=errorbar(D(4).t,D(4).Y(:,1),D(4).Sigma_Y(:,1),'k*','LineWidth',1);
    hold on
        plot(0:simScale:D(4).t(end),Res.solOGinAw.sim,'k-','LineWidth',lw,'Color',simColor)
        c=ciplot(Res.solOGinAw.min,Res.solOGinAw.max,0:simScale:D(5).t(end),uncColor);
        alpha(c,.2);
        uistack(c,'bottom');
        axis tight
        ax=gca;
        set(gca,'Xlim',pXlim)
        set(gca,'Ylim',[-10 19]);
        yticks([-10 -5 0 5 10 15])
        p=get(gca,'Ylim');
        r=rectangle('Position',[0 p(1) 0.4 0.5]);
        r.FaceColor=[0 0 0];

        pos=get(ax,'Position');
        set(ax,'Position',[pos(1)+0.02 pos(2)+0.015 pos(3) pos(4)])

        [ax_x,ax_y]=TufteStyle(ax);
    hold off

    ylabel(ax_y,ylab,'FontSize',FontSize)

    Htitle=title(ax_x,'GABAergic interneurons OG (awake)','FontSize',FontSize);
    set(Htitle,'Position',[titlepos titlePosY]);
    
    [~,hb]=suplabel('B','t',[.1 -0.08 0 .85]);
    hb.FontSize=FontSize;

%% Sensory stimulation anesthesia condition - Row 3
    subplot(5,2,5)
    h1=errorbar(D(3).t,D(3).Y(:,1),D(3).Sigma_Y(:,1),'k*','LineWidth',1);
    hold on
        plot(0:simScale:D(3).t(end),Res.solSens.sim,'k-','LineWidth',lw,'Color',simColor)
        c2=ciplot(Res.solSens.min,Res.solSens.max,0:simScale:D(3).t(end),uncColor);
        alpha(c2,.2)
        uistack(c2,'bottom');
        axis tight
        ax=gca;
        set(gca,'Xlim',pXlim)
        set(gca,'Ylim',[-10 19]);
        yticks([-10 -5 0 5 10 15])

        p=get(gca,'Ylim');

        r=rectangle('Position',[0 p(1) 2 0.5]);
        r.FaceColor=[0 0 0];

        pos=get(ax,'Position');
        set(ax,'Position',[pos(1)+0.02 pos(2) pos(3) pos(4)])

        [ax_x,ax_y]=TufteStyle(ax);
    hold off

    ylabel(ax_y,ylab,'FontSize',FontSize)

    Htitle=title(ax_x,'Sensory stimulation (anesthesia)','FontSize',FontSize);
    set(Htitle,'Position',[titlepos titlePosY])
    
    [~,hc]=suplabel('C','t',[.1 -0.27 0 .85]);
    hc.FontSize=FontSize;

%% GABAergic OG stimulation anesthesia condition - Row 4

    subplot(5,2,7)
    h1=errorbar(D(2).t,D(2).Y(:,1),D(2).Sigma_Y(:,1),'k*','LineWidth',1);
    hold on
        plot(0:simScale:D(2).t(end),Res.solOGin.sim,'k-','LineWidth',lw,'Color',simColor)
        c2=ciplot(Res.solOGin.min,Res.solOGin.max,0:simScale:D(2).t(end),uncColor);

        alpha(c2,.2);
        uistack(c2,'bottom');
        axis tight
        ax=gca;
        set(gca,'Ylim',[-10 19]);
        p=get(gca,'Ylim');
        yticks([-10 -5 0 5 10 15])

        r=rectangle('Position',[0.55 p(1) 0.45 0.5]);
        r.FaceColor=[0 0 0];

        pos=get(ax,'Position');
        set(ax,'Position',[pos(1)+0.02 pos(2)-0.015 pos(3) pos(4)])

        [ax_x,ax_y]=TufteStyle(ax);
    hold off

    ylabel(ax_y,ylab,'FontSize',FontSize)


    Htitle=title(ax_x,'GABAergic interneurons OG (anesthesia)','FontSize',FontSize);
    set(Htitle,'Position',[titlepos titlePosY]);
    
    [~,hd]=suplabel('D','t',[.1 -0.45 0 .85]);
    hd.FontSize=FontSize;

%% Pyramidal OG stimulation anesthesia condition - Row 5

    subplot(5,2,9)
    h1=errorbar(D(1).t,D(1).Y(:,1),D(1).Sigma_Y(:,1),'k*','LineWidth',1);
    hold on
        l1=plot(0:simScale:D(1).t(end),Res.solOGex.sim,'k-','LineWidth',lw,'Color',simColor);
        c2=ciplot(Res.solOGex.min,Res.solOGex.max,0:simScale:D(1).t(end),uncColor);

        alpha(c2,.2)
        uistack(c2,'bottom');
        axis tight

        ax=gca;
        set(gca,'Ylim',[-10 19]);
        p=get(gca,'Ylim');
                yticks([-10 -5 0 5 10 15])

        r=rectangle('Position',[0.9 p(1) 0.1 0.5]);
        r.FaceColor=[0 0 0];
        pos=get(ax,'Position');

        set(ax,'Position',[pos(1)+0.02 pos(2)-0.03 pos(3) pos(4)])

        [ax_x,ax_y]=TufteStyle(ax);
    hold off
    Hxl=xlabel(ax_x,xlab,'FontSize',FontSize);
    pos=get(Hxl,'Position');
    set(Hxl,'Position',[pos(1) pos(2)*0.85]);
    ylabel(ax_y,ylab,'FontSize',FontSize)

    Htitle=title(ax_x,'Pyramidal neurons OG (anesthesia)','FontSize',FontSize);
    pos=get(Htitle,'Position');
    set(Htitle,'Position',[pos(1) titlePosY]);
    
    [~,he]=suplabel('E','t',[.1 -0.64 0 .85]);
    he.FontSize=FontSize;
    
%%%%%%%%%%%%%%%%%%%%%
%%% Second column %%%
%%%%%%%%%%%%%%%%%%%%%
%% Initial setup of variables
width=9;
height=13;
titlePosY=155;

%% Row 1 - Sensory stimulation with BIBP
subplot(5,2,2)
    h2=errorbar(D(8).t,D(8).Y(:,1),D(8).Sigma_Y(:,1),'k*','LineWidth',1);
    hold on
    c=ciplot(Res.solSensP.min,Res.solSensP.max,0:simScale:D(8).t(end),uncColor);
    alpha(c,.2)
    uistack(c,'bottom');

    ax=gca;
    set(gca,'Ylim',[-8 19])
    set(gca,'Xlim',[0 D(1).t(end)])

    p=get(gca,'Ylim');
    r=rectangle('Position',[0 p(1) 2 0.5]);
    r.FaceColor=[0 0 0];

    [hleg]=legend([h2,c],{'BIBP',['Model prediction' newline 'bounds']},'FontSize',FontSize,'Location','best');
    hleg.Box='off';
    hleg.Position(1)=hleg.Position(1)+0.05;
    hleg.Position(2)=hleg.Position(2)+0.02;
    pos=get(ax,'Position');
    set(ax,'Position',[pos(1) pos(2)+0.03 pos(3) pos(4)])

    [ax_x,ax_y]=TufteStyle(ax);
    hold off

    ylabel(ax_y,ylab,'FontSize',FontSize)

    Htitle=title(ax_x,'Sensory stimulation (anesthesia)','FontSize',FontSize);
    pos=get(Htitle,'Position');
    set(Htitle,'Position',[pos(1) titlePosY])
    
    [~,hf]=suplabel('F','t',[.52 .11 0 .85]);
    hf.FontSize=FontSize;

%% Row 2 - GABAergic OG stimulation with BIBP
subplot(5,2,4)

    h2=errorbar(D(7).t,D(7).Y(:,1),D(7).Sigma_Y(:,1),'k*','LineWidth',1);
    hold on
    c=ciplot(Res.solOGinP.min,Res.solOGinP.max,0:simScale:D(7).t(end),uncColor);
    alpha(c,.2);
    uistack(c,'bottom');

    ax=gca;
    set(gca,'Ylim',[-8 19])
    set(gca,'Xlim',[0 D(1).t(end)])

    p=get(gca,'Ylim');
    r=rectangle('Position',[0.55 p(1) 0.45 0.5]);
    r.FaceColor=[0 0 0];

    [hleg]=legend([h2,c],{'BIBP',['Model prediction' newline 'bounds']},'FontSize',FontSize,'Location','best');
    hleg.Box='off';
    hlegPos=get(hleg,'Position');
    hleg.Position(2)=hleg.Position(2)+0.02;
    hleg.Position(1)=hleg.Position(1)+0.05;

    pos=get(ax,'Position');
    set(ax,'Position',[pos(1) pos(2)+0.02 pos(3) pos(4)])

    [ax_x,ax_y]=TufteStyle(ax);
    hold off

    ylabel(ax_y,ylab,'FontSize',FontSize)

    Htitle=title(ax_x,'GABAergic interneurons OG (anesthesia)','FontSize',FontSize);
    pos=get(Htitle,'Position');
    set(Htitle,'Position',[pos(1) titlePosY-5]);
    
    [~,hg]=suplabel('G','t',[.52 -0.07 0 .85]);
    hg.FontSize=FontSize;

%% Row 3 - Pyramidal OG stimulation (anesthesia) with CNQX + AP5
subplot(5,2,6)

    h2=errorbar(D(6).t,D(6).Y(:,1),D(6).Sigma_Y(:,1),'k*','LineWidth',1);
    hold on
    c=ciplot(Res.solOGexP.min,Res.solOGexP.max,0:simScale:D(6).t(42),uncColor);
    alpha(c,.2)
    uistack(c,'bottom');

    ax=gca;
    set(gca,'Ylim',[-8 19])
    set(gca,'Xlim',[0 D(1).t(end)])

    p=get(gca,'Ylim');
    r=rectangle('Position',[0.9 p(1) 0.1 0.5]);
    r.FaceColor=[0 0 0];

    [hleg]=legend([h2,c],{'CNQX + AP5',['Model prediction' newline 'bounds']},'FontSize',FontSize,'Location','best');
    hleg.Box='off';
    hleg.Position(1)=hleg.Position(1)+0.05;
    hleg.Position(2)=hleg.Position(2);

    [ax_x,ax_y]=TufteStyle(ax);
    hold off

    Hxl=xlabel(ax_x,xlab,'FontSize',FontSize);
    pos=get(Hxl,'Position');
    set(Hxl,'Position',[pos(1) pos(2)*0.85]);

    ylabel(ax_y,ylab,'FontSize',FontSize)

    Htitle=title(ax_x,'Pyramidal neurons OG (anesthesia)','FontSize',FontSize);
    pos=get(Htitle,'Position');
    set(Htitle,'Position',[pos(1) titlePosY]);
    
    [~,hh]=suplabel('H','t',[.52 -0.26 0 .85]);
    hh.FontSize=FontSize;

