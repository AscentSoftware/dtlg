#' Create AET02-style AE summary table
#'
#' Summarises adverse events in a format similar to the AET02 table from a CSR,
#' showing total AE counts, patients with AEs, and a breakdown by System Organ
#' Class (SOC) and Preferred Term (PT).
#'
#' @param adsl Subject-level dataset.
#' @param adae Adverse event dataset.
#' @param patient Unique subject identifier variable.
#' @param treat Treatment arm variable.
#' @param target Preferred term variable for grouping (default: `"AEDECOD"`).
#' @param rows_by Higher-level term for nesting (default: `"AEBODSYS"`).
#' @param indent Character or string to indent nested rows (default: 4 non-breaking spaces).
#'
#' @returns A merged data.table containing AE summary.
#'
#' @examples
#' # Create a AET02 table
#' AET02_table(
#'   adsl = adsl,
#'   adae = aesi,
#'   patient = "USUBJID",
#'   treat = "ARM",
#'   target = "AEDECOD",
#'   rows_by = "AEBODSYS",
#'   indent = "  "
#' )
#'
#' @export
AET02_table <- function(adsl,
                        adae,
                        patient,
                        treat,
                        target = "AEDECOD",
                        rows_by = "AEBODSYS",
                        indent = nbsp(n = 4L)) {

  stopifnot(is.data.frame(adsl), is.data.frame(adae))
  stopifnot(all(c(patient, treat, target, rows_by) %in% colnames(adae)))
  stopifnot(patient %in% colnames(adsl))

  patients_with_ae_table <- event_count(
    dt = adae,
    patient = patient,
    treat = treat,
    label = "Total number of patients with at least one AE",
    .total_dt = adsl
  )

  total_ae_events_table <- total_events(
    dt = adae,
    treat = treat,
    label = "Total number of AEs"
  )

  ae_by_soc_pt_table <- list(
    event_count_by(
      dt = adae,
      patient = patient,
      treat = treat,
      target = target,
      rows_by = rows_by,
      .total_dt = adsl,
      indent = indent
    )
  )

  merge_table_lists(list(
    patients_with_ae_table,
    total_ae_events_table,
    ae_by_soc_pt_table
  ))
}

