#' Generate Core Safety Tables for Clinical Study Reports
#'
#' [AET01_table()] produces and combines the main safety summary tables
#' typically found in Section 14.3.1 of a Clinical Study Report (CSR). It
#' calculates patient counts and event totals for deaths, AE-related
#' withdrawals, total AEs, and adverse events of special interest (AESIs).
#'
#' @param adsl A subject-level dataset (typically ADaM ADSL).
#' @param adae A dataset of adverse events, preprocessed with AESI flags.
#' @param patient_var A string indicating the subject identifier variable (e.g., `"USUBJID"`).
#' @param treat_var A string indicating the treatment arm variable (e.g., `"ARM"`).
#' @param aesi_vars A character vector of binary AESI flags in `adae`.
#' @param aesi_heading Optional character string used as a heading in the AESI block.
#' @param indent A string used to indent AESI row labels (default is 2 spaces).
#'
#' @return A merged `data.table` summarising the main safety outcomes.
#'
#' @examples
#' AET01_summary <- AET01_table(
#'   adsl = adsl,
#'   adae = aesi,
#'   patient_var = "USUBJID",
#'   treat_var = "ARM",
#'   aesi_vars = c("FATAL", "SER", "SERWD", "SERDSM", "RELSER",
#'                 "WD", "DSM", "REL", "RELWD", "RELDSM", "SEV")
#' )
#' print(AET01_summary)
#'
#' @export
AET01_table <- function(adsl,
                        adae,
                        patient_var,
                        treat_var,
                        aesi_vars,
                        aesi_heading = "Total number of patients with at least one",
                        indent = "  ") {

  stopifnot(is.data.frame(adsl), is.data.frame(adae))
  missing_vars_adsl <- setdiff(c(patient_var, treat_var), names(adsl))
  missing_vars_adae <- setdiff(c(patient_var, treat_var), names(adae))

  if (length(missing_vars_adsl) > 0) {
    stop("The following variables are missing in `adsl`: ", toString(missing_vars_adsl))
  }

  if (length(missing_vars_adae) > 0) {
    stop("The following variables are missing in `adae`: ", toString(missing_vars_adae))
  }

  # Check AESI variables
  if (!is.character(aesi_vars) || length(aesi_vars) == 0) {
    stop("`aesi_vars` must be a non-empty character vector of variable names.")
  }

  missing_aesi_vars <- setdiff(aesi_vars, names(adae))
  if (length(missing_aesi_vars) > 0) {
    stop("The following `aesi_vars` are not found in `adae`: ", toString(missing_aesi_vars))
  }

  # --- Table Construction ---
  death_table <- event_count(
    dt = adsl,
    patient = patient_var,
    treat = treat_var,
    label = "Total number of deaths",
    .filters = "DTHFL == 'Y'"
  )

  withdrawal_table <- event_count(
    dt = adsl,
    patient = patient_var,
    treat = treat_var,
    label = "Total number of patients withdrawn from study due to an AE",
    .filters = "DCSREAS == 'ADVERSE EVENT'"
  )

  patients_with_ae_table <- event_count(
    dt = adae,
    patient = patient_var,
    treat = treat_var,
    label = "Total number of patients with at least one AE",
    .total_dt = adsl
  )

  total_ae_events_table <- total_events(
    dt = adae,
    treat = treat_var,
    label = "Total number of AEs"
  )

  aesi_table <- multi_event_true(
    dt = adae,
    event_vars = aesi_vars,
    patient = patient_var,
    treat = treat_var,
    heading = aesi_heading,
    .total_dt = adsl,
    indent = indent
  )

  merge_table_lists(list(
    patients_with_ae_table,
    total_ae_events_table,
    death_table,
    withdrawal_table,
    aesi_table
  ))
}
