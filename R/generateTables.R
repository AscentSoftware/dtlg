#' summary_table
#' wrapper function to create data.table on target variables using calc_stats
#'
#' @param dt table to perform function on
#' @param target vector of column names desired to obtain information on
#' @param treat string of treatment variable used for splitting / grouping data
#' @param target_name names to be displayed for target columns either NULL, which uses target, of vector of desired names for all target columns
#' @param indent indent to be used for display and formatting purposes
#' @param .total_dt optional table for total counts to be derived
#'
#' @return a data.table containing summary information on target variables specified
#' @export
#'
#' @import data.table
#'
#' @examples adsl <- random.cdisc.data::cadsl
#' vars<-c('AGE','RACE','ETHNIC','BMRKR1')
#' var_labels <- c("Age (yr)","Sex", "Ethnicity", "Race", "Continous Level Biomarker 1")
#' DMT01<-summary_table(adsl, target = vars, treat = 'ARM', target_name = var_lables, indent = '  ')
#' DMT01_pct<-summary_table(adsl, target = vars, treat = 'ARM', indent = '  ', .total_dt = adsl)

summary_table <- function(dt, target, treat, target_name = NULL,
                         indent = '&nbsp;&nbsp;&nbsp;&nbsp;', .total_dt = NULL) {
  dt <- check_table(dt)
  if (is.null(target_name)){
    target_name <- target
  }

  summary_list <- mapply(calc_stats, target = target, target_name = target_name,
                         treat = list(treat), indent = list(indent),
                         MoreArgs = list(dt = dt, .total_dt = .total_dt))

  table_summary <- data.table::rbindlist(summary_list,use.names = T)
  return(table_summary)
}
