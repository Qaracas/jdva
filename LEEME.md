# La biblioteca JSON de Vargas (jdva)

## ¿Qué es `jdva`?

`jdva` es una biblioteca escrita en [AWK](https://www.gnu.org/software/gawk/manual/gawk.html) con funciones para procesar y crear textos ajustados a la gramática [JSON](https://json.org/json-es.html).

## Requisitos

* Alguna versión reciente de `GNU Awk`.

Nota:

Para que `jdva` funcione en Windows es necesario instalar AWK. [Git](https://git-scm.com/download/win) proporciona AWK.

## Instalación

1. Descargar el proyecto completo escribiendo:

```bash
$ git clone git://github.com/Qaracas/jdva.git
```

2. Ir al recién creado directorio:

```bash
$ cd jdva
(jdva) $
```

3. (Opcional) Fijar la variable de entorno [AWKPATH](https://www.gnu.org/software/gawk/manual/gawk.html#AWKPATH-Variable):

```bash
(jdva) $ export AWKPATH=${AWKPATH}:.:"$(pwd)""/src"
```

4. (Opcional) Ejecutar programa de validación:

```bash
(jdva) $ cd pruebas
(jdva/pruebas) $
(jdva/pruebas) $ ./haz_pruebas
```

5. Copiar los ficheros `src/bbl_jdva.awk` y `src/funcs_priv.awk` dentro del directorio `/usr/local/share/awk`, o dentro de cualquier otro directorio listado en la variable de entorno [AWKPATH](https://www.gnu.org/software/gawk/manual/gawk.html#AWKPATH-Variable).

Para acceder a las funciones de la biblioteca `jdva` desde tu programa AWK, incluye el fichero `bbl_jdva.awk` al principio del todo.

```awk
#!/usr/bin/gawk -E

@include "bbl_jdva.awk"

BEGIN {
    #...
}
```

## Documentación

Consultar la guía de aprendizaje en [LEEME.tutorial.md](LEEME.tutorial.md), y la lista de funciones de la biblioteca en [LEEME.interfaz.md](LEEME.interfaz.md).

Echar también un ojo a los [ejemplos](https://github.com/Qaracas/jdva/tree/master/ejemplos).

## Referencias

Esta librería pretende ser compatible con el formato de intercambio de datos JSON (JavaScript Object Notation) definido en:

* [RFC 7159](https://tools.ietf.org/html/rfc7159)
* [ECMA-404](http://www.ecma-international.org/publications/standards/Ecma-404.htm)

## Autores

* Versión inicial - [Qaracas](https://github.com/Qaracas)
* [Lista de contribuyentes](https://github.com/Qaracas/jdva/contributors)

## Licencia

Este proyecto se distribuye bajo los términos de la Licencia Pública General de GNU (GNU GPL v3.0). Mira el archivo [LICENSE](LICENSE) para más detalle.
