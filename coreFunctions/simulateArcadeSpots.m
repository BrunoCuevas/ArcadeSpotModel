function report = simulateArcadeSpots (parameters, verbose)
	% function simulateArcadeSpots
	% By Bruno Cuevas, 2016
	% Usage
	%		rep = simulateArcadeSpots(params, verbose) ;
	%			params is a structure of parameters.
	%			verbose is a boolean
	%			verbose = false to avoid real-time state comments
	% For additional information, read documentation
	% FAQ : brunocuevaszuviria@gmail.com
	%
	%
	if isstruct(parameters)
		% uncomment the following line to make this simulation repeatable
		%rng 'default';
		addpath(genpath('~/Dropbox/TFG/ArcadeSpots'));
		parameters_control = [];
		parameters_control(1) = isfield(parameters,'B')	;
		parameters_control(2) = isfield(parameters,'BF');
		parameters_control(3) = isfield(parameters,'G')	;
		parameters_control(4) = isfield(parameters,'Pi');
		parameters_control(5) = isfield(parameters,'H')	;
		parameters_control(6) = isfield(parameters,'C')	;
		parameters_control(7) = isfield(parameters,'N') ;
		parameters_control(8) = isfield(parameters,'L') ;
		parameters_control(9) = isfield(parameters,'S') ;
		if any(parameters_control == 0)
			disp('Missing parameters') ;
		else
			%------------------------------------------------------%
			%	Header
			%------------------------------------------------------%
			if verbose == true
				disp('---------------------------------------------');
				disp('    Arcade Spots, 2016');
				disp('           By Bruno Cuevas');
				disp('---------------------------------------------');
			end

			%------------------------------------------------------%
			%	Variables
			%------------------------------------------------------%

			cycles_limit = parameters.C	;
			harvest = parameters.H		;
			interaction_grill = single(parameters.B)	;
			bustrofedon_grill = single(parameters.BF)	;
			genotypes = parameters.G			;
			periodicity = parameters.Pi			;
			nsize = parameters.N				;
			lifespan = parameters.L				;
			initial_seeds = parameters.S		;
			clear parameters;


			% Genotypes.
			genotype_list = [1,2,3,4];
			pathotype_restriction_matrix(:,1) = [1,1,1]';
			pathotype_restriction_matrix(:,2) = [0,1,1]';
			pathotype_restriction_matrix(:,3) = [0,0,1]';
			pathotype_restriction_matrix(:,4) = [0,0,0]';



			% Infectivity value-correction Matrix.
			M = [69.2, 0, 0 ; 0, 33.8, 0 ; 0, 0, 17.6]/69.2;
			C = [0, 0, 0; (5.5-33.8), 0, (14.6-33.8); (0.14-17.64) (6.85-17.64) 0]/69.2;
			% Primary Inoc constants
			w1 = [1280, 720, 320];
			%w2 = [2500, 1000, 500];

			% Dammage constants
			FRC								= [ - 0.58, - 0.648, -0.487];
			% Latence
			latence_time = 7 ;
			% Virulence
			k_param = [];
			k_param(1)  =   0.25	;
			k_param(2)	=	0.25	;
			k_param(3)	=	0.25	;
			A_param = [];
			A_param(1)	=	lifespan(1)*k_param(1);
			A_param(2)	=	lifespan(2)*k_param(2);
			A_param(3)	=	lifespan(3)*k_param(3);


			state = [];
			for iy = 0 : 1 : nsize - 1
				for ix = 1 : 1 : nsize

					genotype_selector = genotypes(ix, iy+1,1);
					state(1).x((iy * nsize)+ix) = 0		;
					state(2).x((iy * nsize)+ix) = 0		;
					state(3).x((iy * nsize)+ix) = 0		;
					state(1).y((iy * nsize)+ix) = 0		;
					state(2).y((iy * nsize)+ix) = 0		;
					state(3).y((iy * nsize)+ix) = 0		;
					state(1).dpi((iy * nsize)+ix) = 0	;
					state(2).dpi((iy * nsize)+ix) = 0	;
					state(3).dpi((iy * nsize)+ix) = 0	;
					state(1).omega((iy * nsize)+ix) = 0	;
					state(2).omega((iy * nsize)+ix) = 0	;
					state(3).omega((iy * nsize)+ix) = 0	;
					state(1).g((iy * nsize)+ix) = pathotype_restriction_matrix(1,genotype_selector);
					state(2).g((iy * nsize)+ix) = pathotype_restriction_matrix(2,genotype_selector);
					state(3).g((iy * nsize)+ix) = pathotype_restriction_matrix(3,genotype_selector);
					state(1).P((iy * nsize)+ix) = 0		;
					state(2).P((iy * nsize)+ix) = 0		;
					state(3).P((iy * nsize)+ix) = 0		;
					state(1).A((iy * nsize)+ix) = 1		;
					state(2).A((iy * nsize)+ix) = 1		;
					state(3).A((iy * nsize)+ix) = 1		;

				end
			end


			inocs_onplay = find(initial_seeds);
			for inoc = 1 : 1 : length(inocs_onplay)
				state(inoc).x(initial_seeds(inoc)) = 1;
			end

			% Report Variables

			hist_infection	= [];
			picture_systemic= [];
			focus_radius = 1 ;
			focus_list = [];
			density_picture = [];
			picture_primary_inoc = [];

			betha0 = -(focus_radius/10);
			betha1 = 0.1;

			if verbose == true
				disp('Starting simulation');
				realtimeplot = animatedline([1], [3], 'color', 'r', 'LineWidth', 3/(nsize^2));
				axis([0,cycles_limit*harvest, 0, nsize * 10]);
				title('Evolution of the system');
				ylabel('Population');
				xlabel('Time(days)');
			end

			for cycle = 1 : 1 : cycles_limit
				dammage = 0 ;
				for day = 1 : 1 : harvest
					tic ;
					if verbose == true
						disp(['cycle = ', num2str(cycle), ' day = ', num2str(day)]);
					end

					agricultor_mediated_spread = 1 ;
					stochastic_infection_events = rand(nsize^2, 3);
					focus_radius = floor(day/(2*latence_time)) + 1;
					[state(1).dpi] = [state(1).dpi] + ([state(1).x] >= 1);
					[state(2).dpi] = [state(2).dpi] + ([state(2).x] >= 1);
					[state(3).dpi] = [state(3).dpi] + ([state(3).x] >= 1);
					[state(1).y] = ([state(1).dpi] > latence_time);
					[state(2).y] = ([state(2).dpi] > latence_time);
					[state(3).y] = ([state(3).dpi] > latence_time);
					increase_infection_vector(:,:) = single(zeros(nsize^2, 3));
					systemic_infection_matrix(:,1) = [state(1).y]'	;
					systemic_infection_matrix(:,2) = [state(2).y]'	;
					systemic_infection_matrix(:,3) = [state(3).y]'	;

					systemic_infection_matrix = single(systemic_infection_matrix);
					infectivity_matrix(:,:) = systemic_infection_matrix*M + systemic_infection_matrix*C;
					infectivity_matrix(infectivity_matrix(:,:)<0) = 0;
					increase_infection_vector(:,1) = (interaction_grill * infectivity_matrix(:,1)) + (bustrofedon_grill*infectivity_matrix(:,1)*agricultor_mediated_spread);
					increase_infection_vector(:,2) = (interaction_grill * infectivity_matrix(:,2)) + (bustrofedon_grill*infectivity_matrix(:,2)*agricultor_mediated_spread);
					increase_infection_vector(:,3) = (interaction_grill * infectivity_matrix(:,3)) + (bustrofedon_grill*infectivity_matrix(:,3)*agricultor_mediated_spread);

					for individual = 1 : 1 : nsize  ^ 2
						% I am not allowing triple infections
						if all([state(1).A(individual), state(2).A(individual), state(3).A(individual)] == 1) == 1
							triple_infection_control = ((state(1).x(individual) + state(2).x(individual) + state(3).x(individual))<2);
							times_since_systemic =  [state(1).dpi(individual), state(2).dpi(individual), state(3).dpi(individual)] - latence_time;
							times_since_systemic(times_since_systemic < 0) = zeros(1, length(times_since_systemic(times_since_systemic < 0)));
							if any(times_since_systemic > 0)
								probability_senescene_event(1) = exp(k_param(1)*times_since_systemic(1) - A_param(1))/(1+(exp(k_param(1)*times_since_systemic(1) - A_param(1))));
								probability_senescene_event(2) = exp(k_param(2)*times_since_systemic(2) - A_param(2))/(1+(exp(k_param(2)*times_since_systemic(2) - A_param(2))));
								probability_senescene_event(3) = exp(k_param(3)*times_since_systemic(3) - A_param(3))/(1+(exp(k_param(3)*times_since_systemic(3) - A_param(3))));
							else
								probability_senescene_event(1) = 0;
								probability_senescene_event(2) = 0;
								probability_senescene_event(3) = 0;
							end
							rand_events = rand(1,3);
							alive_or_not = 1 - any(rand_events < probability_senescene_event);
							state(1).A(individual) = alive_or_not;
							state(2).A(individual) = alive_or_not;
							state(3).A(individual) = alive_or_not;

							state(1).x(individual) = state(1).x(individual) + (state(1).g(individual) * increase_infection_vector(individual,1)*triple_infection_control);
							state(2).x(individual) = state(2).x(individual) + (state(2).g(individual) * increase_infection_vector(individual,2)*triple_infection_control);
							state(3).x(individual) = state(3).x(individual) + (state(3).g(individual) * increase_infection_vector(individual,3)*triple_infection_control);
							state(1).omega(individual) = state(1).omega(individual) + systemic_infection_matrix(individual,1)*w1(1);
							state(2).omega(individual) = state(2).omega(individual) + systemic_infection_matrix(individual,2)*w1(2);
							state(3).omega(individual) = state(3).omega(individual) + systemic_infection_matrix(individual,3)*w1(3);


						else
							state(1).y(individual) = 0;
							state(2).y(individual) = 0;
							state(3).y(individual) = 0;

						end

					end


					[state(1).x([state(1).x(:)] < 1 )] = [state(1).A(state(1).x(:)<1)]'.*[state(1).g(state(1).x(:)<1)]'.*(rand(length(state(1).x([state(1).x(:)] < 1)),1) < [state(1).P([state(1).x(:)] < 1)]') + [state(1).x([state(1).x(:)] < 1 )]';
					[state(2).x([state(2).x(:)] < 1 )] = [state(2).A(state(2).x(:)<1)]'.*[state(2).g(state(2).x(:)<1)]'.*(rand(length(state(2).x([state(2).x(:)] < 1)),1) < [state(2).P([state(2).x(:)] < 1)]') + [state(2).x([state(2).x(:)] < 1 )]';
					[state(3).x([state(3).x(:)] < 1 )] = [state(3).A(state(3).x(:)<1)]'.*[state(3).g(state(3).x(:)<1)]'.*(rand(length(state(3).x([state(3).x(:)] < 1)),1) < [state(3).P([state(3).x(:)] < 1)]') + [state(3).x([state(3).x(:)] < 1 )]';


					[state(1).x([state(1).x(:)] > 1)] = 1;
					[state(2).x([state(2).x(:)] > 1)] = 1;
					[state(3).x([state(3).x(:)] > 1)] = 1;



					picture_systemic(:,:, 1,(((cycle-1)*harvest)+day)) = reshape([state(1).y], nsize, nsize);
					picture_systemic(:,:, 2,(((cycle-1)*harvest)+day)) = reshape([state(2).y], nsize, nsize);
					picture_systemic(:,:, 3,(((cycle-1)*harvest)+day)) = reshape([state(3).y], nsize, nsize);

					picture_primary_inoc(:,:,1,(((cycle-1)*harvest)+day)) = reshape([state(1).omega], nsize, nsize);
					picture_primary_inoc(:,:,2,(((cycle-1)*harvest)+day)) = reshape([state(2).omega], nsize, nsize);
					picture_primary_inoc(:,:,3,(((cycle-1)*harvest)+day)) = reshape([state(3).omega], nsize, nsize);


					[state(1).P(:)] = zeros(nsize ^2,1);
					[state(2).P(:)] = zeros(nsize ^2,1);
					[state(3).P(:)] = zeros(nsize ^2,1);
					for pathotype = 1 : 1 : 3

						if sum(sum(picture_systemic(:,:,pathotype, (((cycle-1)*harvest)+day)))) >= 1
							focus_list = [];

							infected_list = find(picture_systemic(:,:,pathotype, (((cycle-1)*harvest)+day)));
							sample_size	  = floor(length(infected_list)/5) + 1;

							% for iter = 1 : 1 : 10
							% 	dataset = datasample(infected_list, sample_size);
							% 	f0 = datasample(dataset, 1);
							% 	y1 = floor(f0/nsize) - (mod(f0, nsize) == 0) + 1;
							% 	x1 = f0 - ((y1-1)*nsize);
							%
							% 	q1 = 0;
							% 	for element_iter = 1 : 1 : length(dataset)
							% 		val = dataset(element_iter);
							% 		posy=floor(val/nsize) - (mod(val,nsize) == 0) + 1;
							% 		posx = val - (posy - 1) * nsize ;
							% 		dist = ((posy - y1) ^2) + ((posx - x1)^2);
							% 		q1 = q1 + dist;
							% 	end
							% 	energy_inc = -q1;
							% 	x0 = x1;
							% 	y0 = y1;
							% 	while energy_inc < 0
							% 		x0 = x1 ;
							% 		y0 = y1 ;
							% 		q0 = q1 ;
							% 		q1 = 0  ;
							% 		average_vector_x = 0;
							% 		average_vector_y = 0;
							% 		dataset = datasample(infected_list, sample_size);
							% 		for element_iter = 1 : 1 : length(dataset)
							% 			val = dataset(element_iter);
							% 			posy=floor(val/nsize) - (mod(val,nsize) == 0) + 1;
							% 			posx = val - (posy - 1) * nsize ;
							% 			average_vector_y = (posy - y0) + average_vector_y;
							% 			average_vector_x = (posx - x0) + average_vector_x;
							% 		end
							% 		x1 = (1/length(dataset))*average_vector_x + x0;
							% 		y1 = (1/length(dataset))*average_vector_y + y0;
							% 		for element_iter = 1 : 1 : length(dataset)
							% 			val = dataset(element_iter);
							% 			posy = floor(val/nsize) - (mod(val,nsize) == 0) + 1;
							% 			posx = val - (posy - 1) * nsize;
							% 			dist = ((posy - y1)^2) + ((posx - x1)^2);
							% 			q1 = q1 + dist;
							% 		end
							% 		energy_inc = q1 - q0;
							% 	end
							% 	focus_list(iter,:) = [y0, x0];
							% 	for individuals = 1 : 1 : nsize ^2
							% 		individual_y = (floor(individuals/nsize)) - (mod(individuals,nsize) == 0) + 1;
							% 		individual_x = (individuals -((individual_y-1)*nsize));
							% 		dist = sqrt(((individual_x-x0)^2) + ((individual_y-y0)^2));
							% 		prob_increase = (sample_size/5e5)*exp(-0.05*log(sample_size)*dist);
							% 		state(pathotype).P(individuals) = state(pathotype).P(individuals) + prob_increase;
							% 	end
							% end



							for sampler = 1 : 1 : sample_size
								s_1 = datasample (infected_list, 1);
								steps = 0;
								door_open = true;


								while door_open == true;

									steps = steps + 1 ;

									s_0 = s_1 ;
									s_y = floor(s_0/nsize) - (mod(s_0, nsize) == 0) + 1 ;
									s_x = s_0 - ((s_y -1) * nsize)	;

									s_up	= ((s_x - 1) * ((s_x -1) > 0)) + (s_x * (s_x -1 <= 0))		;
									s_down	= ((s_x + 1) * ((s_x +1) <= nsize)) + ((s_x)*(s_x +1 > nsize))	;
									s_left	= ((s_y - 1) * ((s_y - 1) > 0)) + (s_y * (s_y - 1 <= 0)) 		;
									s_right = ((s_y + 1) * ((s_y + 1) <= nsize)) + ((s_y)*(s_y+1 > nsize));

									s_up_border = (s_up - focus_radius)*(s_up - focus_radius > 0) + (s_up - focus_radius <= 0);
									s_left_border = (s_left - focus_radius)*(s_left - focus_radius > 0) + (s_left - focus_radius <= 0);
									s_down_border = (s_down + focus_radius)*(s_down + focus_radius <= nsize) + (s_down + focus_radius > nsize)*nsize;
									s_right_border = (s_right + focus_radius)*(s_right + focus_radius <= nsize) + (s_right + focus_radius > nsize)*nsize;


									density = [];
									density(1) = sum(sum(picture_systemic(s_up_border:s_up, :, pathotype, (((cycle-1)*harvest)+day))));
									density(2) = sum(sum(picture_systemic(s_down:s_down_border,pathotype, (((cycle-1)*harvest)+day))));
									density(3) = sum(sum(picture_systemic(:, s_left_border:s_left, pathotype, (((cycle-1)*harvest)+day))));
									density(4) = sum(sum(picture_systemic(:, s_right:s_right_border,pathotype, (((cycle-1)*harvest)+day))));

									if all(density(1:2)>0)

										relative_cocient_up		= ((density(1)^2)/((density(2)^2)+(density(1)^2))) ;
										relative_cocient_down	= ((density(2)^2)/((density(2)^2)+(density(1)^2))) ;
									else
										relative_cocient_up		= 0;
										relative_cocient_down	= 0;
									end
									if all(density(3:4)>0)
										relative_cocient_left	= ((density(3)^2)/((density(3)^2)+(density(4)^2))) * (sum(density(3:4))>0);
										relative_cocient_right	= ((density(4)^2)/((density(3)^2)+(density(4)^2))) * (sum(density(3:4))>0);
									else
										relative_cocient_right	= 0;
										relative_cocient_left	= 0;
									end

									s_mv(1) = ((-1)*(rand(1) < relative_cocient_up)) + (rand(1) < relative_cocient_down);
									s_mv(2) = ((-1)*(rand(1) < relative_cocient_left)) + (rand(1) < relative_cocient_right);

									s_1 = (((s_y + s_mv(1) * (s_y + s_mv(1) > 0) * (s_y + s_mv(1) <= nsize))-1) * nsize);
									s_1 = s_1 + ((s_x + s_mv(2)) * (s_x + s_mv(2) > 0) * (s_x + s_mv(2) <= nsize)) ;

									if s_0 == s_1

										probability_walk_ending = (exp(betha0 + (betha1*steps))) / (1+(exp(betha0 + (betha1*steps))));
										door_open = (rand(1) > probability_walk_ending);

									end
								end
								focus = s_1;
								focus_x = s_x;
								focus_y = s_y;

								focus_list(sampler, 1:2, (((cycle-1)*harvest)+day)) = [focus, steps];
								for individuals = 1 : 1 : nsize ^2
									individual_y = (floor(individuals/nsize)) - (mod(individuals,nsize) == 0) + 1;
									individual_x = (individuals -((individual_y-1)*nsize));
									dist = sqrt(0.5*((individual_y -focus_y)^2) + ((individual_x - focus_x) ^2));
									state(pathotype).P(individuals) = (1/sample_size) * (steps/1e5) * (exp(-0.05*log(steps)*dist)) + state(pathotype).P(individuals);
								end
							end
						end
					end


					hist_infection(((cycle-1)*harvest)+day,1) = sum([state(1).x(:)]);
					hist_infection(((cycle-1)*harvest)+day,2) = sum([state(2).x(:)]);
					hist_infection(((cycle-1)*harvest)+day,3) = sum([state(3).x(:)]);
					hist_infection(((cycle-1)*harvest)+day,4) = sum([state(1).y(:)]);
					hist_infection(((cycle-1)*harvest)+day,5) = sum([state(2).y(:)]);
					hist_infection(((cycle-1)*harvest)+day,6) = sum([state(3).y(:)]);
					if verbose == true
						addpoints(realtimeplot, (((cycle-1)*harvest)+day), sum([[state(1).y], [state(2).y], [state(3).y]])/3);
						drawnow;
					end
					max_value	 = max([[state(1).P], [state(2).P], [state(3).P]]);
					density_picture(:,:,1, ((cycle-1)*harvest)+day) = (reshape([state(1).P(:)], [nsize, nsize])) / max_value;
					density_picture(:,:,2, ((cycle-1)*harvest)+day) = (reshape([state(2).P(:)], [nsize, nsize])) / max_value ;
					density_picture(:,:,3, ((cycle-1)*harvest)+day) = (reshape([state(3).P(:)], [nsize, nsize])) / max_value ;
					senescence_picture(:,:,((cycle-1)*harvest)+day) = (reshape([state(1).A(:)], [nsize, nsize]));

				end
				hist_dammage(cycle) = 0 ;

				for iy = 0 : 1 : nsize - 1
					for ix = 1 : 1 : nsize
						%harvest
						vir_factor  = FRC.*systemic_infection_matrix(((iy*nsize)+ix), :)	;
						hist_dammage(cycle) = hist_dammage(cycle) + (1 + min(vir_factor))*state(1).A((iy*nsize)+ix)	;
						%seeding

						genotype_selector = genotypes(ix, iy+1, cycle);
						state(1).y((iy * nsize)+ix) = 0		;
						state(2).y((iy * nsize)+ix) = 0		;
						state(3).y((iy * nsize)+ix) = 0		;
						state(1).dpi((iy * nsize)+ix) = 0	;
						state(2).dpi((iy * nsize)+ix) = 0	;
						state(3).dpi((iy * nsize)+ix) = 0	;
						state(1).g((iy * nsize)+ix) = pathotype_restriction_matrix(1,genotype_selector);
						state(2).g((iy * nsize)+ix) = pathotype_restriction_matrix(2,genotype_selector);
						state(3).g((iy * nsize)+ix) = pathotype_restriction_matrix(3,genotype_selector);
						state(1).x((iy * nsize)+ix) = (rand(1) < (state(1).omega((iy*nsize)+ix)*(5e-8)))*state(1).g((iy*nsize)+ix);
						state(2).x((iy * nsize)+ix) = (rand(1) < (state(2).omega((iy*nsize)+ix)*(5e-8)))*state(2).g((iy*nsize)+ix);
						state(3).x((iy * nsize)+ix) = (rand(1) < (state(3).omega((iy*nsize)+ix)*(5e-8)))*state(3).g((iy*nsize)+ix);
						state(1).P((iy * nsize)+ix) = 0		;
						state(2).P((iy * nsize)+ix) = 0		;
						state(3).P((iy * nsize)+ix) = 0		;
						state(1).A((iy * nsize)+ix) = 1		;
						state(2).A((iy * nsize)+ix) = 1		;
						state(3).A((iy * nsize)+ix) = 1		;
						state(1).omega((iy * nsize)+ix) = 0	;
						state(2).omega((iy * nsize)+ix) = 0	;
						state(3).omega((iy * nsize)+ix) = 0	;
					end
				end
			end
			report.hist_infection = hist_infection;
			report.pathotype_composition = int8([[state(1).g(:)] [state(2).g(:)] [state(3).g(:)]]);
			report.picture = picture_systemic;
			report.density_picture = density_picture;
			report.focus_list = focus_list;
			report.senescence_picture = senescence_picture;
			report.hist_dammage = hist_dammage;
			report.picture_primary_inoc = int16(picture_primary_inoc);

		end
	else
		disp('Error: One of the parameters is not numeric')
	end
