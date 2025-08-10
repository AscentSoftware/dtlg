dot_wrap <- function(x) {
  stopifnot(is.character(x))
  . <- NULL
  as.call(c(quote(.), lapply(x, as.name)))
}

drop_keys <- function(dt) {
  data.table::setkey(x = dt, NULL)[]
}


#' Relevel a single column in a data.table (preserving ordered state)
#'
#' @description
#' `dt_relevel_col_()` enforces a specific level order for one column of a
#' `data.table`. If the column is already an ordered factor, its ordered
#' state is preserved; otherwise, the result is an unordered factor. Values not
#' present in `levels` are silently converted to `NA` (base R behaviour).
#'
#' @param dt A `data.table` or an object coercible to one via
#'   `data.table::setDT()`. Modified by reference when `copy = FALSE`.
#'
#' @param col A single column name (string) to relevel.
#'
#' @param levels A character vector with the desired target level order. Any
#'   duplicates are ignored (first occurrence kept). Levels not listed are
#'   dropped; observed values outside this set become `NA`.
#'
#' @param copy Logical. If `TRUE` (default), operate on a shallow copy and
#'   return it. If `FALSE`, modify `dt` by reference and return it invisibly.
#'
#' @returns
#'
#' A `data.table`. When `copy = TRUE`, the modified copy is returned.
#' When `copy = FALSE`, the input `dt` is modified by reference and returned
#' invisibly.
#'
#' @examples
#'
#' dt <- data.table(
#'   grp = factor(c("b", "a", "b", "c"), levels = c("a", "b", "c", "d")),
#'   band = c("low", "high", "med", "high")
#' )
#'
#' # Relevel 'grp' to c("c","a"); values not in the set become NA
#' res <- dt_relevel_col_(dt, col = "grp", levels = c("c", "a"))
#' levels(res$grp)
#'
#' # In-place modification
#' invisible(dt_relevel_col_(dt, col = "band", levels = c("high","low"), copy = FALSE))
#' levels(dt$band)
#'
#' @noRd
#' @keywords internal
#'
dt_relevel_col_ <- function(dt, col, levels, copy = TRUE) {
  stopifnot(length(col) == 1L, is.character(col), !is.na(col))
  stopifnot(is.character(levels))

  data.table::setDT(dt)
  out <- if (copy)
    data.table::copy(dt)
  else
    dt
  if (!col %in% names(out))
    stop(sprintf("Column '%s' not found in data.", col))

  target_levels <- unique(levels)
  cur <- out[[col]]
  ord_flag <- is.ordered(cur)  # FALSE for non-factors; TRUE only for ordered factors

  # Skip if levels and ordered flag already match
  if (is.factor(cur) &&
      identical(levels(cur), target_levels) &&
      identical(is.ordered(cur), ord_flag)) {
    return(if (copy) out else invisible(out))
  }

  out[, (col) := factor(.SD[[1L]], levels = target_levels, ordered = ord_flag), .SDcols = col]

  if (copy) out else invisible(out)
}

#' Relevel multiple columns in a data.table
#'
#' @param dt A `data.table` (or coercible).
#'
#' @param levels Named list: each name is a column; each value is a
#'   character vector with the desired target level order for that column.
#'
#' @param copy Logical. If `TRUE` (default) return a modified copy; if `FALSE`,
#'   modify `dt` by reference and return invisibly.
#'
#' @returns A `data.table` (copy or modified in place).
#' @noRd
#' @keywords internal
dt_relevel_col <- function(dt, levels, copy = TRUE) {
  stopifnot(is.list(levels), length(levels) > 0L, !is.null(names(levels)))
  data.table::setDT(dt)

  out <- if (copy) data.table::copy(dt) else dt
  cols <- names(levels)

  for (c in cols) {
    dt_relevel_col_(out, col = c, levels = levels[[c]], copy = FALSE)
  }

  if (copy) out else invisible(out)
}
