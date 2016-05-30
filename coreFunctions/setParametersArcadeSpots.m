function parameters = setParametersArcadeSpots()
	% function setParametersArcadeSpots
	% By Bruno Cuevas, 2016
	% Usage
	%		parameters = setParametersArcadeSpots ;
	%
	%		It gives some default parameters to run simulations.
	% For additional information, read documentation
	% FAQ : brunocuevaszuviria@gmail.com
	addpath(genpath('~/Dropbox/TFG/ArcadeSpots'));
	parameters.H  = 180 	;
	parameters.C  = 1	;
	parameters.N  = 50	;
	parameters.BF = buildBustrofedonGrill(50, 0.75);
	parameters.B  = buildExponentialInteractionGrill(1.25, 2, 50);
	parameters.BL = buildExponentialInteractionGrill(0.1, 2, 50);
	parameters.Pi = 10  ;
	parameters.G  = buildGenotypeGrill('random', 50, [1,0,0]);
	parameters.L  = [35,95,55];
	parameters.S  = [floor(rand(1)*2500)+1, floor(rand(1)*2500)+1, floor(rand(1)*2500)+1];
