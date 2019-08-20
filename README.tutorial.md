# Tutorial

Dive into the [ejemplos](https://github.com/Qaracas/jdva/tree/master/ejemplos) (examples) folder to see things that you can do with `jdva`.

## Example 01
Build a multidimensional list from an input JSON text and then print the result.

`ejemplo_01.awk`

```awk
@include "bbl_jdva.awk"

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

`entrada.json`

```json
{
    "nombre":"Pedro",
    "edad":42,
    "ciudad":"Madrid",
    "datos":{
        "C.V.":"Computación"
    }
}
```

```bash
$ awk -f ./ejemplo_01.awk entrada.json
```

    [nombre] = "Pedro"
    [edad] = 42
    [ciudad] = "Madrid"
    [datos][C.V.] = "Computación"

## Example 02
Build a multidimensional list from an input JSON text, remove one element,  and then print the result.

```awk
@include "bbl_jdva.awk"

BEGIN {
    cad_json[0] = "";
    linea = "";

    while ((getline linea < ARGV[1]) > 0)
        cad_json[0] = cad_json[0] linea;
    close(ARGV[1]);

    jsonLstm(cad_json, lista);
    quita(lista, "edad");

    pinta(lista);
}
```

`entrada.json`

```json
{
    "nombre":"Pedro",
    "edad":42,
    "ciudad":"Madrid",
    "datos":{
        "C.V.":"Computación"
    }
}
```

```bash
$ awk -f ./ejemplo_02.awk entrada.json
```

    [nombre] = "Pedro"
    [ciudad] = "Madrid"
    [datos][C.V.] = "Computación"

## Example 03
Build a multidimensional list from an input JSON text, modify one element, add new other one, and then print the result.

```awk
@include "bbl_jdva.awk"

BEGIN {
    cad_json[0] = "";
    linea = "";

    while ((getline linea < ARGV[1]) > 0)
        cad_json[0] = cad_json[0] linea;
    close(ARGV[1]);

    jsonLstm(cad_json, lista);
    pon(lista, "apellidos", "Blanco Crespo");
    pon(lista, "edad", 17);

    pinta(lista);
}
```

`entrada.json`

```json
{
    "nombre":"Pedro",
    "edad":42,
    "ciudad":"Madrid",
    "datos":{
        "C.V.":"Computación"
    }
}
```

```bash
$ awk -f ./ejemplo_03.awk entrada.json
```

    [nombre] = "Pedro"
    [edad] = 17
    [ciudad] = "Madrid"
    [datos][C.V.] = "Computación"
    [apellidos] = "Blanco Crespo"

## Example 04
Build a multidimensional list from an input JSON text, and then print the value of one of his element.

```awk
@include "bbl_jdva.awk"

BEGIN {
    cad_json[0] = "";
    linea = "";

    while ((getline linea < ARGV[1]) > 0)
        cad_json[0] = cad_json[0] linea;
    close(ARGV[1]);

    jsonLstm(cad_json, lista);

    print trae(lista, "nombre");
}
```

`entrada.json`

```json
{
    "nombre":"Pedro",
    "edad":42,
    "ciudad":"Madrid",
    "datos":{
        "C.V.":"Computación"
    }
}
```

```bash
$ awk -f ./ejemplo_04.awk entrada.json
```

    Pedro

## Example 05
Build a multidimensional list from scratch, turn it into JSON text, and then print the result.

```awk
@include "bbl_jdva.awk"

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

```bash
$ awk -f ./ejemplo_05.awk
```

    {"nombre":"Pedro","apellidos":"Blanco Crespo","edad":17,"ciudad":"Madrid","datos":{"C.V.":"Computación"}}

## Example 06
Build a multidimensional list from scratch, turn it into JSON text, and then print (pretty print) the formatted result.

```awk
@include "bbl_jdva.awk"

BEGIN {
    cad_json[0] = "";
    
    delete lista;
    pon(lista, "nombre", "Pedro");
    pon(lista, "apellidos", "Blanco Crespo");
    pon(lista, "edad", 17);
    pon(lista, "ciudad", "Madrid");
    pon(lista, "datos.C\\.V\\.", "Computación");

    lstmJson(lista, cad_json);

    sangra(cad_json);
}
```

```bash
$ awk -f ./ejemplo_06.awk
```

    {
        "nombre": "Pedro",
        "apellidos": "Blanco Crespo",
        "edad": 17,
        "ciudad": "Madrid",
        "datos": {"C.V.": "Computación"}
    }