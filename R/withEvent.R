#' event_count
#' Functionality to count the number of distinct occurrences of an 'event', defined using .filters,
#' using patient as the identifier.
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
#' @examples adsl <- random.cdisc.data::cadsl
#' adae <- random.cdisc.data::cadae |> dplyr::filter(ANL01FL == "Y")
#' a<-event_count(adsl,patient = "USUBJID",treat = "ARM", label = "Total number of deaths", .filters = "DTHFL == 'Y'", .total_dt = NULL)
#' b<-event_count(adsl,patient = "USUBJID",treat = "ARM", label = "Total number of patients withdrawn from study due to an AE", .filters = "DCSREAS == 'ADVERSE EVENT'", .total_dt = NULL)
#' d<-event_count(adae, patient = "USUBJID", treat = "ARM", label = "Total number of patients with at least one AE",.total_dt = adsl)

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
#' Identify the total count of treatment groups
#'
#' @param dt table to perform function on
#' @param treat string, treatment population to use as row headers
#' @param label row name to be displayed
#'
#' @return list containing data.table of event
#' @export
#'
#' @examples adae <- random.cdisc.data::cadae |> dplyr::filter(ANL01FL == "Y")
#' e <- total_events(adae, 'ARM', 'Total number of AEs')

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
#' @examples set.seed(99)
#' adae <- random.cdisc.data::cadae |> dplyr::mutate(
#' AEDECOD = with_label(as.character(AEDECOD), "Dictionary-Derived Term"),
#' AESDTH = with_label(
#'   sample(c("N", "Y"), size = nrow(adae), replace = TRUE, prob = c(0.99, 0.01)),
#'   "Results in Death"
#' ),
#' AEACN = with_label(
#'   sample(
#'     c("DOSE NOT CHANGED", "DOSE INCREASED", "DRUG INTERRUPTED", "DRUG WITHDRAWN"),
#'     size = nrow(adae),
#'     replace = TRUE, prob = c(0.68, 0.02, 0.25, 0.05)
#'   ),
#'   "Action Taken with Study Treatment"
#' ),
#' FATAL = formatters::with_label(AESDTH == "Y", "AE with fatal outcome"),
#' SEV = formatters::with_label(AESEV == "SEVERE", "Severe AE (at greatest intensity)"),
#' SER = formatters::with_label(AESER == "Y", "Serious AE"),
#' SERWD = formatters::with_label(AESER == "Y" & AEACN == "DRUG WITHDRAWN", "Serious AE leading to withdrawal from treatment"),
#' SERDSM = formatters::with_label(
#'   AESER == "Y" & AEACN %in% c("DRUG INTERRUPTED", "DOSE INCREASED", "DOSE REDUCED"),
#'   "Serious AE leading to dose modification/interruption"
#' ),
#' RELSER = formatters::with_label(AESER == "Y" & AEREL == "Y", "Related Serious AE"),
#' WD = formatters::with_label(AEACN == "DRUG WITHDRAWN", "AE leading to withdrawal from treatment"),
#' DSM = formatters::with_label(
#'   AEACN %in% c("DRUG INTERRUPTED", "DOSE INCREASED", "DOSE REDUCED"), "AE leading to dose modification/interruption"
#' ),
#' REL = formatters::with_label(AEREL == "Y", "Related AE"),
#' RELWD = formatters::with_label(AEREL == "Y" & AEACN == "DRUG WITHDRAWN", "Related AE leading to withdrawal from treatment"),
#' RELDSM = formatters::with_label(
#'  AEREL == "Y" & AEACN %in% c("DRUG INTERRUPTED", "DOSE INCREASED", "DOSE REDUCED"),
#'   "Related AE leading to dose modification/interruption"
#' )) |> dplyr::filter(ANL01FL == "Y")
#'
#' aesi_vars <- c("FATAL", "SER", "SERWD", "SERDSM", "RELSER", "WD", "DSM", "REL", "RELWD", "RELDSM", "SEV")
#' f <- multi_event_true(adae, event_vars = aesi_vars, patient = "USUBJID", treat = "ARM", heading = "Total number of patients with at least one", .total_dt = adsl, indent = "  ")
multi_event_true <- function(dt, event_vars, patient, treat, heading, label = NULL,
                             .total_dt = NULL, indent = '&nbsp;&nbsp;&nbsp;&nbsp;') {

  dt <- check_table(dt)
  event_filters <- paste0(event_vars, ' == T')
  if(is.null(label)){
    event_label <- lapply(event_vars, function(x) ifelse(is.null(attr(dt[,get(x)],'label')),x,
                                                   attr(dt[,get(x)],'label')))
  } else {
    event_label <- label
  }

  event <- mapply(event_count, .filters = event_filters, label = event_label,
                  MoreArgs = list(dt = dt, patient = patient, treat = treat,
                                  .total_dt = .total_dt))
  event <- data.table::rbindlist(event, use.names = T)
  target_rows <- event[,events]
  event <- rbind(rep(list(''),times=ncol(event)),event)
  event[, events := c(heading, paste0(indent, target_rows))]
  return(list(event))
}

#' merge_table_lists
#'
#' @param dt_l nested list of data.table outputs from created from other dtlg functions
#'
#' @return data.table containing all listed data.tables
#' @export
#'
#' @examples set.seed(99)
#' adae <- random.cdisc.data::cadae |> dplyr::mutate(
#' AEDECOD = formatters::with_label(as.character(AEDECOD), "Dictionary-Derived Term"),
#' AESDTH = formatters::with_label(
#'   sample(c("N", "Y"), size = nrow(adae), replace = TRUE, prob = c(0.99, 0.01)),
#'   "Results in Death"
#' ),
#' AEACN = formatters::with_label(
#'   sample(
#'     c("DOSE NOT CHANGED", "DOSE INCREASED", "DRUG INTERRUPTED", "DRUG WITHDRAWN"),
#'     size = nrow(adae),
#'     replace = TRUE, prob = c(0.68, 0.02, 0.25, 0.05)
#'   ),
#'   "Action Taken with Study Treatment"
#' ),
#' FATAL = formatters::with_label(AESDTH == "Y", "AE with fatal outcome"),
#' SEV = formatters::with_label(AESEV == "SEVERE", "Severe AE (at greatest intensity)"),
#' SER = formatters::with_label(AESER == "Y", "Serious AE"),
#' SERWD = formatters::with_label(AESER == "Y" & AEACN == "DRUG WITHDRAWN", "Serious AE leading to withdrawal from treatment"),
#' SERDSM = formatters::with_label(
#'   AESER == "Y" & AEACN %in% c("DRUG INTERRUPTED", "DOSE INCREASED", "DOSE REDUCED"),
#'   "Serious AE leading to dose modification/interruption"
#' ),
#' RELSER = formatters::with_label(AESER == "Y" & AEREL == "Y", "Related Serious AE"),
#' WD = formatters::with_label(AEACN == "DRUG WITHDRAWN", "AE leading to withdrawal from treatment"),
#' DSM = formatters::with_label(
#'   AEACN %in% c("DRUG INTERRUPTED", "DOSE INCREASED", "DOSE REDUCED"), "AE leading to dose modification/interruption"
#' ),
#' REL = formatters::with_label(AEREL == "Y", "Related AE"),
#' RELWD = formatters::with_label(AEREL == "Y" & AEACN == "DRUG WITHDRAWN", "Related AE leading to withdrawal from treatment"),
#' RELDSM = formatters::with_label(
#'  AEREL == "Y" & AEACN %in% c("DRUG INTERRUPTED", "DOSE INCREASED", "DOSE REDUCED"),
#'   "Related AE leading to dose modification/interruption"
#' )) |> dplyr::filter(ANL01FL == "Y")
#' adsl <- random.cdisc.data::cadsl
#' a<-event_count(adsl,patient = "USUBJID",treat = "ARM", label = "Total number of deaths", .filters = "DTHFL == 'Y'", .total_dt = NULL)
#' b<-event_count(adsl,patient = "USUBJID",treat = "ARM", label = "Total number of patients withdrawn from study due to an AE", .filters = "DCSREAS == 'ADVERSE EVENT'", .total_dt = NULL)
#' d<-event_count(adae, patient = "USUBJID", treat = "ARM", label = "Total number of patients with at least one AE",.total_dt = adsl)
#'
#' e <- total_events(adae, 'ARM', 'Total number of AEs')
#' aesi_vars <- c("FATAL", "SER", "SERWD", "SERDSM", "RELSER", "WD", "DSM", "REL", "RELWD", "RELDSM", "SEV")
#' f <- multi_event_true(adae, event_vars = aesi_vars, patient = "USUBJID", treat = "ARM", heading = "Total number of patients with at least one", .total_dt = adsl, indent = "  ")
#'
#' AET01 <- merge_table_list()
merge_table_lists <- function(dt_l){
  dt_l <- lapply(1:length(dt_l), function(x) dt_l[[x]][[1]])
  dt_l <- data.table::rbindlist(dt_l, use.names = T)
}
