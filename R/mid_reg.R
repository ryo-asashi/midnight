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
#' @param model A fitted model object to be interpreted. Default is \code{NULL}.
#' @param params_main An integer for the maximum number of sample points to model main effects, i.e., \code{k} for main effects in \code{interpret()}.
#' @param params_inter An integer for the maximum number of sample points to model interaction effects, i.e., \code{k} for interactions in \code{interpret()}.
#' @param penalty A non-negative number representing the total amount of regularization, i.e., \code{lambda} in \code{interpret()}.
#' @param terms A character vector or formula of term labels to be included in the fitting process.
#'
#' @returns a \code{mid_reg} model specification.
#'
#' @seealso \code{\link[midr]{interpret}}
#'
#' @export
mid_reg <- function(
    mode = "regression",
    engine = "midr",
    model = NULL,
    params_main = NULL,
    params_inter = NULL,
    penalty = NULL,
    terms = NULL
) {
  args <- list(
    penalty = rlang::enquo(penalty),
    params_main = rlang::enquo(params_main),
    params_inter = rlang::enquo(params_inter),
    model = rlang::enquo(model),
    terms = rlang::enquo(terms)
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
#' @param x A data frame or matrix of predictor variables.
#' @param y A vector of target variable.
#' @param weights An optional vector of case weights.
#' @param ... Other arguments to be passed on to \code{midr::interpret()}.
#'
#' @keywords internal
#'
#' @export
fit_mid_reg <- function(
    formula,
    data,
    weights = NULL,
    model = NULL,
    params_main = NULL,
    params_inter = NULL,
    penalty = NULL,
    terms = NULL,
    ...
) {
  mf <- stats::model.frame(
    formula = formula,
    data = data,
    na.action = "na.pass"
  )
  y <- if (is.null(model)) {
    stats::model.response(mf, "any")
  } else {
    NULL
  }
  if (use.formula <- is.null(terms)) {
    terms <- attr(stats::terms(mf), "term.labels")
    terms <- gsub("`", "", terms) # recipe() adds "`" to non-standard terms
  }
  if (rlang::is_formula(terms)) {
    terms <- attr(stats::terms(terms), "term.labels")
  }
  obj <- midr::interpret(
    object = model,
    x = mf,
    y = y,
    weights = weights,
    k = params_main %||% NA,
    k2 = params_inter %||% NA,
    lambda = penalty %||% 0,
    terms = terms,
    ...
  )
  names(obj$call)[2L:4L] <- c("formula", "data", "model")
  obj$call$formula <- if (use.formula) formula else stats::formula(obj)
  obj$call$data <- quote(data)
  obj$call$model <- if (!is.null(model)) quote(model)
  obj$call$weights <- if (!is.null(weights)) quote(weights)
  obj$call$k <- params_main
  obj$call$k2 <- params_inter
  obj$call$lambda <- penalty
  obj$call$terms <- if (use.formula) NULL else quote(terms)
  dots <- list(...)
  for (name in names(dots))
    obj$call[[name]] <- dots[[name]]
  obj
}
