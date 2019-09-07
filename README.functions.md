# `jdva` library functions

## jsonLstm(json, lista)

Create a multidimensional array from a JSON formatted text string.

**Arguments**

* **json** (1) A pointer to string in JSON format. That is, a one dimensional array of a single element whose index is 0 and his value is a JSON formatted text string.

* **lista** Multidimensional array where the `jsonLstm` function stores the values, and structure, of the input JSON formatted text.

Example:

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

(1) It has been decided to use this _trick_ to force pass the arguments by reference, rather than by value. Except arrays, in [AWK](https://www.gnu.org/software/gawk/manual/gawk.html), any argument is passed by value.

## lstmJson(lista, json)

Obtain a JSON formatted text string, starting from a multidimensional array previously created with the `jsonLstm` function.

**Arguments**

* **lista** A multidimensional array previously created with the `jsonLstm` function.

* **json** A pointer to string in JSON format. That is, a one dimensional array of a single element whose index is 0 and his value is a JSON formatted text string. Such JSON formatted text string, is created by the `lstmJson` function preserving the values, and structure, of the multidimensional array taken as the first argument.

Example:

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

Print on the standard output the content and structure of a multidimensional array.

**Arguments**

* **lista** A multidimensional array previously created with the `jsonLstm` function.

* **frmt** Format string. For example: `"%s\t"`.

Example:

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

Returns the value of an element located within a multidimensional array, previously generated with the `jsonLstm` function, based on a filter that identifies it.

**Arguments**

* **lista** A multidimensional array previously created with the `jsonLstm` function.

* **elmnt** Filter that identifies an element within a multidimensional array structured as a JSON. For example: `"1.name"`.

**Result**

If the item exists in the array, `trae` returns its value and, in addition, sets `RFUNC["trae"]` to 1. If it does not exist, it returns an empty string `""` and, in addition, sets `RFUNC["trae"]` to 0.

Example:

```bash
$ echo "[{\"nombre\": \"alfa\",\"edad\": 34}, {\"nombre\": \"beta\", \"edad\": 36}]" |
> gawk -i bbl_jdva.awk '{
>   cad_json[0]=$0;
>   jsonLstm(cad_json, lista);
>   print trae(lista, "[2].edad");
> }'
36
```

## quita(lista, elmnt)

Remove elements from a multidimensional array that has been previously generated with the `jsonLstm` function.

**Arguments**

* **lista** A multidimensional array previously created with the `jsonLstm` function.

* **elmnt** Filter that identifies an element within a multidimensional array structured as a JSON. For example: `"2.edad"`.

**Result**

If the item exists in array, `quita` deletes it and returns its position. Also, set `RFUNC["quita"]` to 1. If the item does not exist, return 0. In addition, set `RFUNC["quita"]` to 0.

Example:

```bash
$ echo "[{\"nombre\": \"alfa\",\"edad\": 34}, {\"nombre\": \"beta\", \"edad\": 36}]" |
> gawk -i bbl_jdva.awk '{
>   cad_json[0]=$0;
>   jsonLstm(cad_json, lista);
>   quita(lista, "[1].edad");
>   lstmJson(lista, cad_json);
>   sangra(cad_json);
> }'
[
    {"nombre": "alfa"},
    {
        "nombre": "beta",
        "edad": 36
    }
]
```

## function pon(lista, elmnt, valor)

Add new item in a multidimensional array structured as a JSON, or modify the value of an existing one.

**Argumentos**

* **lista** A multidimensional array previously created with the `jsonLstm` function.

* **elmnt** Filter that identifies an element within a multidimensional array structured as a JSON. For example: `"2.edad"`.

* **valor** Value of the new item, or new value (if the item identified by the filter already exists)

**Result**

Returns the position of new element, or the position of the existing one that has been modified.

Example:

```bash
$ gawk -i bbl_jdva.awk 'BEGIN{
> json[0]="";
> delete lista;
> pon(lista, "nombre", "Juan");
> pon(lista, "dirección.tipo", "Calle");
> pon(lista, "dirección.nombre", "de la Diligencia");
> pon(lista, "dirección.número", 23);
> lstmJson(lista, json);
> sangra(json);
> }'
{
    "nombre": "Juan",
    "dirección": {
        "tipo": "Calle",
        "nombre": "de la Diligencia",
        "número": 23
    }
}
```

## function sangra(json)

Pretty print the JSON formatted text string passed as an argument.

**Arguments**

* **json** A pointer to string in JSON format. That is, a one dimensional array of a single element whose index is 0 and his value is a JSON formatted text string. Such JSON formatted text string, is created by the `lstmJson` function preserving the values, and structure, of the multidimensional array taken as the first argument.

Example:

```bash
$ echo "[{\"nombre\": \"alfa\",\"edad\": 34}, {\"nombre\": \"beta\", \"edad\": 36}]" |
> gawk -i bbl_jdva.awk '{
> print $0 "\n";
> json[0]=$0;
> sangra(json);
> }'
[{"nombre": "alfa","edad": 34}, {"nombre": "beta", "edad": 36}]

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