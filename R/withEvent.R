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

event_count <- function(dt, patient, treat, label, .filters = NULL, .total_dt = NULL, pct_dec = 2) {
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
 event <- event[, .(get(treat), paste0(n, ' (', round((n/total)*100, digits = pct_dec),'%)'))]
 event <- data.table::transpose(event,keep.names = 'stats', make.names = 'V1', fill = 0)
 event[, stats := label]
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
  dt <- transpose(dt,keep.names = 'stats',make.names = treat, fill=0)
  dt[, stats := label]
  return(list(dt))
}

#' calculate the event statistics for T/F columns
#'
#' @param dt table to perform function on
#' @param event_vars events to perform counts on
#' @param patient string, column for unique patient identifier
#' @param treat string, treatment population to use as column headers
#' @param heading string, title row to add to the returned table
#' @param label row name to be displayed, if NULL then column name or label is used
#' @param .total_dt optional table for total counts to be derived
#' @param indent indentation to use for statistic row names, used for formatting outputs for shiny
#'
#' @return list of data.table containing events
#' @export
#'
#' @examples set.seed(99)
#' adae <- random.cdisc.data::cadae
#' adae <- adae |> dplyr::mutate(
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
  target_rows <- event[,stats]
  event <- rbind(rep(list(''),times=ncol(event)),event)
  event[, stats := c(heading, paste0(indent, target_rows))]
  return(list(event))
}

#' merge a list of tables stored in lists
#'
#' @param dt_l nested list of data.table outputs from created from other dtlg functions
#'
#' @return data.table containing all listed data.tables
#' @export
#'
#' @examples set.seed(99)
#' adae <- random.cdisc.data::cadae
#' adae <- adae |> dplyr::mutate(
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
#' AET01 <- merge_table_lists(list(d,e,a,b,f))
merge_table_lists <- function(dt_l){
  dt_l <- lapply(1:length(dt_l), function(x) dt_l[[x]][[1]])
  dt_l <- data.table::rbindlist(dt_l, use.names = T)
}

#' count total, at least one and splits on the treatment, grouping and target variables
#'
#' @param dt table to perform function on
#' @param patient string, column for unique patient identifier
#' @param treat string, treatment population to use as column headers
#' @param rows_by string, grouping variable to split events by.
#' @param target string, target column to provide further counts within group provided by rows_by
#' @param .total_dt optional table for total counts to be derived
#' @param indent indentation to use for statistic row names, used for formatting outputs for shiny
#'
#' @return data.table
#' @export
#'
#' @examples adae <- random.cdisc.data::cadae |> dplyr::filter(ANL01FL == "Y")
#' adsl <- random.cdisc.data::cadsl
#' a <-event_count_by(dt=adae, patient='USUBJID', treat='ARM', target='AEDECOD',rows_by = 'AEBODSYS',.total_dt = adsl, indent = ' ')
#'

event_count_by <- function(dt, patient, treat, rows_by, target, .total_dt = NULL,
                           indent = '&nbsp;&nbsp;&nbsp;&nbsp;'){
  dt <- check_table(dt)
  event <- dt
  if(!is.null(.total_dt)){
    .total_dt <- check_table(.total_dt)
  } else {
    .total_dt <- dt
  }
  event_split <- split(droplevels(event), by = rows_by, drop = T)
  event_patient <- mapply(event_count, dt = event_split, treat = treat,
                          label = 'Total number of patients with at least one event',
                         MoreArgs = list(.total_dt=.total_dt,
                                         patient = patient))
  event_total <- mapply(total_events, event_split, treat = treat,
                        label = 'Total number of events')
  event_target <- mapply(calc_stats, dt = event_split, target = target, treat = treat,
                         indent=indent, target_name = names(event_split), MoreArgs = list(.total_dt=.total_dt))
  event_table <- mapply(list, event_target, event_total, event_patient)
  event_table <- rbindlist(event_table, use.names=T)
 return(event_table)
}
