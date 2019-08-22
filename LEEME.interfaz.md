# Funciones de la biblioteca `jdva`

## jsonLstm(json, lista)

Crea una lista multidimensional partiendo de un texto en formato JSON.

**Argumentos**

* **`json`** (1) Puntero a cadena de texto en formato JSON. Es decir, una lista de un sólo elemento cuyo índice sea 0.

* **`lista`** El resultado de la conversión se almacena en lista.

Ejemplo:

```bash
$ echo "[{\"nombre\": \"alfa\",\"edad\": 34}, {\"nombre\": \"beta\", \"edad\": 36}]" |
> gawk -i bbl_jdva.awk '{
>   cad_json[0]=$0;
>   jsonLstm(cad_json, lista);
>   pinta(lista);
> }'
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

```bash
$ echo "[{\"nombre\": \"alfa\",\"edad\": 34}, {\"nombre\": \"beta\", \"edad\": 36}]" |
> gawk -i bbl_jdva.awk '{
>   json_ent[0] = $0;
>   json_sal[0] = "";
>   jsonLstm(json_ent, lista);
>   lstmJson(lista, json_sal);
>   sangra(json_sal);
> }'
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

* **lista** Lista Multidimensional, generada previamente con la función **jsonLstm**.

* **frmt**  Formato de representación. Por ejemplo: "%s\t".

Ejemplo:

```bash
$ echo "[{\"nombre\": \"alfa\",\"edad\": 34}, {\"nombre\": \"beta\", \"edad\": 36}]" |
> gawk -i bbl_jdva.awk '{
>   cad_json[0]=$0;
>   jsonLstm(cad_json, lista);
>   pinta(lista, "%s\t");
> }'
alfa    34      beta    36
```

## trae(lista, elmnt)

Devuelve el valor de un elemento localizado dentro de una lista multidimensional, partiendo de un filtro que lo identifica.

**Argumentos**

* **lista** Lista Multidimensional, generada previamente con la función **jsonLstm**.

* **elmnt** Filtro que identifica al elemento dentro de la lista. Por ejemplo: "1.nombre".

**Resultado**

Si el elemento existe en la lista devuelve su valor y, ademas, pone RFUNC["trae"] a 1. Si no existe, devuelve una cadena vacía "" y, además, pone RFUNC["trae"] a 0.

Ejemplo:

```bash
$ echo "[{\"nombre\": \"alfa\",\"edad\": 34}, {\"nombre\": \"beta\", \"edad\": 36}]" |
> gawk -i bbl_jdva.awk '{
>   cad_json[0]=$0;
>   jsonLstm(cad_json, lista);
>   print trae(lista, "2.edad");
> }'
36
```

## function quita(lista, elmnt)

Elimina elementos de una lista multidimensional que has sido generada previamente con la función **jsonLstm**.

**Argumentos**

* **lista** Lista Multidimensional, generada previamente con la función **jsonLstm**.

* **elmnt** Filtro que identifica al elemento dentro de la lista. Por ejemplo: "2.edad".

**Resultado**

Si el elemento existe en la lista, lo elimina y devuelve su posición. Ademas, pone RFUNC["quita"] a 1. Si no existe el elemento, devuelve 0. Además, pone RFUNC["quita"] a 0.

```bash
```

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