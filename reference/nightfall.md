# Transition into and out of Midnight

`nightfall()` activates the extended features provided by the midnight
package. It overrides specific S3 methods (such as `ggmid.midimp`),
switches the underlying solvers to highly optimized Eigen-based routines
via global options, and applies midnight-themed color palettes.

`daybreak()` reverses these changes, restoring the default behavior,
solvers, and themes of the midr package.

## Usage

``` r
nightfall(methods = TRUE, solvers = TRUE, themes = TRUE)

daybreak(methods = TRUE, solvers = TRUE, themes = TRUE)
```

## Arguments

- methods:

  logical. If `TRUE`, overrides (or restores) the `ggmid.midimp` S3
  method.

- solvers:

  logical. If `TRUE`, sets (or restores) calculation solvers via
  [`options()`](https://rdrr.io/r/base/options.html) (e.g.,
  `midr.solver.qr`, `midr.solver.svd`). These optimized solvers can be
  utilized by specifying the corresponding method in
  [`interpret()`](https://ryo-asashi.github.io/midr/reference/interpret.html)
  (e.g., `method = "qr"`).

- themes:

  logical. If `TRUE`, applies (or restores) color themes by setting
  [`options()`](https://rdrr.io/r/base/options.html) for
  `midr.qualitative`, `midr.sequential`, and `midr.diverging`.

## Value

`nightfall()` and `daybreak()` return an invisible list containing the
previous options for solvers and themes.
