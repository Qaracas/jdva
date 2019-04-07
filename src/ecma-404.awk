function _perror(txt)
{
    printf ("%s\n", txt) > "/dev/stderr";
    exit -1;
}

##
#
# Elimina blancos y tabuladores al inicio y fin de una cadena.
#
# Argumentos:
#   - str = Puntero a cadena.
#   - idx = (Opcional) Elemento de la cadena.
#
##
function _trim(str, idx)
{
    return gsub(/^([ \t]+|\042{1})|([ \t]+|\042{1})$/, "", str[idx]);
}

##
#
# Transforma puntero a cadena JSON en una lista de elementos separados por
# comas. Si es objeto, elimina llave al inicio y fin de la cadena. Si es
# colección, elimina corchetes al inicio y fin de la cadena.
#
# Argumentos:
#   -json = Puntero a cadena JSON.
##
function _json_a_lst_elmtos(json)
{
    return gsub(/(^[ \t]*[\{\[]{1}|[\}\]]{1}[ \t]*$)/, "", json[0]);
}

function _esjson(txt)
{
    if (txt ~/^[ \t]*[\{\[]{1}.*[\}\]]{1}[ \t]*$/)
        return 1;
    return 0;
}

function _id(c, id)
{
    if (length(id))
        return id SUBSEP c;
    else
        return c;
}

function _p2pnts(txt,      a, c, i)
{
    i = 0;
    
    while ((c = substr(txt[0], i++, 1)) != "") {
        if (c == ":" && a == "\042")
            break;
        if (c !~ /[ \t]/)
            a = c;
    }
    return i;
}

function _nuevo(lista, elem, valor, pos,      n, a)
{
    # Si es un par "nombre : valor" modificar valor y pos
    if (valor[0] ~ /[ \t]*\042[^\042]+\042[ \t]*:.+/) {
        _trim(valor, 0);       
        pos = substr(valor[0], 1, _p2pnts(valor) - 2);
        valor[0] = substr(valor[0], _p2pnts(valor),
                          (length(valor[0]) - _p2pnts(valor)) + 1);
        gsub(/\042/, "", pos); _trim(valor, 0);
    }
    
    n = _id(pos, elem);
    _trim(valor, 0);
    lista[n] = valor[0];
    _trim(lista, n);
    return n;
}

##
#
# Trasformar JSON en lista multidimensional
#
# Argumentos:
#   - json = Puntero a cadena JSON.
#   - lst  = Colección con los elementos de la cadena JSON original.
#
##
function jsonLstm(json, lst, id,      a, x, c, i, j, n)
{
    if (!isarray(json)) {
        _perror("El primer argumento debe ser un puntero");
    }
        
    c = ""; a = 1; i = 1; j = 1;
    x["{"] = 0; x["}"] = 0; x["["] = 0; x["]"] = 0;
    x["\042"] = 0; x["sal"] = 0;

    _json_a_lst_elmtos(json);
    
    for (;;) {
		if ((c = substr(json[0], i++, 1)) == "") {
		    if (x["sal"] >= 1)
                break;
            else {
                x["sal"]++;
                c = ",";
            }
		}
        switch (c) {
        case "{":
            x["{"]++;
            break;
        case "}":
            x["}"]++;
            break;
        case "[":
            x["["]++;
            break;
        case "]":
            x["]"]++;
            break;
        case "\042":
            x["\042"]++;
            break;
        case ",":
            if ((x["\042"] % 2 == 0) &&
                (x["{"] == x["}"]) && (x["["] == x["]"]))
            {
                x[0] = substr(json[0], a, (i - a - 1));
                if (_esjson(x[0]))
                    jsonLstm(x, lst, _id(j++, id));
                else {
                    n = _nuevo(lst, id, x, j++);
                    if (n != _id((j - 1), id) &&
                        _esjson(lst[n]))
                    {
                        x[0] = lst[n];
                        delete lst[n];
                        jsonLstm(x, lst, n);
                    }
                }
                a = i;
            }
            break;
        default:
            break;
        }
    }
}

function _nvp_json(nivel, subidc,      i, j)
{
    json = "";

    if (nivel[1] == nivel[0])
        if (subidc[1][nivel[1]] !~ /^[0-9]+$/)
            json = "\042" subidc[1][nivel[1]] "\042:";
    
    if (nivel[1] > nivel[0])
        for (i in subidc[1])
            if (i >= nivel[0])
                if (subidc[1][i] !~ /^[0-9]+$/)
                    json = json "" \
                        ((i > nivel[0]) ? "{" : "") \
                        "\042" subidc[1][i] "\042:";
                else
                    json = json "" ((i > nivel[0]) ? "[" : "");
    
    if (nivel[1] < nivel[0]) {
        for (j = nivel[0]; j > nivel[1]; j--)
            json = json "" ((subidc[0][j] !~ /^[0-9]+$/) ? "}" : "]");
        if (subidc[1][nivel[1]] !~ /^[0-9]+$/)
            json = json "\042" subidc[1][nivel[1]] "\042:";
    }
        
    return json;
}

function lstmJson(lst, json,      i, j, s, n, p)
{
    delete json;
    json[0] = "";
    n[0] = 0; n[1] = 0;         # Nivel anterior y nivel actual
    s[0][1] = ""; s[1][1] = ""; # Subíndice anterior y subíndice actual

    PROCINFO["sorted_in"] = "@ind_num_asc";
    for (i in lst) {
        n[1] = split(i, s[1], SUBSEP);
        p = _nvp_json(n, s);
        if (p ~ /[\]\}]+$/) {
            gsub(/,$/,"", json[0]);
            json[0] = json[0] p ",";
        } else {
            json[0] = json[0] p;
        }
        json[0] = json[0] "\042" lst[i] "\042" ",";
        n[0] = n[1];
        delete s[0];
        for (j in s[1])
            s[0][j] = s[1][j];
    } 
}

function pinta_elmtos(lista,      i, j, s, d)
{
    PROCINFO["sorted_in"] = "@ind_num_asc";
    for (i in lista) {
        split(i, s, SUBSEP);
        d = "";
        for (j in s)
            d = d "[" s[j] "]";
        printf("%s = %s\n", d, lista[i]);
    }
}
