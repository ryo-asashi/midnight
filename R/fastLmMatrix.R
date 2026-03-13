#' Fit Multivariate Linear Models
#'
#' @description
#' \code{fastLmMatrix()} estimates the linear model for multivariate response using one of several methods implemented using the \code{Eigen} linear algebra library.
#'
#' @details
#' \code{fastLmMatrix()} is a performance-optimized version of the standard \code{lm} function, specifically designed to handle multivariate responses (\eqn{Y} as a matrix).
#' It leverages the \code{Eigen} C++ template library for high-performance linear algebra, utilizing \code{Eigen::Map} to avoid unnecessary memory copies and providing several decomposition methods with different trade-offs between speed and numerical stability.
#'
#' @examples
#' # Multivariate Regression with Anscombe's Quartet
#' # Regress three 'y' variables on 'x1' simultaneously
#' Y <- as.matrix(anscombe[, c("y1", "y2", "y3")])
#' X <- as.matrix(cbind(1, anscombe$x1)) # Include intercept
#'
#' fit_ans <- fastLmMatrix(X, Y, method = 0L)
#' print(fit_ans$coefficients)
#'
#' # Formula interface with cbind()
#' fit_form <- fastLmMatrix(cbind(y1, y2, y3) ~ x1, data = anscombe)
#' print(fit_form$coefficients)
#' @param x a model matrix \eqn{X}.
#' @param ... optional parameters passed to methods.
#'
#' @returns
#' \code{fastLmMatrix()} returns a list with the following components:
#' \item{coefficients}{\eqn{p \times k} matrix of coefficients.}
#' \item{fitted.values}{\eqn{n \times k} matrix of fitted values.}
#' \item{residuals}{\eqn{n \times k} matrix of residuals.}
#' \item{rank}{an integer giving the numeric rank of the model matrix \eqn{X}.}
#'
#' @export
#'
fastLmMatrix <- function(x, ...)
UseMethod("fastLmMatrix")

#' @rdname fastLmMatrix
#'
#' @param y the response matrix \eqn{Y}.
#' @param tol tolerance for the rank calculation.
#' @param method an integer with value \code{0} for the column-pivoted QR decomposition, \code{1} for the unpivoted QR decomposition, \code{2} for the LLT Cholesky, \code{3} for the LDLT Cholesky, and \code{4} for the Jacobi singular value decomposition (SVD). Default is zero.
#'
#' @exportS3Method midnight::fastLmMatrix
#'
fastLmMatrix.default <- function(x, y, tol = 1e-7, method = 0L, ...) {
  x <- as.matrix(x)
  y <- as.matrix(y)
  if (method == 0L) {
    fastLmMatrixQR(x, y)
  } else if (method == 1L) {
    fastLmMatrixUnpivotedQR(x, y)
  } else if (method == 2L) {
    fastLmMatrixLLT(x, y)
  } else if (method == 3L) {
    fastLmMatrixLDLT(x, y, tol)
  } else if (method == 4L) {
    fastLmMatrixSVD(x, y, tol)
  } else {
    stop("invalid 'method' found")
  }
}

#' @rdname fastLmMatrix
#'
#' @param formula an object of class "formula" (or one that can be coerced to that class): a symbolic description of the model to be fitted.
#' @param data an optional data frame, list or environment (or object coercible by \code{as.data.frame} to a data frame) containing the variables in the model.
#'
#' @exportS3Method midnight::fastLmMatrix
#'
fastLmMatrix.formula <- function(formula, data = list(), method = 0L, ...) {
  mf <- model.frame(formula = formula, data = data)
  x <- model.matrix(attr(mf, "terms"), data = mf)
  y <- model.response(mf)
  res <- fastLmMatrix.default(x, y, method = method, ...)
  res$call <- match.call()
  res$formula <- formula
  res$intercept <- attr(attr(mf, "terms"), "intercept")
  res
}
