#' MID Regression
#'
#' @description
#' \code{mid_reg()} defines a model that can predict numeric values from predictors using a set of functions each with up to two predictors.
#' This function can fit regression models.
#'
#' @details
#' This function is the main specification for the \strong{parsnip} model.
#' The underlying fitting is performed by \code{fit_mid_reg()}, which is a helper function that connects \code{fit()} to the \code{midr::interpret()} function.
#'
#' @param mode A single character string for the type of model.
#' @param params_main An integer for the maximum number of sample points to model main effects, i.e., \code{k} for main effects in \code{interpret()}.
#' @param params_inter An integer for the maximum number of sample points to model interaction effects, i.e., \code{k} for interactions in \code{interpret()}.
#' @param penalty A non-negative number representing the total amount of regularization, i.e., \code{lambda} in \code{interpret()}.
#' @param custom_formula A formula object. If passed, \code{fit()} internally uses \code{interpret.formula()} with \code{formula = custom_formula}, otherwise it uses \code{interpret.default()}.
#'
#' @returns a \code{mid_reg} model specification.
#'
#' @seealso \code{\link[midr]{interpret}}
#'
#' @export
mid_reg <- function(
    mode = "regression",
    engine = "midr",
    params_main = NULL,
    params_inter = NULL,
    penalty = NULL,
    custom_formula = NULL
) {
  args <- list(
    penalty = rlang::enquo(penalty),
    params_main = rlang::enquo(params_main),
    params_inter = rlang::enquo(params_inter),
    custom_formula = rlang::enquo(custom_formula)
  )
  new_model_spec(
    "mid_reg",
    args = args,
    eng_args = NULL,
    mode = mode,
    user_specified_mode = !missing(mode),
    method = NULL,
    engine = engine,
    user_specified_engine = !missing(engine)
  )
}

#' @rdname mid_reg
#'
#' @param x a data frame or matrix of predictor variables.
#' @param y a vector of target variable.
#' @param weights an optional vector of case weights.
#' @param ... other arguments passed to \code{midr::interpret()}.
#'
#' @keywords internal
#'
#' @export
fit_mid_reg <- function(
    x, y,
    weights = NULL,
    params_main = NA,
    params_inter = NA,
    penalty = 0,
    custom_formula = NULL,
    ...
) {
  k <- c(params_main, params_inter)
  if (!is.null(custom_formula)) {
    environment(custom_formula) <- rlang::ns_env("midnight")
    data <- cbind(y, x)
    names(data)[1L] <- as.character(custom_formula[[2L]])
    midr::interpret(
      custom_formula, data = data, weights = weights,
      k = k, lambda = penalty, ...
    )
  } else {
    midr::interpret(
      x = x, y = y, weights = weights, k = k, lambda = penalty, ...
    )
  }
}
