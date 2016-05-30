%!/usr/bin/matlab
% 26th May 2016
%
% Simulation 7
%
%	The purpose of this simulation is to measure the epidemics value in a context
%	where population values of L+ and L3 are differents.
%
%
disp('Simulation 7')
simulation_parameters = [];
simulation_parameters.B		= buildExponentialInteractionGrill(1.25, 2, 50);
simulation_parameters.BF	= buildBustrofedonGrill(50, 0.75);
simulation_parameters.BL	= buildExponentialInteractionGrill(0.1, 2, 50);
simulation_parameters.Pi	= 1				;
simulation_parameters.L		= [35, 95, 55]	;
simulation_parameters.N		= 50			;
simulation_parameters.C		= 1				;
simulation_parameters.H		= 150			;
simulation_parameters.name	=	'sim 3'		;
saving_number = 0;
lplus_freq = [0 : 0.1 : 1];
for ratio_iter = 1 : 1 : length(lplus_freq)
	%
	%
	%
	disp(['Working in ratio iter ', num2str(lplus_freq(ratio_iter))]);
	saving_number = saving_number + 1;
	x_val = lplus_freq(ratio_iter);
	local_library = [];
	parfor pariter = 1 : 1 : 50
		local_parameters = simulation_parameters;
		local_parameters.G = buildGenotypeGrill('random', 50, [x_val, 0, 1 - x_val, 0]);
		if any(local_parameters.G == 1)
			ensamble = find(local_parameters.G == 1);
			seed_1 = datasample(ensamble, 1);
		else
			seed_1 = 0;
		end
		if any(local_parameters.G <= 2)
			ensamble = find(local_parameters.G <= 2);
			seed_2 = datasample(ensamble, 1);
		else
			seed_2 = 0;
		end
		if any(local_parameters.G <= 3)
			ensamble = find(local_parameters.G <= 3);
			seed_3 = datasample(ensamble, 1);
		else
			seed_3 = 0;
		end
		local_parameters.S = [seed_1, seed_2, seed_3];
		report = simulateArcadeSpots2(local_parameters, false);
		report_library(pariter).hist_infection = [report.hist_infection];
		report_library(pariter).genotypes = local_parameters.G;
		report_library(pariter).seeds = local_parameters.S;
		report_library(pariter).dammage = report.hist_dammage;
	end
	save(['sim_7_', num2str(saving_number)], 'report_library');
end
