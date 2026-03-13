.onLoad <- function(libname, pkgname) {
  # define mid_reg() in the model database
  make_mid_reg()
  # define color themes
  midr::set.color.theme(
    name = "moon", source = "midnight", type = "qualitative",
    kernel = c("#F2C94C", "#5B8DB8", "#A66C98", "#4EA699", "#D96A70", "#8C92AC"),
    kernel.args = list(mode = "palette")
  )
  midr::set.color.theme(
    name = "moonlit", source = "midnight", type = "sequential",
    kernel = c("#141824", "#233A5E", "#38657A", "#65968E", "#A4C49D", "#EAF0C1"),
    kernel.args = list(mode = "ramp")
  )
  midr::set.color.theme(
    name = "eclipse", source = "midnight", type = "diverging",
    kernel = c("#942A45", "#D18C99", "#F4F5F7", "#7392B0", "#1E2A4F"),
    kernel.args = list(mode = "ramp")
  )
  # override OLS solvers
  options(
    midr.solver.qr = fastLmMatrixQR,
    midr.solver.unpivoted.qr = fastLmMatrixUnpivotedQR,
    midr.solver.llt = fastLmMatrixLLT,
    midr.solver.ldlt = fastLmMatrixLDLT,
    midr.solver.svd = fastLmMatrixSVD
  )
  # DALEX --------
  if (requireNamespace("DALEX", quietly = TRUE)) {
    midr::set.color.theme(
      name = "drwhy", source = "DALEX", type = "qualitative",
      kernel = c(text = "colors_discrete_drwhy", namespace = "DALEX"),
      options = list(kernel.size = 7L, palette.formatter = "recycle")
    )
  }
  # return nothing
  invisible(NULL)
}
