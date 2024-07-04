#' event_count
#'
#' @param dt table to perform function on
#' @param patient string, column for unique patient identifier
#' @param treat string, treatment population to use as row headers
#' @param label row name to be displayed
#' @param .filters filter variables for event written as single string e.g. "DTHFL == 'Y' & SEX == 'M'
#'
#' @return data.table of event
#' @export
#'
#' @importFrom rlang parse_expr
#'
#' @examples x

event_count <- function(dt, patient, treat, label, .filters = NULL) {
 dt <- check_table(dt)
 event <- dt
 #come back and look at if this is the best way to apply multiple filters from variables
 if(!is.null(.filters)){
   event <- event[eval(rlang::parse_expr(.filters)), ]
 }
 dt <- dt[,.(total=.N), by=treat]
 event <- unique(event, by='USUBJID')
 event <- event[,.(n = .N), by = treat]
 event <- event[dt, on = treat]
 event <- event[, .(get(treat), paste0(n, ' (', round((n/total)*100, 2),'%)'))]
 event <- data.table::transpose(event,keep.names = 'events', make.names = 'V1', fill = 0)
 event <- event[, events := label]
}



