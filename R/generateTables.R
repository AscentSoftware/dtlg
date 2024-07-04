#' summary_table
#'
#' @param dt table to perform function on
#' @param target vector of column names desired to obtain information on
#' @param treat string of treatment variable used for splitting / grouping data
#' @param target_name names to be displayed for target columns either NULL, which uses target, of vector of desired names for all target columns
#' @param indent indent to be used for display and formatting purposes
#'
#' @return a data.table containing summary information on target variables specified
#' @export
#'
#' @examples x

summary_table <- function(dt, target, treat, target_name = NULL,
                         indent = '&nbsp;&nbsp;&nbsp;&nbsp;') {
  dt <- check_table(dt)
  if (is.null(target_name)){
    target_name <- target
  }
  summary_list <- mapply(calc_stats, target = target, target_name = target_name,
                         treat = list(treat), indent = list(indent),
                         MoreArgs = list(dt = dt))
  table_summary <- data.table::rbindlist(summary_list,use.names = T)
  return(table_summary)
}
