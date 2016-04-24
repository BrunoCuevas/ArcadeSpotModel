function report = simulateArcadeSpots (parameters)
	% function simulateArcadeSpots
	% By Bruno Cuevas, 2016
	% Usage
	%		rep = simulateArcadeSpots(params) ;
	%			params is a structure of parameters.
	% For additional information, read documentation
	% FAQ : brunocuevaszuviria@gmail.com
	%
	%
	if isnumeric(parameters)
		parameters_control = [];
		parameters_control(1) = isfield(parameters,'B')	;
		parameters_control(2) = isfield(parameters,'BF');
		parameters_control(3) = isfield(parameters,'G')	;
		parameters_control(4) = isfield(parameters,'Pi');
		parameters_control(5) = isfield(parameters,'H')	;
		parameters_control(6) = isfield(parameters,'C')	;
		parameters_control(7) = isfield(parameters,'N') ;
		if any(parameters_control == 0) || (parameters.N ^ 2 =! lenght(parameters_control.B(:,1)))
			disp('Missing parameters') ;
		else
			%------------------------------------------------------%
			%	Header
			%------------------------------------------------------%
			disp('---------------------------------------------');
			disp('    Arcade Spots, 2016');
			disp('           By Bruno Cuevas');
			disp('---------------------------------------------');
			%------------------------------------------------------%
			%	Variables
			%------------------------------------------------------%
			disp('Reassigning variables');
			cycles_limit = parameters.C	;
			harvest = parameters.H		;
			interaction_grill = parameters.B	;
			bustrofedon_grill = parameters.BF	;
			genotypes = parameters.G			;
			periodicity = parameters.Pi			;
			nsize = parameters.N				;
			clear parameters;

			disp('Setting constants');
			% Genotypes.
			genotype_list = [1,2,3,4];
			pathotype_restriction_matrix(:,1) = [1,1,1];
			pathotype_restriction_matrix(:,2) = [0,1,1];
			pathotype_restriction_matrix(:,3) = [0,0,1];
			pathotype_restriction_matrix(:,4) = [0,0,0];
			genotype_umbral = [];
			genotype_umbral(1) = 0;
			genotype_umbral(2) = genotypes(1);
			genotype_umbral(3) = genotype_umbral(2) + genotypes(2);
			genotype_umbral(4) = genotype_umbral(3) + genotypes(3);
			genotype_umbral(5) = 1;
			% Infection Matrix.
			M = [69.2, 0, 0 ; 0, 33.8, 0 ; 0, 0, 17.6];
			C = [0, (65.97-69.2), (69.4-69.2); (5.5-33.8), 0, (14.6-33.8); (0.14-17.64) (6.85-17.64) 0];
			% Dammage constants
			FRC								= [1 - 0.58 , 1 - 0.648, 1-0.487];
			% Latence
			latence_time = 10 ;

			disp('Creating population');
			state = [];
			for iy = 0 : 1 : nsize - 1
				for ix = 1 : 1 : nsize
					genotype_raffle = rand(1);
					genotype_result = genotype_umbral > genotype_raffle;
					genotype_selector = 1;
					while genotype_result(genotype_selector) == 1
						genotype_selector = genotype_selector + 1;
					end
					state(1).x((iy * nsize)+ix) = 0	;
					state(2).x((iy * nsize)+ix) = 0	;
					state(3).x((iy * nsize)+ix) = 0	;
					state(1).y((iy * nsize)+ix) = 0	;
					state(2).y((iy * nsize)+ix) = 0	;
					state(3).y((iy * nsize)+ix) = 0	;
					state(1).dpi((iy * nsize)+ix) = 0	;
					state(2).dpi((iy * nsize)+ix) = 0	;
					state(3).dpi((iy * nsize)+ix) = 0	;
					state(1).omega((iy * nsize)+ix) = 0	;
					state(2).omega((iy * nsize)+ix) = 0	;
					state(3).omega((iy * nsize)+ix) = 0	;
					state(1).g((iy * nsize)+ix) = pathotype_restriction_matrix(1,genotype_selector);
					state(2).g((iy * nsize)+ix) = pathotype_restriction_matrix(2,genotype_selector);
					state(3).g((iy * nsize)+ix) = pathotype_restriction_matrix(3,genotype_selector);
					state(1).P((iy * nsize)+ix) = 0	;
					state(2).P((iy * nsize)+ix) = 0	;
					state(3).P((iy * nsize)+ix) = 0	;
					state(1).A((iy * nsize)+ix) = 1	;
					state(2).A((iy * nsize)+ix) = 1	;
					state(3).A((iy * nsize)+ix) = 1	;
				end
			end



			disp('Starting simulation');

			for cycle = 1 : 1 : cycles_limit
				dammage = 0 ;
				for day = 1 : 1 : harvest
					tic ;
					disp(['cycle = ', num2str(cycle), ' day = ', num2str(day)]);
					agricultor_mediated_spread = abs(sin(day/periodicity));
					[state(1).dpi] = [state(1).dpi] + ([state(1).x] >= 1);
					[state(2).dpi] = [stat + bustrofedon_grill*[state(1).y]'e(2).dpi] + ([state(2).x] >= 1);
					[state(3).dpi] = [state(3).dpi] + ([state(3).x] >= 1);
					[state(1).y] = [state(1).dpi] > latence_time;
					[state(2).y] = [state(1).dpi] > latence_time;
					[state(3).y] = [state(1).dpi] > latence_time;
					increase_infection_vector(:,:) =  zeros(nsize^2, 3);
					increase_infection_vector(:,1) = interaction_grill*[state(1).y]' + bustrofedon_grill*[state(1).y]';
					increase_infection_vector(:,2) = interaction_grill*[state(2).y]' + bustrofedon_grill*[state(2).y]';
					increase_infection_vector(:,3) = interaction_grill*[state(3).y]' + bustrofedon_grill*[state(3).y]';
					




				end
			end
	else
		disp('Error: One of the parameters is not numeric')
	end
