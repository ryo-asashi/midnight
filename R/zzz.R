.onLoad <- function(libname, pkgname) {
  # define global_surrogate() in the model database
  try(make_mid_surrogate())
  # define color.themes
  midr::set.color.theme(
    name = "moon", source = "midnight", type = "qualitative",
    kernel = c("#333A59", "#2F4D66", "#2C6070", "#2F7277", "#3D837B",
               "#53927D", "#6EA07E", "#8AAC80", "#A7B584", "#C0BA8B"),
    kernel.args = list(mode = "ramp")
  )
  midr::set.color.theme(
    name = "moonlit", source = "midnight", type = "sequential",
    kernel = c("#333A59", "#2F4D66", "#2C6070", "#2F7277", "#3D837B",
               "#53927D", "#6EA07E", "#8AAC80", "#A7B584", "#C0BA8B"),
    kernel.args = list(mode = "ramp")
  )
  # return nothing
  invisible(NULL)
}
