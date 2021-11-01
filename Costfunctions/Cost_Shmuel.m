function [f,c] = Cost_Shmuel(theta,Data,Con,stimend,FID)

% obs theta(42:43) are the signs parameters passed with the Constants
% vector
thetaneg = theta(1:38);
thetaneg([1 2 3]) = theta(39:41);
thetaneg(4:12)=theta(44:end);
logL=0;

options = amioption('sensi',0,...
    'maxsteps',1e3);
options.sensi = 0;

%% Steady state simulation
Ca_start = 10;

sol = simulate_SSmodel(inf,theta(4:37),[Ca_start,Con],[],options);

% assaign values to constants in the stimulation simulation
options.x0 = sol.x(end,:).';

tstart = 0.0001;
TE = 20*10^-3;       B0 = 4.7;

Constants = [sol.x(end,[11 9 13]), Ca_start, tstart, stimend(1), Con, sol.y(end, 2:6), TE, B0];
Constants_neg = [sol.x(end,[11 9 13]), Ca_start, tstart, stimend(1) + 1, Con, sol.y(end, 2:6), TE, B0]; %Neg stimulation set to 21 sec

% alter simulation tolerances, DAE solver can not handle the default values
options.atol = 1e-6;
options.rtol = 1e-12;
optionsPos = options;
optionsNeg = options;

%% Simulations

    solReal = simulate_SensoryShmuel2(0:0.5:stimend(1), theta(1:38), [Constants, 1], [], optionsPos);
    optionsPos.x0 = solReal.x(end,:)';
    solReal2 = simulate_SensoryShmuel2((stimend(1):0.5:40) - stimend(1), theta(1:38), [Constants, 0], [], optionsPos);
        simPos.y = [solReal.y ; solReal2.y(2:end,:)];
        simPos.x = [solReal.x ; solReal2.x(2:end,:)];

    solRealneg = simulate_SensorynegativeShmuel2(0:0.5:(stimend(1)+1), thetaneg, [Constants_neg,theta(42), theta(43), 1], [], optionsNeg);
    optionsNeg.x0 = solRealneg.x(end,:)';
    solRealneg2 = simulate_SensorynegativeShmuel2(((stimend(1)+1):0.5:40) - (stimend(1)+1), thetaneg, [Constants_neg,theta(42), theta(43), 0], [], optionsNeg);
        simNeg.y = [solRealneg.y ; solRealneg2.y(2:end,:)];
        simNeg.x = [solRealneg.x ; solRealneg2.x(2:end,:)];

    if (solReal.status<0 && solRealneg.status<0)
        logL = NaN;
    else
        %fit to data calculations
        costfig1d = sum((simPos.y(2:2:end-1,6) - Data.BOLD.Y).^2./(Data.BOLD.Sigma_Y.^2));
        costfig2a = sum((simPos.y(2:2:end-1,7) - Data.act.Y(6:end)).^2./(Data.act.Sigma_Y(6:end).^2));
        costfig1dneg = sum((simNeg.y(2:2:end-1,6) - Data.BOLDneg.Y).^2./(Data.BOLDneg.Sigma_Y.^2));
        costfig2aneg = sum((simNeg.y(2:2:end-1,7) - Data.actneg.Y(6:end)).^2./(Data.actneg.Sigma_Y(6:end).^2));
        
        cost = costfig1d + costfig2a + costfig1dneg+ costfig2aneg;

        %penalty Postive simulation
        NOVSM = 10^theta(27)*(simPos.x(2:2:end-1,11)-simPos.x(1,11));
        PGEVSM = 10^theta(28)*(simPos.x(2:2:end-1,9)-simPos.x(1,9));
        NPYVSM = 10^theta(29)*(simPos.x(2:2:end-1,13)-simPos.x(1,13));
        
        straff1 = 1e2*sum(NPYVSM(2:35) < 0);
        straff2 = 1e2*sum(NPYVSM(30:end) < abs(PGEVSM(30:end)));    %force NPY to contributate   
        straff3 = 1e2*sum(NOVSM(5:12) > -0.1.*abs(PGEVSM(5:12)));
        straff4 = 1e2*sum(NPYVSM(5:20) > PGEVSM(5:20));
    
        straffPOS = straff1 + straff2 + straff3 + straff4;
        
        %penalty Negative simulation
        PGEVSM1 = 10^theta(28)*(simNeg.x(2:2:end-1,9)-simNeg.x(1,9));
        NPYVSM1 = 10^theta(29)*(simNeg.x(2:2:end-1,13)-simNeg.x(1,13));
        
        straff21 = 1e2*sum(PGEVSM1(30:38) > -NPYVSM1(30:38));

        straffNeg = straff21; 
        
         
        %% penalty Hb behaviour
        straff21 = 1e1*sum(abs(simPos.y(4:40,9)) < 2*abs(simPos.y(4:40,10)));
        straff22 = 1e0*sum(abs(simPos.y(60:end,9)));
        straff23 = 1e0*sum(abs(simPos.y(60:end,10)));
        
        straffHb = straff21 + straff22 + straff23;
        
        %% total cost + penalty
        logL = logL + cost + straffPOS + straffNeg + straffHb;
    end

f = logL;
c = [];

% MCMC related, save parameters to file
   if nargin == 6 && logL < chi2inv(0.95,160) 
        fprintf(FID,'%4.10f %10.10f ',[f, theta']); fprintf(FID,'\n');
   end
   
end