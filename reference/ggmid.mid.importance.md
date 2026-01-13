# Advanced Visualizations for MID Importance

Extends
[`midr::ggmid`](https://ryo-asashi.github.io/midr/reference/ggmid.html)
to provide modern distribution plots for Maximum Interpretation
Decomposition (MID) feature importance. Added types include sina,
beeswarm, and violin plots.

## Usage

``` r
# S3 method for class 'mid.importance'
ggmid(
  object,
  type = NULL,
  theme = NULL,
  terms = NULL,
  max.nterms = 30,
  scale = NULL,
  method = NULL,
  ...
)
```

## Arguments

- object:

  a "mid.importance" object created by
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

- scale:

  a character string for sina and violin plots. Default is "width",
  ensuring all categories have equal maximum width regardless of
  density.

- method:

  a character string specifying the distribution algorithm. Default is
  "density" for `sinaplot` and "frowney" for `beeswarm`.

- ...:

  additional arguments passed to the underlying geoms.

## Value

a "ggplot" object.

## Details

This function wraps the S3 method of
[`midr::ggmid`](https://ryo-asashi.github.io/midr/reference/ggmid.html)
for "mid.importance" objects and replaces the primary layer with modern
distribution geoms when `type` is one of the extended options.

## Examples

``` r
data(diamonds, package = "ggplot2")
set.seed(42)
idx <- sample(nrow(diamonds), 5e3)
mid <- midr::interpret(price ~ (carat + cut + color + clarity)^2, diamonds[idx, ])
#> 'model' not passed: response variable in 'data' is used
imp <- midr::mid.importance(mid)

# Create a violin plot
midr::ggmid(imp, type = "violinplot")
#> Warning: Ignoring unknown parameters: `terms`


# Create a beeswarm plot
midr::ggmid(imp, type = "beeswarm", theme = "bluescale")
#> Warning: Ignoring unknown parameters: `terms`


# Create a sina plot
midr::ggmid(imp, type = "sinaplot", theme = "Zissou 1")
#> Warning: Ignoring unknown parameters: `terms`
```
