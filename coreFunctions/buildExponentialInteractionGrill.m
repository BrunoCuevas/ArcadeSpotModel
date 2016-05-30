function grill =  buildExponentialInteractionGrill(constant, assimetry, size)
	% function simulateArcadeSpots
	% By Bruno Cuevas, 2016
	% Usage
	%		B = buildExponentialInteractionGrill(constant, assimetry, size) ;
	%			'constant' is the exponential curve value
	%			'assimetry' sets a level for differences between axis
	%			'size' sets a size for grill
	% For additional information, read documentation
	% FAQ : brunocuevaszuviria@gmail.com
	if isnumeric([constant, assimetry, size]) == 1
		


		interaction_grill		= [];

		for central_individual = 1 : 1 : size ^2

			central_pos_y = floor(central_individual/size) - (mod(central_individual, size) == 0) + 1;
			central_pos_x = central_individual - (central_pos_y - 1)*size;
			local_interaction_vector = [];
			for other_individual = 1 : 1 : size ^ 2
				pos_y = floor(other_individual/size) - (mod(other_individual, size) == 0) + 1 ;
				pos_x = other_individual - (pos_y -1)*size;
				distance = assimetry * ((pos_y - central_pos_y) ^2) + ((pos_x - central_pos_x)^2);
				local_interaction_vector(other_individual) = exp(-constant * sqrt(distance));
			end
			interaction_grill(:,central_individual) = local_interaction_vector';
		end
		grill = single(interaction_grill);
	end
