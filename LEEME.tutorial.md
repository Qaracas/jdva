# Tutorial

Bucear en la carpeta [ejemplos](https://github.com/Qaracas/jdva/tree/master/ejemplos) para ver algunas de las cosas que se pueden hacer con `jdva`.

## Ejemplo 01
Armar una lista multidimensional a partir de un texto JSON, y luego pintarla por pantalla.

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
(nombre) = "Pedro"
(edad) = 42
(ciudad) = "Madrid"
(datos)(C.V.) = "Computación"
```

## Ejemplo 02
Armar una lista multidimensional a partir de un texto JSON, quitarle un elemento, y luego pintarla por pantalla.

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
(nombre) = "Pedro"
(ciudad) = "Madrid"
(datos)(C.V.) = "Computación"
```

## Ejemplo 03
Armar una lista multidimensional a partir de un texto JSON, modificar el valor de uno de sus elementos, añadir otro nuevo, y luego pintarla por pantalla.

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
(nombre) = "Pedro"
(edad) = 17
(ciudad) = "Madrid"
(datos)(C.V.) = "Computación"
(apellidos) = "Blanco Crespo"
```

## Ejemplo 04
Armar una lista multidimensional a partir de un texto JSON, y luego pintar por pantalla el valor de uno de sus elementos.

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
Pedro
```

## Ejemplo 05
Armar una lista multidimensional de cero, convertirla en un texto JSON, y luego pintar este último por pantalla.

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
{"nombre":"Pedro","apellidos":"Blanco Crespo","edad":17,"ciudad":"Madrid","datos":{"C.V.":"Computación"}}
```

## Ejemplo 06
Armar una lista multidimensional de cero, convertirla en un texto JSON, y luego pintar este último por pantalla, sangrando cada línea.

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
{
    "nombre": "Pedro",
    "apellidos": "Blanco Crespo",
    "edad": 17,
    "ciudad": "Madrid",
    "datos": {"C.V.": "Computación"}
}
```

## Ejemplo 07
Armar una lista multidimensional partiendo de un texto JSON, que contenga una o varias ristras de elementos entre corchetes, separados por comas, y luego extraer uno de esos elementos en función de su posición relativa. Las listas son en base uno, luego `.[2]` trae el segundo elemento.

`entrada_con_listas.json`

```json
{
  "firstName": "John",
  "lastName": "Smith",
  "isAlive": true,
  "age": 27,
  "address": {
    "streetAddress": "21, 2nd Street",
    "city": "New York",
    "state": "NY",
    "postalCode": "10021-3100"
  },
  "phoneNumbers": [
    {
      "type": "home",
      "number": "212 555-1234"
    },
    {
      "type": "office",
      "number": "646 555-4567"
    },
    {
      "type": "mobile",
      "number": "123 456-7890"
    }
  ],
  "children": [],
  "spouse": null
}
```

```bash
$ cat entrada_con_listas.json |
> gawk -i bbl_jdva.awk '{
>   cad_json[0]=cad_json[0] $0;
> }
> END{
>   jsonLstm(cad_json, lista);
>   print trae(lista, "phoneNumbers.[3].number");
> }'
123 456-7890
```
