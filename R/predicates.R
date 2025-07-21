is_bool <- function(x) {
  is.logical(x) && identical(length(x), 1L) && !is.na(x)
}

is_scalar_number <- function(x) {
  is.numeric(x) && identical(length(x), 1L) && !is.na(x)
}
