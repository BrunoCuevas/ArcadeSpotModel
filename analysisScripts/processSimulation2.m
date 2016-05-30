function results = processSimulation2(name, number, pathotype)
	% Function processSimulation2
	% By Bruno Cuevas, 2016
	% Usage:
	%	C = processSimulation2('name', number, pathotype) ;
	%	Reads the infection and areas vector of each simulation,
	%	and reports also the distance.
	% FAQ : brunocuevaszuviria@gmail.com
	hist_area = [];
	hist_infection = [];
	distance = [];
	for iter_major = 1 : 1 : number
		current_name = [name, '_', num2str(iter_major),'.mat'];
		current_library = load(current_name)				;
		current_library = current_library.report_library	;
		length_current_library = length(current_library)	;
		for iter_menor =  1 : 1 : length_current_library
			current_column = ((iter_major-1)*length_current_library) + iter_menor 	;
			hist_area(:,current_column) = current_library(iter_menor).hist_infection(:,pathotype + 3)	;
			hist_infection(:,current_column) = current_library(iter_menor).hist_infection(:,pathotype)	;
			position = current_library(iter_menor).seed;
			posy	= floor(position/50) - (mod(position,50) == 0) +1;
			posx 	= position - ((posy-1)*50);
			distance(current_column) = sqrt(((posy-25)^2) + ((posx-25)^2));
		end
	end
	results.hist_area = hist_area;
	results.hist_infection = hist_infection;
	results.distance = distance;
	return
