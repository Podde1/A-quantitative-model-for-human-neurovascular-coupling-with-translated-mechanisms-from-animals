%% Ploting script that generates figure 3 from the article
load('GenerateData\GeneratedModelUncertainties\DrewStructs.mat')
Res = DrewSimulation;

ylab_a={'Arteriolar diameter change (\Delta%)'};
ylab_v={'Venular diameter change (\Delta%)'};

xlab={'Time (seconds)'};
FontSize=14;
x0=0;
y0=0;
width=19.05;
height=22.23;
simScale=0.1;
titleY=320;
startTime=1e-5;

% time vectors and indexs to match time series with the data
timeV=startTime:simScale:Data.D.t(end);
timeV2=startTime:simScale:Data.D10.t(end);
timeV3=startTime:simScale:Data.D30.t(end);

index1 = 1:(Data.D.t(end)*(1/simScale)); 
index2 = 1:(Data.D10.t(end)*(1/simScale)); 
index3 = 1:(Data.D30.t(end)*(1/simScale)); 

figure('Name', 'Figure 3')
    set(gcf,'units','centimeters')
        set(gcf,'position',[x0,y0,width,height])
        set(gcf,'Color',[1 1 1])
        
        sizebar=0.02;
        
    %% 125ms arterioles
    h125msA= subplot(2,3,1);
        c2=ciplot(Res.D.Art.min(index1),Res.D.Art.max(index1),timeV,'r');
        hold on
        c2.EdgeColor='r';

        alpha(c2,.2);
        uistack(c2,'bottom');
        l1= plot(timeV,Res.D.Art.sim(index1),'r-','linewidth',2);
        e1=errorbar(Data.D.t,Data.D.Y(:,1),Data.D.Sigma_Y(:,1),'r*');
        axis([0 6 -5 30])
        title('0.125 sec stimulation','FontSize',16)
        h125msA.FontSize=FontSize;

        rectangle('Position',[0,-2,0.125,sizebar*sum(abs(h125msA.YLim))],'FaceColor','k')
        hold off
        
        ax=gca;
        pXlim=[0 Data.D.t(end)];
        set(gca,'Xlim',pXlim)
        
        % Increase width
        pos=get(ax,'Position');
        set(ax,'Position',[pos(1)-0.02 pos(2)-0.02 pos(3)+0.02 pos(4)+0.04])

        [ax_x,ax_y]=TufteStyle(ax);
        ax_x.FontSize  = 13;
        ax_y.FontSize  = 13;
        hold off

        ylabel(ax_y,ylab_a,'FontSize',FontSize,'Interpreter','tex')
        x = xlabel(ax_x,xlab,'FontSize',FontSize);
        x.Position(2) = x.Position(2) + 3;
        
        [hleg]=legend([e1,l1,c2],{'Experimental Data','Model Simulation','Model uncertainty'},'FontSize',10,'Location','best');
        hleg.ItemTokenSize=[10 10];
        hleg.Box='off';
        hleg.Position(1)=hleg.Position(1);
        
        % Title
        Htitle=title(ax_x,'Arterioles','FontSize',FontSize+2);
        pos=get(Htitle,'Position');
        titlepos=pos(1);
        set(Htitle,'Position',[titlepos titleY]);
        
    
    %% 125 ms venules  
    h125msv = subplot(2,3,4);
        h125msv.FontSize=FontSize;

        c2=ciplot(Res.D.Ven.min(index1),Res.D.Ven.max(index1),timeV,'b');
        hold on
        c2.EdgeColor='b';

        alpha(c2,.2);
        uistack(c2,'bottom');

        e2 = errorbar(Data.D.t,Data.D.Y(:,2),Data.D.Sigma_Y(:,2),'b*');
        l2 = plot(timeV,Res.D.Ven.sim(index1),'b-','linewidth',2);

        axis([0 6 -4 8])
        rectangle('Position',[0,-2,0.125,sizebar*sum(abs(h125msv.YLim))],'FaceColor','k')
        hold off

        axis tight
        ax=gca;
        pXlim=[0 Data.D.t(end)];
        set(gca,'Xlim',pXlim)
        set(gca,'Ylim',[-3 10]);


        % Increase width
        pos=get(ax,'Position');
        set(ax,'Position',[pos(1)-0.02 pos(2)-0.03 pos(3)+0.02 pos(4)+0.04])
        
        [hleg2]=legend([e2,l2,c2],{'Experimental Data','Model Simulation','Model Uncertainty'},'FontSize',10,'Location','best');
        hleg2.ItemTokenSize=[10 10];
        hleg2.Box='off';
        hleg2.Position(1)=hleg.Position(1);
        
        [ax_x,ax_y]=TufteStyle(ax);
        ax_x.FontSize  = 13;
        ax_y.FontSize  = 13;
        hold off

        ylabel(ax_y,ylab_v,'FontSize',FontSize+2)
        x = xlabel(ax_x,xlab,'FontSize',FontSize);
        x.Position(2) = x.Position(2) + 3;
        
        % Title
        Htitle=title(ax_x,'Venules','FontSize',FontSize);
        pos=get(Htitle,'Position');
        titlepos=pos(1);
        set(Htitle,'Position',[titlepos titleY]);  

        %% Add overaching title
        [~,h3_1]=suplabel('0.125 s stimulation'  ,'t');
        h3_1.FontSize=14;
        h3_1.Position(2)=h3_1.Position(2)-0.0;       


    %% 10 s arteriolar
        h10sA = subplot(2,3,2);
        h10sA.FontSize=FontSize;
        c2=ciplot(Res.D10.Art.min(index2),Res.D10.Art.max(index2),timeV2,'r');
        hold on
        c2.EdgeColor='r';

        alpha(c2,.2);
        uistack(c2,'bottom');
        errorbar(Data.D10.t,Data.D10.Y(:,1),Data.D10.Sigma_Y(:,1),'r*')
        plot(timeV2,Res.D10.Art.sim(index2),'r-','linewidth',2)
        axis([0 95 -10 40])
        rectangle('Position',[0,-2,10,sizebar*sum(abs(h125msA.YLim))],'FaceColor','k')
        hold off

        axis tight
        ax=gca;
        pXlim=[0 Data.D10.t(end)];
        set(gca,'Xlim',pXlim)
        set(gca,'Ylim',[-5 30]);

        % Increase width
        pos=get(ax,'Position');
        set(ax,'Position',[pos(1)+0.01 pos(2)-0.02 pos(3)+0.02 pos(4)+0.04])

        [ax_x,ax_y]=TufteStyle(ax);
        ax_x.FontSize  = 13;
        ax_y.FontSize  = 13;
        hold off
        
        x = xlabel(ax_x,xlab,'FontSize',FontSize);
        x.Position(2) = x.Position(2) + 3;

        % Title
        Htitle=title(ax_x,'Arterioles','FontSize',FontSize);
        pos=get(Htitle,'Position');
        titlepos=pos(1);
        set(Htitle,'Position',[titlepos titleY]);
        

        
    %% 10 s Venules
    h10sv = subplot(2,3,5);
        h10sv.FontSize=FontSize;
        c2=ciplot(Res.D10.Ven.min(index2),Res.D10.Ven.max(index2),timeV2,'b');
        hold on
        c2.EdgeColor='b';

        alpha(c2,.2);
        uistack(c2,'bottom');
        errorbar(Data.D10.t,Data.D10.Y(:,2),Data.D10.Sigma_Y(:,2),'b*')
        hold on

        plot(timeV2,Res.D10.Ven.sim(index2),'b-','linewidth',2)
        rectangle('Position',[0,-2,10,sizebar*sum(abs(h125msv.YLim))],'FaceColor','k')
        hold off
        axis([0 40 -3 10])

        axis tight
        ax=gca;

        % Increase width
        pos=get(ax,'Position');
        set(ax,'Position',[pos(1)+0.01 pos(2)-0.03 pos(3)+0.02 pos(4)+0.04])
        set(gca,'Ylim',[-3 10]);
        
        [ax_x,ax_y]=TufteStyle(ax);
        ax_x.FontSize  = 13;
        ax_y.FontSize  = 13;
        hold off
        
        x = xlabel(ax_x,xlab,'FontSize',FontSize);
        x.Position(2) = x.Position(2) + 3;

        % Title
        Htitle=title(ax_x,'Venules','FontSize',FontSize);
        pos=get(Htitle,'Position');
        titlepos=pos(1);
        set(Htitle,'Position',[titlepos titleY]);
        
    %% 30 s arterioles
    h30sa = subplot(2,3,3);
        h30sa.FontSize=FontSize;
        c2=ciplot(Res.D30.Art.min(index3),Res.D30.Art.max(index3),timeV3,'r');
        hold on
        c2.EdgeColor='r';

        alpha(c2,.2);
        uistack(c2,'bottom');
        errorbar(Data.D30.t,Data.D30.Y(:,1),Data.D30.Sigma_Y(:,1),'r*')

        plot(timeV3,Res.D30.Art.sim(index3),'r-','linewidth',2)
    
        axis([0 95 -5 30])
        rectangle('Position',[0,-2,30,sizebar*sum(abs(h125msA.YLim))],'FaceColor','k')
        hold off

        ax=gca;

        % Increase width
        pos=get(ax,'Position');
        set(ax,'Position',[pos(1)+0.04 pos(2)-0.02 pos(3)+0.02 pos(4)+0.04])

        [ax_x,ax_y]=TufteStyle(ax);
        ax_x.FontSize  = 13;
        ax_y.FontSize  = 13;
        hold off
        
        x = xlabel(ax_x,xlab,'FontSize',FontSize);
        x.Position(2) = x.Position(2) + 3;

        % Title
        Htitle=title(ax_x,'Arterioles','FontSize',FontSize);
        pos=get(Htitle,'Position');
        titlepos=pos(1);
        set(Htitle,'Position',[titlepos titleY]);

 
    %% 30 s venules
    h30sv = subplot(2,3,6);
        h30sv.FontSize=FontSize;
        c2=ciplot(Res.D30.Ven.min(index3),Res.D30.Ven.max(index3),timeV3,'b');
        hold on
        c2.EdgeColor='b';

        alpha(c2,.2);
        uistack(c2,'bottom');
        errorbar(Data.D30.t,Data.D30.Y(:,2),Data.D30.Sigma_Y(:,2),'b*')

        plot(timeV3,Res.D30.Ven.sim(index3),'b-','linewidth',2)

        axis([0 95 -3 10])
        rectangle('Position',[0,-2,30,sizebar*sum(abs(h125msv.YLim))],'FaceColor','k')
        hold off

        ax=gca;

        % Increase width
        pos=get(ax,'Position');
        set(ax,'Position',[pos(1)+0.04 pos(2)-0.03 pos(3)+0.02 pos(4)+0.04])

        [ax_x,ax_y]=TufteStyle(ax);
        ax_x.FontSize  = 13;
        ax_y.FontSize  = 13;
        
        x = xlabel(ax_x,xlab,'FontSize',FontSize);
        x.Position(2) = x.Position(2) + 3;
        
        % Title
        Htitle=title(ax_x,'Venules','FontSize',FontSize);
        pos=get(Htitle,'Position');
        titlepos=pos(1);
        set(Htitle,'Position',[titlepos titleY]);

        %% Add overaching title
        [~,h3_2]=suplabel('10 s stimulation'  ,'t');
        h3_2.FontSize=14;
        h3_2.Position(1)=h3_2.Position(1);
        
        [~,h3_3]=suplabel('30 s stimulation','t');
        h3_3.FontSize=14;
        h3_3.Position(1)=h3_3.Position(1)+0.32;
        
        %% Annotations
        [~,hIn_1]=suplabel('A','t',[.02 .08 0 .87]);
        hIn_1.FontSize=14;
        
        [~,h10s_l1]=suplabel('B','t',[.02 .08 0.66 .87]);
        h10s_l1.FontSize=14;
        
        [~,h30s_l]=suplabel('C','t',[.08 .08 1.16 .87]);
        h30s_l.FontSize=14;
        
        [~,hIn_2]=suplabel('D','t',[.02 .08 0 .4]);
        hIn_2.FontSize=14;
        
        [~,h10s_l2]=suplabel('E','t',[.02 .08 0.66 .4]);
        h10s_l2.FontSize=14;
        
        [~,h30s_2]=suplabel('F','t',[.08 .08 1.16 .4]);
        h30s_2.FontSize=14;
           