# Funciones de la biblioteca `jdva`

## jsonLstm(json, lista)

Crea una lista multidimensional partiendo de un texto en formato JSON.

**Argumentos**

* **`json`** (1) Puntero a cadena de texto en formato JSON. Es decir, una lista de un sólo elemento cuyo índice sea 0.

* **`lista`** El resultado de la conversión se almacena en lista.

Ejemplo:

```awk
@include "bbl_jdva.awk"

BEGIN {
    cad_json[0] = "[{\"nombre\": \"alfa\",\"edad\": 34}, {\"nombre\": \"beta\", \"edad\": 36}]";

    jsonLstm(cad_json, lista);

    pinta(lista);
}
```

```bash
$ awk -f ./ejemplo_07.awk
[1][nombre] = "alfa"
[1][edad] = 34
[2][nombre] = "beta"
[2][edad] = 36
```

(1) Se ha decidido usar este _truco_ para forzar que el argumento se pase por referencia, en lugar de por valor. En [AWK](https://www.gnu.org/software/gawk/manual/gawk.html) cualquier argumento, excepto las listas, se pasa por valor. 

## lstmJson(lista, json)

Crear una cadena de texto en formato JSON partiendo de una lista multidimensional, generada previamente con la función **jsonLstm**.

**Argumentos**

* **`lista`** Lista Multidimensional, generada previamente con la función **jsonLstm**.

* **`json`**  Puntero a cadena de texto en formato JSON. Es decir, una lista de un sólo elemento cuyo índice sea 0.

Ejemplo:

```awk
@include "bbl_jdva.awk"

BEGIN {
    json_ent[0] = "[{\"nombre\": \"alfa\",\"edad\": 34}, {\"nombre\": \"beta\", \"edad\": 36}]";
    json_sal[0] = "";

    jsonLstm(json_ent, lista);

    lstmJson(lista, json_sal);

    sangra(json_sal);
}
```

```bash
$ awk -f ./ejemplo.awk
[
    {
        "nombre": "alfa",
        "edad": 34
    },
    {
        "nombre": "beta",
        "edad": 36
    }
]
```

## pinta(lista [, frmt])

Pinta por pantalla una lista multidimensional

**Argumentos**

* **lista** Lista MJ.

* **frmt**  Formato de representación. Por ejemplo: "%s\t"

## trae(lista, elmnt)

Busca un elemento localizado dentro de una lista MJ y devuelve su valor.

**Argumentos**

* **lista** Lista MJ.
* **elmnt** Elemento a buscar en formato "a.b.c".
    
**Resultado**

Si el elemento existe en la lista devuelve su valor y, ademas, pone RFUNC["trae"] a 1. Si no existe devuelve "" y, además, pone RFUNC["trae"] a 0.

## function quita(lista, elmnt)

Elimina elementos de una lista multidimensional jasonizada.

**Argumentos**

* **lista** Lista MJ.

* **elmnt** Elemento a aliminar en formato "a.b.c".

**Resultado**

Si el elemento existe en la lista lo elimina y devuelve su posición. Ademas, pone RFUNC["quita"] a 1. Si no existe el elemento devuelve 0 y, además, pone RFUNC["quita"] a 0.

## function pon(lista, elmnt, valor)

Añade un nuevo elemento a la lista MJ o modifica el valor de uno ya existente.

**Argumentos**

* **lista** Lista MJ.

* **elmnt** Elemento para añadir/modificar en formato "a.b.c".

* **valor** Valor del nuevo elemento o nuevo valor para el elemento ya existente.

**Resultado**

Devuelve la posición del nuevo elemento, o la posición del que se haya modificado, en caso de que existiese.

## function sangra(json)

Pinta por pantalla el texto en formato JSON que se le pasa como argumento, sangrando líneas para facilitar su lectura.

**Argumentos**

* **json** Puntero a cadena de texto en formato JSON.