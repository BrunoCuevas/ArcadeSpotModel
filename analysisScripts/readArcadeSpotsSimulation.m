function matrix = readArcadeSpotsSimulation(name, number, pathotype);
	% Function sim_ensambler
	% By Bruno Cuevas, 2016
	% Usage:
	%	C = sim_ensambler ('name', number, pathotype) ;
	%	Reads a set of matlab data files where a variable stored
	%	is a vector of simulation reports; it takes the infection
	%	and the surface values from a pathotype.
	% FAQ : brunocuevaszuviria@gmail.com
	hist_area = [];
	hist_infection = [];
	for iter_major = 1 : 1 : number
		current_name = [name, '_', num2str(iter_major),'.mat'];
		current_library = load(current_name);
		current_library = current_library.report_library;
		length_current_library = length(current_library);
		for iter_menor =  1 : 1 : length_current_library
			current_column = ((iter_major-1)*length_current_library) + iter_menor ;
			hist_area(:,current_column) = current_library(iter_menor).hist_infection(:,pathotype + 3);
			hist_infection(:,current_column) = current_library(iter_menor).hist_infection(:,pathotype);
		end
	end
	matrix.hist_area = hist_area;
	matrix.hist_infection = hist_infection;
	return
