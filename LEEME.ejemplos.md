# Documentación

## Interfaz de programación

<table>
<tr>
<th align="left">
jsonLstm
</th>
</tr>
<tr>
<td>
<pre>

**function jsonLstm(json, lista)**

Trasforma una cadena de texto en formato JSON en una lista multidimensional 
(en adelante nombrada como lista jotasonizada).

**Argumentos:**
   json  - Puntero a cadena de texto en formato JSON.
   lista - Lista multidimensional jotasonizada.
</pre>
</td>
</tr>
<tr>
<th align="left">
lstmJson
</th>
</tr>
<tr>
<td>
<pre>

**function lstmJson(lista, json)**

Trasforma una lista multidimensional jotasonizada en una cadena de texto en formato JSON.

**Argumentos:**
    json  - Puntero a cadena de texto en formato JSON.
    lista - Lista multidimensional jotasonizada.
</pre>
</td>
</tr>
<tr>
<th align="left">
pinta
</th>
</tr>
<tr>
<td>
<pre>

**function pinta(lista, frmt)**

Pinta por pantalla una lista multidimensional

**Argumentos:**
    lista - Lista multidimensional jotasonizada.
    frmt  - Formato de representación. Por ejemplo: "%s ,"
</pre>
</td>
</tr>
<tr>
<th align="left">
trae
</th>
</tr>
<tr>
<td>
<pre>

**function trae(lista, elmnt)**

Busca un elemento localizado dentro de una lista multidimensional jotasonizada y devuelve su valor.

**Argumentos:**
    lista - Lista multidimensional jotasonizada.
    elmnt - Elemento a buscar en formato "a.b.c".
</pre>
</td>
</tr>
<tr>
<th align="left">
quita
</th>
</tr>
<tr>
<td>
<pre>

**function quita(lista, elmnt)**

Elimina elementos de una lista multidimensional jasonizada.

**Argumentos:**
    lista - Lista multidimensional jotasonizada.
    elmnt - Elemento a aliminar en formato "a.b.c".
</pre>
</td>
</tr>
<tr>
<th align="left">
pon
</th>
</tr>
<tr>
<td>
<pre>

**function pon(lista, elmnt, valor)**

Añade un nuevo elemento a la lista jotasonizada o modifica el valor de uno ya existente.

**Argumentos:**
    lista - Lista multidimensional jotasonizada.
    elmnt - Elemento para añadir/modificar en formato "a.b.c".
    valor - Valor del nuevo elemento o nuevo valor para el elemento ya existente.
</pre>
</td>
</tr>
</table> 
 
## Ejemplos de uso

### Convertir JSON en lista multidimensional

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

### Eliminar elemento

```awk
jsonLstm(cad_json, lista);
quita(lista, "edad");
pinta(lista);
```

Resultado:

    [nombre] = "Pedro"
    [ciudad] = "Madrid"
    [datos][C.V.] = "Computación"

### Modificar/añadir elemento

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

### Traer elemento

```awk
jsonLstm(cad_json, lista);
print trae(lista, "nombre");
```

Resultado:

    Pedro

### Convertir lista multidimensional en JSON

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
