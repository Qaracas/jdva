# Autor: Ulpiano Tur de Vargas <ulpiano.tur.devargas@gmail.com>
#
# Este programa es software libre; puedes distribuirlo y/o
# modificarlo bajo los términos de la Licencia Pública General de GNU
# según la publicó la Fundación del Software Libre; ya sea la versión 3, o
# (a su elección) una versión superior.
#
# Este programa se distribuye con la esperanza de que sea útil,
# pero SIN NINGUNA GARANTIA; ni siquiera la garantía implícita de
# COMERCIABILIDAD o APTITUD PARA UN PROPÓSITO DETERMINADO. Vea la
# Licencia Pública General de GNU para más detalles.
#
# Deberías haber recibido una copia de la Licencia Pública General
# de GNU junto con este software; mira el fichero LICENSE. Si
# no, mira <https://www.gnu.org/licenses/>.

# Author: Ulpiano Tur de Vargas <ulpiano.tur.devargas@gmail.com>
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 3, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
# General Public License for more details.
#
# You should have received a copy of the GNU General Public
# License along with this software; see the file LICENSE. If
# not, see <https://www.gnu.org/licenses/>.

@include "funcs_priv.awk";

BEGIN {
    CNTSEC = 1;

    RFUNC["trae"]  = 0;
    RFUNC["quita"] = 0;

    TRUE  = "_true_";
    FALSE = "_false_";
    NULL  = "_null_";
}

function jsonLstm(json, lista, id,      a, x, c, i, j, k, n)
{
    if (!isarray(json)) {
        _perror("El primer argumento debe ser un puntero.");
    }

    if (length(id) == 0) {
        CNTSEC = 1;
        delete lista;
    }
    c = n = ""; j = 1;

    x["\042"] = x["{"] = x["}"] = x["["] = x["]"] = 0;

    i = a    = _ppctr(json) + 1;
    x["fin"] = _puctr(json);
    x["pmc"] = substr(json[0], (i - 1), 1);

    # Listas u objetos vacíos
    if (i == x["fin"]) {
        x[0] = "";
        n = (x["pmc"] == "[" ? "[" j "]" : j);
        n = _id(n, id);
        _nuevo(lista, n, x, j);
        # Para que "lstmJson()" sepa si es lista u objeto
        if (x["pmc"] == "{")
            lista[CNTSEC][n][4] = 1;
        return;
    }
    
    for (; (c = substr(json[0], i++, 1)); ) {
        if (x["\042"] % 2 && c == "\134" && i++)
            continue;
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
        default:
            break;
        }
        if (c == "," || (i >= x["fin"] && i++)) {
            if ((x["\042"] % 2 == 0) && \
                (x["{"] == x["}"]) &&   \
                (x["["] == x["]"]))
            {
                n = "[" j "]";
                x[0] = substr(json[0], a, (i - a - 1));
                if (_esjson(x[0]))
                    jsonLstm(x, lista, _id(n, id));
                else {
                    if ((k = _i2puntos(x)) > 0) {
                        n = __trim(substr(x[0], 1, k - 1));
                        x[0] = substr(x[0],                     \
                                      k + 1,                    \
                                      (length(x[0]) - k) + 1);
                    }
                    n = _id(n, id);
                    if (_esjson(x[0]))
                        jsonLstm(x, lista, n);
                    else
                        _nuevo(lista, n, x, j);
                }
                CNTSEC++; j++; a = i;
            }
            if (i >=  x["fin"])
                return;
        }
    }
}

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
                if (_esmlst(s[1][k]))
                    json[0] = json[0] "[";
                else
                    json[0] = json[0] "{" _nombre(s[1][k], lista[i][j]);
        }
        # 2, 3, 4 - Inicio nuevo elemento
        else if (i > 1 && 3 in lista[i][j]) {
            # 2 - Nivel superior respecto al anterior
            if (n[1] > n[0]) {
                # Cerrar listas anteriores, si las hay
                gsub(/,$/, "", json[0]);
                for (k = n[0]; k > _nvl_cambia(s); k--)
                    if (_esmlst(s[0][k]))
                        json[0] = json[0] "]";
                    else
                        json[0] = json[0] "}";
                json[0] = json[0] ",";
                for (k = _nvl_cambia(s); k <= n[1]; k++)
                    if (_esmlst(s[1][k]))
                        json[0] = json[0]                      \
                            ((_t(s[1][k])+0 == 1) ? "[" : "");
                    else
                        json[0] = json[0]                      \
                            ((k > _nvl_cambia(s) &&            \
                              (!(k in s[0]) ||                 \
                               _cmpi(s, k))) ? "{" : "")       \
                            _nombre(s[1][k], lista[i][j]);
            }
            # 3 - Nivel igual respecto al anterior
            else if (n[1] == n[0]) {
                gsub(/,$/, "", json[0]);
                for (k = n[0]; k > _nvl_cambia(s); k--)
                    if (_esmlst(s[0][k]))
                        json[0] = json[0] "]";
                    else
                        json[0] = json[0] "}";
                json[0] = json[0] ",";
                for (k = _nvl_cambia(s); k < n[0]; k++) {
                    if (k == _nvl_cambia(s) && !(_esmlst(s[1][k])))
                        json[0] = json[0] _nombre(s[1][k], lista[i][j]);
                    if (_esmlst(s[1][k+1]))
                        json[0] = json[0] "[";
                    else
                        json[0] = json[0] "{" _nombre(s[1][k+1], lista[i][j]);
                }
            }
            # 4 - Nivel inferior respecto al anterior
            else if (n[1] < n[0]) {
                gsub(/,$/, "", json[0]);
                for (k = n[0]; k > _nvl_cambia(s); k--)
                    if (_esmlst(s[0][k]))
                        json[0] = json[0] "]";
                    else
                        json[0] = json[0] "}";
                json[0] = json[0] ",";
                for (k = _nvl_cambia(s); k <= n[1]; k++)
                    if (_esmlst(s[1][k])) {
                        if (!(_esmlst(s[0][k]) &&                       \
                              (_t(s[1][k])+0) > (_t(s[0][k])+0)))       \
                            json[0] = json[0] "[";
                    } else
                        json[0] = json[0]                      \
                            ((k == _nvl_cambia(s)) ? "" : "{") \
                            _nombre(s[1][k], lista[i][j]);
            }
        }
        # 5 - Nuevo elemento
        else {
            if (n[1] < n[0]) {
                gsub(/,$/, "", json[0]);
                for (k = n[0]; k > _nvl_cambia(s); k--)
                    if (_esmlst(s[0][k]))
                        json[0] = json[0] "]";
                    else
                        json[0] = json[0] "}";
                json[0] = json[0] ",";
            }
            if (!(_esmlst(s[1][n[1]])))
                json[0] = json[0] _nombre(s[1][n[1]], lista[i][j]);
        }
        
        if (lista[i][j][1] != "")
            json[0] = json[0]                                  \
                ((lista[i][j][2] == "s") ? "\042" : "")        \
                lista[i][j][1]                                 \
                ((lista[i][j][2] == "s") ? "\042" : "") ",";
        else
            if (lista[i][j][2] == "s")
                json[0] = json[0] "\042\042,";

        # 6 - Fin de cadena JSON
        if (++x[0] == length(lista)) {
            gsub(/,$/, "", json[0]);
            for (k = n[1]; k > 0; k--)
                if (_esmlst(s[1][k]))
                    json[0] = json[0] "]";
                else 
                    json[0] = json[0] "}";
            break;
        }
        
        n[0] = n[1];
        delete s[0];
        for (z in s[1])
            s[0][z] = s[1][z];
    }    
}

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

function quita(lista, elmnt,      i, j, k, l, d, s, p, n)
{
    RFUNC["quita"] = 0;
    gsub(/\./, SUBSEP, elmnt);
    gsub(/\\./, ".", elmnt);

    p = substr(elmnt, 1, _xedni(elmnt, SUBSEP));
    s = strtonum(substr(elmnt, _xedni(elmnt, SUBSEP)+1));
    n = index(elmnt, SUBSEP);

    PROCINFO["sorted_in"] = "@ind_num_asc";
    for (i in lista) {
        if (elmnt in lista[i]) {
            if (3 in lista[i][elmnt]) {
                if ((i+1) in lista)
                    for (j in lista[i+1]) {
                        lista[i+1][j][3] = 1;
                        break;
                    }
            }
            delete lista[i];
            RFUNC["quita"] = 1;
            d = i;
            continue;
        }
        if (RFUNC["quita"]) {
            for (j in lista[i]) {
                if (s && substr(j, 1, _xedni(j, SUBSEP)) == p) {
                    if (n)
                        l = substr(j, 1, _xedni(j, SUBSEP)) s++;
                    else
                        l = s++;
                } else {
                    l = j;
                }
                for (k in lista[i][j])
                    lista[i-1][l][k] = lista[i][j][k];
            }
            delete lista[i]
        }
    }

    if (RFUNC["quita"])
        return d;
    else
        return 0;
}

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

    c = d = tope = elmt = "";
    i = t = 1; t_max = 100; e = 0;
    x["{"] = x["}"] = x["["] = x["]"] = x["\042"] = 0;

    while ((c = substr(json[0], i++, 1)) != "") {
        if (c ~ /[ \t]/ && (x["\042"] % 2 == 0))
            continue;

        switch (c) {
        case "{":
            x["{"]++; e = t = 1;
            tope = tope c "\n" _blancos(x);
            break;
        case "}":
            x["}"]++;
            if (d == "{" || e == 1) {
                gsub(/\r?\n[ ]*[^\r?\n]*$/, "", tope);
                gsub(/\042:/, "\042: ", elmt);
                tope = tope elmt c;
            } else 
                tope = tope "\n" _blancos(x) c;
            e = 0;
            break;
        case "[":
            x["["]++; e = 1;
            tope = tope c "\n" _blancos(x);
            break;
        case "]":
            x["]"]++;
            if (d == "[" || e == 1) {
                gsub(/\r?\n[ ]*[^\r?\n]*$/, "", tope);
                tope = tope elmt c;
            } else
                tope = tope "\n" _blancos(x) c;
            e = 0;
            break;
        case "\042":
            x["\042"]++;
            tope = tope c;
            break;
        case ",":
            if (e) e++;
            tope = tope c ((x["\042"] % 2 == 0) ? "\n" _blancos(x) : "");
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
