BEGIN {
    CNTSEC = 1;
}

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
    return gsub(/^[ \t]*(\042{1})*|(\042{1})*[ \t]*$/, "", str[idx]);
}

function __trim(str)
{
    gsub(/^[ \t]*(\042{1})*|(\042{1})*[ \t]*$/, "", str);
    return str;
}

##
#
# Transforma puntero a cadena JSON en una lista de elementos separados por
# comas. Si es objeto, elimina llave al inicio y fin de la cadena. Si es
# colección, elimina corchetes al inicio y fin de la cadena.
#
# Argumentos:
#   - json = Puntero a cadena JSON.
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

##
#
# Cada elemento de la lista es a su vez una lista de 3 elementos:
# lista[X][Y]; donde X es el índice JSON, e Y será:
# [1] = Es el valor del elemento JSON
# [2] = Es el tipo. Será "s" = es cadena; "n" = no es cadena
# [3] = 1    = elemento primero en lista u objeto
#       NULO = nada: elemento medio o final de lista u objeto
#
##
function _nuevo(lista, elem, valor, pos,      n, o, i)
{
    if (pos == 1) o = 1;
    # Si es un par "nombre : valor" modificar valor y pos
    if (valor[0] ~ /[ \t]*\042[^\042]+\042[ \t]*:.+/) {
        gsub(/\042[ \t]*:/, "\042:", valor[0]);
        i = index(valor[0], "\042:");
        pos = __trim(substr(valor[0], 1, i));
        valor[0] = substr(valor[0], i + 2, (length(valor[0]) - i) + 1);
    }
    
    n = _id(pos, elem);
    if (o == 1)
        lista[CNTSEC][n][3] = 1;

    lista[CNTSEC][n][2] = \
        (valor[0] ~ /^[ \t]*\042[^\042]*\042[ \t]*$/) ? "s" : "n";
    _trim(valor, 0);
    lista[CNTSEC][n][1] = valor[0];
    
    return n;
}

##
#
# Retorna el nivel, de dos elementos con más de un nivel, 
# en el cual un nuevo elemento es diferente de otro.
#
# Argumentos:
#   - nvl = Puntero con los dos niveles (subíndice anterior y actual)
#
# Resultado:
#   -     0     = No se han encontrado elementos diferentes hasta el del menor
#   - Nº entero = Que indica en que nivel difiere el subíndice actual con 
#                 respecto al anterior
#
##
function _nvl_cambia(nvl,      i, c)
{
    if (length(nvl[0]) > length(nvl[1]))
        c = length(nvl[1]);
    else
        c = length(nvl[0]);
    
    for (i = 1; i <= c; i++)
        if (nvl[0][i] != nvl[1][i])
            return i;
    return 0;
}

##
#
# Trasformar JSON en lista multidimensional
#
# Argumentos:
#   - json = Puntero a cadena JSON.
#   - lista  = Colección con los elementos de la cadena JSON original.
#
##
function jsonLstm(json, lista, id,     a, x, c, i, j, n)
{
    if (!isarray(json)) {
        _perror("El primer argumento debe ser un puntero");
    }
    
    if (length(id) == 0) {
        CNTSEC = 1;
        delete lista;
    }
    c = n = ""; a = i = j = 1;
    x["{"] = x["}"] = x["["] = x["]"] = 0;
    x["\042"] = x["sal"] = 0;

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
                    jsonLstm(x, lista, _id(j++, id));
                else {
                    n = _nuevo(lista, id, x, j++);
                    if (n != _id((j - 1), id) &&
                        _esjson(lista[CNTSEC][n][1]))
                    {
                        x[0] = lista[CNTSEC][n][1];
                        delete lista[CNTSEC][n];
                        jsonLstm(x, lista, n);
                    }
                }
                CNTSEC++;
                a = i;
            }
            break;
        default:
            break;
        }
    }
}

##
#
# Trasformar lista multidimensional en JSON
#
# Argumentos:
#   - json = Puntero a cadena JSON.
#   - lista  = Colección de elementos estructurados.
#
##
function lstmJson(lista, json,      i, j, k, z, s, n, x)
{
    if (!isarray(lista) || !isarray(json)) {
        _perror("El primer y segundo argumentos deben ser un punteros");
    }
    
    delete json;
    json[0] = "";
    x[0] = 0;                   # Contador elementos
    n[0] = 1; n[1] = 1;         # Nivel anterior y nivel actual
    s[0][1] = ""; s[1][1] = ""; # Subíndice anterior y subíndice actual
    
    PROCINFO["sorted_in"] = "@ind_num_asc";
    for (i in lista) {
        for (j in lista[i]) {
            n[1] = split(j, s[1], SUBSEP);
            break;
        }
        
        # 1 - Inicio cadena JSON
        if (i == 1) {
            for (k in s[1])
                if (s[1][k] !~ /^[0-9]+$/)
                    json[0] = json[0] "{" "\042" s[1][k] "\042:";
                else 
                    json[0] = json[0] "[";
        }
        # 2, 3, 4 - Inicio nuevo elemento
        else if (i > 1 && 3 in lista[i][j]) {
            # 2 - Nivel superior respecto al anterior
            if (n[1] > n[0]) {
                # Cerrar listas anteriores, si las hay
                gsub(/,$/, "", json[0]);
                for (k = n[0]; k > _nvl_cambia(s); k--)
                    if (s[0][k] ~ /^[0-9]+$/)
                        json[0] = json[0] "]";
                    else
                        json[0] = json[0] "}";
                json[0] = json[0] ",";
                for (k = _nvl_cambia(s); k <= n[1]; k++)
                    if (s[1][k] ~ /^[0-9]+$/)
                        json[0] = json[0] \
                            ((s[1][k]+0 == 1) ? "[" : "");
                    else
                        json[0] = json[0] \
                                ((k > _nvl_cambia(s) && \
                                  (!(k in s[0]) || \
                                   s[1][k] != s[0][k])) ? "{" : "") \
                                "\042" s[1][k] "\042:";
            }
            # 3 - Nivel igual respecto al anterior
            else if (n[1] == n[0]) {
                gsub(/,$/, "", json[0]);
                for (k = n[0]; k > _nvl_cambia(s); k--)
                    if (s[0][k] ~ /^[0-9]+$/)
                        json[0] = json[0] "]";
                    else
                        json[0] = json[0] "}";
                json[0] = json[0] ",";
                for (k = _nvl_cambia(s); k < n[0]; k++) {
                    if (k == _nvl_cambia(s) && s[1][k] !~ /^[0-9]+$/)
                        json[0] = json[0] "\042" s[1][k] "\042:";
                    if (s[1][k+1] ~ /^[0-9]+$/)
                        json[0] = json[0] "[";
                    else
                        json[0] = json[0] "{" "\042" s[1][k+1] "\042:";
                }
            }
            # 4 - Nivel inferior respecto al anterior
            else if (n[1] < n[0]) {
                gsub(/,$/, "", json[0]);
                for (k = n[0]; k > _nvl_cambia(s); k--)
                    if (s[0][k] ~ /^[0-9]+$/)
                        json[0] = json[0] "]";
                    else
                        json[0] = json[0] "}";
                json[0] = json[0] ",";
                for (k = _nvl_cambia(s); k <= n[1]; k++)
                    if (s[1][k] ~ /^[0-9]+$/) {
                        if (!(s[0][k] ~ /^[0-9]+$/ && \
                              (s[1][k]+0) > (s[0][k]+0)))
                            json[0] = json[0] "[";
                    } else
                        json[0] = json[0] \
                            ((k == _nvl_cambia(s)) ? "" : "{") \
                            "\042" s[1][k] "\042:";
            }
        }
        # 5 - Nuevo elemento
        else {
            if (n[1] < n[0]) {
                gsub(/,$/, "", json[0]);
                for (k = n[0]; k > _nvl_cambia(s); k--)
                    if (s[0][k] ~ /^[0-9]+$/)
                        json[0] = json[0] "]";
                    else
                        json[0] = json[0] "}";
                json[0] = json[0] ",";
            }
            if (s[1][n[1]] !~ /^[0-9]+$/)
                json[0] = json[0] "\042" s[1][n[1]] "\042:";
        }
        
        if (lista[i][j][1] != "")
            json[0] = json[0] \
                    ((lista[i][j][2] == "s") ? "\042" : "") \
                    lista[i][j][1] \
                    ((lista[i][j][2] == "s") ? "\042" : "") ",";
        else
            if (lista[i][j][2] == "s")
                json[0] = json[0] "\042\042,";

        # 6 - Fin de cadena JSON
        if (++x[0] == length(lista)) {
            gsub(/,$/, "", json[0]);
            for (k = n[1]; k > 0; k--)
                if (s[1][k] !~ /^[0-9]+$/)
                    json[0] = json[0] "}";
                else 
                    json[0] = json[0] "]";
            break;
        }
        
        n[0] = n[1];
        delete s[0];
        for (z in s[1])
            s[0][z] = s[1][z];
    }    
}

function pinta_elmtos(lista, frmt,      i, j, f)
{
    if (length(frmt) == 0)
        f = "_pinta_sin_frmt";
    else
        f = "_pinta_frmt";
    
    PROCINFO["sorted_in"] = "@ind_num_asc";
    for (i in lista) {
        for (j in lista[i]) {
            @f(lista[i][j], j, frmt);
            break;
        }
    }
}

function _pinta_frmt(txt, idc, frmt,      k, s, d) 
{
    printf(frmt, txt[1]);
}

function _pinta_sin_frmt(txt, idc, frmt,      k, s, d) 
{
    split(idc, s, SUBSEP);
    d = "";
    for (k in s)
        d = d "[" s[k] "]";
    if (txt[2] == "s")
        printf("%s = \042%s\042\n", d, txt[1]);
    else
        printf("%s = %s\n", d, txt[1]);    
}
