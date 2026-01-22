is_pkg_available <- function(pkg) {
  (requireNamespace(pkg, quietly = TRUE))
}

assert_pkg_is_installed <- function(pkg) {
  if (isFALSE(is_pkg_available(pkg = pkg))) {
    stop("Package ", pkg, " must be installed to use this function.", call. = FALSE)
  }
}
