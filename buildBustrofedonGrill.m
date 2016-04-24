function BustrofedonGrill = buildBustrofedonGrill(nsize, constant);
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
	if isnumeric(nsize) && isnumeric(constant)
		disp(['building matrix, dimensions ', num2str(nsize), 'x', num2str(nsize)]);
		linearbustrofedon = [];
		for ix = 1 : 1 : nsize
			for iy = 1 : 1 : nsize
				ik = ((iy-1)*nsize) + ix ;
				if mod(iy,2) == 1
					relative_position = ((iy-1)*nsize) + ix ;
				else
					relative_position = (iy*nsize) - (ix -1);
				end
				linearbustrofedon(ik) = relative_position;
			end
		end
		BustrofedonGrill = zeros(nsize^2, nsize^2);
		for ix = 1 : 1 : length(linearbustrofedon);
			val = 0;
			for iy = ix : 1 : length(linearbustrofedon)
				val = val + 1;
				BustrofedonGrill(linearbustrofedon(iy), ix) = exp(-constant * val);
			end
		end

	else
		disp('ERROR. One of the constants was not numeric.')
	end
