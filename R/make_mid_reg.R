make_mid_reg <- function() {
  if ("mid_reg" %in% parsnip::get_model_env()$models) {
    return()
  }
  # set new model
  parsnip::set_new_model(
    model = "mid_reg"
  )
  # set model mode
  parsnip::set_model_mode(
    model = "mid_reg",
    mode = "regression"
  )
  # set model engine
  parsnip::set_model_engine(
    model = "mid_reg",
    mode = "regression",
    eng = "midr"
  )
  # set dependency
  parsnip::set_dependency(
    model = "mid_reg",
    eng = "midr",
    pkg = "midr"
  )
  # set model arg: k --> params_main
  parsnip::set_model_arg(
    model = "mid_reg",
    eng = "midr",
    parsnip = "params_main",
    original = "params_main",
    func = list(pkg = "dials",
                fun = "num_knots",
                range = c(5L, 100L)),
    has_submodel = FALSE
  )
  # set model arg: k2 --> params_inter
  parsnip::set_model_arg(
    model = "mid_reg",
    eng = "midr",
    parsnip = "params_inter",
    original = "params_inter",
    func = list(pkg = "dials",
                fun = "num_knots",
                range = c(1L, 5L)),
    has_submodel = FALSE
  )
  # set model arg: lambda --> penalty
  parsnip::set_model_arg(
    model = "mid_reg",
    eng = "midr",
    parsnip = "penalty",
    original = "penalty",
    func = list(pkg = "dials",
                fun = "penalty",
                range = c(-3, 2)),
    has_submodel = FALSE
  )
  # set model arg: terms --> terms
  parsnip::set_model_arg(
    model = "mid_reg",
    eng = "midr",
    parsnip = "terms",
    original = "terms",
    func = list(fun = "none"),
    has_submodel = FALSE
  )
  # set model arg: model --> model
  parsnip::set_model_arg(
    model = "mid_reg",
    eng = "midr",
    parsnip = "model",
    original = "model",
    func = list(fun = "none"),
    has_submodel = FALSE
  )
  # set fit
  parsnip::set_fit(
    model = "mid_reg",
    eng = "midr",
    mode = "regression",
    value = list(
      interface = "formula",
      protect = c("formula", "data", "weights"),
      func = c(pkg = "midnight",
               fun = "fit_mid_reg"),
      defaults = list()
    )
  )
  # set encoding
  parsnip::set_encoding(
    model = "mid_reg",
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
    model = "mid_reg",
    eng = "midr",
    mode = "regression",
    type = "numeric",
    value = list(
      pre = NULL,
      post = NULL,
      func = c(fun = "predict"),
      args = list(
        object = str2lang("object$fit"),
        newdata = str2lang("new_data"),
        type = "response"
      )
    )
  )
  invisible(NULL)
}
