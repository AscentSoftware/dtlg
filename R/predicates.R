is_bool <- function(x) {
  is.logical(x) && identical(length(x), 1L) && !is.na(x)
}

is_scalar_number <- function(x) {
  is.numeric(x) && identical(length(x), 1L) && !is.na(x)
}

is_string <- function(x) {
  is.character(x) && identical(length(x), 1L) && !is.na(x)
}

and <- function(...) {
  dots <- list(...)
  Reduce(`&`, dots, init = TRUE)
}
