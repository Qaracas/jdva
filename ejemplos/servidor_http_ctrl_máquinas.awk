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

function ControladorMaquinaria(CnltHttp, cad_json,      cdi, r)
{
    delete cdi;
    r = busca_maquina(CnltHttp["descripcion"], cdi);
    if (r) {
        crea_maquina(cdi, cad_json);
    } else {
        delete lst;
        pon(lst, "mensaje", "Máquina no encontrada");
        lstmJson(lst, cad_json);
    }
    return r;
}

function busca_maquina(cadena, c,      i, ln, bbdd)
{
    bbdd = "./servidor_http_bbdd_máquinas.txt";
    while ((getline ln < bbdd) > 0) {
        patsplit(ln, c, /([^\t]*)|(\\"[^\\"]+\\")/);
        for (i in c)
            gsub(/^[ \t]*(\042{1})*|(\042{1})*[ \t]*$/, "", c[i]);
        if (index(tolower(c[2]), tolower(cadena))) {
            close(bbdd);
            return 1;
        }
    }
    close(bbdd);
    return 0;
}

function crea_maquina(c, cad_json,      lst)
{
    delete lst;
    pon(lst, "modelo",              (c[1] == "" ? NULL : c[1]));
    pon(lst, "descripción",         (c[2] == "" ? NULL : c[2]));
    pon(lst, "precio.I\\.V\\.A\\.", (c[3] == "" ? NULL : c[3]));
    pon(lst, "serie",               (c[3] == "" ? NULL : c[4]));
    pon(lst, "porcentaje",          (c[5] == "" ? NULL : c[5]));
    pon(lst, "precio.neto",         (c[6] == "" ? NULL : c[6]));

    lstmJson(lst, cad_json);
}