#' Calculate descriptive summary statistics for a numeric variable
#'
#' @description
#'
#' [calc_desc()] summarises a numeric variable (`target`) by another (`treat`) and
#' reports summary statistics in clinical trial reporting format. The following
#' statistics are calculated for `target`, per group, i.e. by variable `treat`
#' levels:
#'
#' - `n`: number of observations
#' - `Mean (SD)`: mean and standard deviation of `target`
#' - `Median`: median of `target`
#' - `Min, Max`: minimum and maximum of `target`
#' - `Missing`: number of missing `target` values
#'
#' @param dt A `data.frame` containing, at least, the variables indicated in
#' `target` and `treat`.
#' @param target Target variable passed as a string for which summary
#'   statistics are to be calculated.
#' @param target_name Heading for the target variable as a string. Defaults to
#' `target`.
#' @param treat A string indicating the grouping variable, e.g. the variable
#' specifying the treatment population.
#' @param indent A string to be used as indentation of summary statistics
#' labels. Defaults to four HTML non-breaking spaces (`&nbsp;`).
#' @param pct_dec Decimal places for reported figures.
#'
#' @returns A list containing a `data.table` formatted as follows:
#'
#' - First column is named `stats` and contains the target variable name
#' indicated in `target` in the first row. Subsequent rows contain the
#' summarised statistics labels.
#'
#' - Other columns are for the levels of the grouping variable (`treat`).
#'
#' - All columns are of character type.
#'
#' This table is structured for easy integration with Shiny output widgets.
#'
#' @examples
#' # Calculate summary statistics for the age of the subjects in each region.
#' calc_stats(dt = adsl, "AGE", treat = "REGION1")[[1]]
#'
#' # Calculate summary statistics for biomarker 1 in each of the three arms
#' # (`ARM`).
#' calc_stats(dt = adsl, "BMRKR1", treat = "ARM")[[1]]
#'
#' @export
#'
calc_desc <- function(dt,
                      target,
                      target_name = target,
                      treat,
                      indent = nbsp(n = 4L),
                      pct_dec = 1) {

  stopifnot(
    is.data.frame(dt),
    is_string(target),
    is_string(target_name),
    is_string(treat),
    is_string(indent),
    is.numeric(pct_dec)
  )

  data.table::setDT(x = dt)

  n_stats <- 5L
  dt_stats <-
    dt_summarise(
      dt,
      .by = treat,
      n = as.character(.N),
      `Mean (SD)` = format_mean_sd(mean = mean(target, na.rm = TRUE), sd = stats::sd(target, na.rm = TRUE), .digits = pct_dec),
      Median = round(stats::median(target, na.rm = TRUE), digits = pct_dec),
      `Min, Max` = format_min_max(min = min(target, na.rm = TRUE), max = max(target, na.rm = TRUE), .digits = pct_dec),
      Missing = as.character(sum(is.na(target))),
      .env = list(target = as.name(target), pct_dec = pct_dec)
    )

  dt_stats <- data.table::transpose(dt_stats, keep.names = 'stats', make.names = treat)
  header <- c(target_name, rep(list(''), times = ncol(dt_stats) - 1L))
  dt_stats[, `:=`(stats = indent(dt_stats$stats, indentation = indent))]
  dt_stats <- rbind(header, dt_stats)

  list(dt_stats)
}


#' Calculate counts of a categorical variable
#'
#' [calc_counts()] counts observations of a categorical variable (`target`) by
#' another (`treat`) and reports summary statistics in clinical trial reporting
#' format.
#'
#' @param dt A `data.frame` containing, at least, the variables indicated in
#' `target` and `treat`.
#' @param target Target variable passed as a string for which summary
#'   statistics are to be calculated.
#' @param target_name Heading for the target variable as a string. Defaults to
#' `target`.
#' @param treat A string indicating the grouping variable, e.g. the variable
#' specifying the treatment population.
#' @param indent A string to be used as indentation of summary statistics
#' labels. Defaults to four HTML non-breaking spaces (`&nbsp;`).
#' @param .total_dt Separate table from `dt` from which to derive total counts
#' per group.
#' @param pct_dec This argument is ignored, and is only kept for backward
#' compatibility reasons.
#'
#' @returns A list containing a `data.table` formatted as follows:
#'
#' - First column is named `stats` and contains the target variable name
#' indicated in `target` in the first row. Subsequent rows contain the
#' levels of `target`.
#'
#' - Other columns are for the levels of the grouping variable (`treat`).
#'
#' - All columns are of character type.
#'
#' This table is structured for easy integration with Shiny output widgets.
#'
#' @examples
#' calc_counts(dt = adsl, "RACE", treat = "ARM")[[1]]
#'
#' @export
#'
calc_counts <- function(dt,
                        target,
                        target_name = target,
                        treat,
                        indent = nbsp(n = 4L),
                        .total_dt = NULL,
                        pct_dec = 1) {

  stopifnot(
    is.data.frame(dt),
    is_string(target),
    is_string(target_name),
    is_string(treat),
    is_string(indent),
    is.null(.total_dt) || is.data.frame(.total_dt)
  )


  data.table::setDT(x = dt)
  counts_by_grp <- dt_count(dt = dt,
                            treatment = treat,
                            stats = target)

  if (!is.null(.total_dt)) {
    data.table::setDT(x = .total_dt)
    counts_by_trt <- dt_count(.total_dt, treatment = treat, .name = "total")
    counts_by_grp <- counts_by_grp[counts_by_trt, on = 'treatment']
    counts_by_grp$n <- format_n_pct(
      n = counts_by_grp$n,
      pct = 100 * counts_by_grp$n / counts_by_grp$total,
      .pct_digits = pct_dec
    )
    j <- dot_wrap(c("treatment", "stats", "n"))
    counts_by_grp <- counts_by_grp[, j, env = list(j = j)]
  }

  counts_by_grp <- data.table::dcast(
    counts_by_grp,
    stats::as.formula("stats ~ treatment"),
    value.var = 'n',
    fill = 0
  )

  header <- c(target_name, rep(list(''), times = ncol(counts_by_grp) - 1L))
  counts_by_grp[,  `:=`(stats = paste0(indent, as.character(counts_by_grp$stats)))]
  counts_by_grp <- rbind(header, counts_by_grp)

  list(counts_by_grp)
}


#' Calculate summary statistics for a variable
#'
#' [calc_stats()] calculates summary statistics for a variable on groups. This
#' is a generic function; note that it dispatches based on the class of
#' `target` (second argument), not `dt` (first argument).
#'
#' @inheritParams calc_desc
#' @inheritParams calc_counts
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
#' @examples
#' # Calculate summary statistics of a numeric variable, e.g. `AGE`.
#' calc_stats(dt = adsl, "AGE", treat = "ARM")[[1]]
#'
#' # Calculate summary statistics of a categorical variable, e.g. `SEX`.
#' calc_stats(dt = adsl, "SEX", treat = "ARM")[[1]]
#'
#' @export
#'
calc_stats <- function(dt,
                       target,
                       target_name = target,
                       treat,
                       indent = nbsp(n = 4L),
                       .total_dt = NULL,
                       pct_dec = 1) {
  data.table::setDT(x = dt)
  UseMethod('calc_stats', dt[[target]])
}

#' @export
calc_stats.numeric <- function(..., .total_dt = NULL) calc_desc(...)

#' @export
calc_stats.character <- calc_counts

#' @export
calc_stats.factor <- calc_counts

#' @export
calc_stats.logical <- calc_counts

#' @export
calc_stats.default <- function(dt, target, ...) {
  target_class <- class(dt[[target]])
  stop("`cal_stats()` does not support dispatch on `target` variables of class ", target_class, ".")
}
