function [f,c] = Cost_Shmuel(theta,Data,Con,stimend,FID)

    if size(theta,1) > 1
            theta = theta';
    end
    
    % obs theta(42:43) are the signs parameters 
    thetaneg = theta(1:38);
    thetaneg([1 2 3]) = theta(39:41);
    thetaneg(4:12)=theta(44:end);
    
    thetapos = 10.^(theta(1:38));
    thetaneg = 10.^(thetaneg);
    logL=0;

    options = amioption('sensi',0,...
        'maxsteps',1e3);
    options.sensi = 0;

    try
    %% Steady state simulation
    Ca_start = 10;

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
    t1 = 0:0.5:stimend(1);
    solReal = simulate_Model(t1, thetapos, Constants, [], optionsPos);
    optionsPos.x0 = solReal.x(end,:)';
    
    t2 = (stimend(1):0.5:40) - stimend(1);
    Constants(end) = 0; 
    solReal2 = simulate_Model(t2, thetapos, Constants, [], optionsPos);
    
    simPos.y = [solReal.y ; solReal2.y(2:end,:)];
    simPos.x = [solReal.x ; solReal2.x(2:end,:)];
    
    if solReal.status<0
        throw(MException('error'))
    end
    
    t1 = 0:0.5:(stimend(1)+1);
    solRealneg = simulate_ModelNegative(t1, thetaneg, Constants_neg, [], optionsNeg);
    
    optionsNeg.x0 = solRealneg.x(end,:)';
    Constants_neg(end) = 0;
    t2 = ((stimend(1)+1):0.5:40) - (stimend(1)+1);
    solRealneg2 = simulate_ModelNegative(t2, thetaneg, Constants_neg, [], optionsNeg);
    
    simNeg.y = [solRealneg.y ; solRealneg2.y(2:end,:)];
    simNeg.x = [solRealneg.x ; solRealneg2.x(2:end,:)];

    if solRealneg.status<0
        throw(MException('error'))
    end
    
    %% fit to data calculations
    costfig1d = sum((simPos.y(2:2:end-1,6) - Data.BOLD.Y).^2./(Data.BOLD.Sigma_Y.^2));
    costfig2a = sum((simPos.y(2:2:end-1,8) - Data.act.Y(6:end)).^2./(Data.act.Sigma_Y(6:end).^2));
    costfig1dneg = sum((simNeg.y(2:2:end-1,6) - Data.BOLDneg.Y).^2./(Data.BOLDneg.Sigma_Y.^2));
    costfig2aneg = sum((simNeg.y(2:2:end-1,8) - Data.actneg.Y(6:end)).^2./(Data.actneg.Sigma_Y(6:end).^2));

    cost = costfig1d + costfig2a + costfig1dneg+ costfig2aneg;

    %penalty Postive simulation
    NOVSM  = thetapos(27)*(simPos.x(2:2:end-1,11)-simPos.x(1,11));
    PGEVSM = thetapos(28)*(simPos.x(2:2:end-1,9)-simPos.x(1,9));
    NPYVSM = thetapos(29)*(simPos.x(2:2:end-1,13)-simPos.x(1,13));

    straff1 = 1e2*sum(NPYVSM(2:35) < 0);
    straff2 = 1e2*sum(NPYVSM(30:end) < abs(PGEVSM(30:end)));    %force NPY to contributate   
    straff3 = 1e2*sum(NOVSM(5:12) > -0.1.*abs(PGEVSM(5:12)));
    straff4 = 1e2*sum(NPYVSM(5:20) > PGEVSM(5:20));

    straffPOS = straff1 + straff2 + straff3 + straff4;

    %penalty Negative simulation
    PGEVSM1 = thetaneg(28)*(simNeg.x(2:2:end-1,9)-simNeg.x(1,9));
    NPYVSM1 = thetaneg(29)*(simNeg.x(2:2:end-1,13)-simNeg.x(1,13));

    straff21 = 1e2*sum(PGEVSM1(30:38) > -NPYVSM1(30:38));

    straffNeg = straff21; 


    %% penalty Hb behaviour
    straff21 = 1e1*sum(abs(simPos.y(4:40,4)) < 2*abs(simPos.y(4:40,5)));
    straff22 = 1e0*sum(abs(simPos.y(60:end,4)));
    straff23 = 1e0*sum(abs(simPos.y(60:end,5)));

    straffHb = straff21 + straff22 + straff23;

    %% total cost + penalty
    logL = logL + cost + straffPOS + straffNeg + straffHb;

    f = logL;
    c = [];

    % MCMC related, save parameters to file
   if nargin == 5 && logL < chi2inv(0.95,160) 
        fprintf(FID,'%4.10f %10.10f ',[f, theta']); fprintf(FID,'\n');
   end
    catch
        f = 1e20;
        c = [];
    end
end