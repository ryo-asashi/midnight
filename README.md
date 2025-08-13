
<!-- README.md is generated from README.Rmd. Please edit that file -->

# midnight <img src="man/figures/logo.png" align="right" height="138"/>

<!-- badges: start -->

<!-- badges: end -->

The ‘midnight’ package implements a ‘parsnip’ engine for the ‘midr’
package, allowing users to seamlessly fit, tune, and evaluate MID
(Maximum Interpretation Decomposition) models with ‘tidymodels’
workflows. Development and augmentation of the package are driven by
research from the “Moonlight Seminar 2025”, a collaborative study group
of actuaries from the Institute of Actuaries of Japan focused on
advancing the practical applications of interpretable models.

## Installation

You can install the development version of midnight from
[GitHub](https://github.com/) with:

``` r
# install.packages("pak")
pak::pak("ryo-asashi/midnight")
```

## Fit MID Surrogate Models using ‘parsnip’

This is a basic example which shows you how to solve a common problem:

``` r
library(parsnip)
library(midr)
library(midnight)
library(khroma)
library(ggplot2)
library(gridExtra)
theme_set(theme_midr())
# create a first-order mid surrogate model
mid_spec_1 <- mid_surrogate() %>%
  set_mode("regression") %>%
  set_engine("midr", verbosity = 3)
mid_spec_1
#> mid surrogate Model Specification (regression)
#> 
#> Engine-Specific Arguments:
#>   verbosity = 3
#> 
#> Computational engine: midr
# fit the model
mid_1 <- mid_spec_1 %>%
  fit_xy(x = airquality[, -1], y = airquality[1])
mid_1
#> parsnip model object
#> 
#> 
#> Call:
#> interpret(x = x, y = y, weights = weights, k = k, lambda = penalty,
#>  verbosity = ..1)
#> 
#> Intercept: 42.099
#> 
#> Main Effects:
#> 5 main effect terms
#> 
#> Uninterpreted Variation Ratio: 0.028441
# create a second-order mid surrogate model via "custom formula"
mid_spec_2 <- mid_surrogate(
  params_main = 50, params_inter = 5, penalty = .9,
  custom_formula = Ozone ~ .^2
) %>%
  set_mode("regression") %>%
  set_engine("midr", verbosity = 3)
# fit the model
mid_2 <- mid_spec_2 %>%
  fit_xy(x = airquality[, -1], y = airquality[1])
mid_2
#> parsnip model object
#> 
#> 
#> Call:
#> interpret(formula = Ozone ~ .^2, data = data, weights = weights,
#>  verbosity = ..1, k = k, lambda = penalty)
#> 
#> Intercept: 42.099
#> 
#> Main Effects:
#> 5 main effect terms
#> 
#> Interactions:
#> 10 interaction terms
#> 
#> Uninterpreted Variation Ratio: 0.073086
```

``` r
grid.arrange(nrow = 2,
 ggmid(mid.importance(mid_2$fit), theme = "muted"),
 ggmid(mid_2$fit, "Temp", main.effects = TRUE),
 ggmid(mid_2$fit, "Wind", main.effects = TRUE),
 ggmid(mid_2$fit, "Temp:Wind", main.effects = TRUE, theme = "tokyo") 
)
```

<img src="man/figures/README-unnamed-chunk-2-1.png" width="100%" />
