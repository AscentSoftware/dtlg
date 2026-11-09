#' Count events
#'
#' [event_count()] counts events defined by predicate expressions passed in
#' `.filters`.
#'
#' @inheritParams calc_counts
#'
#' @param patient A string indicating the subject identifying variable.
#'
#' @param .total_dt Subject-level population used as the denominator for
#'   percentages, with one row per patient, e.g. ADSL. Defaults to `dt`,
#'   before `.filters` are applied.
#'   An error is raised if it has missing or duplicated `patient` values, or a
#'   patient under more than one treatment; for event-level `dt`, such as
#'   ADAE, supply ADSL. If `NULL`, counts are reported without percentages.
#'
#' @param label A string to be used as label in the output reporting table. This
#' should be a text descriptive of the event being counted.
#'
#' @param .filters Predicate expressions identifying events in `dt`. Argument
#'   should be passed as a `character` vector of expressions to be evaluated in
#'   the frame of `dt`.
#'
#' @returns A one-element list, where the element is a `data.table`.
#'
#' @examples
#' # Count deaths per arm.
#' event_count(
#'   adsl,
#'   patient = "USUBJID",
#'   treat = "ARM",
#'   label = "Total number of deaths",
#'   .filters = "DTHFL == 'Y'"
#' )[[1]]
#'
#' # Count patients withdraw from study due to an adverse event.
#' withdrawn_lbl <- "Total number of patients withdrawn from study due to an AE"
#' event_count(
#'   adsl,
#'   patient = "USUBJID",
#'   treat = "ARM",
#'   label = withdrawn_lbl,
#'   .filters = "DCSREAS == 'ADVERSE EVENT'"
#' )[[1]]
#'
#' # Count patients with at least one adverse event.
#' # NB: When `.filters` is `NULL` (i.e., omitted), all records in `dt` are used
#' # for counting events.
#' event_count(
#'   adae,
#'   patient = "USUBJID",
#'   treat = "ARM",
#'   label = "Total number of patients with at least one AE",
#'   .filters = "ANL01FL == 'Y'",
#'   .total_dt = adsl
#' )[[1]]
#'
#' @export
#'
event_count <- function(dt,
                        patient,
                        treat,
                        label,
                        .filters = NULL,
                        .total_dt = dt,
                        pct_dec = 1) {

  dt <- maybe_copy_dt(x = dt)
  if (!is.null(.total_dt)) {
    .total_dt <- maybe_copy_dt(x = .total_dt)
    assert_subject_population(.total_dt, patient = patient, treat = treat)
  }

  df_filtered <-
    if (isFALSE(is.null(.filters))) {
      stopifnot(is.character(.filters))
      .filters <- lapply(.filters, str2lang)
      do.call(what = dt_filter, args = c(list(dt = dt), .filters))
    } else {
      dt
    }

  df_filtered_uniq <- unique(df_filtered, by = patient)

  # No matching records: a count table cannot be built from zero rows, so
  # report zero for every arm of the population, or of `dt` without one.
  if (nrow(df_filtered_uniq) == 0L) {
    arms <- level_set(.total_dt %||% dt, cols = treat)[[treat]]
    return(list(zero_event_row(label, arms = arms)))
  }

  df_filtered_uniq[[label]] <- label
  if (!is.null(.total_dt)) {
    .total_dt[[label]] <- label
  }

  events <-
    summary_table(
      dt = df_filtered_uniq,
      target = label,
      treat = treat,
      .total_dt = .total_dt,
      indent = "",
      pct_dec = pct_dec
    )[.N, ]

  list(events)
}

# One-row event table with a zero count in each treatment arm, in the same
# layout as a row produced by `event_count()`.
zero_event_row <- function(label, arms) {
  arms <- as.character(arms[!is.na(arms)])
  out <- data.table::data.table(stats = label)
  for (arm in arms) {
    data.table::set(out, j = arm, value = "0")
  }
  out
}

#' Count total events
#'
#' [total_events()] counts the number of observations in `dt` in each group
#' defined by `treat` levels. Counts are returned in wide format, i.e. one
#' column per level in `treat`.
#'
#' @inheritParams event_count
#'
#' @param dt A `data.frame` containing, at least, the variable indicated in
#'   `treat`.
#'
#' @returns A list wrapping a one-row `data.table` of `1 + n` variables, where
#'   `n` is the number of levels in `treat`. First variable is `stats`,
#'   `character` type, whose value is the argument passed in as `label`.
#'   Following variables are of `integer` type and provide the counts.
#'
#' @examples
#' # In the absence of pre-filtering, `total_events()`, actually, just counts
#' # observations in `dt`.
#' total_events(dt = adsl, treat = "ARM", label = "Subjects")[[1]]
#'
#' # If `dt` is pre-filtered, e.g. with a condition matching an event, then
#' # `total_events()` can be used to (effectively) count events.
#' total_events(dt = adsl[adsl$DTHFL == "Y"], treat = "ARM", label =
#' "Deaths")[[1]]
#'
#' # Another example using the complement predicate condition.
#' total_events(dt = adsl[adsl$DTHFL == "N"], treat = "ARM", label =
#' "Lives")[[1]]
#'
#' @export
#'
total_events <- function(dt, treat, label) {
  dt <- maybe_copy_dt(x = dt)

  j <- dot_wrap(c(n = ".N"))
  by <- as.call(c(quote(list), as.name(treat)))

  dt <- dt[, j = j, by = by, env = list(j = j, by = by)]
  dt <- data.table::transpose(
    dt,
    keep.names = "stats",
    make.names = treat,
    fill = 0
  )
  dt[, `:=`(stats = label)]
  list(dt[])
}


#' Summarise multiple AESI-like events per treatment arm
#'
#' `multi_event_true()` generates a summary table showing the number and
#' percentage of patients with at least one event across multiple binary
#' indicator variables (e.g., flags for adverse events of special interest).
#'
#' Each event is counted only once per patient. This function is typically used
#' for summarising *Adverse Events of Special Interest* (AESIs) or other derived
#' flags (e.g., `SER`, `FATAL`, `RELDSM`) that are binary (TRUE/FALSE).
#'
#' @param dt A `data.frame` or `data.table` containing the binary event flags
#'   and subject-level data.
#'
#' @param event_vars A character vector of column names of binary flags to
#'   summarise. Flags must be logical, or numeric with `1` marking the event;
#'   character or factor flags such as `"Y"`/`"N"` raise an error.
#'
#' @param patient A string giving the name of the variable that uniquely
#'   identifies each patient (e.g., `"USUBJID"`).
#'
#' @param treat A string giving the name of the treatment variable (e.g.,
#'   `"ARM"`).
#'
#' @param heading A string to be shown as the first row in the output, usually a
#'   summary descriptor such as `"Total number of patients with at least one"`.
#'
#' @param label Optional. A character vector of the same length as `event_vars`
#'   giving human-readable labels for the output table rows. If `NULL`, labels
#'   are extracted from the `label` attribute of each variable, or fall back to
#'   the variable name.
#'
#' @param .total_dt Subject-level population used as the denominator for
#'   percentages, with one row per patient, e.g. ADSL. Defaults to `dt`.
#'   An error is raised if it has missing or duplicated `patient` values, or a
#'   patient under more than one treatment; for event-level `dt`, such as
#'   ADAE, supply ADSL. If `NULL`, counts are reported without percentages.
#'
#' @param indent A string to indent the row labels (e.g., `"  "` or `nbsp(n =
#'   4L)` for non-breaking spaces).
#'
#' @param pct_dec An integer indicating how many decimal places to show in
#'   percentages (default is `1`).
#'
#' @returns A one-element list containing a `data.table` with one row per event
#'   plus one header row. The first column is `"stats"` (row labels), and
#'   subsequent columns are one per treatment arm, with values in `"n (x%)"`
#'   format.
#'
#' @examples
#' aesi_vars <- c(
#'   "FATAL", "SER", "SERWD", "SERDSM", "RELSER",
#'   "WD", "DSM", "REL", "RELWD", "RELDSM", "SEV"
#' )
#'
#' heading <- "Total number of patients with at least one AE"
#'
#' multi_event_true(
#'   dt = aesi,
#'   event_vars = aesi_vars,
#'   patient = "USUBJID",
#'   treat = "ARM",
#'   heading = heading,
#'   .total_dt = adsl,
#'   indent = "  "
#' )[[1]]
#'
#' @seealso [event_count()], [total_events()]
#'
#' @export
#'
multi_event_true <- function(dt,
                             event_vars,
                             patient,
                             treat,
                             heading,
                             label = NULL,
                             .total_dt = dt,
                             indent = nbsp(n = 4L),
                             pct_dec = 1) {
  dt <- maybe_copy_dt(x = dt)
  event_filters <- paste0(event_vars, " == TRUE")
  event_label <- label %||% lapply(event_vars, \(x) label(dt[[x]]) %||% x)

  stopifnot(
    identical(length(event_filters), length(event_label)),
    all(event_vars %in% colnames(dt))
  )

  # Flags are selected with `== TRUE`, which is never true for text such as
  # "Y", so character or factor flags would silently count zero patients.
  is_flag <- vapply(
    event_vars,
    \(x) is.logical(dt[[x]]) || is.numeric(dt[[x]]),
    logical(1L)
  )
  if (!all(is_flag)) {
    stop(
      sprintf(
        "`event_vars` must be logical (or numeric 0/1) flags; not: %s.",
        toString(event_vars[!is_flag])
      ),
      call. = FALSE
    )
  }

  event <- mapply(
    event_count,
    .filters = event_filters,
    label = event_label,
    MoreArgs = list(
      dt = dt,
      patient = patient,
      treat = treat,
      .total_dt = .total_dt,
      pct_dec = pct_dec
    )
  )

  event <- data.table::rbindlist(event, use.names = TRUE)
  target_rows <- event$stats
  event <- rbind(rep(list(""), times = ncol(event)), event)
  event[, `:=`(stats = c(heading, paste0(indent, target_rows)))]

  list(event[])
}


#' Summarise adverse events by arm and other grouping variables
#'
#' `event_count_by()` creates a tabular summary of adverse events grouped by a
#' higher-level classification variable (e.g., system organ class), and counts
#' both the number of events and the number of unique patients per treatment
#' arm.
#'
#' @param dt A `data.frame` or `data.table` containing the adverse event data
#'   and patient-level identifiers.
#'
#' @param patient A string giving the name of the patient identifier variable
#'   (e.g., `"USUBJID"`).
#'
#' @param treat A string giving the name of the treatment arm variable (e.g.,
#'   `"ARM"`).
#'
#' @param rows_by A string giving the name of the grouping variable (e.g.,
#'   `"AEBODSYS"` for body system).
#'
#' @param target A string giving the name of the variable to report within each
#'   group (e.g., `"AEDECOD"` for preferred term).
#'
#' @param .total_dt Subject-level population used as the denominator for
#'   percentages, with one row per patient, e.g. ADSL. Defaults to `dt`.
#'   An error is raised if it has missing or duplicated `patient` values, or a
#'   patient under more than one treatment; for event-level `dt`, such as
#'   ADAE, supply ADSL. If `NULL`, counts are reported without percentages.
#'
#' @param indent A string used to indent row labels (e.g., `"  "` or `nbsp(n =
#'   4L)`).
#'
#' @param pct_dec Integer. Number of decimal places to show in percentages.
#'   Defaults to `1`.
#'
#' @returns A `data.table` with the following structure:
#'
#' * One row per combination of `rows_by` and `target`
#' * One row per group total (`Total number of events`)
#' * One row per patient-level total
#' (`Total number of patients with at least one event`)
#'
#' Columns include:
#' - `stats`: character column with labels
#' - one column per level of the `treat` variable, formatted as `"n (x%)"`
#'
#' @examples
#' event_count_by(
#'   dt = adae[adae$ANL01FL == "Y"],
#'   patient = 'USUBJID',
#'   treat = 'ARM',
#'   rows_by = 'AEBODSYS',
#'   target = 'AEDECOD',
#'   .total_dt = adsl,
#'   indent = ' '
#' )
#'
#' @seealso [event_count()], [calc_stats()], [total_events()]
#'
#' @export
#'
event_count_by <- function(dt,
                           patient,
                           treat,
                           rows_by,
                           target,
                           .total_dt = dt,
                           indent = nbsp(n = 4L),
                           pct_dec = 1) {
  dt <- maybe_copy_dt(x = dt)
  if (!is.null(.total_dt)) {
    .total_dt <- maybe_copy_dt(x = .total_dt)
    assert_subject_population(.total_dt, patient = patient, treat = treat)
  }

  event <- dt

  event_split <- split(droplevels(event), by = rows_by, drop = TRUE)

  event_patient <- mapply(
    event_count,
    dt = event_split,
    treat = treat,
    label = "Total number of patients with at least one event",
    MoreArgs = list(
      .total_dt = .total_dt,
      patient = patient,
      pct_dec = pct_dec
    )
  )
  event_total <- mapply(total_events,
                        event_split,
                        treat = treat,
                        label = "Total number of events")

  event_target <- mapply(
    calc_stats,
    dt = event_split,
    target = target,
    treat = treat,
    indent = indent,
    target_name = names(event_split),
    MoreArgs = list(.total_dt = .total_dt, pct_dec = pct_dec)
  )
  event_table <- mapply(list, event_target, event_total, event_patient)
  event_table <- data.table::rbindlist(event_table, use.names = TRUE)
  event_table
}
