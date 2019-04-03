BEGIN {
	cad_json = "";
	linea = "";
	
	while ((getline linea < ARGV[1]) > 0)
		cad_json = cad_json linea;
	close(ARGV[1]);
	
	elementos(cad_json, lista);
	
	for (i in lista)
		print lista[i];
	
	a = index(lista[5], ":");
	elementos(substr(lista[5], a + 1, length(lista[5]) - a - 1), lista);

	for (i in lista)
		print lista[i];
}

function elementos(json, lst,    a, x, c, i, j) {
	delete lst;
	c = "";
	x["{"] = 0; x["}"] = 0;
	x["["] = 0; x["]"] = 0;
	x["\""] = 0;
	a = 1; i = 1; j = 1;
	
	while ((c = substr(json, i++, 1)) != "") {
		switch (c) {
		case "{":
		    if (i > 2) x["{"]++;
			break;
		case "}":
			x["}"]++;
			break;
		case "[":
			if (i > 2) x["["]++;
			break;
		case "]":
			x["]"]++;
			break;
		case "\"":
			x["\""]++;
			break;
		case ",":
		    if ((x["\""] % 2 == 0) &&
				(x["{"] == x["}"]) &&
				(x["["] == x["]"])) {
				lst[j++] = substr(json, a, (i - a - 1));
				a = i;
			}
			break;
		default:
			break;
		}
	}
	lst[j] = substr(json, a, (i - a - 1));
}