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

function ControladorEspecies(CnltHttp, cad_json,      cdi, lst, r)
{
    delete cdi;
    r = busca_especie(CnltHttp["nombre"], cdi);
    if (r) {
        crea_especie(cdi, cad_json);
    } else {
        delete lst;
        pon(lst, "mensaje", "Especie no encontrada");
        lstmJson(lst, cad_json);
    }
    return r;
}

function busca_especie(cadena, c,      i, ln, bbdd)
{
    bbdd = "./servidor_http_bbdd_especies.txt";
    while ((getline ln < bbdd) > 0) {
        patsplit(ln, c, /([^\t]*)|(\"[^\"]+\")/);
        for (i in c)
            gsub(/^[ \t]*(\042{1})*|(\042{1})*[ \t]*$/, "", c[i]);
        if (index(tolower(c[1]), tolower(cadena))) {
            close(bbdd);
            return 1;
        }
    }
    close(bbdd);
    return 0;
}

function crea_especie(c, cad_json,      i, lst, dr, regiones)
{
    delete lst;
    pon(lst, "hábito (sólo plantas)",  (c[4] == "" ? NULL : c[4]));
    pon(lst, "nombre.común",           (c[1] == "" ? NULL : c[1]));
    pon(lst, "nombre.científico",      (c[2] == "" ? NULL : c[2]));
    pon(lst, "nombre.sinonimia",       (c[3] == "" ? NULL : c[3]));
    pon(lst, "clasificación.reino",    (c[5] == "" ? NULL : c[5]));
    pon(lst, "clasificación.división", (c[6] == "" ? NULL : c[6]));
    pon(lst, "clasificación.clase",    (c[7] == "" ? NULL : c[7]));
    pon(lst, "clasificación.orden",    (c[8] == "" ? NULL : c[8]));
    pon(lst, "clasificación.familia",  (c[9] == "" ? NULL : c[9]));
    pon(lst, "distribución.código",    (c[10] == "" ? NULL : c[10]));

    regiones[1]  = "Arica y Parinacota";
    regiones[2]  = "Tarapacá";
    regiones[3]  = "Antofagasta";
    regiones[4]  = "Atacama";
    regiones[5]  = "Coquimbo";
    regiones[6]  = "Valparaíso continental";
    regiones[7]  = "Metropolitana";
    regiones[8]  = "O'higgins";
    regiones[9]  = "Maule";
    regiones[10] = "Bío-Bío";
    regiones[11] = "Araucanía";
    regiones[12] = "De Los Ríos";
    regiones[13] = "De Los Lagos";
    regiones[14] = "Aysén";
    regiones[15] = "Magallanes continental e insular";
    regiones[16] = "Antártica";
    regiones[17] = "Isla Pascua";
    regiones[18] = "Sala y Gómez";
    regiones[19] = "Jfdez";
    regiones[20] = "Desventuradas";

    dr = 1;
    for (i in regiones)
        if (c[i + 10] == "1")
            pon(lst, "distribución.regiones.[" dr++ "]", regiones[i]);

    lstmJson(lst, cad_json);
}
