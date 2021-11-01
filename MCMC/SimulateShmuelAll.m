function [simulationOutput] = SimulateShmuelAll(theta, Con, stimend,Data,cutOff)

thetaneg = theta(1:38);
thetaneg([1 2 3]) = theta(39:41);
thetaneg(4:12)=theta(44:end);
logL=0;

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

%Constants = [ssArt, Ca_start, tstart, stimend(1), Con, HbO_0, HbR_0, SaO2_0, ScO2_0, SvO2_0, TE, B0];
Constants = [sol.x(end,[11 9 13]), Ca_start, tstart, stimend(1), Con, sol.y(end, 2:6), TE, B0];
Constants_neg = [sol.x(end,[11 9 13]), Ca_start, tstart, stimend(1) + 1, Con, sol.y(end, 2:6), TE, B0]; %LFP neg seems to have 21 sec stim length

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

    solRealneg = simulate_SensorynegativeShmuel2(0:0.5:(stimend(1)+1), thetaneg, [Constants_neg,theta(42), theta(43), 1], [], optionsNeg);
    optionsNeg.x0 = solRealneg.x(end,:)';
    solRealneg2 = simulate_SensorynegativeShmuel2(((stimend(1)+1):0.5:40) - (stimend(1)+1), thetaneg, [Constants_neg,theta(42), theta(43), 0], [], optionsNeg);
        simNeg.y = [solRealneg.y ; solRealneg2.y(2:end,:)];
        
    costfig1d = sum((simPos.y(2:2:end-1,6) - Data.BOLD.Y).^2./(Data.BOLD.Sigma_Y.^2));
    costfig2a = sum((simPos.y(2:2:end-1,7) - Data.act.Y(6:end)).^2./(Data.act.Sigma_Y(6:end).^2));
    costfig1dneg = sum((simNeg.y(2:2:end-1,6) - Data.BOLDneg.Y).^2./(Data.BOLDneg.Sigma_Y.^2));
    costfig2aneg = sum((simNeg.y(2:2:end-1,7) - Data.actneg.Y(6:end)).^2./(Data.actneg.Sigma_Y(6:end).^2));

    cost = costfig1d + costfig2a + costfig1dneg+ costfig2aneg;

    logL = logL + cost;
    
%% construc toutput matrix
    if (solReal.status<0 || solRealneg.status<0)
        simulationOutput = NaN(4,40);
        disp('Failed')
        
    elseif logL>cutOff
        simulationOutput = NaN(4,40);
        disp('Larger than cut-off')   
        
    else
        simulationOutput = [solReal.y(2:2:end-1,6).'
            solReal.y(2:2:end-1,7).'
            solRealneg.y(2:2:end-1,6).'
            solRealneg.y(2:2:end-1,7).'
            ];
    end
end