.onLoad <- function(libname, pkgname) {
  # define global_surrogate() in the model database
  make_mid_surrogate()
  # return nothing
  invisible(NULL)
}
