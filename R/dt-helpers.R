#' Count the observations in each group
#'
#' [dt_count()] is a simple wrapper around `data.table` commands to perform
#' a count on observations in each group. Groups are defined by indicating
#' variables to group by.
#'
#' @param dt A `data.table` or an object coercible to a `data.table`.
#' @param ... Variables to group by, passed as `character`. If named arguments
#' are passed, then those names become the new variable names.
#' @param .name The name of the new column in the output.
#' If omitted, it will default to `n`.
#'
#' @returns A `data.table` with summarised counts per group.
#'
#' @examples
#' x <- c("A", "A", "A", "B", "B", "B")
#' y <- c("X", "Y", "Z", "Z", "Z", NA)
#' (dt <- data.table::data.table(x, y))
#'
#' # Count observations grouped by `x`
#' dt_count(dt = dt, "x")
#'
#' # Count observations grouped by `y`
#' dt_count(dt = dt, "y")
#'
#' # Count observations grouped by `x` and `y`
#' dt_count(dt = dt, "x", "y")
#'
#' # Count observations grouped by `x` and `y` and rename them to `x1` and `y2`,
#' # respectively.
#' dt_count(dt = dt, x1 = "x", y1 = "y")
#'
#' # Name the new column `total` instead of `n`.
#' dt_count(dt = dt, x1 = "x", y1 = "y", .name = "total")
#'
#' @noRd
#' @keywords internal
dt_count <- function(dt, ..., .name = "n") {

  group_vars <- list(...)
  data.table::setDT(x = dt, key = unlist(group_vars))

  j <- as.call(c(quote(.), lapply(stats::setNames(".N", .name), as.name)))
  by <- as.call(c(quote(list), lapply(group_vars, as.name)))

  drop_keys(dt[ , j, by = by, env = list(j = j)])
}

#' Summarise each group down to one row
#'
#' [dt_summarise()] summarises a table using `data.table` as backend. Grouping
#' is indicated with `.by` and aggregations as expressions in `...`, evaluated
#' in the frame of `dt`.
#'
#' @param dt A `data.frame`.
#'
#' @param .by A character vector of variable names to be used as grouping
#' criteria.
#'
#' @param ... A sequence of expressions evaluated in the frame of `dt`.
#'
#' @param .env A list or environment for substitution of variables in `j`
#' and `by` parameters.
#'
#' @returns A `data.table` with summary statistics.
#'
#' @noRd
#' @keywords internal
#'
dt_summarise <- function(dt, .by, ..., .env = parent.frame()) {

  summarising_mappings <- as.list(substitute(...()))
  data.table::setDT(x = dt, key = .by)
  j <- substitute_q(as.call(c(quote(.), summarising_mappings)), env = .env)
  by <- as.call(c(quote(.), lapply(.by, as.name)))
  drop_keys(dt[, j = j, by = by, env = list(j = j, by = by)])
}

dt_filter <- function(dt, ..., .env = parent.frame()) {
  filters <- as.list(substitute(...()))
  i <- substitute_q(as.call(c(quote(and), filters)), env = .env)
  dt[i, , env = list(i = i)]
}
