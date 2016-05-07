function parametersbox = setParametersFromFile (filename)
	% Function setParametersFromFile
	% By Bruno Cuevas, 2016
	% Usage:
	%	M = setParametersFromFile (filename) ;
	%	Set the simulateArcadeSpots parameters from reading a file that
	%	contains the values that will be employed to create the environment
	% FAQ : brunocuevaszuviria@gmail.com
	%
	%
	if ischar(filename)
		disp(['Reading parameters from file : ', filename]);
		raw_parameters =readtable(filename, 'delimiter', 'comma');
		startparameters = table2struct(raw_parameters);
		for iter = 1 : 1 : length([startparameters.H])
			disp(['working  in ',startparameters(iter).name]);
			disp(['iter = ', num2str(iter)]);
			parameters.name = startparameters(iter).name;
			parameters.H = startparameters(iter).H;
			parameters.N = startparameters(iter).N;
			parameters.C = startparameters(iter).C;
			parameters.BF = buildBustrofedonGrill(parameters.N, startparameters(iter).BF);
			temp_vector  = [];
			temp_vector(1) = startparameters(iter).B;
			temp_vector(2) = startparameters(iter).assimetry;
			temp_vector(3) = startparameters(iter).N;
			parameters.B = buildExponentialInteractionGrill(temp_vector(1), temp_vector(2), temp_vector(3));
			parameters.Pi = startparameters(iter).periodicity;
			freqs = [];
			freqs(1) = startparameters.g1;
			freqs(2) = startparameters.g2;
			freqs(3) = startparameters.g3;
			for cycle_iter = 1 : 1 : parameters.C
				parameters.G(:,:,cycle_iter) = buildGenotypeGrill(startparameters(iter).genotype, startparameters(iter).N, freqs);
			end
			parameters.L = [startparameters(iter).l1, startparameters(iter).l2, startparameters(iter).l3];
			parameters.S = [startparameters(iter).s1, startparameters(iter).s2, startparameters(iter).s3];
			parametersbox(iter) = parameters;
		end
	end
