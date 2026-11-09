#' Assert a subject-level denominator population
#'
#' Percentages are computed as counts divided by the number of rows per
#' treatment arm in the denominator population. That is only meaningful when
#' the population has exactly one row per patient, as in ADSL. This helper
#' rejects populations that would silently yield a different denominator, for
#' example event-level data such as ADAE.
#'
#' @param dt A data frame holding the denominator population.
#' @param patient A string naming the subject identifier column.
#' @param treat A string naming the treatment column.
#' @param arg A string naming the argument that supplied `dt`, used in error
#'   messages.
#'
#' @returns `dt`, invisibly, if it has one row per patient, no missing patient
#'   identifiers and a single treatment per patient. Otherwise an error.
#'
#' @examples
#' adsl <- data.frame(USUBJID = c("A1", "B1"), ARM = c("Drug A", "Placebo"))
#' assert_subject_population(adsl, "USUBJID", "ARM")
#'
#' adae <- data.frame(USUBJID = c("A1", "A1"), ARM = c("Drug A", "Drug A"))
#' try(assert_subject_population(adae, "USUBJID", "ARM"))
#'
#' @noRd
assert_subject_population <- function(dt, patient, treat, arg = ".total_dt") {
  missing_cols <- setdiff(c(patient, treat), names(dt))
  if (length(missing_cols) > 0L) {
    stop(
      sprintf(
        "`%s` must contain the column(s) %s.",
        arg,
        paste0("'", missing_cols, "'", collapse = ", ")
      ),
      call. = FALSE
    )
  }

  ids <- dt[[patient]]
  if (anyNA(ids)) {
    stop(
      sprintf("`%s` has missing values in '%s'.", arg, patient),
      call. = FALSE
    )
  }

  dup_ids <- unique(ids[duplicated(ids)])
  if (length(dup_ids) == 0L) {
    return(invisible(dt))
  }

  # A repeated patient listed under several arms is a different defect from
  # repeated rows within one arm, so report it specifically.
  trts <- dt[[treat]]
  in_dup <- ids %in% dup_ids
  n_trts <- tapply(
    trts[in_dup],
    as.character(ids[in_dup]),
    \(x) length(unique(x))
  )
  multi_arm <- names(n_trts)[n_trts > 1L]
  if (length(multi_arm) > 0L) {
    id <- multi_arm[[1L]]
    stop(
      sprintf(
        paste(
          "Each patient must belong to one treatment in `%s`:",
          "\"%s\" appears under %s."
        ),
        arg,
        id,
        paste0(
          "\"", unique(trts[as.character(ids) == id]), "\"",
          collapse = " and "
        )
      ),
      call. = FALSE
    )
  }

  stop(
    sprintf(
      paste(
        "`%s` must have one row per patient, but '%s' is duplicated",
        "(e.g. \"%s\"). Supply the subject-level population, such as ADSL,",
        "as `.total_dt`."
      ),
      arg,
      patient,
      dup_ids[[1L]]
    ),
    call. = FALSE
  )
}
