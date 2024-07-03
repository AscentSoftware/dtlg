#' get_desc
#'
#' Given a table, calculate descriptive statistics for a target column.
#'
#' @param dt table input to use.
#' @param target string, column name to calculate descriptive statistics about
#' @param target_name string, how to display column name when new table is create, if null then target column name is used
#' @param treat string, treatment population to use as row headers
#' @param indent indentation to use for statistic row names, used for formatting outputs for shiny
#'
#' @return table output of new descriptive information.
#' @export
#'
#' @import data.table
#'
#' @examples x
#'

calc_desc <- function(dt, target, target_name = NULL, treat,
                     indent = '&nbsp;&nbsp;&nbsp;&nbsp;'){
  dt <- check_table(dt)
  if (is.null(target_name)){
    target_name <- target
  }
  stat_names <- c(paste0(indent,'n'),
                  paste0(indent,'Mean (SD)'),
                  paste0(indent,'Median'),
                  paste0(indent,'Min, Max'),
                  paste0(indent,'Missing'))

  dt_stats <- dt[,.(n = .N,
                    Mean.SD = paste0(round(mean(get(target), na.rm = T),2),
                                     ' (',round(sd(get(target), na.rm = T),2),')'),
                    Median = round(median(get(target), na.rm = T),2),
                    Min.Max = paste0(round(min(get(target), na.rm = T),2)
                                     ,', ',round(max(get(target), na.rm = T),2))),
                 by=treat]
  dt_missing<-dt[is.na(get(target)),.(Missing = .N), by=treat]
  if (nrow(dt_missing)==0) {
    dt_stats[,Missing := 0]
  } else {
    dt_stats[dt_missing, on=.(treat=treat)]
  }
  dt_stats <- dt_stats[,.(treatment = get(treat),x = '', dt_stats[,2:ncol(dt_stats)])]
  dt_stats <- data.table::transpose(dt_stats, keep.names = 'stats', make.names = 'treatment')
  dt_stats[,stats := c(target_name, stat_names)]
  return(dt_stats)
}


#' Title
#'
#' @param dt table input to use.
#' @param target string, column name to calculate count statistics on
#' @param target_name string, how to display column name when new table is create, if null then target column name is used
#' @param treat string, treatment population to use as row headers
#' @param indent indentation to use for statistic row names, used for formatting outputs for shiny
#'
#' @return data.table
#' @export
#'
#' @examples x

calc_counts <- function(dt, target, target_name = NULL, treat,
                       indent = '&nbsp;&nbsp;&nbsp;&nbsp;') {
  dt <- check_table(dt)
  if (is.null(target_name)){
    target_name <- target
  }
  dt_count <- dt[,.(n = .N), by = list(treatment=get(treat),stats=get(target))]
  dt_count <- data.table::dcast(dt_count, stats ~ treatment, value.var = 'n', fill = 0)

  target_rows <- dt_count[,stats]

  dt_count <- rbind(rep(list(''),times=ncol(dt_count)),dt_count)

  dt_count[,stats := c(target_name, paste0(indent,as.character(target_rows)))]

}



