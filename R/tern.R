#' Create a clinical reporting table with tern/rtables
#'
#' [tern_summary_table()] is a convenience wrapper around `{rtables}` and
#' `{tern}` commands to generate a clinical reporting summary statistics tables
#' whilst using a similar interface as [summary_table()]. This can be helpful
#' for side by side comparisons of the two functions.
#'
#' @inherit summary_table
#'
#' @seealso [summary_table()]
#'
#' @examples
#' dmg_vars <- c("AGE", "RACE", "ETHNIC")
#' dmg_var_lbls <- c("Age (yr)", "Race", "Ethnicity")
#'
#' # Demographics table (DMT01)
#' tern_summary_table(
#'   adsl,
#'   target = dmg_vars,
#'   treat = "ARM",
#'   target_name = dmg_var_lbls
#' )
#'
#' # Demographics table (DMT01) with continuous variable (e.g., BMRKR1)
#' tern_summary_table(
#'   adsl,
#'   target = c(dmg_vars, "BMRKR1"),
#'   treat = "ARM",
#'   target_name = c(dmg_var_lbls, "Biomarker 1")
#' )
#'
#' @export
tern_summary_table <- function(dt, target, treat, target_name = target) {

  assert_pkg_is_installed("rtables")
  assert_pkg_is_installed("tern")

  dt <- tern::df_explicit_na(dt, na_level = "Missing")

  rtables::basic_table(show_colcounts = TRUE) |>
    rtables::split_cols_by(var = treat) |>
    tern::analyze_vars(vars = target, var_labels = target_name, na_rm = FALSE) |>
    rtables::build_table(dt)
}

#' Convert a TableTree to a dtlg table
#'
#' [as_dtlg_table()] reformats a TableTree object into a format close to that
#' of dtlg's `data.table`.
#'
#' @param tt A TableTree object. Typically obtained with [tern_summary_table()].
#'
#' @param .label_col Label for stats' column.
#'
#' @returns A data.table.
#'
#' @examples
#' vars <- c('AGE', 'RACE', 'ETHNIC', 'BMRKR1')
#' var_labels <- c("Age (yr)", "Race", "Ethnicity", "Continuous Level Biomarker 1")
#'
#' # Summary statistics table split by ARM with custom labels.
#' (tt <- tern_summary_table(
#'   adsl,
#'   target = vars,
#'   treat = 'ARM',
#'   target_name = var_labels
#' ))
#'
#' # Format as a dtlg table
#' as_dtlg_table(tt)
#'
#' @export
as_dtlg_table <- function(tt, .label_col = "stats") {

  assert_pkg_is_installed("rtables")
  assert_pkg_is_installed("dplyr")

  rtables::as_result_df(
    tt,
    simplify = TRUE,
    keep_label_rows = TRUE,
    data_format = "strings"
  ) |>
    dplyr::rename("{.label_col}" := "label_name") |>
    dplyr::mutate(dplyr::across(is.character, ~ dplyr::if_else(is.na(.x), "", .x))) |>
    data.table::as.data.table()
}

#' Generate Core Safety Tables (CSR Section 14.3.1) using `tern`/`rtables`
#'
#' [tern_AET01_table()] produces a consolidated safety summary table using
#' `rtables` and `tern`. It mirrors the output and interface of
#' [AET01_table()], generating standard adverse event summaries (e.g. death,
#' withdrawal, AESIs) for Clinical Study Reports (CSR) Section 14.3.1.
#'
#' The function returns a single formatted `rtables` table summarising core
#' safety endpoints by treatment arm.
#'
#' @param adsl A subject-level dataset (typically ADaM ADSL).
#'
#' @param adae A dataset of adverse events, preprocessed with AESI flags.
#'
#' @param patient_var A string indicating the subject identifier variable (e.g.,
#'   `"USUBJID"`).
#'
#' @param treat_var A string indicating the treatment arm variable (e.g., `"ARM"`).
#'
#' @param aesi_vars A character vector of binary AESI flags in `adae`.
#'
#' @param aesi_heading Ignored (included for interface compatibility).
#'
#' @param indent Ignored (included for interface compatibility).
#'
#' @return A `TableTree` object from the `rtables` package.
#'
#' @examples
#' tern_AET01_table(
#'   adsl = adsl,
#'   adae = aesi,
#'   patient_var = "USUBJID",
#'   treat_var = "ARM",
#'   aesi_vars = c("FATAL", "SER", "SERWD", "SERDSM", "RELSER",
#'                 "WD", "DSM", "REL", "RELWD", "RELDSM", "SEV")
#' )
#'
#' @export
tern_AET01_table <- function(adsl,
                             adae,
                             patient_var,
                             treat_var,
                             aesi_vars,
                             aesi_heading = "Total number of patients with at least one",
                             indent = "  ") {

  # --- Input validation ---
  stopifnot(is.data.frame(adsl), is.data.frame(adae))

  required_vars <- c(patient_var, treat_var)
  missing_vars_adsl <- setdiff(required_vars, names(adsl))
  missing_vars_adae <- setdiff(required_vars, names(adae))

  if (length(missing_vars_adsl) > 0) {
    stop("The following variables are missing in `adsl`: ", paste(missing_vars_adsl, collapse = ", "))
  }

  if (length(missing_vars_adae) > 0) {
    stop("The following variables are missing in `adae`: ", paste(missing_vars_adae, collapse = ", "))
  }

  if (!is.character(aesi_vars) || length(aesi_vars) == 0) {
    stop("`aesi_vars` must be a non-empty character vector.")
  }

  missing_aesi <- setdiff(aesi_vars, names(adae))
  if (length(missing_aesi) > 0) {
    stop("The following `aesi_vars` are not in `adae`: ", paste(missing_aesi, collapse = ", "))
  }

  # --- ADSL layout: deaths and withdrawals ---
  lyt_adsl <- rtables::basic_table(show_colcounts = TRUE) |>
    rtables::split_cols_by(treat_var) |>
    tern::count_patients_with_event(
      patient_var,
      filters = c("DTHFL" = "Y"),
      denom = "N_col",
      .labels = c(count_fraction = "Total number of deaths"),
      table_names = "death_count"
    ) |>
    tern::count_patients_with_event(
      patient_var,
      filters = c("DCSREAS" = "ADVERSE EVENT"),
      denom = "N_col",
      .labels = c(count_fraction = "Total number of patients withdrawn from study due to an AE"),
      table_names = "ae_withdrawal"
    )

  tbl_adsl <- rtables::build_table(lyt_adsl, df = adsl, alt_counts_df = adsl)

  # --- ADAE layout: AE summary and AESIs ---
  aesi_labels <- sapply(aesi_vars, \(x) label(adae[[x]]) %||% x)

  lyt_adae <- rtables::basic_table(show_colcounts = TRUE) |>
    rtables::split_cols_by(treat_var) |>
    tern::analyze_num_patients(
      vars = patient_var,
      .stats = c("unique", "nonunique"),
      .labels = c(
        unique = "Total number of patients with at least one AE",
        nonunique = "Total number of AEs"
      ),
      .formats = list(unique = tern::format_count_fraction_fixed_dp, nonunique = "xx"),
      show_labels = "hidden"
    ) |>
    tern::count_patients_with_flags(
      patient_var,
      flag_variables = aesi_vars,
      .labels = aesi_labels,
      denom = "N_col",
      var_labels = aesi_heading,
      show_labels = "visible"
    )

  tbl_adae <- rtables::build_table(lyt_adae, df = adae, alt_counts_df = adsl)

  # --- Merge final result with consistent col_info ---
  rtables::col_info(tbl_adsl) <- rtables::col_info(tbl_adae)

  rbind(
    tbl_adae[1:2, ],
    tbl_adsl,
    tbl_adae[3:nrow(tbl_adae), ]
  )
}

#' Generate AET02-style AE summary using `tern` and `rtables`
#'
#' This function builds a System Organ Class (SOC) and Preferred Term (PT)
#' adverse event summary table, following the AET02 CSR format, using the
#' `tern` and `rtables` packages.
#'
#' @param adsl Subject-level dataset.
#' @param adae Adverse event dataset.
#' @param patient Unique subject identifier variable.
#' @param treat Treatment arm variable.
#' @param target Preferred term variable (default: `"AEDECOD"`).
#' @param rows_by Higher-level nesting term (default: `"AEBODSYS"`).
#' @param indent Ignored (included for compatibility).
#'
#' @returns A `TableTree` object with AE summary by SOC/PT.
#'
#' @seealso [AET02_table()]
#'
#' @export
tern_AET02_table <- function(adsl,
                             adae,
                             patient,
                             treat,
                             target = "AEDECOD",
                             rows_by = "AEBODSYS",
                             indent = "  ") {

  stopifnot(is.data.frame(adsl), is.data.frame(adae))
  stopifnot(all(c(patient, treat) %in% names(adsl)))
  stopifnot(all(c(patient, treat, target, rows_by) %in% names(adae)))

  adae <- tern::df_explicit_na(adae, na_level = "Missing")

  lyt <- rtables::basic_table(show_colcounts = TRUE) |>
    rtables::split_cols_by(var = treat) |>
    rtables::split_rows_by(var = rows_by, split_fun = rtables::drop_split_levels, nested = TRUE) |>
    tern::count_occurrences(
      vars = target,
      id = patient,
      denom = "N_col",
      .labels = c(count_fraction = "Patients with AE (n, %)"),
      .formats = c(count_fraction = tern::format_count_fraction_fixed_dp)
    )

  rtables::build_table(lyt, df = adae, alt_counts_df = adsl)
}
