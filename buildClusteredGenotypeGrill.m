function grill = buildClusteredGenotypeGrill(growdirections, nsize)
	genotypes = [1, 2, 3, 4];
	grill = 4*ones(nsize, nsize);
	random_matrix_value = rand(nsize, nsize);

	grill(random_matrix_value(:,:) < 1) = 3;
	grill(random_matrix_value(:,:) < 0.86) = 2;
	grill(random_matrix_value(:,:) < 0.75) = 1;
	grill(random_matrix_value(:,:) < 0.5) = 4;
	new_cells = find(grill);
	new_cells = new_cells(randperm(length(new_cells)));
	old_cells = [];
	counter = 1;
	while (length(new_cells) > 0)
		%
		%
		%
		counter = counter +1;
		for cell_iter_counter = 1 : 1 : length(new_cells)
			cell_iter = new_cells(cell_iter_counter);

			central_y = floor(cell_iter/nsize) - (mod(cell_iter,nsize) == 0) + 1;
			central_x = cell_iter - ((central_y -1)*nsize);
			genotype = grill(central_x,central_y);
			for growdirections_iter = 1 : 1 : growdirections
				random_direction = [];
				random_direction(1) = (-1) ^ (rand(1) > 0.5);
				random_direction(2) = (-1) ^ (rand(1) > 0.5);
				matrix_coordinates = [];
				matrix_coordinates(1) = (central_y + random_direction(1))*((central_y + random_direction(1)) > 0)*((central_y + random_direction(1)) <= nsize);
				matrix_coordinates(1) = matrix_coordinates(1) + (central_y + random_direction(1) <= 0) + nsize*(central_y + random_direction(1) > nsize);
				matrix_coordinates(2) = (central_x + random_direction(2))*((central_x + random_direction(2)) > 0)*((central_x + random_direction(2)) <= nsize);
				matrix_coordinates(2) = matrix_coordinates(2) + (central_x + random_direction(2) <= 0) + nsize*(central_x + random_direction(2) > nsize);

				grill(matrix_coordinates(2), matrix_coordinates(1)) = genotype;
			end
		end


		old_cells = union(new_cells, old_cells);
		new_cells = setxor(find(grill), old_cells);
		new_cells = new_cells(randperm(length(new_cells)));
		disp(['growth = ', num2str(length(new_cells))]);
	end
	%grill(grill(:,:)==0) = 4;
