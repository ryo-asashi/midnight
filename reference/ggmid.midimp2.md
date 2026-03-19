# Plot MID Importance with ggplot2

Extends
[`midr::ggmid()`](https://ryo-asashi.github.io/midr/reference/ggmid.html)
to provide modern distribution plots for MID feature importance. Added
types include sina, beeswarm, and violin plots.

## Usage

``` r
# S3 method for class 'midimp2'
ggmid(object, type = NULL, theme = NULL, terms = NULL, max.nterms = 30, ...)
```

## Arguments

- object:

  a "midimp2" object to be visualized.

- type:

  the plotting style. In addition to standard types ("barplot",
  "boxplot", "dotchart", "heatmap"), this extended method supports
  "violinplot", "sinaplot", and "beeswarm".

- theme:

  a character string or object defining the color theme. See
  [`color.theme`](https://ryo-asashi.github.io/midr/reference/color.theme.html)
  for details.

- terms:

  an optional character vector specifying which terms to display.

- max.nterms:

  an integer specifying the maximum number of terms to display. Defaults
  to 30.

- ...:

  optional parameters passed on to the layers.

## Value

`ggmid.midimp()` returns a "ggplot" object.

## Details

This is an S3 method for the
[`midr::ggmid()`](https://ryo-asashi.github.io/midr/reference/ggmid.html)
generic for "midimp2" objects created by
[`midnight::mid.importance()`](https://ryo-asashi.github.io/midnight/reference/mid.importance.md).
This method replaces the primary layer with modern distribution geoms
when `type` is one of the extended options.

## See also

[`mid.importance`](https://ryo-asashi.github.io/midnight/reference/mid.importance.md)

## Examples

``` r
mid <- midr::interpret(Ozone ~ .^2, airquality, lambda = .5)
#> 'model' not passed: response variable in 'data' is used
imp <- mid.importance(mid)

# Create a violin plot
ggmid(imp, type = "violinplot", theme = "moon")


# Create a beeswarm plot
ggmid(imp, type = "beeswarm", theme = "Hokusai3")


# Create a sina plot
ggmid(imp, type = "sinaplot", theme = "bicolor")
```
