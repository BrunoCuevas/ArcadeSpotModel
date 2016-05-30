function bustrofedon_grill = buildBustrofedonGrill(nsize, constant);
	% Function buildBustrofedonGrill
	% By Bruno Cuevas, 2016
	% Usage:
	%	M = buildBustrofedonGrill(n, BC) ; Creates a n^2xn^2 interaction
	%			grill using a bustrofedon pattern and an exponential
	%			function in relation to distance.
	%	n and BC must be numerical values
	% FAQ : brunocuevaszuviria@gmail.com
	%
	%
	grill = zeros(nsize, nsize);
	for iy = 1 : 1 : nsize
		for ix = 1 : 1 : nsize
			grill(ix,iy) = ((iy-1)*nsize) + ix;
		end
	end
	bustrofedon_grill = zeros(nsize^2, nsize^2);
	majorsense = 1;
	for iter_a = 1 : 1 : nsize ^ 2
		vector = zeros(nsize^2,1);
		vector(1) = iter_a;
		start_pos = find(grill==iter_a);
		start_y   = floor(start_pos/nsize) - (mod(start_pos, nsize) == 0) + 1;
		start_x   = start_pos - (start_y - 1) * nsize;
		column	  = start_y;
		row 	  = start_x;
		sense	  = (-1) ^ (-(mod(column, 2)==0));
		iter	  = 1;
		door_open = 1;
		while door_open == 1
			iter = iter + 1;
			if start_x + sense > nsize || start_x + sense <= 0
				if start_y < nsize
					shift_move_right = 1;
					shift_move_up	 = 0;
					sense = -sense;
				else
					break
				end
			else
				shift_move_right = 0;
				shift_move_up	= 1;
			end
			start_x = start_x + sense * shift_move_up;
			start_y = start_y + shift_move_right;

			vector(iter) = grill(start_x , start_y );

			if (start_x + (nsize*(start_y-1))) == nsize^2
				door_open = 0;
			end

		end
		%disp([' VECTOR FOR ', num2str(iter_a), ' | ', num2str(vector')]);
		dist = 0;
		for iter = 1 : 1 : length(vector)
			if not(vector(iter) == 0)
				dist = dist + 1;
				bustrofedon_grill(vector(iter),iter_a) = exp(-constant*dist);
			end
		end
		bustrofedon_grill = single(bustrofedon_grill);
	end
