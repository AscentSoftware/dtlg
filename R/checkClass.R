#' check_table
#'
#' @param x table to check class of
#'
#' @return table converted to data.table
#'
#' @examples check_table(x)
check_table <- function(x) {
  UseMethod('check_table')
}

#' @rdname check_table
#'
#' @export
check_table.default <- function(x){
  return(data.table::as.data.table(x))
}

#' @rdname check_table
#'
#' @export
check_table.data.table <- function(x) {
  return(x)
}
