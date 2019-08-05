BEGIN {
    CNTSEC = 1;

    RFUNC["trae"]  = 0;
    RFUNC["quita"] = 0;

    TRUE  = "_true_";
    FALSE = "_false_";
    NULL  = "_null_";
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

function _i2puntos(valor,      i, j)
{
    if (!(i = index(valor[0],"\042")))
        return 0;
    j = index(substr(valor[0],i + 1, length(valor[0]) - i), "\042");
    if (!j)
        return 0;
    i = i + j;
    j = index(substr(valor[0],i + 1, length(valor[0]) - i), ":");
    if (j)
        return i + j;
    return 0;
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
function _nuevo(lista, elem, valor, pos,      n, i)
{
    n = pos;
    # Si es un par "nombre : valor" modificar valor y pos
    if ((i = _i2puntos(valor)) > 0) {
        n = __trim(substr(valor[0], 1, i - 1));
        valor[0] = substr(valor[0], i + 1, (length(valor[0]) - i) + 1);
    }

    n = _id(n, elem);
    if (pos == 1)
        lista[CNTSEC][n][3] = 1;

    lista[CNTSEC][n][2] = (valor[0] ~ /^[ \t]*\042/) ? "s" : "n";
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
#   - json  = Puntero a cadena JSON.
#   - lista = Colección con los elementos de la cadena JSON original.
#
##
function jsonLstm(json, lista, id,      a, x, c, i, j, n)
{
    if (!isarray(json)) {
        _perror("El primer argumento debe ser un puntero.");
    }

    if (length(id) == 0) {
        CNTSEC = 1;
        delete lista;
    }
    c = n = ""; a = i = j = 1;
    x["{"] = x["}"] = x["["] = x["]"] = 0;
    x["\042"] = x["sal"] = 0;
    x["pc"] = substr(json[0], 1, 1);

    # Ojo!! Aquí estamos modificando la cadena.
    # La dejamos como estaba en ((1))
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
    # ((1))
    json[0] = x["pc"] json[0] ((x["pc"] == "{") ? "}" : "]");
}

##
#
# Trasformar lista multidimensional en JSON
#
# Argumentos:
#   - json  = Puntero a cadena JSON.
#   - lista = Colección de elementos estructurados.
#
##
function lstmJson(lista, json,      i, j, k, z, s, n, x)
{
    if (!isarray(lista) || !isarray(json)) {
        _perror("El primer y segundo argumentos deben ser punteros");
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

##
#
# Pinta por pantalla una lista multidimensional
#
# Argumentos:
#   - lista  = Colección con los elementos del texto JSON.
#   - frmt   = Formato de representación. Por ejem.: "%s ,"
#
##
function pinta(lista, frmt,      i, j, f)
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

##
#
# Devuelve el valor de cualquier elemento de la lista JSON
#
# Argumentos:
#   - lista  = Colección con los elementos del texto JSON.
#   - elmnt  = Elemento a buscar en formato "a.b.c".
#
# Resultado:
#   - Si el elemento existe en la lista devuelve su valor y, ademas,
#     pone RFUNC["trae"] a 1.
#   - Si no existe el elemento devuelve "" y, además, pone RFUNC["trae"] a 0.
#
##
function trae(lista, elmnt,      i)
{
    gsub(/\./, SUBSEP, elmnt);
    gsub(/\\./, ".", elmnt);
    for (i in lista) {
        if (elmnt in lista[i]) {
            RFUNC["trae"] = 1;
            return lista[i][elmnt][1];
        }
    }
    RFUNC["trae"] = 0;
    return "";
}

##
#
# Elimina cualquier elemento de la lista JSON
#
# Argumentos:
#   - lista  = Colección con los elementos del texto JSON.
#   - elmnt  = Elemento a buscar en formato "a.b.c".
#
# Resultado:
#   - Si el elemento existe en la lista lo elimina y devuelve su posición.
#     Ademas, pone RFUNC["quita"] a 1.
#   - Si no existe el elemento devuelve 0 y, además, pone RFUNC["quita"] a 0.
#
##
function quita(lista, elmnt,      i)
{
    gsub(/\./, SUBSEP, elmnt);
    gsub(/\\./, ".", elmnt);
    for (i in lista) {
        if (elmnt in lista[i]) {
            delete lista[i][elmnt];
            RFUNC["quita"]  = 1;
            return i;
        }
    }
    RFUNC["quita"]  = 0;
    return 0;
}

function _mismo_padre(a, b,      s1, s2, l1, l2)
{
    l1 = split(a, s1, SUBSEP);
    l2 = split(b, s2, SUBSEP);
    
    if (l1 < l2+1)
        return 0;
    
    for (i in s2)
        if (s1[i] != s2[i])
            return 0;
    
    return 1;
}

function _copia(a, b, m, n,      i)
{
    for (i in a[m]) {
        b[n][i][1] = a[m][i][1];
        b[n][i][2] = a[m][i][2];
        if (3 in a[m][i])
            b[n][i][3] = a[m][i][3];
    }
}

##
#
# Sustituye a typeof en GNU Awk < 4.2
#
# Ver función o_class() en:
# https://github.com/cup/lake/blob/8ebe900/libo.awk#L5-L22
#
##
function _typeof(obj,      q, x, z)
{
    if (obj == TRUE || obj == FALSE || obj == NULL)
        return "undefined";
    
    q = CONVFMT; CONVFMT = "% g";

    split(" " obj "\1" obj, x, "\1");

    x[1] = obj == x[1];
    x[2] = obj == x[2];
    x[3] = obj == 0;
    x[4] = obj "" == +obj;

    CONVFMT = q;

    z["0001"] = z["1101"] = z["1111"] = "number";
    z["0100"] = z["0101"] = z["0111"] = "string";
    z["1100"] = z["1110"] = "strnum";
    z["0110"] = "undefined";

    return z[x[1] x[2] x[3] x[4]];
}

##
#
# Añade un nuevo elemento a la lista MJ o modifica el valor de uno 
# ya existente.
#
# Argumentos:
#   - lista = Lista multidimensional MJ.
#   - elmnt = Elemento para añadir/modificar en formato "a.b.c".
#   - valor = Valor del nuevo elemento o nuevo valor para el elemento ya 
#             existente.
# Resultado:
#   - Devuelve la posición del nuevo elemento la posición del que se haya
#     modificado en caso de que existiese. 
#
##
function pon(lista, elmnt, valor,      i, j, k, x, s, lst, mp)
{
    gsub(/\./, SUBSEP, elmnt);
    gsub(/\\./, ".", elmnt);
    
    # Marca elemento anterior mismo padre
    mp = 0;
    # Tipo nuevo elemento
    x[1] = ((_typeof(valor) == "string") ? "s" : "n");
    
    if (valor == TRUE || valor == FALSE || valor == NULL)
        gsub(/^_|_$/, "", valor);
    
    # Nivel nuevo elemento
    x[2] = split(elmnt, s, SUBSEP);
    # Nombre padre nuevo elemento
    x[3] = "";
    if (x[2] > 1)
        for (i = 1; i < length(s); i++)
            x[3] = x[3] ((length(x[3]) > 0) ? SUBSEP : "") s[i];
    
    # 01.- Lista vacía
    if (length(lista) == 0) {
        lista[1][elmnt][1] = valor;
        lista[1][elmnt][2] = x[1];
        lista[1][elmnt][3] = 1;
        return 1;
    }
    
    # 02.- Buscar el lista
    for (i in lista) {   
        if (elmnt in lista[i]) {
            # Existe elemento. Cambiar el valor.
            lista[i][elmnt][1] = valor;
            lista[i][elmnt][2] = x[1];
            delete lst;
            return i;
        } else {
            # Ver si elemento tiene mismo padre que nuevo elemento.
            for (j in lista[i]) {
                if (x[2] > 1) {
                    if (_mismo_padre(j, x[3])) {
                        mp = 1;
                    } else {
                        if (mp) {
                            lst[i][elmnt][1] = valor;
                            lst[i][elmnt][2] = x[1];
                            for (k in lista)
                                if (k+0 > i+0)
                                _copia(lista, lst, k, k+1);
                            delete lista;
                            for (k in lst)
                                _copia(lst, lista, k, k);
                            delete lst;
                            return i;
                        }
                    }
                }
                break;
            }
        }
        _copia(lista, lst, i, i);
    }
    
    # 03.- Poner nuevo elemento al final.
    lista[i+1][elmnt][1] = valor;
    lista[i+1][elmnt][2] = x[1];
    if (x[2] > 1 && mp == 0)
        lista[i+1][elmnt][3] = 1;
    delete lst;
    return length(lista);
}

function sangra(json,      x, c, d, i, t, e, tope, elmt)
{
    if (!isarray(json)) {
        _perror("El primer argumento debe ser un puntero.");
    }
    
    if (RS !~ /^\r?\n$/)
        _perror("Separador de línea incorrecto.");
    
    c = d = tope = elmt = "";
    i = t = 1; t_max = 100; e = 0;
    x["{"] = x["}"] = x["["] = x["]"] = x["\042"] = 0;
    
    while ((c = substr(json[0], i++, 1)) != "") {
        if (c ~ /[ \t]/ && (x["\042"] % 2 == 0))
            continue;
        
        switch (c) {
        case "{":
            x["{"]++; e = t = 1;
            tope = tope c RS _blancos(x);
            break;
        case "}":
            x["}"]++;
            if (d == "{" || e == 1) {
                gsub(/\r?\n[ ]*[^\r?\n]*$/, "", tope);
                gsub(/\042:/, "\042: ", elmt);
                tope = tope elmt c;
            } else 
                tope = tope RS _blancos(x) c;
            e = 0;
            break;
        case "[":
            x["["]++; e = 1;
            tope = tope c RS _blancos(x);
            break;
        case "]":
            x["]"]++;
            if (d == "[" || e == 1) {
                gsub(/\r?\n[ ]*[^\r?\n]*$/, "", tope);
                tope = tope elmt c;
            } else
                tope = tope RS _blancos(x) c;
            e = 0;
            break;
        case "\042":
            x["\042"]++;
            tope = tope c;
            break;
        case ",":
            if (e) e++;
            tope = tope c ((x["\042"] % 2 == 0) ? RS _blancos(x) : "");
            break;
        case ":":
            tope = tope c ((x["\042"] % 2 == 0) ? " " : "");
            break;
        default:
            tope = tope c;
            break;
        }
        if (e > 0 && c !~/[\[\{]/)
            elmt = elmt c;
        else
            elmt = "";
        d = c;
        if (++t > t_max) {
            printf "%s", tope;
            tope = "";
            t = 1;
        }
    }
    if (t <= t_max)
        printf "%s\n", tope;
}

function _blancos(x,      i, b)
{
    b = "";
    for (i = 0; i < ((x["{"] - x["}"]) + (x["["] - x["]"])); i++)
        b = b "    ";
    return b;
}