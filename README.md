# Unicode test data for JavaScript

If you ever need JavaScript arrays of all Unicode symbols per category per Unicode version (for testing purposes, perhaps), or JavaScript-compatible regular expressions to match those symbols, this directory has got you covered. Because of [the way JavaScript exposes “characters”](http://mathiasbynens.be/notes/javascript-encoding), generating this data is trickier than it sounds, as you have to account for surrogate pairs.

For example, I’ve used a variation of this data in the following test case: <http://mathias.html5.org/tests/javascript/identifiers/> It dynamically creates and runs over 90k tests, based on [the appropriate Unicode categories and symbols](http://mathiasbynens.be/notes/javascript-identifiers).

## Generated data

Per Unicode **category**, a number of separate files will be created:

 * `${version}/categories/${category}-code-points.js`: a JavaScript-compatible array containing all numerical Unicode code points in that category.
 * `${version}/categories/${category}-symbols.js`: a JavaScript-compatible array containing all Unicode symbols in that category as strings.
 * `${version}/categories/${category}-regex.js`: a JavaScript-compatible regular expression that matches all Unicode symbols in that category.

The same thing is done for **scripts**, **blocks**, and **properties**.

The data is currently being generated for the following Unicode versions:

 * 2.0.14
 * 2.1.9
 * 3.0.1
 * 3.2.0
 * 4.0.1
 * 4.1.0
 * 5.0.0
 * 5.1.0
 * 5.2.0
 * 6.0.0
 * 6.1.0
 * 6.2.0
 * 6.3.0

I’ll update this repository (and this list) as soon as new Unicode versions are released.

## How to generate the data

I’ve included the Python (v2.7.1) and Bash (v3.2.48) scripts I wrote to generate these files. I’m new to Python, so [suggestions on how to improve these scripts are more than welcome](https://github.com/mathiasbynens/unicode-data/issues/new)!

To (re-)generate all data in this repository, run:

```bash
./generate.sh
```

## Tests for the generated data

The generated data is fully tested by a script that verifies that, within the range of code points from `0x000000` to `0x10FFFF`, _only_ the symbols in `${version}/${category}-symbols.js` are matched by the regular expression in `${version}/${category}-regex.js`. [This rather heavy test case (which runs over 33 million assertions) is available online.](http://mathias.html5.org/data/unicode/test?version=6.1.0)

## HTTP API

I’ve set up an HTTP API of sorts, which allows you to customize the output a little bit. This saves you from downloading, editing, and re-hosting the generated files if you just want to write some quick tests. Here’s an example:

```
http://mathias.html5.org/data/unicode/format?version=6.2.0&category=Ll&type=symbols&prepend=window.symbols%20%3D%20&append=%3B
```

### Available query string parameters

 * `category`: can be any Unicode category
 * `script`: can be any Unicode script
 * `property`: can be any Unicode property
 * `block`: can be any Unicode block
 * `type`: can be `code-points`, `symbols` or `regex`; defaults to `symbols`
 * `version`: can be any Unicode version for which data is available; defaults to the latest available version
 * `prepend`: a string to prepend to the output; defaults to the empty string
 * `append`: a string to append to the output; defaults to the empty string

## Credits

Thanks to:

 * [Yusuke Suzuki](http://twitter.com/Constellation) for writing [his Unicode database parser in Python](http://code.google.com/p/esprima/issues/detail?id=110#c1).
 * [Michaeljohn “inimino” Clement](http://inimino.org/) for [detailing the problems with regular expression ranges in JavaScript](http://inimino.org/~inimino/blog/javascript_cset).
 * [Jan Moesen](http://jan.moesen.nu/) for teaching me about Bash’s Insanely Fantastic Splitting™.
 * [Steven Levithan](http://stevenlevithan.com/) for the valuable feedback and suggestions.

## Author

[Mathias Bynens](http://mathiasbynens.be/)
