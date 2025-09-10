#' Perspective Plot of MID Interaction Effects
#'
#' @description
#' Visualizes the combined effect of two variables from a "mid" object using a 3D perspective plot.
#'
#' @details
#' This function calculates the sum of the main effects of \code{xvar} and \code{yvar} and their interaction effect (\code{xvar:yvar}).
#' The resulting sum is plotted as the height on the z-axis.
#'
#' @param object a "mid" object, typically the result of \code{midr::interpret()}.
#' @param xvar a character string with the name of the variable for the x-axis. Alternatively, a single string in the format \code{xvar:yvar} can be provided, in which case \code{yvar} can be omitted.
#' @param yvar a character string with the name of the variable for the y-axis.
#' @param x a numeric vector specifying the sequence of values for the x-axis.
#' @param y a numeric vector specifying the sequence of values for the y-axis.
#' @param ... additional arguments passed on to \code{graphics::persp()}. Used to customize the plot's appearance, such as view angles (\code{theta}, \code{phi}) or color (\code{col}).
#' @param resolution an integer or an integer vector of length two, specifying the number of grid points to use when creating the sequence for numeric variables.
#'
#' @returns
#' \code{mid_perspective()} invisibly returns the viewing transformation matrix, see \code{\link[graphics]{persp}} for details.
#' This function is primarily called for its side effect of creating a plot.
#'
#' @seealso \code{\link[graphics]{persp}}
#'
#' @examples
#' mid <- midr::interpret(mpg ~ wt * hp + am, data = mtcars, lambda = .5)
#'
#' Create a basic perspective plot
#' mid_perspective(mid, xvar = "wt", yvar = "hp")
#'
#' # Customize the plot by passing arguments to graphics::persp
#' mid_perspective(mid, "wt", "hp", theta = 210, phi = 20, col = "lightblue", shade = .5)
#'
#' @export mid_perspective
#'
mid_perspective <- function(
  object, xvar, yvar = NULL, x = NULL, y = NULL, ..., resolution = 50L
) {
  if (grepl(":", xvar) && is.null(yvar)) {
    tags <- unlist(strsplit(xvar, ":"))
    xvar <- tags[[1L]]
    yvar <- tags[[2L]]
  }
  if (is.null(yvar))
    stop("'xvar' and 'yvar' must be specified")
  if (length(resolution) < 2L)
    resolution <- c(resolution, resolution)
  if (is.null(x)) {
    encoder <- object$encoders$main.effects[[xvar]] %||%
      object$encoders$interactions[[xvar]]
    if (encoder$type == "linear" || encoder$type == "constant") {
      x_range <- range(attr(encoder$frame, "reps"))
      x <- seq(x_range[1L], x_range[2L], length.out = resolution[1L])
    } else if (encoder$type == "factor") {
      x <- rep(attr(encoder$frame, "levels"), each = 2L)
    } else {
      x <- NA
    }
  } else if (is.data.frame(x) && is.null(y)) {
    y <- x[[yvar]]
    x <- x[[xvar]]
  }
  if (is.null(y)) {
    encoder <- object$encoders$main.effects[[yvar]] %||%
      object$encoders$interactions[[yvar]]
    if (encoder$type == "linear" || encoder$type == "constant") {
      y_range <- range(attr(encoder$frame, "reps"))
      y <- seq(y_range[1L], y_range[2L], length.out = resolution[2L])
    } else if (encoder$type == "factor") {
      y <- rep(attr(encoder$frame, "levels"), each = 2L)
    } else {
      y <- NA
    }
  }
  newdata <- expand.grid(x = x, y = y)
  names(newdata) <- c(xvar, yvar)
  terms <- intersect(
    c(xvar, yvar, paste0(xvar, ":", yvar), paste0(yvar, ":", xvar)),
    midr::mid.terms(object)
  )
  z <- numeric(length = nrow(newdata))
  for (term in terms)
    z <- z + midr::mid.effect(object, term, x = newdata)
  z <-  matrix(z, nrow = length(x), ncol = length(y))
  args <- list(...)
  args[["x"]] <- if (is.numeric(x)) x else as.numeric(x) + c(-0.45, + 0.45)
  args[["y"]] <- if (is.numeric(y)) y else as.numeric(y) + c(-0.45, + 0.45)
  args[["z"]] <- z
  args[["xlab"]] <- args[["xlab"]] %||% xvar
  args[["ylab"]] <- args[["ylab"]] %||% yvar
  args[["zlab"]] <- args[["zlab"]] %||% "mid"
  do.call(graphics::persp, args)
}

#' @exportS3Method graphics::persp
persp.mid <- function(object, ...) {
  mid_perspective(object, ...)
}

