# Sonak

Es una interfaz de programación escrita en AWK que ofrece una serie de funciones para procesar textos en formato JSON.

## Instalación

1. Descarga el proyecto completo escribiendo:

        git clone git://github.com/Qaracas/sonak.git

2. (Opcional) Ejecuta el programa de validación:

        cd [ruta sonak]/pruebas
        ./verifica

3. Copia el fichero `src/ecma-404.awk` dentro del directorio `/usr/local/share/awk`, o dentro de cualquier otro directorio listado dentro de la variable de entorno AWKPATH.

Para poder *ver* las funciones de la biblioteca sonak desde tu programa AWK, incluye el fichero `ecma-404.awk` al principio del todo.

    @include "ecma-404.awk"

## Ejemplos de uso

### Convertir JSON en lista multidimensional

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

Entrada:

    {
        "nombre":"Pedro",
        "edad":42,
        "ciudad":"Madrid",
        "datos":{
            "C.V.":"Computación"
        }
    }

Resultado:

    [nombre] = "Pedro"
    [edad] = 42
    [ciudad] = "Madrid"
    [datos][C.V.] = "Computación"

### Eliminar elemento

    jsonLstm(cad_json, lista);
    quita(lista, "edad");
    pinta(lista);

Resultado:

    [nombre] = "Pedro"
    [ciudad] = "Madrid"
    [datos][C.V.] = "Computación"

### Modificar/añadir elemento

    jsonLstm(cad_json, lista);
    pon(lista, "apellidos", "Blanco Crespo");
    pon(lista, "edad", 17);
    pinta(lista);

Resultado:

    [nombre] = "Pedro"
    [edad] = 17
    [ciudad] = "Madrid"
    [datos][C.V.] = "Computación"
    [apellidos] = "Blanco Crespo"

### Traer elemento

    jsonLstm(cad_json, lista);
    print trae(lista, "nombre");

Resultado:

    Pedro

### Convertir lista multidimensional en JSON

    delete lista;
    pon(lista, "nombre", "Pedro");
    pon(lista, "apellidos", "Blanco Crespo");
    pon(lista, "edad", 17);
    pon(lista, "ciudad", "Madrid");
    pon(lista, "datos.C\\.V\\.", "Computación");
    
    lstmJson(lista, cad_json);
    
    print cad_json[0];

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

## Autores

* **Ulpiano Tur de Vargas** - *Versión inicial* - [Qaracas](https://github.com/Qaracas)

Echa un ojo a la lista de [personas](https://github.com/Qaracas/sonak/contributors) que han participado en este proyecto.

## Licencia

Este proyecto se distribuye bajo los términos de la Licencia Pública General de GNU (GNU GPL v3.0) - mira el archivo [LICENSE](LICENSE) para más detalle.
