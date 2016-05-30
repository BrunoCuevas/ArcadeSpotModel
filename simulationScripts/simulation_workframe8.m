%!/usr/bin/matlab
% 30th May 2016
% Simulation 8
% The general purpose of this simulation is to test the evolution of epidemics
%	in a wild-like genotype grill where there are only two phenotypes (L4 and L+)
%
parameters = [];
% No bustrofedon nor assimetry
nsize = 50;
parameters.B	= buildExponentialInteractionGrill(1.25, 1, nsize);
parameters.BL	= buildInteractionBoundaryFreeMatrix (0.1, 3, nsize, 1);
parameters.BF	= zeros(nsize)	;
parameters.N	= nsize			;
parameters.C	= 1				;
parameters.H	= 300			;
parameters.Pi	= 1				;
parameters.L	= [35, 95, 55]	;



%	The design of this simulation is to set firstly different genotype
%	frequencies, then differents clustered populations, and then perform
%	a large number of simulations in the same position.

simulation_freqs_set = [0 : 0.1 : 1];
for freq_iter = 1 : 1 : length(simulation_freqs_set)
	for grill_iter = 1 : 1 : 10
		local_library = [];
		parameters.G = buildClusteredGenotypeGrill(9, 50, [simulation_freqs_set(grill_iter), 0, 0] );
		parfor pariter = 1 :  1 : 25
			local_parameters = parameters;
			local_parameters.S = [];
			if any(parameters.G == 1)
				local_parameters.S(1) = dataset(find(parameters.G == 1), 1);
			else
				local_parameters.S(1) = 0;
			end
			if any(parameters.G <= 2)
				local_parameters.S(2) = dataset(find(parameters.G <= 2), 1);
			else
				local_parameters.S(2) = 0;
			end
			if any(parameters.G <= 3)
				local_parameters.S(3) = dataset(find(parameters.G <=3), 1);
			else
				local_parameters.S(3) = 0;
			end
			report = simulateArcadeSpots2(local_parameters, parameters)
			local_library(pariter).hist_infection = report.hist_infection;
			local_library(pariter).genotype = local_parameters.G;
			local_library(pariter).seeds = local_parameters.S;
		end
		save(['sim_8_', num2str(freq_iter), '_', num2str(grill_iter)], 'local_library');
	end
end
