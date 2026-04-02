#' Transition into and out of Midnight
#'
#' @description
#' \code{nightfall()} activates the extended features provided by the \pkg{midnight} package.
#' It overrides specific S3 methods (such as \code{ggmid.midimp}), switches the underlying solvers to highly optimized Eigen-based routines via global options, and applies midnight-themed color palettes.
#'
#' \code{daybreak()} reverses these changes, restoring the default behavior, solvers, and themes of the \pkg{midr} package.
#'
#' @param methods logical. If \code{TRUE}, overrides (or restores) the \code{ggmid.midimp} S3 method.
#' @param solvers logical. If \code{TRUE}, sets (or restores) calculation solvers via \code{options()} (e.g., \code{midr.solver.qr}, \code{midr.solver.svd}). These optimized solvers can be utilized by specifying the corresponding method in \code{interpret()} (e.g., \code{method = "qr"}).
#' @param themes logical. If \code{TRUE}, applies (or restores) color themes by setting \code{options()} for \code{midr.qualitative}, \code{midr.sequential}, and \code{midr.diverging}.
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
      diverging = "eclipse",
      sequential = "moonlit"
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
