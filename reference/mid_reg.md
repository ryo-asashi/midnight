# MID Regression

`mid_reg()` defines a model that can predict numeric values from
predictors using a set of functions each with up to two predictors. This
function can fit regression models.

## Usage

``` r
mid_reg(
  mode = "regression",
  engine = "midr",
  model = NULL,
  params_main = NULL,
  params_inter = NULL,
  penalty = NULL,
  terms = NULL
)

fit_mid_reg(
  formula,
  data,
  weights = NULL,
  model = NULL,
  params_main = NULL,
  params_inter = NULL,
  penalty = NULL,
  terms = NULL
)
```

## Arguments

- mode:

  A single character string for the type of model.

- model:

  A fitted model object to be interpreted. Default is `NULL`.

- params_main:

  An integer for the maximum number of sample points to model main
  effects, i.e., `k` for main effects in
  [`interpret()`](https://ryo-asashi.github.io/midr/reference/interpret.html).

- params_inter:

  An integer for the maximum number of sample points to model
  interaction effects, i.e., `k` for interactions in
  [`interpret()`](https://ryo-asashi.github.io/midr/reference/interpret.html).

- penalty:

  A non-negative number representing the total amount of regularization,
  i.e., `lambda` in
  [`interpret()`](https://ryo-asashi.github.io/midr/reference/interpret.html).

- terms:

  A character vector or formula of term labels to be included in the
  fitting process.

- weights:

  an optional vector of case weights.

- x:

  a data frame or matrix of predictor variables.

- y:

  a vector of target variable.

## Value

a `mid_reg` model specification.

## Details

This function is the main specification for the **parsnip** model. The
underlying fitting is performed by `fit_mid_reg()`, which is a helper
function that connects `fit()` to the
[`midr::interpret()`](https://ryo-asashi.github.io/midr/reference/interpret.html)
function.

## See also

[`interpret`](https://ryo-asashi.github.io/midr/reference/interpret.html)
