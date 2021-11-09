function [f,c,gf,gc] = Cost_Drew(theta,Data,Con,stimend, FID)

logL=0;
dlogL = zeros(numel(theta),1);

options = amioption('sensi',0,...
    'maxsteps',1e4);
options.sensi = 0;
options.nmaxevent = 1e3;

%% Steady state simulation
Ca_start = 10;

% steady state simulation
sol = simulate_SSmodel(inf,theta(4:end),[Ca_start,Con],[],options);

% assaign values to constants in the stimulation simulation
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

%% Simulations
    solReal = simulate_Drew(Data.D.t,theta, Constants, [], options);

    Constants(5) = stimend(2);
    options.atol = 1e-5;
    options.rtol = 1e-8;

    solReal10 = simulate_Drew(Data.D10.t,theta, Constants, [], options);
    Constants(5) = stimend(3);

    solReal30 = simulate_Drew(Data.D30.t,theta, Constants, [], options);


    if (solReal30.status<0 && solReal10.status<0 && solReal.status<0)
        logL = NaN;
    else
        cost0_02 = sum((solReal.y(2:end,1) - Data.D.Y(2:end,1)).^2./(Data.D.Sigma_Y(2:end,1).^2)) + sum((solReal.y(2:end,2) - Data.D.Y(2:end,2)).^2./(Data.D.Sigma_Y(2:end,2).^2));
        cost10 = sum((solReal10.y(2:end,1) - Data.D10.Y(2:end,1)).^2./(Data.D10.Sigma_Y(2:end,1).^2)) + sum((solReal10.y(2:end,2) - Data.D10.Y(2:end,2)).^2./(Data.D10.Sigma_Y(2:end,2).^2));
        cost30 = sum((solReal30.y(2:end,1) - Data.D30.Y(2:end,1)).^2./(Data.D30.Sigma_Y(2:end,1).^2)) + sum((solReal30.y(2:end,2) - Data.D30.Y(2:end,2)).^2./(Data.D30.Sigma_Y(2:end,2).^2));  

       cost=cost30 + cost10 + cost0_02;
       logL = logL + cost;
    end

f = logL;
gf = dlogL;
c = [];
gc = [];

%% MCMC related, save parameters to file
if nargin == 5 && logL < chi2inv(0.95,288) 
    fprintf(FID,'%4.10f %10.10f ',[f, theta']); fprintf(FID,'\n');
end

end