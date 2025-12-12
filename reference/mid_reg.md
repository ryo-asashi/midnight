# MID Regression

`mid_reg()` defines a model that can predict numeric values from
predictors using a set of functions each with up to two predictors. This
function fits a regression model based on the Maximum Interpretation
Decomposition.

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
  terms = NULL,
  ...
)
```

## Arguments

- mode:

  a single character string for the type of model. Currently, only
  "regression" is supported.

- engine:

  a single character string specifying the computational engine to use.
  The default is "midr".

- model:

  an optional fitted model object (black-box model) to be interpreted.
  Default is `NULL`.

- params_main:

  an integer specifying the maximum number of sample points (knots) to
  model main effects. Corresponds to the argument `k[1]` in
  [`midr::interpret()`](https://ryo-asashi.github.io/midr/reference/interpret.html).

- params_inter:

  an integer specifying the maximum number of sample points (knots) to
  model interaction effects. Corresponds to the argument `k[2]` or `k2`
  in
  [`midr::interpret()`](https://ryo-asashi.github.io/midr/reference/interpret.html).

- penalty:

  a non-negative number representing the total amount of regularization.
  Corresponds to the argument `lambda` in
  [`midr::interpret()`](https://ryo-asashi.github.io/midr/reference/interpret.html).

- terms:

  a character vector or formula of term labels to be included in the
  fitting process.

- formula:

  an object of class `formula`: a symbolic description of the model to
  be fitted.

- data:

  a data frame containing the variables in the model.

- weights:

  an optional vector of case weights.

- ...:

  other arguments to be passed on to
  [`midr::interpret()`](https://ryo-asashi.github.io/midr/reference/interpret.html).

## Value

a "model_spec" object with class "mid_reg".

## Details

This function is the main specification for the **parsnip** model. The
underlying fitting is performed by `fit_mid_reg()`, which is a helper
function that connects
[`fit()`](https://generics.r-lib.org/reference/fit.html) to the
[`midr::interpret()`](https://ryo-asashi.github.io/midr/reference/interpret.html)
function.

## See also

[`interpret`](https://ryo-asashi.github.io/midr/reference/interpret.html)
