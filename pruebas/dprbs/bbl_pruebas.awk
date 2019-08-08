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

function compara(lista01, lista02)
{
    for (i in lista01) {
        for (j in lista01[i]) {
            for (k in lista01[i][j]) {
                if (!(i in lista02)) {
                    plog("Falta "i" en lista_02.\n", 1, "ERROR");
                    return -1;
                }
                if (!(j in lista02[i])) {
                    plog("Falta "j" en lista_02["i"].\n", 1, "ERROR");
                    return -1;
                }
                if (!(k in lista01[i][j])) {
                    plog("Falta "k" en lista_01["i"]["j"].\n", 1, "ERROR");
                    return -1;
                }
                if (!(k in lista02[i][j])) {
                    plog("Falta "k" en lista_02["i"]["j"].\n", 1, "ERROR");
                    return -1;
                }
                plog("Compara ["i"]["j"]["k"] en listas 01 y 02... ", 
                        1, "INFO");
                if (lista01[i][j][k] != lista02[i][j][k]) {
                    plog("Error.\n");
                    return -1;
                }
                plog("Hecho.\n");
            }
        }
    }
    return 0;
}

function plog(txt, stm, nvl)
{
    if (length(stm) == 0)
        stm = "";
    else
        stm = fstm();
    printf (((stm != "" && length(nvl) > 0) ? "%s %s - " : "") txt,
                stm, nvl) >> LOG;
}

function fstm(frmt)
{
    if (length(frmt) == 0)
        frmt = "%d/%m/%Y %H:%M:%S";
    return strftime(frmt);
}
