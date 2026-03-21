# Transition into and out of Midnight

`nightfall()` activates the extended features provided by the midnight
package. It registers customized S3 methods (e.g., for
[`ggmid.midimp()`](https://ryo-asashi.github.io/midnight/reference/ggmid.midimp.md)),
switches the underlying solvers to highly optimized Eigen-based
routines, and applies midnight-themed color palettes.

`daybreak()` reverses these changes, restoring the default behavior,
solvers, and themes of the midr package.

## Usage

``` r
nightfall(methods = TRUE, solvers = TRUE, themes = TRUE)

daybreak(methods = TRUE, solvers = TRUE, themes = TRUE)
```

## Arguments

- methods:

  logical. If `TRUE`, registers (or restores) the extended S3 methods.

- solvers:

  logical. If `TRUE`, switches (or restores) the calculation solvers for
  matrix responses.

- themes:

  logical. If `TRUE`, applies (or restores) the specific color themes.

## Value

`nightfall()` and `daybreak()` return an invisible list containing the
previous options for solvers and themes.
