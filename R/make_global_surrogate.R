make_global_surrogate <- function() {
  # set new model
  parsnip::set_new_model(
    model = "global_surrogate"
  )
  # set model mode
  parsnip::set_model_mode(
    model = "global_surrogate",
    mode = "regression"
  )
  # set model engine
  parsnip::set_model_engine(
    model = "global_surrogate",
    mode = "regression",
    eng = "midr"
  )
  # set dependency
  parsnip::set_dependency(
    model = "global_surrogate",
    eng = "midr",
    pkg = "midr"
  )
  # set model arg: lambda --> penalty
  parsnip::set_model_arg(
    model = "global_surrogate",
    eng = "midr",
    parsnip = "penalty",
    original = "lambda",
    func = list(pkg = "dials",
                fun = "penalty"),
    has_submodel = FALSE
  )
  # set model arg: k --> num_knots
  parsnip::set_model_arg(
    model = "global_surrogate",
    eng = "midr",
    parsnip = "num_knots",
    original = "k",
    func = list(pkg = "dials",
                fun = "num_knots"),
    has_submodel = FALSE
  )
  # set fit
  parsnip::set_fit(
    model = "global_surrogate",
    eng = "midr",
    mode = "regression",
    value = list(
      interface = "formula",
      protect = c("formula", "data"),
      func = c(pkg = "midr",
               fun = "interpret"),
      defaults = list()
    )
  )
  # set encoding
  parsnip::set_encoding(
    model = "global_surrogate",
    eng = "midr",
    mode = "regression",
    options = list(
      predictor_indicators = "none",
      compute_intercept = FALSE,
      remove_intercept = FALSE,
      allow_sparse_x = FALSE
    )
  )
  # set pred
  parsnip::set_pred(
    model = "global_surrogate",
    eng = "midr",
    mode = "regression",
    type = "numeric",
    value = list(
      pre = NULL,
      post = NULL,
      func = c(fun = "predict"),
      args = list(
        object = rlang::expr(object$fit),
        newdata = rlang::expr(new_data),
        type = "response"
      )
    )
  )
}
