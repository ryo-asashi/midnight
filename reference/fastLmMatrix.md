# Fit Multivariate Linear Models

`fastLmMatrix()` estimates the linear model for multivariate response
using one of several methods implemented using the `Eigen` linear
algebra library.

## Usage

``` r
fastLmMatrixLDLT(x, y, tol = 1e-07)

fastLmMatrixLLT(x, y)

fastLmMatrixQR(x, y)

fastLmMatrixSVD(x, y, tol = 1e-07)

fastLmMatrixUnpivotedQR(x, y)

fastLmMatrix(x, ...)

# Default S3 method
fastLmMatrix(x, y, tol = 1e-07, method = 0L, ...)

# S3 method for class 'formula'
fastLmMatrix(formula, data = list(), method = 0L, ...)
```

## Arguments

- x:

  a model matrix \\X\\.

- y:

  the response matrix \\Y\\.

- tol:

  tolerance for the rank calculation.

- ...:

  optional parameters passed to methods.

- method:

  an integer with value `0` for the column-pivoted QR decomposition, `1`
  for the unpivoted QR decomposition, `2` for the LLT Cholesky, `3` for
  the LDLT Cholesky, and `4` for the Jacobi singular value decomposition
  (SVD). Default is zero.

- formula:

  an object of class "formula" (or one that can be coerced to that
  class): a symbolic description of the model to be fitted.

- data:

  an optional data frame, list or environment (or object coercible by
  `as.data.frame` to a data frame) containing the variables in the
  model.

## Value

`fastLmMatrix()` returns a list with the following components:

- coefficients:

  \\p \times k\\ matrix of coefficients.

- fitted.values:

  \\n \times k\\ matrix of fitted values.

- residuals:

  \\n \times k\\ matrix of residuals.

- rank:

  an integer giving the numeric rank of the model matrix \\X\\.

## Details

`fastLmMatrix()` is a performance-optimized version of the standard `lm`
function, specifically designed to handle multivariate responses (\\Y\\
as a matrix). It leverages the `Eigen` C++ template library for
high-performance linear algebra, utilizing `Eigen::Map` to avoid
unnecessary memory copies and providing several decomposition methods
with different trade-offs between speed and numerical stability.

## Examples

``` r
# Multivariate Regression with Anscombe's Quartet
# Regress three 'y' variables on 'x1' simultaneously
Y <- as.matrix(anscombe[, c("y1", "y2", "y3")])
X <- as.matrix(cbind(1, anscombe$x1)) # Include intercept

fit_ans <- fastLmMatrix(X, Y, method = 0L)
print(fit_ans$coefficients)
#>             y1       y2        y3
#> [1,] 3.0000909 3.000909 3.0024545
#> [2,] 0.5000909 0.500000 0.4997273

# Formula interface with cbind()
fit_form <- fastLmMatrix(cbind(y1, y2, y3) ~ x1, data = anscombe)
print(fit_form$coefficients)
#>                    y1       y2        y3
#> (Intercept) 3.0000909 3.000909 3.0024545
#> x1          0.5000909 0.500000 0.4997273
```
