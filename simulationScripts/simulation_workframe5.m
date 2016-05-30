%!/usr/bin/matlab
% 20th May 2016
% By Bruno Cuevas
%
%
%	Simulation 5
%
%
%	The purpose of this simulation is to test the impact of host-genotype
%	composition within viral spread.
%
%
%
clear all;
clc;
disp('________________________________________________________________________')
disp('		Simulation 5. Genetic Diversity');
disp('________________________________________________________________________')
simulation_parameters 		= [];
simulation_parameters.B		= buildExponentialInteractionGrill(1.25, 2, 50);
simulation_parameters.BF	= buildBustrofedonGrill(50, 0.75);
simulation_parameters.Pi	= 1;
simulation_parameters.L		= [35, 95, 55];
simulation_parameters.S		= [0, 0, 0];
simulation_parameters.N		= 50;
simulation_parameters.C		= 5;
simulation_parameters.H		= 150;
simulation_parameters.BL	= buildExponentialInteractionGrill(0.1, 2, 50);
simulation_parameters.name	=	'sim_4'
library_report 				= [];
sobolset_object 			= sobolset(2);
sobolset_values				=	net(sobolset_object, 300);
l0_values 					= sobolset_values(:,1);
l3_values 					= sobolset_values(:,2);
clear sobolset_object;
	parfor iter_major = 1 : 1 : 300

		local_parameters = simulation_parameters;
		l0 = l0_values(iter_major);
		l3 = l3_values(iter_major);
		if (l0 + l3) > 1
			l3_int = l3;
			l3 = 1 - l0;
			l0 = 1 - l3_int;
		end
		temp_historial = [];
		mean_values = [];
			%for iter_menor = 1 : 1 : 5
			local_parameters.G(:,:,1) = buildGenotypeGrill('random', 50, [l0, 0, l3]);
			local_parameters.G(:,:,2) =	local_parameters.G(:,:,1)
			local_parameters.G(:,:,3) = local_parameters.G(:,:,1)
			local_parameters.G(:,:,4) = local_parameters.G(:,:,1)
			local_parameters.G(:,:,5) = local_parameters.G(:,:,1)
			l4 = sum(sum(local_parameters.G(:,:,1) == 4))/2500;
			if any(local_parameters.G(:,:,1) == 1)
				seed_p0 = datasample(find(local_parameters.G(:,:,1) == 1),1);
			else
				seed_p0 = 0;
			end
			if any(local_parameters.G(:,:,1) <= 2)
				seed_p12 = datasample(find(local_parameters.G(:,:,1) <= 2),1);
			else
				seed_p12 = 0;
			end
			if any(local_parameters.G(:,:,1) <= 3)
				seed_p123 = datasample(find(local_parameters.G(:,:,1) <= 3),1);
			else
				seed_p123 = 0;
			end
			local_parameters.S = [seed_p0, seed_p12, seed_p123];
			report = simulateArcadeSpots2(local_parameters, false);

			temp_historial = report.hist_infection;
		%end
		%for iter_stat = 1 : 1 : length(temp_historial(:,1))
		%	mean_values(iter_stat) = mean(temp_historial(iter_stat,:));
		%end
		library_report(iter_major).hist_area	= temp_historial(:,1:3);
		library_report(iter_major).hist_pop		= temp_historial(:,4:6);
		library_report(iter_major).genotype_composition = [l0, l3, l4];
	end

save('sim_5', 'library_report');
