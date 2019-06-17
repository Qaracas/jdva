# Sonak

## ¿Qué es `sonak`?

`Sonak` es una interfaz de programación escrita en [AWK](https://www.gnu.org/software/gawk/manual/gawk.html) que ofrece funciones para procesar y crear texto en formato [JSON](https://json.org/json-es.html).

## Requisitos

* `GNU Awk 4.2.1, API: 2.0 (GNU MPFR 4.0.1, GNU MP 6.1.2)` o superior.

Nota:

Para que `sonak` funcione en Windows es necesario tener AWK instalado. [Git](https://git-scm.com/download/win) proporciona AWK.

## Instalación

1. Descarga el proyecto completo escribiendo:

```bash
$ git clone git://github.com/Qaracas/sonak.git
```

2. (Opcional) Ejecuta el programa de validación:

```bash
$ cd [ruta sonak]/pruebas
$ ./verifica
```

3. Copia el fichero `src/ecma-404.awk` dentro del directorio `/usr/local/share/awk`, o dentro de cualquier otro directorio listado en la variable de entorno [AWKPATH](https://www.gnu.org/software/gawk/manual/gawk.html#AWKPATH-Variable).

Para acceder a las funciones de la biblioteca `sonak` desde tu programa AWK, incluye el fichero `ecma-404.awk` al principio del todo.

```awk
#!/usr/bin/gawk -E

@include "../src/ecma-404.awk"

BEGIN {
    ...
}
```

## Documentación

Consultar [LEEME.ejemplos.md](LEEME.ejemplos.md) para ver ejemplos de uso y una lista con las funciones de la interfaz.

## Autores

* Versión inicial - [Qaracas](https://github.com/Qaracas)
* [Lista de contribuyentes](https://github.com/Qaracas/sonak/contributors)

## Licencia

Este proyecto se distribuye bajo los términos de la Licencia Pública General de GNU (GNU GPL v3.0). Mira el archivo [LICENSE](LICENSE) para más detalle.
