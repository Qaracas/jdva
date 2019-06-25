# Ejemplos de uso

## Convertir JSON en lista multidimensional

```awk
#!/usr/bin/gawk -E

@include "ecma-404.awk"

BEGIN {
    cad_json[0] = "";
    linea = "";

    while ((getline linea < ARGV[1]) > 0)
        cad_json[0] = cad_json[0] linea;
    close(ARGV[1]);

    jsonLstm(cad_json, lista);

    pinta(lista);
}
```

Si al programa anterior se le pasase como argumento la ruta al siguiente fichero JSON:

    {
        "nombre":"Pedro",
        "edad":42,
        "ciudad":"Madrid",
        "datos":{
            "C.V.":"Computación"
        }
    }

Obtendríamos el resultado:

    [nombre] = "Pedro"
    [edad] = 42
    [ciudad] = "Madrid"
    [datos][C.V.] = "Computación"

## Eliminar elemento

```awk
jsonLstm(cad_json, lista);
quita(lista, "edad");
pinta(lista);
```

Resultado:

    [nombre] = "Pedro"
    [ciudad] = "Madrid"
    [datos][C.V.] = "Computación"

## Modificar/añadir elemento

```awk
jsonLstm(cad_json, lista);
pon(lista, "apellidos", "Blanco Crespo");
pon(lista, "edad", 17);
pinta(lista);
```

Resultado:

    [nombre] = "Pedro"
    [edad] = 17
    [ciudad] = "Madrid"
    [datos][C.V.] = "Computación"
    [apellidos] = "Blanco Crespo"

## Traer elemento

```awk
jsonLstm(cad_json, lista);
print trae(lista, "nombre");
```

Resultado:

    Pedro

## Convertir lista multidimensional en JSON

```awk
#!/usr/bin/gawk -E

@include "../src/ecma-404.awk"

BEGIN {
    cad_json[0] = "";
    
    delete lista;
    pon(lista, "nombre", "Pedro");
    pon(lista, "apellidos", "Blanco Crespo");
    pon(lista, "edad", 17);
    pon(lista, "ciudad", "Madrid");
    pon(lista, "datos.C\\.V\\.", "Computación");

    lstmJson(lista, cad_json);

    print cad_json[0];
}
```

Resultado:

    {
        "nombre":"Pedro",
        "apellidos":"Blanco Crespo",
        "edad":17,
        "ciudad":"Madrid",
        "datos":{
            "C.V.":"Computación"
        }
    }
