dot_wrap <- function(x) {
  stopifnot(is.character(x))
  . <- NULL
  as.call(c(quote(.), lapply(x, as.name)))
}

drop_keys <- function(dt) {
  setkey(x = dt, NULL)[]
}
