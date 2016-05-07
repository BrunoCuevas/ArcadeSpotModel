function parameters = setParametersArcadeSpots()
	% function setParametersArcadeSpots
	% By Bruno Cuevas, 2016
	% Usage
	%		parameters = setParametersArcadeSpots ;
	%
	%		It gives some default parameters to run simulations.
	% For additional information, read documentation
	% FAQ : brunocuevaszuviria@gmail.com
	parameters.H  = 180 	;
	parameters.C  = 1	;
	parameters.N  = 50	;
	parameters.BF = buildBustrofedonGrill(50, 0.5);
	parameters.B  = buildExponentialInteractionGrill(0.5, 0.45, 50);
	parameters.Pi = 10  ;
	parameters.G  = buildGenotypeGrill('random', 50);
	parameters.L  = [10,15,23];
