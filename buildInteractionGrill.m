function final_grill = builtInteractionGrill(nsize, localMatrix)
	% Function buildInteractionGrill
	% By Bruno Cuevas, 2016
	% Usage:
	%	M = buildInteractionGrill(n, L) ; Creates a n^2xn^2 interaction
	%			grill using L as local interaction source.
	%	L must be an square and odd-range matrix.
	% FAQ : brunocuevaszuviria@gmail.com
	%
	%
	if isnumeric(nsize) == true && isnumeric(localMatrix) == true

			disp(['checking requistes to built matrix, dimensions ', num2str(nsize), ' x ', num2str(nsize)]);

			final_grill = [];

			localMatrix_x_size = length(localMatrix(:,1));
			localMatrix_y_size = length(localMatrix(1,:));

			if localMatrix_y_size == localMatrix_x_size
				disp (['    square matrix requisite, reached']);
				if mod(localMatrix_y_size,2) == 1
					disp (['    odd size requisite, reached']);
					localMatrix_x_center = floor(localMatrix_x_size/2) + 1;
					localMatrix_y_center = floor(localMatrix_y_size/2) + 1;
					localMatrix_x_tour = floor(localMatrix_y_size/2)	;
					localMatrix_y_tour = floor(localMatrix_y_size/2)	;
					% igc will mean 'iterator grill columns'
					igc_y = 0;
					for igc = 1 : 1 : nsize ^ 2
						igc_y = (mod(igc,nsize) == 1) + igc_y;
						igc_x = igc - ((igc_y - 1)*nsize)	;
						temp_vector = zeros(nsize ^ 2 ,1)	;
						for iy = -localMatrix_y_tour : 1: localMatrix_y_tour
							for ix = -localMatrix_x_tour : 1 :localMatrix_x_tour
								if (igc_y + iy > 0 && igc_y + iy <= nsize) && (igc_x + ix > 0 && igc_x + ix <= nsize)
									pos_y = (igc_y + iy - 1);
									pos_x = (igc_x + ix)	;
									temp_vector((pos_y*nsize) + pos_x) = localMatrix(localMatrix_x_center + ix,localMatrix_y_center + iy);
								end
							end
							final_grill(:,igc) = temp_vector;
						end
					end

				else
					disp (['    not an odd size']);
				end
			else
				disp (['    not a square matrix']);
			end

	else
		disp('Error: Not a numeric value in one of the parameters');
	end
