#' Merge a list of list-wrapped data.tables into one data.table
#'
#' This function is typically used to combine multiple reporting tables,
#' each produced by `event_count()`, `total_events()`, or
#' `multi_event_true()`, into a single summary table. These intermediate tables
#' are often returned as one-element lists containing a `data.table`.
#'
#' This helper unwraps and merges them, row-wise, to produce a
#' consolidated safety report table --- commonly used in clinical study reports
#' or data monitoring reviews.
#'
#' @param dt_l A list of one-element lists, where each element is a list
#'   containing a single `data.table`.
#'
#' @returns A single merged `data.table`, row-bound from all input tables.
#'
#' @examples
#' # Count deaths by treatment arm
#' death_table <- event_count(
#'   adsl,
#'   patient = "USUBJID",
#'   treat = "ARM",
#'   label = "Total number of deaths",
#'   .filters = "DTHFL == 'Y'"
#' )
#'
#' # Count study withdrawals due to adverse events
#' withdrawal_table <- event_count(
#'   adsl,
#'   patient = "USUBJID",
#'   treat = "ARM",
#'   label = "Total number of patients withdrawn from study due to an AE",
#'   .filters = "DCSREAS == 'ADVERSE EVENT'"
#' )
#'
#' # Count patients with at least one adverse event
#' patients_with_ae_table <- event_count(
#'   adae,
#'   patient = "USUBJID",
#'   treat = "ARM",
#'   label = "Total number of patients with at least one AE"
#' )
#'
#' # Count total number of adverse events (not patients)
#' total_ae_events_table <- total_events(
#'   dt = adae,
#'   treat = "ARM",
#'   label = "Total number of AEs"
#' )
#'
#' # Summarise AESIs (e.g., serious, related, severe, etc.)
#' aesi_vars <- c("FATAL", "SER", "SERWD", "SERDSM", "RELSER",
#'                "WD", "DSM", "REL", "RELWD", "RELDSM", "SEV")
#'
#' aesi_table <- multi_event_true(
#'   dt = aesi,
#'   event_vars = aesi_vars,
#'   patient = "USUBJID",
#'   treat = "ARM",
#'   heading = "Total number of patients with at least one",
#'   .total_dt = adsl,
#'   indent = "  "
#' )
#'
#' # Combine all safety tables into a single summary table
#' safety_summary <- merge_table_lists(list(
#'   patients_with_ae_table,
#'   total_ae_events_table,
#'   death_table,
#'   withdrawal_table,
#'   aesi_table
#' ))
#'
#' safety_summary
#'
#' @export
merge_table_lists <- function(dt_l) {
  dt_l <- lapply(dt_l, `[[`, 1)
  data.table::rbindlist(dt_l, use.names = TRUE)
}

