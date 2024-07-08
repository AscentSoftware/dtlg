#' event_count
#'
#' @param dt table to perform function on
#' @param patient string, column for unique patient identifier
#' @param treat string, treatment population to use as row headers
#' @param label row name to be displayed
#' @param .filters filter variables for event written as single string e.g. "DTHFL == 'Y' & SEX == 'M'
#' @param .total_dt optional table for total counts to be derived
#'
#' @return list containing data.table of event
#' @export
#'
#' @importFrom rlang parse_expr
#'
#' @examples x

event_count <- function(dt, patient, treat, label, .filters = NULL, .total_dt = NULL) {
 dt <- check_table(dt)
 event <- dt
 if(!is.null(.total_dt)){
   .total_dt <- check_table(.total_dt)
 } else {
   .total_dt <- dt
 }
 #come back and look at if this is the best way to apply multiple filters from variables
 if(!is.null(.filters)){
   event <- event[eval(rlang::parse_expr(.filters)), ]
 }
 .total_dt <- .total_dt[,.(total=.N), by=treat]
 event <- unique(event, by='USUBJID')
 event <- event[,.(n = .N), by = treat]
 event <- event[.total_dt, on = treat]
 event <- event[, .(get(treat), paste0(n, ' (', round((n/total)*100, 2),'%)'))]
 event <- data.table::transpose(event,keep.names = 'events', make.names = 'V1', fill = 0)
 event[, events := label]
 return(list(event))
}

#' total_events
#'
#' @param dt table to perform function on
#' @param treat string, treatment population to use as row headers
#' @param label row name to be displayed
#'
#' @return list containing data.table of event
#' @export
#'
#' @examples x
total_events <- function(dt, treat, label){
  dt <- check_table(dt)
  dt <- dt[,.(n = .N), by = treat]
  dt <- transpose(dt,keep.names = 'events',make.names = treat, fill=0)
  dt[, events := label]
  return(list(dt))
}

#' multi_event_true
#'
#' @param dt table to perform function on
#' @param event_vars events to perform counts on
#' @param patient string, column for unique patient identifier
#' @param treat string, treatment population to use as row headers
#' @param heading string, title row to add to the returned table
#' @param label row name to be displayed, if NULL then column name or label is used
#' @param .total_dt optional table for total counts to be derived
#' @param indent indentation to use for statistic row names, used for formatting outputs for shiny
#'
#' @return list of data.table containing events
#' @export
#'
#' @examples x
multi_event_true <- function(dt, event_vars, patient, treat, heading, label = NULL,
                             .total_dt = NULL, indent = '&nbsp;&nbsp;&nbsp;&nbsp;') {

  dt <- check_table(dt)
  event_filters <- paste0(event_vars, ' == T')
  if(is.null(label)){
    event_label <- lapply(event_vars, function(x) ifelse(is.null(attr(dt[,get(x)],'label')),x,
                                                   attr(dt[,get(x)],'label')))
  }

  event <- mapply(event_count, .filters = event_filters, label = event_label,
                  MoreArgs = list(dt = dt, patient = patient, treat = treat,
                                  .total_dt = .total_dt))
  event <- data.table::rbindlist(event, use.names = T, fill = 0)
  target_rows <- event[,events]
  event <- rbind(rep(list(''),times=ncol(event)),event)
  event[, events := c(heading, paste0(indent, target_rows))]
  return(list(event))
}

#' merge_table_lists
#'
#' @param dt_l nested list of data.table outputs from created from other dtlg functions
#'
#' @return data.table
#' @export
#'
#' @examples x
merge_table_lists <- function(dt_l){
  dt_l <- lapply(1:length(dt_l), function(x) dt_l[[x]][[1]])
  dt_l <- data.table::rbindlist(dt_l, use.names = T, fill = '0 (0%)')
}
