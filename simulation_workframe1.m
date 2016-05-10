%!/usr/bin/matlab
%By Bruno Cuevas
% Simulation Workframe 1
%
%
%
%
clear all;
parameters = [];
parameters.B = buildExponentialInteractionGrill(1, 2.25, 50);
parameters.BF = buildBustrofedonGrill(50, 1);
parameters.Pi = 1;
parameters.G(:,:,1) = buildGenotypeGrill('random', 50, [1,0,0]);
parameters.G(:,:,2) = buildGenotypeGrill('random', 50, [1,0,0]);
parameters.L = [35, 95, 55];
parameters.S = [0, 0, 0];
parameters.N = 50;
parameters.C = 2;
parameters.H = 150;
parameters.name = 'sim1';
simulations_main_name = 'sim_1';
name = '';
for iter = 1 : 1 : 10
	report_library  = [] ;
	parfor pariter = 1 : 1 : 10
		local_parameters = parameters
		local_parameters.S = datasample([1:2500], 3);
		disp(['   working in ', num2str(iter)]);
		report = simulateArcadeSpots(local_parameters, false);
		report_library(pariter).picture = report.picture;
		report_library(pariter).hist_infection = report.hist_infection;
		report_library(pariter).senescence_picture = report.senescence_picture;

	end
	save([simulations_main_name, '_', num2str(iter)],'report_library');
end
