function interaction_grill = buildInteractionBoundaryFreeMatrix (constant, layer, nsize, assimetry)
	%
	%
	%
	%
	%
	%
	if isnumeric([constant, layer, nsize]) == 1

		disp('Starting building process')

		interaction_grill		= [];

		for central_individual = 1 : 1 : nsize ^2

			central_pos_y = floor(central_individual/nsize) - (mod(central_individual, nsize) == 0) + 1;
			central_pos_x = central_individual - (central_pos_y - 1)*nsize;
			local_interaction_vector = [];
			for other_individual = 1 : 1 : nsize ^ 2
				pos_y = floor(other_individual/nsize) - (mod(other_individual, nsize) == 0) + 1 ;
				pos_x = other_individual - (pos_y -1)*nsize;
				distance = assimetry * ((pos_y - central_pos_y) ^2) + ((pos_x - central_pos_x)^2);
				local_interaction_vector(other_individual) = exp(-constant * sqrt(distance));
			end
			if central_pos_x - layer < 1

				for inc_pos_x = 1 : 1 : layer - central_pos_x + 1
					for pos_y = 1 : 1 : nsize
						pos_x = central_pos_x - inc_pos_x;
						%pos_y = central_pos_y;
						distance = assimetry * ((pos_y - central_pos_y) ^2) + ((pos_x - central_pos_x)^2);
						mirrored_position = ((pos_y-1)*nsize) + (nsize - inc_pos_x + 1);
						local_interaction_vector(mirrored_position) = exp(-constant*sqrt(distance)); %+ local_interaction_vector(mirrored_position);
					end
				end
			end
			if central_pos_y - layer < 1
				for inc_pos_y = 1: 1 : layer - central_pos_y + 1
					for pos_x = 1 : 1 : nsize
						%pos_x = central_pos_x;
						pos_y = central_pos_y - inc_pos_y;
						distance = assimetry * ((pos_y - central_pos_y) ^2) + ((pos_x - central_pos_x)^2);
						mirrored_position = ((nsize - inc_pos_y )*nsize) + (pos_x);
						local_interaction_vector(mirrored_position) = exp(-constant*sqrt(distance));% + local_interaction_vector(mirrored_position);
					end
				end
			end
			if central_pos_x + layer > nsize
				for inc_pos_x = 1 : 1 : layer - (nsize - central_pos_x)
					for pos_y = 1 : 1 : nsize
						pos_x = central_pos_x + inc_pos_x ;
						%pos_y = central_pos_y;
						distance = assimetry * ((pos_y - central_pos_y) ^2) + ((pos_x - central_pos_x)^2);
						mirrored_position = ((pos_y-1)*nsize) + (inc_pos_x);
						local_interaction_vector(mirrored_position) = exp(-constant*sqrt(distance));% + local_interaction_vector(mirrored_position);
					end
				end
			end
			if central_pos_y + layer > nsize
				for inc_pos_y = 1 : 1 : layer - (nsize - central_pos_y)
					for pos_x = 1 : 1 : nsize
						%pos_x = central_pos_x;
						pos_y = central_pos_y + inc_pos_y;
						distance = assimetry * ((pos_y - central_pos_y) ^2) + ((pos_x - central_pos_x)^2);
						mirrored_position = ((inc_pos_y-1)*nsize) + (pos_x);

						local_interaction_vector(mirrored_position) = exp(-constant*sqrt(distance));% + local_interaction_vector(mirrored_position);
					end
				end
			end
			interaction_grill(:,central_individual) = local_interaction_vector';
		end
		grill = single(interaction_grill);
	end
