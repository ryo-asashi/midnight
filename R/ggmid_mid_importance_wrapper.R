#' Advanced Visualizations for MID Importance
#'
#' @description
#' Extends \code{midr::ggmid} to provide modern distribution plots for Maximum Interpretation Decomposition (MID) feature importance.
#' Added types include sina, beeswarm, and violin plots.
#'
#' @details
#' This function wraps the S3 method of \code{midr::ggmid} for "mid.importance" objects and replaces the primary layer with modern distribution geoms when \code{type} is one of the extended options.
#'
#' @param object a "mid.importance" object created by \code{midr::mid.importance}.
#' @param type a character string specifying the plot type. In addition to standard types ("barplot", "boxplot", "dotchart", "heatmap"), this extended method supports "violin", "sinaplot", and "beeswarm".
#' @param theme a character string for the visual theme.
#' @param terms a character vector of terms to include. If \code{NULL} (default), all terms are shown.
#' @param max.nterms an integer. The maximum number of terms to display.
#' @param scale a character string for sina and violin plots. Default is "width", ensuring all categories have equal maximum width regardless of density.
#' @param method a character string specifying the distribution algorithm. Default is "density" for \code{sinaplot} and "frowney" for \code{beeswarm}.
#' @param ... additional arguments passed to the underlying geoms.
#'
#' @return a "ggplot" object.
#'
#' @exportS3Method midr::ggmid
#'
ggmid.mid.importance <- function(
    object, type = NULL, theme = NULL, terms = NULL, max.nterms = 30,
    scale = NULL, method = NULL, ...
  ) {
  type_new <- c("violin", "sinaplot", "beeswarm")
  type_all <- c("barplot", "dotchart", "heatmap", "boxplot", type_new)
  type <- match.arg(type, type_all)
  func <- utils::getS3method(
    "ggmid", "mid.importance", envir = asNamespace("midr")
  )
  if (!type %in% type_new) {
    pl <- func(object = object, type = type, theme = theme, terms = terms,
               max.nterms = max.nterms, ...)
    return(pl)
  }
  # override boxplot
  if (type == "sinaplot" && !requireNamespace("ggforce", quietly = TRUE)) {
      stop("Install 'ggforce' for sina plots")
  }
  if (type == "beeswarm" && !requireNamespace("ggbeeswarm", quietly = TRUE)) {
      stop("Install 'ggbeeswarm' for beeswarm plots")
  }
  pl <- func(object = object, type = "boxplot", theme = NULL, terms = terms,
             max.nterms = max.nterms, ...)
  if (!all(c("importance", "order") %in% colnames(pl$data))) {
    pl$data <- merge(pl$data[, c("mid", "term")],
                     object$importance, by = "term", all.x = TRUE)
  }
  pl$layers[[1L]] <- switch(
    type,
    "sinaplot" = {
      names(pl$layers[[1L]] <- "geom_sina")
      ggforce::geom_sina(
        ggplot2::aes(.data[["mid"]], .data[["term"]]),
        scale = scale %||% "width", method = method %||% "density", ...
      )
    },
    "beeswarm" = {
      names(pl$layers[[1L]] <- "geom_quasirandom")
      ggbeeswarm::geom_quasirandom(
        ggplot2::aes(.data[["mid"]], .data[["term"]]),
        orientation = "y", method = method %||% "quasirandom", ...
      )
    },
    "violin" = {
      names(pl$layers[[1L]] <- "geom_violin")
      ggplot2::geom_violin(
        ggplot2::aes(.data[["mid"]], .data[["term"]]),
        scale = scale %||% "width", ...)
    }
  )
  theme <- midr::color.theme(theme)
  use.theme <- inherits(theme, "color.theme")
  if (use.theme) {
    if (type == "violin") {
      var <- switch(theme$type, "qualitative" = "order", "importance")
      pl <- pl + ggplot2::aes(fill = .data[[var]], group = .data[["term"]]) +
        midr::scale_fill_theme(theme = theme)
    } else {
      var <- switch(
        theme$type, "qualitative" = "order", "diverging" = "mid", "importance"
      )
      pl <- pl + ggplot2::aes(color = .data[[var]], group = .data[["term"]]) +
        midr::scale_color_theme(theme = theme)
    }
  }
  return(pl)
}
