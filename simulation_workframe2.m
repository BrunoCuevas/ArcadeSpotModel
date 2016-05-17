%!/usr/bin/matlab
% 11th May 2016
% By Bruno Cuevas
%
%	Simulation 2.
%
%	The purpose of this set of simulations is to test if is there any
%	relationship between centrality and increased dammage. In order to archive
%	that, I am  going to test simulations in the different locations of the
%	grill using a reduced interaction matrix.
%
%
%------------------------------------------------------------------------------%
clear all;
clc;
disp('________________________________________________________________________')
disp('		Simulation 2. Distance2centreVSArea');
disp('________________________________________________________________________')
simulation_parameters 		= [];
simulation_parameters.B		= buildExponentialInteractionGrill(1.25, 2, 50);
simulation_parameters.BF	= buildBustrofedonGrill(50, 0.75);
simulation_parameters.Pi	= 1;
simulation_parameters.G		= buildGenotypeGrill('random', 50, [1,0,0]);
simulation_parameters.L		= [35, 95, 55];
simulation_parameters.S		= [0, 0, 0];
simulation_parameters.N		= 50;
simulation_parameters.C		= 1;
simulation_parameters.H		= 150;
simulation_parameters.name	=	'sim_2'
saving_number = 0;
areas_matrix = zeros(50,50);
for iter_y  = 1 : 1 : 5
	for iter_x = 1 : 1 : 5
		seed_positions = zeros(100,1);
		seed_positions(1) = ((iter_y-1)*500) + ((iter_x - 1)*10) + 1;
		row_increase = 0;
		col_increase = 0;
		for iter_seed = 2 : 1 : 100
			col_increase				= ((mod((iter_seed-1),10)==0)*50) + col_increase;
			row_increase				= (row_increase + 1)*(1-(mod((iter_seed-1),10)==0));
			seed_positions(iter_seed)	= seed_positions(1) + row_increase + col_increase;
		end
		report_library = [];
		saving_number = saving_number + 1;
		disp(['working in ', num2str(saving_number)]);

		parfor pariter = 1 : 1 : 50
			local_parameters = simulation_parameters;
			current_seed = datasample(seed_positions, 1);
			local_parameters.S = [current_seed, 0 , 0];
			report = simulateArcadeSpots(local_parameters, false);
			report_library(pariter).hist_infection = [report.hist_infection];
			report_library(pariter).seed = current_seed;
			report_library(pariter).dammage = [report.hist_dammage];
		end
		save(['sim_2_', num2str(saving_number)], 'report_library');
	end
end
