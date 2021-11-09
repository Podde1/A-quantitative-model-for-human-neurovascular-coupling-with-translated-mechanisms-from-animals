function [f,c,gf,gc] = Cost_Drew_TimeVariant(theta,Data,Con,stimend, FID)

logL=0;
dlogL = zeros(numel(theta),1);

options = amioption('sensi',0,...
    'maxsteps',5e3);
options.sensi = 0;
%% SS simulation
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

%% simulations 
    theta1=theta(1:37);
    solReal = simulate_Drew(Data.D.t,theta1, Constants, [], options);

    Constants(5) = stimend(2);
    theta10=theta(1:37);
    solReal10 = simulate_Drew(Data.D10.t,theta10(1:37), Constants, [], options);

    Constants(5) = stimend(3);
    solReal30_1 = simulate_Drew(Data.D30.t(1:3),theta10, Constants, [], options);
    options.x0 = solReal30_1.x(end,:).';

    theta30=theta(1:37);
    theta30(31:32)=theta(38:39);
    theta30(34:35)=theta(40:41);
   
    Constants(5)= stimend(3) - solReal30_1.t(end);
    solReal30_2 = simulate_Drew(Data.D30.t(1:end-2),theta30, Constants, [], options);

    solReal30.t=[solReal30_1.t; solReal30_2.t(2:end)+2];
    solReal30.y=[solReal30_1.y; solReal30_2.y(2:end,:)];
    solReal30.x=[solReal30_1.x; solReal30_2.x(2:end,:)];
    
    if (solReal30_1.status<0 && solReal10.status<0 && solReal.status<0)
        logL = NaN;
    else
        cost0_02 = sum((solReal.y(2:end,1) - Data.D.Y(2:end,1)).^2./(Data.D.Sigma_Y(2:end,1).^2)) + sum((solReal.y(2:end,2) - Data.D.Y(2:end,2)).^2./(Data.D.Sigma_Y(2:end,2).^2));
        cost10 = sum((solReal10.y(2:end,1) - Data.D10.Y(2:end,1)).^2./(Data.D10.Sigma_Y(2:end,1).^2)) + sum((solReal10.y(2:end,2) - Data.D10.Y(2:end,2)).^2./(Data.D10.Sigma_Y(2:end,2).^2));
        cost30 = sum((solReal30.y(2:end,1) - Data.D30.Y(2:end,1)).^2./(Data.D30.Sigma_Y(2:end,1).^2)) + 1*sum((solReal30.y(2:end,2) - Data.D30.Y(2:end,2)).^2./(Data.D30.Sigma_Y(2:end,2).^2));

        cost = cost0_02 + cost10 + cost30;
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