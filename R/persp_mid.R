#' Perspective Plot of MID Effects
#'
#' @description
#' Visualizes the combined effect of two variables from a "mid" object using a 3D perspective plot.
#'
#' @details
#' This is an S3 method for the \code{persp()} generic that calculates the sum of the main effects of \code{xvar} and \code{yvar} and their interaction effect (\code{xvar:yvar}).
#' The resulting sum is plotted as the height on the z-axis.
#'
#' @param object a "mid" object, typically the result of \code{midr::interpret()}.
#' @param xvar a character string with the name of the variable for the x-axis. Alternatively, a single string in the format \code{xvar:yvar} can be provided, in which case \code{yvar} can be omitted.
#' @param yvar a character string with the name of the variable for the y-axis.
#' @param ... additional arguments passed on to \code{graphics:::persp.default()}. Used to customize the plot's appearance, such as view angles (\code{theta}, \code{phi}) or color (\code{col}).
#' @param xval a numeric or character vector specifying the sequence of values for the x-axis.
#' @param yval a numeric or character vector specifying the sequence of values for the y-axis.
#'
#' @examples
#' mid <- midr::interpret(mpg ~ wt * hp + factor(am), data = mtcars, lambda = .5)
#'
#' # Create a basic perspective plot
#' persp(mid, xvar = "wt", yvar = "hp")
#'
#' # Customize the plot by passing arguments to graphics:::persp.default()
#' persp(mid, "wt", "hp", theta = 210, phi = 20, col = "lightblue", shade = .5)
#' persp(mid, "factor(am):wt", theta = 210, shade = .2)
#' @returns
#' \code{persp.mid()} invisibly returns the viewing transformation matrix, see \code{\link[graphics]{persp}} for details.
#' This function is primarily called for its side effect of creating a plot.
#'
#' @seealso \code{\link[graphics]{persp}}
#'
#' @exportS3Method graphics::persp
#'
persp.mid <- function(
  object, xvar, yvar = NULL, ..., xval = NULL, yval = NULL) {
  if (grepl(":", xvar) && is.null(yvar)) {
    tags <- unlist(strsplit(xvar, ":"))
    xvar <- tags[[1L]]
    yvar <- tags[[2L]]
  }
  if (is.null(yvar))
    stop("'xvar' and 'yvar' must be specified")
  if (is.null(xval)) {
    encoder <- object$encoders$main.effects[[xvar]] %||%
      object$encoders$interactions[[xvar]]
    if (encoder$type == "linear" || encoder$type == "constant") {
      x_range <- range(attr(encoder$frame, "reps"))
      xval <- seq(x_range[1L], x_range[2L], length.out = 50L)
    } else if (encoder$type == "factor") {
      xval <- attr(encoder$frame, "levels")
    } else {
      xval <- NA
    }
  }
  if (!(xnum <- is.numeric(xval)))
    xval <- rep(xval, each = 2L)
  xlen <- length(xval)
  if (is.null(yval)) {
    encoder <- object$encoders$main.effects[[yvar]] %||%
      object$encoders$interactions[[yvar]]
    if (encoder$type == "linear" || encoder$type == "constant") {
      y_range <- range(attr(encoder$frame, "reps"))
      yval <- seq(y_range[1L], y_range[2L], length.out = 50L)
    } else if (encoder$type == "factor") {
      yval <- attr(encoder$frame, "levels")
    } else {
      yval <- NA
    }
  }
  if (!(ynum <- is.numeric(yval)))
    yval <- rep(yval, each = 2L)
  ylen <- length(yval)
  newdata <- expand.grid(x = xval, y = yval)
  names(newdata) <- c(xvar, yvar)
  z <- numeric(length = nrow(newdata))
  terms <- intersect(
    c(xvar, yvar, paste0(xvar, ":", yvar), paste0(yvar, ":", xvar)),
    midr::mid.terms(object)
  )
  for (term in terms)
    z <- z + midr::mid.effect(object, term, x = newdata)
  z <-  matrix(z, nrow = xlen, ncol = ylen)
  mar <- 0.499
  args <- list(...)
  args[["x"]] <- if (xnum) xval else
    rep(seq_len(xlen %/% 2L), each = 2L) + c(-mar, mar)
  args[["y"]] <- if (ynum) yval else
    rep(seq_len(ylen %/% 2L), each = 2L) + c(-mar, mar)
  args[["z"]] <- z
  args[["xlab"]] <- args[["xlab"]] %||% xvar
  args[["ylab"]] <- args[["ylab"]] %||% yvar
  args[["zlab"]] <- args[["zlab"]] %||% "mid"
  do.call("persp.default", args, envir = rlang::ns_env("graphics"))
}
