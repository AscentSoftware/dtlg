reorder_cols <- function(dt, cols, before_cols = "stats", skip_absent = TRUE) {

  cols %||% return(dt)

  all_cols <- colnames(dt)
  cols_missing <- sort(setdiff(all_cols, cols))
  new_cols <- unique(c(before_cols, cols, cols_missing))
  data.table::setcolorder(dt, new_cols, skip_absent = skip_absent)[]
}

#' Summary Table
#'
#' [summary_table()] summarises clinical variables into a report table using
#' `data.table` as backend.
#'
#' @inheritParams calc_stats
#' @param treat_order Customise the column order of the output table.
#' @param skip_absent Whether to ignore variables passed in `treat_order` that
#'   are absent from `dt`. Default is `TRUE`; `FALSE` will throw an error in
#'   case there are missing variables.
#'
#' @returns A `data.table` of summary statistics. The format depends on the
#' type of the `target` variable:
#'
#' - If the `target` variable is categorical, i.e. type `character`, `factor`
#' or `logical` then the output is that of [calc_counts()].
#'
#' - If the `target` variable is numeric, then the output is that of
#' [calc_desc()].
#'
#' @seealso [tern_summary_table()]
#'
#' @examples
#' dmg_vars <- c("AGE", "RACE", "ETHNIC")
#' dmg_var_lbls <- c("Age (yr)", "Race", "Ethnicity")
#'
#' # Demographics table (DMT01)
#' summary_table(
#'   adsl,
#'   target = dmg_vars,
#'   treat = 'ARM',
#'   target_name = dmg_var_lbls
#' )
#'
#' # Demographics table (DMT01) with continuous variable (e.g., BMRKR1)
#' summary_table(
#'   adsl,
#'   target = c(dmg_vars, "BMRKR1"),
#'   treat = 'ARM',
#'   target_name = c(dmg_var_lbls, "Biomarker 1")
#' )
#'
#' @export
#'
summary_table <- function(dt,
                          target,
                          treat,
                          target_name = target,
                          indent = nbsp(n = 4L),
                          .total_dt = dt,
                          pct_dec = 1,
                          treat_order = NULL,
                          skip_absent = TRUE) {

  stopifnot(length(target) >= length(target_name), length(target) >= length(indent))
  vct_args <- vctrs::vec_recycle_common(target = target, target_name = target_name, indent = indent)
  scl_args <- list(dt = dt, treat = treat, .total_dt = .total_dt, pct_dec = pct_dec)

  summaries <-
    with(
      vct_args,
      expr = mapply(
        FUN = calc_stats,
        target = target,
        target_name = target_name,
        indent = indent,
        MoreArgs = scl_args
      )
    )

  summaries |>
    data.table::rbindlist(use.names = TRUE) |>
    reorder_cols(cols = treat_order, skip_absent = skip_absent)
}

#' Create a summary table using multiple rows for grouping on one target column
#'
#' @inheritParams summary_table
#' @param rows_by string, grouping variable to split events by.
#' @param sep character string to separate the terms
#'
#' @returns The same output as [summary_table()] except that folded by variables
#' indicated in `rows_by`.
#' @export
#'
#' @examples
#' summary_table_by(
#'   adlb,
#'   target = "AVAL",
#'   treat = "ARM",
#'   rows_by = c("PARAM","AVISIT")
#' )
summary_table_by <- function(dt,
                             target,
                             treat,
                             rows_by,
                             indent = nbsp(n = 4L),
                             .total_dt = dt,
                             pct_dec = 1,
                             treat_order = NULL,
                             skip_absent = TRUE,
                             sep = ".") {
  dt <- maybe_copy_dt(x = dt)

  dt <- split(droplevels(dt), by = rows_by, drop = T, sorted = T)
  label <- names(dt)

  if (length(rows_by) > 1) {
    label <- strsplit(label, ".", fixed = TRUE)
    heading_full <- lapply(X = label, function(x) {
      x[1]
    })
    heading <- unique(heading_full)
    label <- lapply(label, \(x) paste(x[-1L], collapse = sep))
    label <- paste0(indent, label)
    indent <- paste0(indent, indent)
  }

  summary_split <- mapply(
    calc_stats,
    dt = dt,
    target = target,
    target_name = label,
    treat = treat,
    indent = indent,
    pct_dec = pct_dec
  )

  if (length(rows_by) > 1) {
    x <- 0
    for (i in 1:length(heading)) {
      y = sum(heading_full %in% heading[i])
      summary_split <- append(
        summary_split,
        list(data.table::data.table(stats = heading[[i]])),
        after = x
      )
      x <- x + y + 1
    }
  }

  summary_split |>
    data.table::rbindlist(use.names = TRUE, fill = TRUE) |>
    reorder_cols(cols = treat_order, skip_absent = skip_absent) |>
    list()
}

#' Create a summary table using multiple rows for grouping on two target column
#' ideal for creating change from baseline tables
#'
#' @param dt table to perform function on
#' @param target vector of column names desired to obtain information on
#' @param treat string of treatment variable used for splitting / grouping data
#' @param rows_by string, grouping variable to split events by.
#' @param indent indent to be used for display and formatting purposes
#' @param .total_dt optional table for total counts to be derived
#' @param pct_dec decimal places for percentages
#' @param treat_order customise the column order of output table
#' @param skip_absent Logical, default `TRUE`. Passed to `data.table::setcolorder`,
#' if `treat_order` includes columns not present in `dt`:
#' - `TRUE` will silently ignore them
#' - `FALSE` will throw an error
#' @param sep character string to separate the terms
#'
#' @return data.table
#' @export
#'
#' @examples
#' adlb <- random.cdisc.data::cadlb |>
#'   dplyr::filter(AVISIT != "SCREENING")
#'
#' labs <- summary_table_by_targets(
#'   dt = adlb,
#'   target = c("AVAL", "CHG"),
#'   treat = "ARM",
#'   rows_by = c("PARAM", "AVISIT"),
#'   indent = "  "
#' )
summary_table_by_targets <- function(dt,
                                     target,
                                     treat,
                                     rows_by,
                                     indent = nbsp(n = 4L),
                                     .total_dt = NULL,
                                     pct_dec = 1,
                                     treat_order = NULL,
                                     skip_absent = TRUE,
                                     sep = ".") {
  if (length(target) != 2) {
    print("target needs to be length 2")
  }

  .total_dt <- maybe_copy_dt(x = .total_dt)

  summary_tables <- mapply(
    summary_table_by,
    target = target,
    MoreArgs = list(
      dt = dt,
      treat = treat,
      rows_by = rows_by,
      indent = indent,
      .total_dt = .total_dt,
      pct_dec = pct_dec,
      treat_order = treat_order,
      skip_absent = skip_absent,
      sep = sep
    )
  )

  for (i in seq_along(summary_tables)) {
    data.table::setnames(
      summary_tables[[i]],
      old = -1L,
      new = paste(names(summary_tables[[i]])[-1L], target[i], sep = sep)
    )
  }

  data.table::cbindlist(
    c(
      list(summary_tables[[1]][, 1, with = FALSE]),
      lapply(
        seq(2, ncol(summary_tables[[1]])),
        \(i) data.table::cbindlist(lapply(summary_tables, \(dat) dat[, i, with = FALSE]))
      )
    )
  )
}

