.onLoad <- function(libname, pkgname) {
  # define mid_reg() in the model database
  if (isNamespaceLoaded("parsnip")) {
    make_mid_reg()
  } else {
    setHook(packageEvent("parsnip", "onLoad"), function(...) make_mid_reg())
  }
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
    kernel = c("#86B3EB", "#5A7EB3", "#344C7A", "#2A2A2A", "#932A45", "#C8576E", "#FF879D"),
    kernel.args = list(mode = "ramp")
  )
  # DALEX --------
  if (requireNamespace("DALEX", quietly = TRUE)) {
    midr::set.color.theme(
      name = "drwhy", source = "DALEX", type = "qualitative",
      kernel = c(text = "colors_discrete_drwhy", namespace = "DALEX"),
      options = list(kernel.size = 7L, palette.formatter = "recycle")
    )
  }
  # colormap --------
  if (requireNamespace("colormap", quietly = TRUE)) {
    for (x in colormap::colormaps) {
      type <- if (x %in% c("picnic", "portland", "RdBu"))
        "diverging" else "sequential"
      midr::set.color.theme(
        name = x, source = "colormap", type = type,
        kernel = c(text = "colormap", namespace = "colormap"),
        kernel.args = list(
          colormap = x, format = "hex", alpha = 1, reverse = FALSE
        ),
        options = list(
          kernel.size = Inf,
          reverse.method = "kernel.args$reverse <- !kernel.args$reverse",
          ramp.scaler = switch(x, NULL, portland = c(0, 0.95))
        )
      )
    }
  }
  # MetBrewer --------
  if (requireNamespace("MetBrewer", quietly = TRUE)) {
    for (x in names(MetBrewer::MetPalettes)) {
      palette.formatter <- NULL
      if (x %in% c(
        "Derain", "Greek", "Hokusai", "Hokusai2", "Hokusai3", "Homer1",
        "Homer2", "Manet", "OKeeffe2", "Peru2", "Pillement", "Tam",
        "VanGogh1", "VanGogh3", "Veronese"
      )) {
        type <- "sequential"
      } else if (x %in% c(
        "Benedictus", "Cassatt1", "Cassatt2", "Demuth", "Hiroshige", "Ingres",
        "Isfahan1", "Morgenstern", "OKeeffe1", "Paquin", "Pissaro", "Troy"
      )) {
        type <- "diverging"
      } else {
        type <- "qualitative"
        palette.formatter <- if (x %in% c(
          "Austria", "Egypt", "Juarez", "Klimt", "Lakota",
          "Navajo", "NewKingdom", "Redon", "Tara", "Tsimshian", "Wising"
        )) "recycle" else "interpolate"
      }
      midr::set.color.theme(
        name = x, source = "MetBrewer", type = type,
        kernel = c(
          text = "function(...) as.vector(do.call(met.brewer, list(...)))",
          namespace = "MetBrewer"
        ),
        kernel.args = list(
          name = x, direction = 1L, override.order = FALSE
        ),
        options = list(
          kernel.size = if (type == "qualitative")
            length(MetBrewer::MetPalettes[[x]][[1L]]) else Inf,
          reverse.method = "kernel.args$direction <- - kernel.args$direction",
          ramp.rescaler = switch(
            x, NULL,
            Ingres = c(0.1, 1), Isfahan1 = c(0, 0.9), Cassatt1 = c(0, 0.9)
          ),
          palette.formatter = palette.formatter
        )
      )
    }
  }
  # return nothing
  invisible(NULL)
}
