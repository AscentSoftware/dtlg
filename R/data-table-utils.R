dot_wrap <- function(x) {
  stopifnot(is.character(x))
  as.call(c(str2lang("."), lapply(x, as.name)))
}

drop_keys <- function(dt) {
  data.table::setkey(x = dt, NULL)[]
}
