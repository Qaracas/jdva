# The Vargas' JSON library (jdva)

* Read this in other languages: [Español](LEEME.md).

## What is `jdva`?

`jdva` is an [AWK](https://www.gnu.org/software/gawk/manual/gawk.html) library that offers functions to parse and create texts conform to the [JSON](https://json.org/index.html) grammar.

## Software requirements

* A recent version of AWK.

Note:

For `jdva` to work in Windows it is necessary to have AWK installed. [Git](https://git-scm.com/download/win) provides AWK.

## Installation

1. Download the complete project writing:

```bash
$ git clone git://github.com/Qaracas/jdva.git
```

2. Go to new created directory:

```bash
$ cd jdva
(jdva) $
```

3. (Opcional) Set [AWKPATH](https://www.gnu.org/software/gawk/manual/gawk.html#AWKPATH-Variable) environment variable:

```bash
(jdva) $ export AWKPATH=${AWKPATH}:.:"$(pwd)""/src"
```

4. (Optional) Run tests program:

```bash
(jdva) $ cd pruebas
(jdva/pruebas) $
(jdva/pruebas) $ ./haz_pruebas
```

5. Copy `src/bbl_jdva.awk` and `src/funcs_priv.awk` files into the `/usr/local/share/awk` directory, or into any other directory listed in [AWKPATH](https://www.gnu.org/software/gawk/manual/gawk.html#AWKPATH-Variable) environment variable.

To access `jdva` library functions from your AWK program, include the `bbl_jdva.awk` file at the beginning.

```awk
#!/usr/bin/gawk -E

@include "bbl_jdva.awk"

BEGIN {
    #...
}
```

Or pass it through the _include source file_ command line option.

```bash
gawk -i bbl_jdva.awk '{#...}'
```

## Documentation

See [README.tutorial.md](README.tutorial.md) for examples and [README.interface.md](README.interface.md) for a complete list of library functions.

Take a look the [ejemplos](https://github.com/Qaracas/jdva/tree/master/ejemplos) (examples) folder as well.

## References

This library aims to conform with the JSON (JavaScript Object Notation) data exchange format defined in:

* [RFC 7159](https://tools.ietf.org/html/rfc7159)
* [ECMA-404](http://www.ecma-international.org/publications/standards/Ecma-404.htm)

## Authors

* Initial version - [Qaracas](https://github.com/Qaracas)
* [List of contributors](https://github.com/Qaracas/jdva/contributors)

## License

This project is distributed under the terms of the GNU General Public License (GNU GPL v3.0). Look at the file [LICENSE](LICENSE) for more details.
