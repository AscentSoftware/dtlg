is_zero <- function(x, tol = .Machine$double.eps^0.5) {
  near(x, 0, tol = tol)
}
