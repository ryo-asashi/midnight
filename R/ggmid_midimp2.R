#' Plot MID Importance with ggplot2
#'
#' @description
#' Extends \code{midr::ggmid()} to provide modern distribution plots for MID feature importance.
#' Added types include sina, beeswarm, and violin plots.
#'
#' @details
#' This is an S3 method for the \code{midr::ggmid()} generic for "midimp2" objects created by \code{midnight::mid.importance()}.
#' This method replaces the primary layer with modern distribution geoms when \code{type} is one of the extended options.
#'
#' @param object a "midimp2" object to be visualized.
#' @param type the plotting style. In addition to standard types ("barplot", "boxplot", "dotchart", "heatmap"), this extended method supports "violinplot", "sinaplot", and "beeswarm".
#' @param theme a character string or object defining the color theme. See \code{\link[midr]{color.theme}} for details.
#' @param terms an optional character vector specifying which terms to display.
#' @param max.nterms an integer specifying the maximum number of terms to display. Defaults to 30.
#' @param ... optional parameters passed on to the layers.
#'
#' @examples
#' mid <- midr::interpret(Ozone ~ .^2, airquality, lambda = .5)
#' imp <- mid.importance(mid)
#'
#' # Create a violin plot
#' ggmid(imp, type = "violinplot", theme = "moon")
#'
#' # Create a beeswarm plot
#' ggmid(imp, type = "beeswarm", theme = "Hokusai3")
#'
#' # Create a sina plot
#' ggmid(imp, type = "sinaplot", theme = "bicolor")
#' @returns
#' \code{ggmid.midimp()} returns a "ggplot" object.
#'
#' @exportS3Method midr::ggmid
#'
ggmid.midimp2 <- function(
    object, type = NULL, theme = NULL, terms = NULL, max.nterms = 30, ...
  ) {
  type.new <- c("violinplot", "sinaplot", "beeswarm")
  type.all <- c("barplot", "dotchart", "heatmap", "boxplot", type.new)
  if (!is.null(type)) {
    type <- match.arg(type, type.all)
  }
  mcall <- match.call(expand.dots = TRUE)
  mcall[[1L]] <- utils::getS3method(
    f = "ggmid", class = "midimp", envir = asNamespace("midr")
  )
  mcall[["object"]] <- object
  if (is.null(type) || !type %in% type.new) {
    return(eval(mcall, parent.frame()))
  }
  mcall[["type"]] <- "boxplot"
  mcall["theme"] <- list(NULL)
  pl <- eval(mcall, parent.frame())
  # check dependencies for special types
  if (type == "sinaplot" && !requireNamespace("ggforce", quietly = TRUE)) {
    stop("Please install 'ggforce' for sina plots")
  }
  if (type == "beeswarm" && !requireNamespace("ggbeeswarm", quietly = TRUE)) {
    stop("Please install 'ggbeeswarm' for beeswarm plots")
  }
  # augment importance and order
  if (!all(c("importance", "order") %in% colnames(pl$data))) {
    box <- pl$data
    imp <- object$importance
    idx <- match(box$term, imp$term)
    box$importance <- imp$importance[idx]
    if ("order" %in% names(imp)) box$order <- imp$order[idx]
    pl$data <- box
  }
  pl$layers[[1L]] <- switch(
    type,
    sinaplot = {
      .geom_sina(
        mapping = ggplot2::aes(x = .data[["mid"]], y = .data[["term"]]), ...
      )
    },
    beeswarm = {
      .geom_quasirandom(
        mapping = ggplot2::aes(x = .data[["mid"]], y = .data[["term"]]), ...
      )
    },
    violinplot = {
      .geom_violin(
        mapping = ggplot2::aes(x = .data[["mid"]], y = .data[["term"]]), ...
      )
    }
  )
  # add color theme
  if (missing(theme))
    theme <- getOption("midr.sequential", getOption("midr.qualitative", NULL))
  theme <- midr::color.theme(theme)
  use.theme <- inherits(theme, "color.theme")
  if (use.theme) {
    if (type == "violinplot") {
      var <- switch(
        theme$type,
        qualitative = "order",
        "importance"
      )
      pl <- pl +
        ggplot2::aes(fill = .data[[var]], group = .data[["term"]]) +
        midr::scale_fill_theme(theme = theme)
    } else {
      var <- switch(
        theme$type,
        qualitative = "order",
        diverging = "mid",
        "importance"
      )
      pl <- pl +
        ggplot2::aes(color = .data[[var]], group = .data[["term"]]) +
        midr::scale_color_theme(theme = theme)
    }
  }
  return(pl)
}

standardize_param_names <- function(dots) {
  names(dots) <- ggplot2::standardise_aes_names(names(dots))
  dots[!duplicated(names(dots), fromLast = TRUE)]
}

filter_params <- function(dots, allowed) {
  dots[names(dots) %in% allowed]
}

.geom_sina <- function(mapping = NULL, data = NULL, ...) {
  allowed_params <- c(
    # Aesthetics & basic params
    "colour", "fill", "alpha", "linewidth", "linetype", "size", "shape", "stroke",
    "na.rm", "show.legend", "inherit.aes", "key_glyph", "position",
    # geom_sina specific params
    "scale", "method", "maxwidth", "binwidth", "rel_min_width", "seed", "jitter_y"
  )
  dots <- standardize_param_names(list(...))
  dots$scale <- dots$scale %||% "width"
  dots$method <- dots$method %||% "density"

  args <- c(
    list(mapping = mapping, data = data),
    filter_params(dots, allowed_params)
  )
  do.call(ggforce::geom_sina, args)
}

.geom_quasirandom <- function(mapping = NULL, data = NULL, ...) {
  allowed_params <- c(
    # Aesthetics & basic params
    "colour", "fill", "alpha", "linewidth", "linetype", "size", "shape", "stroke",
    "na.rm", "show.legend", "inherit.aes", "key_glyph", "position",
    # geom_quasirandom specific params
    "width", "varwidth", "bandwidth", "nbins", "method", "groupOnX", "dodge.width", "orientation"
  )
  dots <- standardize_param_names(list(...))
  dots$orientation <- dots$orientation %||% "y"
  dots$method <- dots$method %||% "quasirandom"

  args <- c(
    list(mapping = mapping, data = data),
    filter_params(dots, allowed_params)
  )
  do.call(ggbeeswarm::geom_quasirandom, args)
}

.geom_violin <- function(mapping = NULL, data = NULL, ...) {
  allowed_params <- c(
    # Aesthetics & basic params
    "colour", "fill", "alpha", "linewidth", "linetype", "size", "weight",
    "na.rm", "show.legend", "inherit.aes", "key_glyph", "position",
    # geom_violin specific params
    "draw_quantiles", "trim", "scale", "bounds", "width"
  )
  dots <- standardize_param_names(list(...))
  dots$scale <- dots$scale %||% "width"

  args <- c(
    list(mapping = mapping, data = data),
    filter_params(dots, allowed_params)
  )
  do.call(ggplot2::geom_violin, args)
}


#' @rdname ggmid.midimp2
#'
#' @keywords internal
#' @export
#'
mid.importance <- function(object, ...) {
  out <- midr::mid.importance(object, ...)
  class(out) <- c("midimp2", class(out))
  out
}
