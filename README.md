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

## Documentación

Consultar [LEEME.ejemplos.md](LEEME.ejemplos.md) para ver ejemplos de uso.

## Autores

* **Ulpiano Tur de Vargas** - *Versión inicial* - [Qaracas](https://github.com/Qaracas)

Echa un ojo a la lista de [personas](https://github.com/Qaracas/sonak/contributors) que han participado en este proyecto.

## Licencia

Este proyecto se distribuye bajo los términos de la Licencia Pública General de GNU (GNU GPL v3.0) - mira el archivo [LICENSE](LICENSE) para más detalle.
