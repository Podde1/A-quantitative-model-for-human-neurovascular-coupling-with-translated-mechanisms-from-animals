%% Ploting script that generates the curves from figure 4 in the article
[~, Data, Con, stimend, theta] = optsetupfunction(1);

options = amioption('sensi',0,...
    'maxsteps',1e4);
options.sensi = 0;

%% SS simulation
Ca_start = 10;

% steady state simulation
sol = simulate_SSmodel(inf,theta(4:end),[Ca_start,Con],[],options);

% assaign values to constants in the stimulation simulation
ssArt = sol.y(1);
HbO_0 = sol.y(2);
HbR_0 = sol.y(3);
SaO2_0 = sol.y(4);
ScO2_0 = sol.y(5);
SvO2_0 = sol.y(6);

options.x0 = sol.x(end,:).';

TE = 20*10^-3;       B0 = 7;

Constants = [sol.x(end,[11 9 13]), Ca_start, stimend(1), Con, HbO_0, HbR_0, SaO2_0, ScO2_0, SvO2_0, TE, B0];

% alter simulation tolerances, DAE solver can not handle the default values
options.atol = 1e-6;
options.rtol = 1e-12;

%% Simulation
    solReal = simulate_Drew(0:0.01:6,theta, Constants, [], options);

    Constants(5) = stimend(2);
    solReal10 = simulate_Drew(0:0.01:40,theta, Constants, [], options);

    Constants(5) = stimend(3);

    solReal30 = simulate_Drew(0:0.01:95,theta, Constants, [], options);

%% Plotting of results

% Setup of common variables
ylab={'Vasoactive effect (A.U)'};
ylab_N={'Neuronal response (A.U)'};
xlab={'Time (seconds)'};
lw=1.5;
FontSize=8;
x0=0;
y0=0;
width=12;
height=4;
simScale=0.1;
uncColor=[1 0 0];
CNOVSM = [113 246 108]./255;
CNPYVSM = [165 168 120]./255;
CPGE2VSM = [242 184 70]./255;

titleY=0;
sizebar=0.02;


%% Calulcation of Delta effect of the vasoactive arms
PGE2_1=10.^(theta(28)).*(solReal.x(:,9)-solReal.x(1,9));
NPY_1=10.^(theta(29)).*(solReal.x(:,13)-solReal.x(1,13));
NO_1=10.^(theta(27)).*(solReal.x(:,11)-solReal.x(1,11));


%% Initialize figure
figure('Name', 'Figure 4_ABC')
    set(gcf,'units','centimeters')
    set(gcf,'position',[x0,y0,width,height])
    set(gcf,'Color',[1 1 1])
        
    axN1=subplot(1,3,1);
        axN1.FontSize=FontSize;
        plot(solReal.t,solReal.x(:,3)./max(solReal.x(:,3)),'-','Color',CPGE2VSM,'LineWidth',lw);
        hold on
        plot(solReal.t,solReal.x(:,2)./max(solReal.x(:,2)),'-','Color',CNPYVSM,'LineWidth',lw);
        plot(solReal.t,solReal.x(:,1)./max(solReal.x(:,1)),'-','Color',CNOVSM,'LineWidth',lw);
        axis tight
        rectangle('Position',[0,-0.4,0.125,sizebar*sum(abs(axN1.YLim))],'FaceColor','k')
        
        hold off

        pos=get(axN1,'Position');
        set(axN1,'Position',[pos(1)-0.03 pos(2)+0.1 pos(3) pos(4)-0.1])

        [ax_x,ax_y]=TufteStyle(axN1);
        ax_x.FontSize=FontSize;
        ax_y.FontSize=FontSize;
        h_x=xlabel(ax_x,xlab,'FontSize',FontSize);
        h_x_pos=get(h_x,'Position');
        set(h_x,'Position',[h_x_pos(1) h_x_pos(2)+7]);
        t1=title(ax_x,{'0.125 s'...
                'stimulation'});
        ylabel(ax_y,ylab_N,'FontSize',FontSize)
        
        ax_x.XTick = [0 2 4 6];
        ax_x.XTickLabel = [0 2 4 6];
        set(t1,'Position',[3.1 92 0])

    
    
    axN2=subplot(1,3,2);
        axN2.FontSize=FontSize;
        plot(solReal10.t,solReal10.x(:,3)./max(solReal10.x(:,3)),'-','Color',CPGE2VSM,'LineWidth',lw);
        hold on
        plot(solReal10.t,solReal10.x(:,2)./max(solReal10.x(:,2)),'r','Color',CNPYVSM,'LineWidth',lw);
        plot(solReal10.t,solReal10.x(:,1)./max(solReal10.x(:,1)),'-','Color',CNOVSM,'LineWidth',lw);
        rectangle('Position',[0,-0.7,10,sizebar*sum(abs(axN2.YLim))],'FaceColor','k')

        axis tight
        hold off
        ax3_ylim=get(axN2,'ylim');
        t1=title('10 s stimulation');
        post=get(t1,'Position');
        pos=get(axN2,'Position');
        set(axN2,'Position',[pos(1)-0.01 pos(2)+0.1 pos(3) pos(4)-0.1])

        [ax_x,ax_y]=TufteStyle(axN2);
        ax_x.FontSize=FontSize;
        ax_y.FontSize=FontSize;
        
        ax_x.XTick = [0 20 40];
        ax_x.XTickLabel = [0 20 40];

        h_x=xlabel(ax_x,xlab,'FontSize',FontSize);
        h_x_pos=get(h_x,'Position');
        set(h_x,'Position',[h_x_pos(1) h_x_pos(2)+7]);
        t1=title(ax_x,'10 s stimulation');
        set(t1,'Position',[post(1)+3 106 0])
        
   
    axN3=subplot(1,3,3);
        axN3.FontSize=FontSize;
        l1=plot(solReal30.t,solReal30.x(:,3)./max(solReal30.x(:,3)),'-','Color',CPGE2VSM,'LineWidth',lw);
        hold on
        l3=plot(solReal30.t,solReal30.x(:,2)./max(solReal30.x(:,2)),'-','Color',CNPYVSM,'LineWidth',lw);
        l2=plot(solReal30.t,solReal30.x(:,1)./max(solReal30.x(:,1)),'-','Color',CNOVSM,'LineWidth',lw);
        axis tight
        rectangle('Position',[0,-0.7,30,sizebar*sum(abs(axN3.YLim))],'FaceColor','k')

        hold off
        t1=title('0.125 s stimulation');
        post=get(t1,'Position');
        pos=get(axN3,'Position');
        set(axN3,'Position',[pos(1)+0.01 pos(2)+0.1 pos(3) pos(4)-0.1])

        [hleg,~,~,~]=legendflex([l1,l2,l3],{'\color[rgb]{0.949 0.721 0.274}{N_{Pyr}}','\color[rgb]{0.443 0.965 0.423}{N_{NO}}','\color[rgb]{0.647 0.659 0.471}{N_{NPY}}'},'anchor',[1 1],'ncol',1,'nrow',4,'fontsize',8,'xscale',0.2, 'box','off');

        hlegPos=get(hleg,'Position');
        set(hleg,'Position',[hlegPos(1)+75 hlegPos(2)+10 hlegPos(3:4)]); 
        [ax_x,ax_y]=TufteStyle(axN3);
        
        ax_x.XTick = [0 20 40 60 80];
        ax_x.XTickLabel = [0 20 40 60 80];

        ax_x.FontSize=FontSize;
        ax_y.FontSize=FontSize;
        h_x=xlabel(ax_x,xlab,'FontSize',FontSize);
        h_x_pos=get(h_x,'Position');
        set(h_x,'Position',[h_x_pos(1) h_x_pos(2)+7]);
        t1=title(ax_x,'30 s stimulation');
        set(t1,'Position',[post(1)+3 106 0])
        
    [~,h1]=suplabel('A','t',[.05 .09 0.0 0.85]);
    h1.FontSize=12;  
    
    [~,h2]=suplabel('B','t',[.05 .09 0.60 0.85]);
    h2.FontSize=12;

    [~,h3]=suplabel('C','t',[.05 .09 1.2 0.85]);
    h3.FontSize=12;
        
 %% Subplot 125ms Vasoactive 
figure('Name', 'Figure 4_EFG')
    set(gcf,'units','centimeters')
    set(gcf,'position',[x0,y0,width,height])
    set(gcf,'Color',[1 1 1])
    
    ax1=subplot(1,3,1);
        ax1.FontSize=FontSize;
        plot(solReal.t,PGE2_1,'-','Color',CPGE2VSM,'LineWidth',lw);
        hold on
        plot(solReal.t,NPY_1,'-','Color', CNPYVSM,'LineWidth',lw);
        plot(solReal.t,NO_1,'-','Color', CNOVSM,'LineWidth',lw);
        plot(solReal.t,PGE2_1+NO_1-NPY_1,'k--','LineWidth',lw);
        xlim([0 6])
        ylim([-3 5.5])
        rectangle('Position',[0,-0.4,0.125,sizebar*sum(abs(ax1.YLim))],'FaceColor','k')
        
        hold off
        t1=title('0.125 s stimulation');
        post=get(t1,'Position');
        pos=get(ax1,'Position');
        set(ax1,'Position',[pos(1)-0.03 pos(2)+0.1 pos(3) pos(4)-0.1])
        
        [ax_x,ax_y]=TufteStyle(ax1);
        h_ylabel2=ylabel(ax_y,ylab,'FontSize',FontSize);
        set(h_ylabel2,'Position',[h_ylabel2.Position(1) h_ylabel2.Position(2) h_ylabel2.Position(3)])
        
        ax_x.XTick = [0 2 4 6];
        ax_x.XTickLabel = [0 2 4 6];
        
        ax_x.FontSize=FontSize;
        ax_y.FontSize=FontSize;
        h_x=xlabel(ax_x,xlab,'FontSize',FontSize);
        h_x_pos=get(h_x,'Position');
        set(h_x,'Position',[h_x_pos(1) h_x_pos(2)+7]);t1=title(ax_x,{'0.125 s'... 
            'stimulation'});
        set(t1,'Position',[post(1) 92 0])



%% Subplot 10s Vasoactive

    ax2=subplot(1,3,2);
        ax2.FontSize=FontSize;
        PGE2_2=10.^(theta(28)).*(solReal10.x(:,9)-solReal10.x(1,9));
        NPY_2=10.^(theta(29)).*(solReal10.x(:,13)-solReal10.x(1,13));
        NO_2=10.^(theta(27)).*(solReal10.x(:,11)-solReal10.x(1,11));
        l1=plot(solReal10.t,PGE2_2,'-','Color',CPGE2VSM,'LineWidth',lw);
        hold on
        l3=plot(solReal10.t,NPY_2,'-','Color', CNPYVSM,'LineWidth',lw);
        l2=plot(solReal10.t,NO_2,'-','Color', CNOVSM,'LineWidth',lw);
        l4=plot(solReal10.t,PGE2_2+NO_2-NPY_2,'k--','LineWidth',lw);
        rectangle('Position',[0,-0.4,10,sizebar*sum(abs(ax2.YLim))],'FaceColor','k')
        
        hold off
        ylim([-3 5.5])
        t2=title('10 s stimulation');
        post2=get(t2,'Position');
        pos=get(ax2,'Position');
        set(ax2,'Position',[pos(1)-0.025 pos(2)+0.1 pos(3) pos(4)-0.1])
       
        [ax_x,ax_y]=TufteStyle(ax2);
        ax_x.FontSize=FontSize;
        ax_y.FontSize=FontSize;
        h_x=xlabel(ax_x,xlab,'FontSize',FontSize);
        h_x_pos=get(h_x,'Position');
        set(h_x,'Position',[h_x_pos(1) h_x_pos(2)+7]);
        t2=title(ax_x,'10 s stimulation');
        
        ax_x.XTick = [0 20 40];
        ax_x.XTickLabel = [0 20 40];
        
        set(t2,'Position',[post2(1) 106 0])



%% Subplot 30s Vasoactive
    ax3=subplot(1,3,3);
        ax3.FontSize=FontSize;
        PGE2_3=10.^(theta(28)).*(solReal30.x(:,9)-solReal30.x(1,9));
        NPY_3=10.^(theta(29)).*(solReal30.x(:,13)-solReal30.x(1,13));
        NO_3=10.^(theta(27)).*(solReal30.x(:,11)-solReal30.x(1,11));
        plot(solReal30.t,PGE2_3,'-','Color',CPGE2VSM,'LineWidth',lw)
        hold on
        plot(solReal30.t,NPY_3,'-','Color', CNPYVSM,'LineWidth',lw)
        plot(solReal30.t,NO_3,'-','Color', CNOVSM,'LineWidth',lw)
        plot(solReal30.t,PGE2_3+NO_3-NPY_3,'k--','LineWidth',lw)
        axis([0 90 -3 5.5])
        rectangle('Position',[0,-0.4,30,sizebar*sum(abs(ax3.YLim))],'FaceColor','k')

        hold off
        t3=title('30 s stimulation');
        post3=get(t3,'Position');
        pos=get(ax3,'Position');
        set(ax3,'Position',[pos(1)-0.017 pos(2)+0.1 pos(3) pos(4)-0.1])
        [hleg2,object_h,plot_h,text_str]=legendflex([l1,l2,l3],{'\color[rgb]{0.949 0.721 0.274}{PGE_{2, SMC}}','\color[rgb]{0.443 0.965 0.423}{NO_{SMC}}','\color[rgb]{0.647 0.659 0.471}{NPY_{SMC}}'},'anchor',[1 1],'ncol',1,'nrow',3,'fontsize',8,'xscale',0.2, 'box','off');
             
        set(hleg2,'Position',[hleg2.Position(1)+220 hleg2.Position(2)+10 hleg2.Position(3:4)])


        [ax_x,ax_y]=TufteStyle(ax3);
        ax_x.FontSize=FontSize;
        ax_y.FontSize=FontSize;
        [hleg3,object_h2,plot_h2,text_str2]=legendflex(l4,{['Total: \color[rgb]{0.949 0.721 0.274}{PGE_{2, SMC}} ' char(10) '\color{black}{+} \color[rgb]{0.443 0.965 0.423}{NO_{SMC}} \color{black}{-} \color[rgb]{0.647 0.659 0.471}{NPY_{SMC}}']},'anchor',[3 1],'ncol',0,'nrow',0,'fontsize',8,'xscale',0.2, 'box','off','padding',[0 0 0]);
        set(hleg3,'Position',[hleg3.Position(1)+85 hleg3.Position(2)-60 hleg3.Position(3:4)])

        ax_x.XTick = [0 20 40 60 80];
        ax_x.XTickLabel = [0 20 40 60 80];
        
        h_x=xlabel(ax_x,xlab,'FontSize',FontSize);
        h_x_pos=get(h_x,'Position');
        set(h_x,'Position',[h_x_pos(1) h_x_pos(2)+7]);
        t3=title(ax_x,'30 s stimulation');
        set(t3,'Position',[post3(1) 106 0])
        
        
    [~,h4]=suplabel('E','t',[.05 .08 0.02 0.85]);
    h4.FontSize=12;

    [~,h5]=suplabel('F','t',[.05 .08 0.60 0.85]);
    h5.FontSize=12;

    [~,h6]=suplabel('G','t',[.05 .08 1.15 0.85]);
    h6.FontSize=12;
     