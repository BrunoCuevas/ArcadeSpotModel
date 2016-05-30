function genotypegrill = buildGenotypeGrill(argument, size, genotype_freqs)
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
				grill = [];
				genotype_choicer = [] ;
				genotype_choicer(1) = genotype_freqs(1);
				genotype_choicer(2) = genotype_freqs(2) + genotype_choicer(1);
				genotype_choicer(3) = genotype_freqs(3) + genotype_choicer(2);
				genotype_choicer(4) = 1 ;

				for individual = 1 : 1 : size^2
					genotype_lotery = rand(1);
					genotype_evaluator = 1 ;
					while genotype_choicer(genotype_evaluator) < genotype_lotery
						genotype_evaluator = genotype_evaluator + 1;
					end
					grill(individual) = genotype_evaluator;
				end
				genotypegrill = reshape(grill, [size, size]);
				genotypegrill = int8(genotypegrill);
			end
			if strcmp(argument, 'regular')
				grill = [];
				genotype_choicer = [] ;
				genotype_choicer(1) = genotype_freqs(1);
				genotype_choicer(2) = genotype_freqs(2);
				genotype_choicer(3) = genotype_freqs(3);
				genotype_choicer(4) = 1 - sum(genotype_choicer);
				genotype_choicer = floor(genotype_choicer*10);
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
