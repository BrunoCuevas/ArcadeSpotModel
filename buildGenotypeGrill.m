function genotypegrill = buildGenotypeGrill(argument, size)
	% Function buildGenotypeGrill
	% By Bruno Cuevas, 2016
	% Usage:
	%	G = buildInteractionGrill('argument', 'size' ) ; Creates a different
	%	type of grill for each argument.
	%
	% FAQ : brunocuevaszuviria@gmail.com
	%
	%
	known_patterns = {'random', 'clustered', 'regular'};
	if isnumeric(size) && ischar(argument)
		if any(strcmp(argument,known_patterns) == 1)
			if strcmp(argument, 'random')
				disp('Creating a random genotype grill')
				grill = [];
				genotype_choicer = [0.60 0.85 0.95 1]
				for individual = 1 : 1 : size^2
					genotype_lotery = rand(1);
					genotype_evaluator = 1 ;
					while genotype_choicer(genotype_evaluator) < genotype_lotery
						genotype_evaluator = genotype_evaluator + 1;
					end
					grill(individual) = genotype_evaluator;
				end
				disp('Grill built!');
				genotypegrill = reshape(grill, [size, size]);
				genotypegrill = int8(genotypegrill);
			end
			if strcmp(argument, 'regular')
				disp('Creating a regular genotype grill')
				grill = [];
				genotype_choicer = [6, 2, 1, 1];
				current_genotype = 1;
				counter = 0;
				for individual = 1 : 1 : size ^2
					counter = counter + 1;
					if genotype_choicer(current_genotype) == counter
						if current_genotype == 4
							current_genotype = 1;
							counter = 0;
						else
							current_genotype = current_genotype + 1;
							counter = 0;
						end
					end
					
					grill(individual) = current_genotype;
				end
				genotypegrill = reshape(grill, [size, size]);
				genotypegrill = int8(genotypegrill);
			end

		else
			warning('Not a valid argument!');
			return
		end

	end
