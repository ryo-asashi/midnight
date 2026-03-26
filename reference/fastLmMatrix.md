# Fit Multivariate Linear Models

`fastLmMatrix()` estimates the linear model for multivariate response
using one of several methods implemented using the `Eigen` linear
algebra library.

## Usage

``` r
fastLmMatrix(x, ...)

# Default S3 method
fastLmMatrix(x, y, tol = 1e-07, method = 0L, ...)

# S3 method for class 'formula'
fastLmMatrix(formula, data = list(), method = 0L, ...)
```

## Arguments

- x:

  a model matrix \\X\\.

- ...:

  optional parameters passed to methods.

- y:

  the response matrix \\Y\\.

- tol:

  tolerance for the rank calculation.

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

`fastLmMatrix()` is a performance-optimized version of the standard
[`lm.fit()`](https://rdrr.io/r/stats/lmfit.html) function. Unlike
[`RcppEigen::fastLm()`](https://rdrr.io/pkg/RcppEigen/man/fastLm.html),
it is specifically designed to handle multivariate responses (\\Y\\ as a
matrix). It leverages the Eigen C++ template library for
high-performance linear algebra, providing several decomposition methods
with different trade-offs between speed and numerical stability.

## See also

[`lm.fit`](https://rdrr.io/r/stats/lmfit.html),
[`fastLm`](https://rdrr.io/pkg/RcppEigen/man/fastLm.html)
