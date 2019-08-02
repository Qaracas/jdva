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
        patsplit(ln, c, /([^\t]*)|(\"[^\"]+\")/);
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