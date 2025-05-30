#' check_table
#'
#' @param x table to check class of
#'
#' @return table converted to data.table
#'
#' @examples a <- data.frame(a=1,b=2)
#' #a <- check_table(a)
check_table <- function(x) {
  UseMethod('check_table')
}

#' @rdname check_table
#'
#' @export
check_table.default <- function(x){
  data.table::setDT(x)
  return(x)
}

#' @rdname check_table
#'
#' @export
check_table.data.table <- function(x) {
  return(x)
}

