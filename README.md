
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
library(ggplot2)
library(gridExtra)
library(tune)
library(rsample)
library(ISLR2)
theme_set(theme_midr())
```

``` r
# create a first-order mid surrogate model
mid_spec_1 <- mid_surrogate(
  params_main = 50, penalty = .1
) %>%
  set_mode("regression") %>%
  set_engine("midr", verbosity = 0)
mid_spec_1
#> mid surrogate Model Specification (regression)
#> 
#> Main Arguments:
#>   penalty = 0.1
#>   params_main = 50
#> 
#> Engine-Specific Arguments:
#>   verbosity = 0
#> 
#> Computational engine: midr
# fit the model
mid_1 <- mid_spec_1 %>%
  fit(medv ~ ., ISLR2::Boston)
mid_1
#> parsnip model object
#> 
#> 
#> Call:
#> interpret(x = x, y = y, weights = weights, k = k, lambda = penalty,
#>  verbosity = ..1)
#> 
#> Intercept: 22.533
#> 
#> Main Effects:
#> 12 main effect terms
#> 
#> Uninterpreted Variation Ratio: 0.055656
```

``` r
# create a second-order mid surrogate model via "custom formula"
mid_spec_2 <- mid_surrogate(
  params_main = 50, params_inter = 5, penalty = .1,
  custom_formula = medv ~ .^2
) %>%
  set_mode("regression") %>%
  set_engine("midr", verbosity = 0)
mid_spec_2
#> mid surrogate Model Specification (regression)
#> 
#> Main Arguments:
#>   penalty = 0.1
#>   params_main = 50
#>   params_inter = 5
#>   custom_formula = medv ~ .^2
#> 
#> Engine-Specific Arguments:
#>   verbosity = 0
#> 
#> Computational engine: midr
# fit the model
mid_2 <- mid_spec_2 %>%
  fit(medv ~ ., ISLR2::Boston) # pass original data on to interpret()
mid_2
#> parsnip model object
#> 
#> 
#> Call:
#> interpret(formula = medv ~ .^2, data = data, weights = weights,
#>  verbosity = ..1, k = k, lambda = penalty)
#> 
#> Intercept: 22.533
#> 
#> Main Effects:
#> 12 main effect terms
#> 
#> Interactions:
#> 66 interaction terms
#> 
#> Uninterpreted Variation Ratio: 0.032996
```

``` r
grid.arrange(nrow = 2,
 ggmid(mid.importance(mid_2$fit), theme = "moon", max.nterms = 15),
 ggmid(mid_2$fit, "lstat", main.effects = TRUE),
 ggmid(mid_2$fit, "dis", main.effects = TRUE),
 ggmid(mid_2$fit, "lstat:dis", theme = "moonlit")
)
```

<img src="man/figures/README-ggmid_2d_fit-1.png" width="100%" />

``` r
par.midr()
persp(mid_2$fit, "lstat:dis", theta = 150, phi = 20, shade = .5)
```

<img src="man/figures/README-persp_mid-1.png" width="100%" />

## Tune MID Surrogate Models using ‘tune’

``` r
# create a second-order mid surrogate model via "custom formula"
mid_spec <- mid_surrogate(
  params_main = tune(),
  params_inter = tune(),
  penalty = tune(),
  custom_formula = medv ~ .^2
) %>%
  set_mode("regression") %>%
  set_engine("midr", verbosity = 0)
mid_spec
#> mid surrogate Model Specification (regression)
#> 
#> Main Arguments:
#>   penalty = tune()
#>   params_main = tune()
#>   params_inter = tune()
#>   custom_formula = medv ~ .^2
#> 
#> Engine-Specific Arguments:
#>   verbosity = 0
#> 
#> Computational engine: midr
# define a cross validation method
set.seed(42)
cv <- vfold_cv(ISLR2::Boston, v = 2)
# execute the hyperparameter tuning
tune_res <- mid_spec %>%
  tune_bayes(
    medv ~ .,
    resamples = cv,
    iter = 50
  )
tune_best <- select_best(tune_res, metric = "rmse")
tune_best
#> # A tibble: 1 × 4
#>   penalty params_main params_inter .config
#>     <dbl>       <int>        <int> <chr>  
#> 1    11.4          60            5 Iter5
```

``` r
# create a second-order mid surrogate model via "custom formula"
mid_spec <- mid_surrogate(
  params_main = tune_best$params_main,
  params_inter = tune_best$params_inter,
  penalty = tune_best$penalty,
  custom_formula = medv ~ .^2
) %>%
  set_mode("regression") %>%
  set_engine("midr", verbosity = 0, singular.ok = TRUE)
mid_spec
#> mid surrogate Model Specification (regression)
#> 
#> Main Arguments:
#>   penalty = tune_best$penalty
#>   params_main = tune_best$params_main
#>   params_inter = tune_best$params_inter
#>   custom_formula = medv ~ .^2
#> 
#> Engine-Specific Arguments:
#>   verbosity = 0
#>   singular.ok = TRUE
#> 
#> Computational engine: midr
# fit the model
mid_tune <- mid_spec %>%
  fit(medv ~ ., ISLR2::Boston) # pass original data on to interpret()
mid_tune
#> parsnip model object
#> 
#> 
#> Call:
#> interpret(formula = medv ~ .^2, data = data, weights = weights,
#>  verbosity = ..1, k = k, lambda = penalty, singular.ok = ..2)
#> 
#> Intercept: 22.533
#> 
#> Main Effects:
#> 12 main effect terms
#> 
#> Interactions:
#> 66 interaction terms
#> 
#> Uninterpreted Variation Ratio: 0.1004
```

``` r
grid.arrange(nrow = 2,
 ggmid(mid.importance(mid_2$fit), theme = "moon", max.nterms = 15),
 ggmid(mid_tune$fit, "lstat", main.effects = TRUE),
 ggmid(mid_tune$fit, "dis", main.effects = TRUE),
 ggmid(mid_tune$fit, "lstat:dis", theme = "moonlit")
)
```

<img src="man/figures/README-ggmid_tune_fit-1.png" width="100%" />

``` r
par.midr()
persp(mid_tune$fit, "lstat:dis", theta = 150, phi = 20, shade = .5)
```

<img src="man/figures/README-persp_tuned_mid-1.png" width="100%" />
