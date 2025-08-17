#' Expand grid as data.table from named vectors
#'
#' @description
#' `dt_expand_grid()` creates the Cartesian product of the named vectors
#' supplied via `...`, preserving their type, values, and order.
#' If `.include_na = TRUE`, `NA` is appended to each vector if it is not
#' already present.
#'
#' @param ... Named vectors. Each name becomes a column name in the result.
#' @param .include_na Logical, default `FALSE`. If `TRUE`, append `NA` to each
#'   input vector if it is not already present.
#'
#' @returns A `data.table` with one column per input and all combinations of
#' values.
#'
#' @noRd
#' @keywords internal
dt_expand_grid <- function(..., .include_na = FALSE) {
  args <- list(...)
  if (length(args) == 0L) return(data.table::data.table())
  if (is.null(nms <- names(args)) || any(!nzchar(nms))) {
    stop("All arguments to dt_expand_grid() must be *named*.")
  }

  if (.include_na) {
    args <- lapply(args, function(v) {
      if (!anyNA(v)) c(v, NA) else v
    })
  }

  grid <- do.call(
    data.table::CJ,
    c(args, list(sorted = FALSE, unique = FALSE))
  )
  data.table::setnames(grid, nms)
  grid[]
}

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
#' @param .fct_levels One of `"used"` or `"all"` (default `"all"`). Controls
#'   whether factor columns return only levels that appear in the data or all
#'   declared levels. The order of returned factor levels always follows the
#'   factor's level order.
#' @param .include_na Whether to include `NA` as unobserved levels.
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
dt_count <- function(dt,
                     ...,
                     .name = "n",
                     .fct_levels = c("all", "used"),
                     .include_na = FALSE) {

  .fct_levels <- match.arg(.fct_levels)
  group_vars <- list(...)
  data.table::setDT(dt)

  # Original vs output names (support renaming)
  orig <- unlist(group_vars)
  out_names <- names(group_vars)
  if (is.null(out_names)) out_names <- rep("", length(orig))
  out_names[out_names == ""] <- orig[out_names == ""]

  if (.name %in% out_names) {
    stop("`.name` ('", .name, "') conflicts with a grouping column name.", call. = FALSE)
  }

  # Fast count of observed groups
  by <- dot_wrap(unname(orig))
  out <- dt[, .N, by = by, env = list(by = by)]
  data.table::setnames(out, old = orig, new = out_names)
  data.table::setnames(out, "N", .name)

  vals_list <- level_set(df = dt, cols = orig, .sort = TRUE, .fct_levels = .fct_levels)
  names(vals_list) <- out_names

  # Full key space via dt_expand_grid(); optionally append NA per column
  key_space <- do.call(
    dt_expand_grid,
    c(vals_list, list(.include_na = .include_na))
  )

  # Left join counts into full key space; fill missing with 0
  res <- out[key_space, on = out_names]
  res[is.na(get(.name)), (.name) := 0L][]
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



