#' Transition into and out of Midnight
#'
#' @description
#' \code{nightfall()} activates the extended features provided by the \pkg{midnight} package.
#' It registers customized S3 methods (e.g., for \code{ggmid.midimp()}), switches the underlying solvers to highly optimized Eigen-based routines, and applies midnight-themed color palettes.
#'
#' \code{daybreak()} reverses these changes, restoring the default behavior, solvers, and themes of the \pkg{midr} package.
#'
#' @param methods logical. If \code{TRUE}, registers (or restores) the extended S3 methods.
#' @param solvers logical. If \code{TRUE}, switches (or restores) the calculation solvers for matrix responses.
#' @param themes logical. If \code{TRUE}, applies (or restores) the specific color themes.
#'
#' @returns
#' \code{nightfall()} and \code{daybreak()} return an invisible list containing the previous options for solvers and themes.
#'
#' @export
#'
nightfall <- function(methods = TRUE, solvers = TRUE, themes = TRUE) {
  if (isTRUE(methods)) {
    s3register_ggmid.midimp()
  }
  old_solvers <- if (isTRUE(solvers)) {
    set_mid_solvers(
      qr = fastLmMatrixQR,
      unpivoted.qr = fastLmMatrixUnpivotedQR,
      llt = fastLmMatrixLLT,
      ldlt = fastLmMatrixLDLT,
      svd = fastLmMatrixSVD
    )
  } else NULL
  old_themes <- if (isTRUE(themes)) {
    set_mid_themes(
      qualitative = "moon",
      diverging = "moonlit",
      sequential = "eclipse"
    )
  } else NULL
  invisible(c(old_solvers, old_themes))
}

#' @rdname nightfall
#' @export
#'
daybreak <- function(methods = TRUE, solvers = TRUE, themes = TRUE) {
  if (isTRUE(methods)) {
    s3restore_ggmid.midimp()
  }
  old_solvers <- if (isTRUE(solvers)) {
    set_mid_solvers(
      qr = NULL,
      unpivoted.qr = NULL,
      llt = NULL,
      ldlt = NULL,
      svd = NULL
    )
  } else NULL
  old_themes <- if (isTRUE(themes)) {
    set_mid_themes(
      qualitative = NULL,
      diverging = NULL,
      sequential = NULL
    )
  } else NULL
  invisible(c(old_solvers, old_themes))
}

# internal helpers

s3register_ggmid.midimp <- function() {
  registerS3method("ggmid", "midimp", ggmid.midimp, asNamespace("midr"))
}

s3restore_ggmid.midimp <- function() {
  if (isNamespaceLoaded("midr")) {
    ns <- asNamespace("midr")
    if (exists("ggmid.midimp", envir = ns, inherits = FALSE)) {
      fun <- get("ggmid.midimp", envir = ns, inherits = FALSE)
      registerS3method("ggmid", "midimp", fun, ns)
    }
  }
}

set_mid_solvers <- function(...) {
  dots <- list(...)
  names(dots) <- paste0("midr.solver.", tolower(names(dots)))
  options(dots)
}

set_mid_themes <- function(
    diverging = NULL, qualitative = NULL, sequential = NULL
  ) {
  options(
    midr.diverging = diverging,
    midr.qualitative = qualitative,
    midr.sequential = sequential
  )
}
