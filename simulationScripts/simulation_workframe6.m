%!/usr/bin/matlab
% By Bruno Cuevas
% 24th May 2016
%
%
%
clear all;
clc;
cd '~/Documents/Matlabscripts/sim_6';

parameters = setParametersArcadeSpots;
parameters.B = buildExponentialInteractionGrill(1.25, 2, 50);
parameters.BF = buildBustrofedonGrill(50, 0.75);
parameters.BL = buildExponentialInteractionGrill(0.1,2, 50);
library1 = [];
library2 = [];
parfor pariter = 1 : 1 : 25
	report = simulateArcadeSpots(parameters, false);
	library1(pariter).hist = report.hist_infection;
	report = simulateArcadeSpots2(parameters, false);
	library2(pariter).hist = report.hist_infection;
end
save('sim_6');
