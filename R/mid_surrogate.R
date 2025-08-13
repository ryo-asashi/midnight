#' Global Surrogate Model Specification
#'
#' \code{mid_surrogate()} defines a model that serves as a surrogate model of another target model. This function can fit classification and regression models.
#'
#' @param mode A single character string for the type of model.
#' @param penalty A non-negative number representing the total amount of regularization (`lambda` in midr).
#' @param params_main An integer for the maximum number of sample points to model main effects (`k` for main effects in midr).
#' @param params_inter An integer for the maximum number of sample points to model interaction effects (`k` for interactions in midr).
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
