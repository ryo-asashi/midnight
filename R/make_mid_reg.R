make_mid_reg <- function() {
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
  # set model arg: formula --> custom_formula
  parsnip::set_model_arg(
    model = "mid_reg",
    eng = "midr",
    parsnip = "custom_formula",
    original = "custom_formula",
    func = list(fun = "none"),
    has_submodel = FALSE
  )
  # set fit
  parsnip::set_fit(
    model = "mid_reg",
    eng = "midr",
    mode = "regression",
    value = list(
      interface = "data.frame",
      protect = c("x", "y", "weights"),
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
        object = rlang::expr(object$fit),
        newdata = rlang::expr(new_data),
        type = "response"
      )
    )
  )
  invisible(NULL)
}

# global variable declaration
utils::globalVariables(c("object", "new_data", "new_model_spec"))
