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
```

3. (Opcional) Set [AWKPATH](https://www.gnu.org/software/gawk/manual/gawk.html#AWKPATH-Variable) environment variable:

```bash
$ export AWKPATH=${AWKPATH}:.:"$(pwd)""/src"
```

4. (Optional) Run the validation program:

```bash
$ cd [ruta jdva]/pruebas
$ ./verifica
```

5. Copy `src/bbl_jdva.awk` and `src/funcs_priv.awk` files into the `/usr/local/share/awk` directory, or into any other directory listed in [AWKPATH](https://www.gnu.org/software/gawk/manual/gawk.html#AWKPATH-Variable) environment variable.

To access functions of the `jdva` library from your AWK program, include the `bbl_jdva.awk` file at the beginning.

```awk
#!/usr/bin/gawk -E

@include "bbl_jdva.awk"

BEGIN {
    ...
}
```

## Documentation

See [README.examples.md](README.examples.md) for examples of use and a list of interface functions.

## References

This library aims to conform with the JSON (JavaScript Object Notation) data exchange format defined in:

* [RFC 7159](https://tools.ietf.org/html/rfc7159)
* [ECMA-404](http://www.ecma-international.org/publications/standards/Ecma-404.htm)


## Authors

* Initial version - [Qaracas](https://github.com/Qaracas)
* [List of contributors](https://github.com/Qaracas/jdva/contributors)

## License

This project is distributed under the terms of the GNU General Public License (GNU GPL v3.0). Look at the file [LICENSE](LICENSE) for more details.
