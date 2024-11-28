#' calc_desc
#'
#' Given a table, calculate descriptive statistics for a target column.
#'
#' @param dt table input to use.
#' @param target string, column name to calculate descriptive statistics about
#' @param target_name string, how to display column name when new table is create, if null then target column name is used
#' @param treat string, treatment population to use as row headers
#' @param indent indentation to use for statistic row names, used for formatting outputs for shiny
#'
#' @return a list containing a data.table
#' @export
#'
#' @import data.table
#'
#' @examples adsl<- random.cdisc.data::cadsl
#' age<-calc_desc(adsl, 'AGE', 'AGE', treat='ARM')
#'

calc_desc <- function(dt, target, target_name, treat,
                      indent = '&nbsp;&nbsp;&nbsp;&nbsp;'){
  dt <- check_table(dt)
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

    # Merge stats data.table with missing data.table
    dt_stats <- dt_missing[dt_stats, on=treat][, Missing := data.table::fifelse(is.na(Missing), 0, Missing)]
    data.table::setcolorder(dt_stats, c(setdiff(names(dt_stats), "Missing"), "Missing"))
  }
  dt_stats <- dt_stats[,.(treatment = get(treat),x = '', dt_stats[,2:ncol(dt_stats)])]
  dt_stats <- data.table::transpose(dt_stats, keep.names = 'stats', make.names = 'treatment')
  dt_stats[,stats := c(target_name, stat_names)]
  return(list(dt_stats))
}


#' calc_counts
#' generate counts of a column
#' @param dt table input to use.
#' @param target string, column name to calculate count statistics on
#' @param target_name string, how to display column name when new table is create, if null then target column name is used
#' @param treat string, treatment population to use as row headers
#' @param indent indentation to use for statistic row names, used for formatting outputs for shiny
#' @param .total_dt optional table for total counts to be derived
#'
#' @return a list containing a data.table
#' @export
#'
#' @import data.table
#'
#' @examples adsl <- random.cdisc.data::cadsl
#' RACE<-calc_counts(dt = adsl, 'RACE', target_name = 'RACE', treat = 'ARM', indent = '')

calc_counts <- function(dt, target, target_name, treat,
                       indent = '&nbsp;&nbsp;&nbsp;&nbsp;', .total_dt = NULL) {
  dt <- check_table(dt)

  dt_count <- dt[,.(n = .N), by = list(treatment = get(treat),stats = get(target))]
  if(!is.null(.total_dt)){
    .total_dt <- check_table(.total_dt)
    .total_dt <- .total_dt[,.(total=.N), by=list(treatment = get(treat))]
    dt_count <- dt_count[.total_dt, on = 'treatment']
    dt_count <- dt_count[, .(treatment, stats, n=paste0(n, ' (', round((n/total)*100, 2),'%)'))]
  }

  dt_count <- data.table::dcast(dt_count, stats ~ treatment, value.var = 'n', fill = 0)

  target_rows <- dt_count[,stats]

  dt_count <- rbind(rep(list(''),times=ncol(dt_count)),dt_count)

  dt_count[,stats := c(target_name, paste0(indent,as.character(target_rows)))]
  return(list(dt_count))
}


#' calc_stats
#' wrapper of calc_desc and calc_counts
#'
#' @param dt table input to use.
#' @param target string, column name to calculate count statistics on
#' @param target_name string, how to display column name when new table is created, if null, target is used
#' @param treat string, treatment population to use as row headers
#' @param indent indentation to use for statistic row names, used for formatting outputs for shiny
#' @param .total_dt optional table for total counts to be derived, works for character, logical and factor
#'
#' @return a list containing a data.table
#' @export
#'
#' @examples adsl <- random.cdisc.data::cadsl
#' age<-calc_stats(adsl,'AGE',treat='ARM')

calc_stats <- function(dt, target, target_name, treat,
                       indent = '&nbsp;&nbsp;&nbsp;&nbsp;',
                       .total_dt = NULL){
  dt <- check_table(dt)
  UseMethod('calc_stats', dt[,(get(target))])
}

#' @rdname calc_stats
#' @export

calc_stats.numeric <- function(dt, target, target_name=NULL, treat,
                               indent = '&nbsp;&nbsp;&nbsp;&nbsp;', .total_dt=NULL) {
  if (is.null(target_name)){
    target_name <- target
  }
  x <- calc_desc(dt=dt,target=target, target_name = target_name, treat=treat,
            indent = indent)
  return(x)
}

#' @rdname calc_stats
#' @export

calc_stats.character <- function(dt, target, target_name=NULL, treat,
                               indent = '&nbsp;&nbsp;&nbsp;&nbsp;', .total_dt=NULL) {
  if (is.null(target_name)){
    target_name <- target
  }
  x <- calc_counts(dt=dt,target=target, target_name = target_name, treat=treat,
            indent = indent, .total_dt = .total_dt)
  return(x)
}

#' @rdname calc_stats
#' @export

calc_stats.factor <- function(dt, target, target_name=NULL, treat,
                                 indent = '&nbsp;&nbsp;&nbsp;&nbsp;', .total_dt=NULL) {
  if (is.null(target_name)){
    target_name <- target
  }
  x <- calc_counts(dt=dt,target=target, target_name = target_name, treat=treat,
              indent = indent, .total_dt = .total_dt)
  return(x)
}

#' @rdname calc_stats
#' @export

calc_stats.logical <- function(dt, target, target_name=NULL, treat,
                              indent = '&nbsp;&nbsp;&nbsp;&nbsp;', .total_dt=NULL) {
  if (is.null(target_name)){
    target_name <- target
  }
  x <- calc_counts(dt=dt,target=target, target_name = target_name, treat=treat,
              indent = indent, .total_dt = .total_dt)
  return(x)
}
