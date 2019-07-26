# Sonak

* Read this in other languages: [Español](LEEME.md).

## What is `sonak`?

`Sonak` is a programming interface written in [AWK](https://www.gnu.org/software/gawk/manual/gawk.html) that offers functions to parse and create texts conform to the [JSON](https://json.org/index.html) grammar.

## Software requirements

* A recent version of AWK.

Note:

For `sonak` to work in Windows it is necessary to have AWK installed. [Git](https://git-scm.com/download/win) provides AWK.

## Installation

1. Download the complete project writing:

```bash
$ git clone git://github.com/Qaracas/sonak.git
```

2. (Optional) Run the validation program:

```bash
$ cd [ruta sonak]/pruebas
$ ./verifica
```

3. Copy the `src/ecma-404.awk` file into the `/usr/local/share/awk` directory, or into any other directory listed in the [AWKPATH](https://www.gnu.org/software/gawk/manual/gawk.html#AWKPATH-Variable) environment variable.

To access the functions of the `sonak` library from your AWK program, include the` ecma-404.awk` file at the beginning.

```awk
#!/usr/bin/gawk -E

@include "../src/ecma-404.awk"

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
* [List of contributors](https://github.com/Qaracas/sonak/contributors)

## License

This project is distributed under the terms of the GNU General Public License (GNU GPL v3.0). Look at the file [LICENSE](LICENSE) for more details.
