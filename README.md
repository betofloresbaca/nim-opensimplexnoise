# Open Simplex Noise

This is a port of the open simplex noise algorithm based on [KdotJPG C# Open Simplex Noise](https://gist.github.com/KdotJPG/f271080228b55056e6da70c73eb3e9b1).

This implementation ports the C# implementation by KdotJPG without changing the sintax to be more nim-like, this can change in future releases to improve usage experience.

## Instalation

```bash
nimble install opensimplexnoise
```

## Usage

```nim
import opensimplexnoise

#[
    You can also provide a (seed : int64) parameter. Example:
    var noise = newOpenSimplex(141228)
]#
var noise = newOpenSimplex()

echo noise.evaluate(0.01, 0.02) # 2D noise
echo noise.evaluate(0.01, 0.02, 0.03) # 3D noise
echo noise.evaluate3XYBeforeZ(0.01, 0.02, 0.03) # 3D noise
echo noise.evaluate3XZBeforeY(0.01, 0.02, 0.03) # 3D noise
echo noise.evaluate(0.01, 0.02, 0.03, 0.04) # 4D noise
```

## Known Issues

This is a very early version of the implementation that could have bugs, however, this was tested using a large dataset generated using the [KdotJPG C# implementation](https://gist.github.com/KdotJPG/f271080228b55056e6da70c73eb3e9b1) (see tests/suite folder) and it passed all the tests, that means that it produces the same output as the original version.

The only possible bug that needs to be solved is that for the `newOpenSimplex` function there are some integer overflows needed. This is a bad practice for most programs so nim adds some checks to the generated program that avoids them throwing exceptions at running time. I tryed to disable that checks enclosing the unsecure code between `{.push overflowChecks: off.}` and `{.pop.}` but for some reason I need to also provide the `-d:danger` parameter in the CLI i.e. to test I run:

```bash
nimble -d:danger test
```

## More Information

For more information about the way all the OpenSimplexNoise methods work visit the KdotJPG resources:

* [C# implementation](https://gist.github.com/KdotJPG/f271080228b55056e6da70c73eb3e9b1)
* [Original Java Implementation](https://gist.github.com/KdotJPG/b1270127455a94ac5d19)

Thanks Kurt Spencer for developing this awesome algorithm.
