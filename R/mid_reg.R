#' MID Regression
#'
#' @description
#' \code{mid_reg()} defines a model that can predict numeric values from predictors using a set of functions each with up to two predictors.
#' This function fits a regression model based on the Maximum Interpretation Decomposition.
#'
#' @details
#' This function is the main specification for the \strong{parsnip} model.
#' The underlying fitting is performed by \code{fit_mid_reg()}, which is a helper function that connects \code{fit()} to the \code{midr::interpret()} function.
#'
#' @param mode a single character string for the type of model. Currently, only "regression" is supported.
#' @param engine a single character string specifying the computational engine to use. The default is "midr".
#' @param model an optional fitted model object (black-box model) to be interpreted. Default is \code{NULL}.
#' @param params_main an integer specifying the maximum number of sample points (knots) to model main effects. Corresponds to the argument \code{k[1]} in \code{midr::interpret()}.
#' @param params_inter an integer specifying the maximum number of sample points (knots) to model interaction effects. Corresponds to the argument \code{k[2]} or \code{k2} in \code{midr::interpret()}.
#' @param penalty a non-negative number representing the total amount of regularization. Corresponds to the argument \code{lambda} in \code{midr::interpret()}.
#' @param terms a character vector or formula of term labels to be included in the fitting process.
#'
#' @returns a "model_spec" object with class "mid_reg".
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
  if (!requireNamespace("parsnip", quietly = TRUE)) {
    stop("the 'parsnip' package is required to use mid_reg();",
         "please install it with install.packages('parsnip')", call. = FALSE)
  }
  args <- list(
    penalty = rlang::enquo(penalty),
    params_main = rlang::enquo(params_main),
    params_inter = rlang::enquo(params_inter),
    model = rlang::enquo(model),
    terms = rlang::enquo(terms)
  )
  parsnip::new_model_spec(
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
#' @param formula an object of class \code{formula}: a symbolic description of the model to be fitted.
#' @param data a data frame containing the variables in the model.
#' @param weights an optional vector of case weights.
#' @param ... other arguments to be passed on to \code{midr::interpret()}.
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
  .formula <- NULL
  if (is.null(terms)) {
    .formula <- formula
    terms <- attr(stats::terms(mf), "term.labels")
  } else if (rlang::is_formula(terms)) {
    .formula <- stats::formula(terms)
    .data <- data[NULL, ]
    if ("..y" %in% colnames(.data))
      .data[["..y"]] <- NULL
    terms <- attr(stats::terms(terms, data = .data), "term.labels")
  }
  terms <- gsub("`", "", terms) # recipe() adds "`" to non-standard terms
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
  obj$call <- rlang::call2(
    "interpret",
    formula = .formula %||% stats::formula(obj),
    data = quote(data),
    model = if (!is.null(model)) quote(model) else NULL,
    weights = if (!is.null(weights)) quote(weights) else NULL,
    k = params_main,
    k2 = params_inter,
    lambda = penalty,
    terms = quote(terms)
  )
  dots <- list(...)
  for (name in names(dots))
    obj$call[[name]] <- dots[[name]]
  obj
}
