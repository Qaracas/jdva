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
    return gsub(/^[ \t]*\042?|\042?[ \t]*$/, "", str[idx]);
}

function __trim(str)
{
    gsub(/^[ \t]*\042?|\042?[ \t]*$/, "", str);
    return str;
}

function _esjson(txt)
{
    if (txt ~/^[ \t]*[\{\[]{1}.*[\}\]]{1}[ \t]*$/)
        return 1;
    return 0;
}

function _esjsnulo(txt)
{
    if (txt ~/^[ \t]*[\{\[]{1}[\}\]]{1}[ \t]*$/)
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

function _xedni(cadena, crt,      i)
{
    i = index(cadena, crt);
    if (i)
        i = i + _xedni(substr(cadena, i+1), crt);
    return i
}

##
#
# Compara dos subindices o identificadores de elemento "hasta cierto nivel"
#
##
function _cmpi (subid, nvl,      i)
{
    PROCINFO["sorted_in"]  = "@ind_num_desc";
    for (i in subid[1])
        if (subid[1][i] != subid[0][i])
            return 1;
    return 0;
}

function _esmlst(elmt)
{
    if (elmt ~ /^[0-9]+$/)
        return 1;
    return 0;
}

function _nombre(nombre)
{
    if (length(nombre))
        return "\042" nombre "\042:";
    return "";
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

    #if (valor["pc"] == "[") n = "[" n "]";
    
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

function _blancos(x,      i, b)
{
    b = "";
    for (i = 0; i < ((x["{"] - x["}"]) + (x["["] - x["]"])); i++)
        b = b "    ";
    return b;
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
