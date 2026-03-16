# Advanced Visualizations for MID Importance

Extends
[`midr::ggmid`](https://ryo-asashi.github.io/midr/reference/ggmid.html)
to provide modern distribution plots for Maximum Interpretation
Decomposition (MID) feature importance. Added types include sina,
beeswarm, and violin plots.

## Usage

``` r
# S3 method for class 'midimp'
ggmid(object, type = NULL, theme = NULL, terms = NULL, max.nterms = 30, ...)
```

## Arguments

- object:

  a "midimp" object created by
  [`midr::mid.importance`](https://ryo-asashi.github.io/midr/reference/mid.importance.html).

- type:

  a character string specifying the plot type. In addition to standard
  types ("barplot", "boxplot", "dotchart", "heatmap"), this extended
  method supports "violinplot", "sinaplot", and "beeswarm".

- theme:

  a character string for the visual theme.

- terms:

  a character vector of terms to include. If `NULL` (default), all terms
  are shown.

- max.nterms:

  an integer. The maximum number of terms to display.

- ...:

  additional arguments passed to the underlying geoms.

## Value

`ggmid.midimp()` returns a "ggplot" object.

## Details

This function wraps the S3 method of
[`midr::ggmid`](https://ryo-asashi.github.io/midr/reference/ggmid.html)
for "midimp" objects and replaces the primary layer with modern
distribution geoms when `type` is one of the extended options.

## Examples

``` r
mid <- midr::interpret(Ozone ~ .^2, airquality, lambda = .5)
#> 'model' not passed: response variable in 'data' is used
imp <- midr::mid.importance(mid)

# Create a violin plot
midr::ggmid(imp, type = "violinplot", theme = "HCL")


# Create a beeswarm plot
midr::ggmid(imp, type = "beeswarm", theme = "shap")


# Create a sina plot
midr::ggmid(imp, type = "sinaplot", theme = "bicolor")
```
