.onLoad <- function(libname, pkgname) {
  # define global_surrogate() in the model database
  make_global_surrogate()
  # return nothing
  invisible(NULL)
}
