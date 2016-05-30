function average_values = processSimulation3 (name, number)
	m1 = [];
	m2 = [];
	m3 = [];
	xx = [];
	for iter = 1 :1: number
		temp = load([name, '_', num2str(iter)]);
		temp = temp.report_library;
		v1 = [];
		v2 = [];
		v3 = [];
		for iter2 = 1 : 1 :  length(temp)
			v1(iter2) = temp(iter2).hist_infection(150,1);
			v2(iter2) = temp(iter2).hist_infection(150,2);
			v3(iter2) = temp(iter2).hist_infection(150,3);
			x = temp(iter2).genotypes;
			x = sum(sum(x == 1));
		end
		m1(iter) = mean(v1);
		m2(iter) = mean(v2);
		m3(iter) = mean(v3);
		xx(iter) = x;
	end
	average_values = [ xx', m1', m2', m3'];
