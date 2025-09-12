#' Global Surrogate Model Specification
#'
#' @description
#' \code{mid_surrogate()} defines a model that serves as a surrogate model of another target model. This function can fit classification (to be implemented) and regression models.
#'
#' @details
#' This function is the main specification for the \strong{parsnip} model.
#' The underlying fitting is performed by \code{fit_mid_surrogate()}, which is a helper function that connects \code{parsnip::fit()} to the \code{midr::interpret()} function.
#'
#' @param mode A single character string for the type of model.
#' @param penalty A non-negative number representing the total amount of regularization (\code{lambda} in \code{interpret()}).
#' @param params_main An integer for the maximum number of sample points to model main effects (\code{k} for main effects in \code{interpret()}).
#' @param params_inter An integer for the maximum number of sample points to model interaction effects (\code{k} for interactions in \code{interpret()}).
#' @param custom_formula A formula object. If passed, \code{fit()} internally uses \code{interpret.formula()}, otherwise it uses \code{interpret.default()} (`formula` in \code{interpret()}).
#'
#' @returns a \code{mid_surrogate} model specification.
#'
#' @seealso \code{\link[midr]{interpret}}
#'
#' @export
mid_surrogate <- function(
    mode = "regression", params_main = NULL, params_inter = NULL,
    penalty = NULL, custom_formula = NULL
) {
  if (mode != "regression") {
    rlang::abort("`mode` should be 'regression'")
  }
  args <- list(
    penalty = rlang::enquo(penalty),
    params_main = rlang::enquo(params_main),
    params_inter = rlang::enquo(params_inter),
    custom_formula = rlang::enquo(custom_formula)
  )
  new_model_spec(
    "mid_surrogate",
    args = args,
    eng_args = NULL,
    mode = mode,
    method = NULL,
    engine = NULL
  )
}

#' @rdname mid_surrogate
#'
#' @param x a data frame or matrix of predictor variables.
#' @param y a vector of target variable.
#' @param weights an optional vector of case weights.
#' @param ... other arguments passed to \code{midr::interpret()}.
#'
#' @keywords internal
#'
#' @export
#'
fit_mid_surrogate <- function(
    x, y, weights = NULL, params_main = NA, params_inter = NA,
    penalty = 0, custom_formula = NULL, ...
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
