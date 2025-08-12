#' Global Surrogate Model Specification
#'
#' \code{global_surrogate()} defines a model that serves as a surrogate model of another target model. This function can fit classification and regression models.
#'
#' @param mode A single character string for the type of model.
#' @param penalty A non-negative number representing the total amount of regularization (`lambda` in midr).
#' @param k An integer for the maximum number of sample points (`k` in midr).
#'
#' @export
global_surrogate <- function(
    mode = "regression", penalty = NULL, num_knots = NULL
) {
  if (mode != "regression") {
    rlang::abort("`mode` should be 'regression'")
  }
  args <- list(
    penalty = rlang::enquo(penalty),
    num_knots = rlang::enquo(num_knots)
  )
  new_model_spec(
    "global_surrogate",
    args = args,
    eng_args = NULL,
    mode = mode,
    method = NULL,
    engine = NULL
  )
}
