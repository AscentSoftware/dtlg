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

#' Create a summary table using multiple rows for grouping, only works for 2 row groups currently.
#'
#' @param dt table to perform function on
#' @param target vector of column names desired to obtain information on
#' @param treat string of treatment variable used for splitting / grouping data
#' @param rows_by string, grouping variable to split events by.
#' @param indent indent to be used for display and formatting purposes
#' @param .total_dt optional table for total counts to be derived
#'
#' @return a data.table containing summary information on target variables specified
#' @export
#'
#' @import data.table
#'
#' @examples adlb <- random.cdisc.data::cadlb
#' labs <- summary_table_by(adlb, 'AVAL', 'ARM', c('PARAM','AVISIT'), '  ', NULL)
#'

summary_table_by <- function(dt, target, treat, rows_by,
                             indent = '&nbsp;&nbsp;&nbsp;&nbsp;', .total_dt = NULL){
  dt <- check_table(dt)
  dt <- split(droplevels(dt), by = rows_by)
  label <- names(dt)
  if(length(rows_by>1)){
    label <- strsplit(label, '\\.')
    heading <- lapply(X=label, function(x){x[1]})
    heading <- unique(heading)
    label <- lapply(label,function(x){paste(x[2:length(x)],collapse='.')})
    label <- paste0(indent, label)
    indent <- paste0(indent,indent)
  }
  summary_split <- mapply(calc_stats, dt = dt, target = target, target_name = label,
                          treat = treat, indent = indent)
  #For rows_by of > 2, this method does not work as it lists like follows a:a, b:a, a:b, b:b
  # and not a:a, a:b, b:a, b:b
  x <- 0
  y <- length(summary_split)/length(heading)
  for (i in 1:length(heading)) {
    summary_split<-append(summary_split,list(data.table(stats=heading[[i]])),after = x)
    x <- x+y+1
  }
  summary_split <- rbindlist(summary_split, use.names = T, fill = T)
  return(summary_split)
}
