#' summary_table
#' wrapper function to create data.table on target variables using calc_stats
#'
#' @param dt table to perform function on
#' @param target vector of column names desired to obtain information on
#' @param treat string of treatment variable used for splitting / grouping data
#' @param target_name names to be displayed for target columns either NULL, which uses target, of vector of desired names for all target columns
#' @param indent indent to be used for display and formatting purposes
#' @param .total_dt optional table for total counts to be derived
#' @param pct_dec decimal places for percentages
#' @param treat_order customise the column order of output table
#' @param skip_absent Logical, default TRUE. Passed to data.table::setcolorder, if treat_order includes columns not present in dt, TRUE will silently ignore them, FALSE will throw an error.
#'
#' @return a data.table containing summary information on target variables specified
#' @export
#'
#' @import data.table
#'
#' @examples adsl <- random.cdisc.data::cadsl
#' vars<-c('AGE','RACE','ETHNIC','BMRKR1')
#' var_labels <- c("Age (yr)", "Race", "Ethnicity", "Continous Level Biomarker 1")
#' DMT01<-summary_table(adsl, target = vars, treat = 'ARM', target_name = var_labels, indent = '  ')
#' DMT01_pct<-summary_table(adsl, target = vars, treat = 'ARM', indent = '  ', .total_dt = adsl)

summary_table <- function(dt, target, treat, target_name = NULL,
                         indent = '&nbsp;&nbsp;&nbsp;&nbsp;', .total_dt = NULL,
                         pct_dec = 1, treat_order = NULL, skip_absent = TRUE) {
  dt <- check_table(dt)
  if (is.null(target_name)){
    target_name <- target
  }

  summary_list <- mapply(calc_stats, target = target, target_name = target_name,
                         treat = list(treat), indent = list(indent),
                         MoreArgs = list(dt = dt, .total_dt = .total_dt,
                                         pct_dec = pct_dec))

  table_summary <- data.table::rbindlist(summary_list, use.names = T)
  if (!is.null(treat_order)) {
    cols_missing <- sort(setdiff(colnames(table_summary), treat_order))
    table_summary <- data.table::setcolorder(
      table_summary,
      unique(c("stats", treat_order, cols_missing)),
      skip_absent = skip_absent
    )
  }
  return(table_summary)
}

#' Create a summary table using multiple rows for grouping on one target column
#'
#' @param dt table to perform function on
#' @param target vector of column names desired to obtain information on
#' @param treat string of treatment variable used for splitting / grouping data
#' @param rows_by string, grouping variable to split events by.
#' @param indent indent to be used for display and formatting purposes
#' @param .total_dt optional table for total counts to be derived
#' @param pct_dec decimal places for percentages
#' @param treat_order customise the column order of output table
#' @param skip_absent Logical, default TRUE. Passed to data.table::setcolorder, if treat_order includes columns not present in dt, TRUE will silently ignore them, FALSE will throw an error.
#'
#' @return list containing a data.table containing summary information on target variables specified
#' @export
#'
#' @import data.table
#'
#' @examples adlb <- random.cdisc.data::cadlb|>dplyr::filter(AVISIT != "SCREENING")
#' labs <- summary_table_by(adlb, 'AVAL', 'ARM', c('PARAM','AVISIT'), '  ', NULL)
#'

summary_table_by <- function(dt, target, treat, rows_by,
                             indent = '&nbsp;&nbsp;&nbsp;&nbsp;',
                             .total_dt = NULL, pct_dec = 1, treat_order = NULL,
                             skip_absent = TRUE){

  dt <- check_table(dt)
  dt <- split(droplevels(dt), by = rows_by, drop = T,sorted=T)
  label <- names(dt)
  if(length(rows_by)>1){
    label <- strsplit(label, '\\.')
    heading_full <- lapply(X=label, function(x){x[1]})
    heading <- unique(heading_full)
    label <- lapply(label,function(x){paste(x[2:length(x)],collapse='.')})
    label <- paste0(indent, label)
    indent <- paste0(indent,indent)
  }
  summary_split <- mapply(calc_stats, dt = dt, target = target, target_name = label,
                          treat = treat, indent = indent,
                          pct_dec = pct_dec)

  if(length(rows_by)>1){
    x <- 0
    for (i in 1:length(heading)) {
      y = sum(heading_full%in%heading[i])
      summary_split<-append(summary_split,list(data.table(stats=heading[[i]])),after = x)
      x <- x+y+1
    }
  }
  summary_split <- rbindlist(summary_split, use.names = T, fill = T)
  if (!is.null(treat_order)) {
    cols_missing <- sort(setdiff(colnames(summary_split), treat_order))
    summary_split <- data.table::setcolorder(
      summary_split,
      unique(c("stats", treat_order, cols_missing)),
      skip_absent = skip_absent
    )
  }
  return(list(summary_split))
}

#' Create a summary table using multiple rows for grouping on two target column
#' ideal for creating change from baseline tables
#'
#' @param dt table to perform function on
#' @param target vector of column names desired to obtain information on
#' @param treat string of treatment variable used for splitting / grouping data
#' @param rows_by string, grouping variable to split events by.
#' @param indent indent to be used for display and formatting purposes
#' @param .total_dt optional table for total counts to be derived
#' @param pct_dec decimal places for percentages
#' @param treat_order customise the column order of output table
#' @param skip_absent Logical, default TRUE. Passed to data.table::setcolorder, if treat_order includes columns not present in dt, TRUE will silently ignore them, FALSE will throw an error.
#'
#' @return data.table
#' @export
#'
#' @examples adlb <- random.cdisc.data::cadlb|>dplyr::filter(AVISIT != "SCREENING")
#' labs <- summary_table_by_targets(adlb, c('AVAL','CHG'), 'ARM', c('PARAM','AVISIT'), '  ', NULL)
summary_table_by_targets <- function(dt, target, treat, rows_by,
                                     indent = '&nbsp;&nbsp;&nbsp;&nbsp;',
                                     .total_dt = NULL, pct_dec = 1, treat_order = NULL,
                                     skip_absent = TRUE){
  if(length(target)!=2){
    print('target needs to be length 2')
  }
  dt <- check_table(dt)
  summary_tables <- mapply(summary_table_by, target = target,
                           MoreArgs = list(dt = dt, treat = treat, rows_by = rows_by,
                                           indent = indent, .total_dt = .total_dt,
                                           pct_dec = pct_dec, treat_order = treat_order,
                                           skip_absent = skip_absent))
  x <- summary_tables[[1]]
  y <- summary_tables[[2]]
  full <- x[,1]
  names(x) <- paste(names(x),target[1],sep = '.')
  names(y) <- paste(names(y),target[2],sep = '.')
   for (i in 2:ncol(x)){
     full<- data.table(full,x[,..i],y[,..i])
   }
  return(full)
}

