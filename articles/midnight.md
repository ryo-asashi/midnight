# Introduction to midnight: Core Modeling and Fast Solvers

The **midnight** package is designed to provide robust modeling
capabilities and highly optimized solvers, working seamlessly alongside
the **midr** package. The core philosophy of **midnight** revolves
around its two main functionalities:

1.  [`mid_reg()`](https://ryo-asashi.github.io/midnight/reference/mid_reg.md):
    A seamless **tidymodels** (**parsnip**) interface for intuitive
    model specification.

2.  [`fastLmMatrix()`](https://ryo-asashi.github.io/midnight/reference/fastLmMatrix.md):
    High-performance multivariate least squares solvers designed for
    speed and efficiency.

In addition to these core computational features, the package offers
advanced visualization tools and integrated color themes.

## The Tidymodels Interface

**midnight** fully integrates with the **tidymodels** ecosystem. The
[`mid_reg()`](https://ryo-asashi.github.io/midnight/reference/mid_reg.md)
function allows you to specify models using the familiar **parsnip**
syntax, enabling pipeline-based workflows for model fitting and
hyperparameter tuning.

``` r
library(midr)
library(midnight)
library(parsnip)
library(ggplot2)
library(patchwork)

# fitting a model with interaction using mid_reg()
mid <- mid_reg(
  params_main = 50, # k
  penalty = 5 # lambda
) |>
  fit(Ozone ~ (Wind + Solar.R) ^ 2, na.omit(airquality))

mid
#> parsnip model object
#> 
#> 
#> Call:
#> interpret(formula = Ozone ~ (Wind + Solar.R)^2, data = data,
#>  model = NULL, weights = NULL, k = 50, k2 = NULL, lambda = 5,
#>  terms = terms)
#> 
#> Intercept: 42.099
#> 
#> Main Effects:
#> 2 main effect terms
#> 
#> Interactions:
#> 1 interaction term
#> 
#> Uninterpreted Variation Ratio: 0.33087
```

## High-Performance Least Square Solvers

For situations requiring fitting a surrogate model for multivariate
responses, **midnight** provides highly optimized OLS solvers. You can
compare standard **RcppEigen** implementations with the matrix-based
solvers provided by **midnight**.

``` r
# standard RcppEigen solver
fit1 <- RcppEigen::fastLm(
  Ozone ~ Wind + Solar.R, na.omit(airquality)
)
print(as.matrix(fit1$coefficients))
#>                   [,1]
#> (Intercept) 77.2460424
#> Wind        -5.4017973
#> Solar.R      0.1003506
fit2 <- RcppEigen::fastLm(
  Temp ~ Wind + Solar.R, na.omit(airquality)
)
# fastLmMatrix
print(as.matrix(fit2$coefficients))
#>                    [,1]
#> (Intercept) 85.70227521
#> Wind        -1.25187025
#> Solar.R      0.02453254
fit3 <- fastLmMatrix(
  cbind(Ozone, Temp) ~ Wind + Solar.R, na.omit(airquality)
)
print(fit3$coefficients)
#>                  Ozone        Temp
#> (Intercept) 77.2460424 85.70227521
#> Wind        -5.4017973 -1.25187025
#> Solar.R      0.1003506  0.02453254
```

Furthermore, you can globally override the default Least Squares Solvers
used in
[`mid_reg()`](https://ryo-asashi.github.io/midnight/reference/mid_reg.md)
(and
[`interpret()`](https://ryo-asashi.github.io/midr/reference/interpret.html))
to leverage this speed boost across your entire modeling pipeline by
using
[`nightfall()`](https://ryo-asashi.github.io/midnight/reference/nightfall.md).

``` r
# activate midnight package
nightfall()

mids <- mid_reg(
  params_main = 50, # k
  penalty = 5 # lambda
) |>
  fit(cbind(Ozone, Temp) ~ (Wind + Solar.R) ^ 2, airquality)
#> custom solver 'qr' is used

mids
#> parsnip model object
#> 
#> 
#> Call:
#> interpret(formula = cbind(Ozone, Temp) ~ (Wind + Solar.R)^2,
#>  data = data, model = NULL, weights = NULL, k = 50, k2 = NULL,
#>  lambda = 5, terms = terms)
#> 
#> Intercept: 42.099, 77.793
#> 
#> Main Effects:
#> 2 main effect terms
#> 
#> Interactions:
#> 1 interaction term
#> 
#> Uninterpreted Variation Ratio: 0.33087, 0.52745
```

## New Visualization Styles

To understand the output of
[`mid_reg()`](https://ryo-asashi.github.io/midnight/reference/mid_reg.md),
**midnight** provides S3 methods for MID models like
[`persp.mid()`](https://ryo-asashi.github.io/midnight/reference/persp.mid.md)
and
[`ggmid.midimp()`](https://ryo-asashi.github.io/midnight/reference/ggmid.midimp.md),
which is activated when
[`nightfall()`](https://ryo-asashi.github.io/midnight/reference/nightfall.md)
is called. These methods help translate complex model outputs into
interpretable insights.

### Variable Importance

Using `ggmid(type = 'beeswarm')`, as well as `'violinplot'` or
`'sinaplot'`, you can effortlessly plot feature importance distributions
to understand the impact of individual variables and their interactions.

``` r
imp <- mid.importance(mid$fit, data = airquality)
p1 <- ggmid(imp, type = "beeswarm", theme = "Hokusai3") +
  theme(legend.position = "bottom")
p2 <- ggmid(imp, type = "violin", theme = "moon") +
  theme(legend.position = "bottom")
p1 + p2
```

![](midnight_files/figure-html/midimp-1.png)

### Joint Effect Surface

The S3 method of [`persp()`](https://rdrr.io/r/graphics/persp.html) for
“mid” creates surface plots, making it easy to examine the joint effect
of two predictors.

``` r
par.midr(mar = c(0, 0, 0, 0))
persp(mid$fit, "Wind:Solar.R", theta = 45, phi = 30)
```

![](midnight_files/figure-html/persp-1.png)

## Additional Color Themes

To ensure the visualizations are both accurate and aesthetically
pleasing, **midnight** adds a wide array of color palettes from
**colormap**, *DALEX* and **MetBrewer** as well as three original
themes.

### Qualitative Themes

![](midnight_files/figure-html/qualitative-1.png)![](midnight_files/figure-html/qualitative-2.png)![](midnight_files/figure-html/qualitative-3.png)![](midnight_files/figure-html/qualitative-4.png)![](midnight_files/figure-html/qualitative-5.png)![](midnight_files/figure-html/qualitative-6.png)![](midnight_files/figure-html/qualitative-7.png)![](midnight_files/figure-html/qualitative-8.png)

### Sequential Themes

![](midnight_files/figure-html/sequential-1.png)![](midnight_files/figure-html/sequential-2.png)![](midnight_files/figure-html/sequential-3.png)![](midnight_files/figure-html/sequential-4.png)![](midnight_files/figure-html/sequential-5.png)![](midnight_files/figure-html/sequential-6.png)![](midnight_files/figure-html/sequential-7.png)![](midnight_files/figure-html/sequential-8.png)![](midnight_files/figure-html/sequential-9.png)![](midnight_files/figure-html/sequential-10.png)![](midnight_files/figure-html/sequential-11.png)![](midnight_files/figure-html/sequential-12.png)![](midnight_files/figure-html/sequential-13.png)![](midnight_files/figure-html/sequential-14.png)

### Diverging Themes

![](midnight_files/figure-html/diverging-1.png)![](midnight_files/figure-html/diverging-2.png)![](midnight_files/figure-html/diverging-3.png)![](midnight_files/figure-html/diverging-4.png)

## Summary

The **midnight** package combines the computational speed of
[`fastLmMatrix()`](https://ryo-asashi.github.io/midnight/reference/fastLmMatrix.md)
with the modern API of **tidymodels** via
[`mid_reg()`](https://ryo-asashi.github.io/midnight/reference/mid_reg.md).
When paired with its powerful visualization and color theme systems, it
provides a comprehensive toolkit for building, scaling, and interpreting
sophisticated models.
