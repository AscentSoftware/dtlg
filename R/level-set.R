#' Extract per-column level sets from a data.frame
#'
#' For each column in `df`, returns the set of values used to define
#' group spaces. Factors return their full `levels()` (including unused) or
#' only *used* levels, as controlled by `.fct_levels`. Non-factors return
#' unique values, optionally sorted.
#'
#' @param df A data.frame.
#' @param cols Optional character vector of column names to restrict
#'   the output. If `NULL` (default), all columns are used.
#' @param .sort Logical (default `TRUE`). If `TRUE`, non-factor
#'   columns use `sort(unique(x), na.last = TRUE)`; if `FALSE`, they use
#'   `unique(x)` (order of first appearance). Ignored for factor columns.
#' @param .fct_levels One of `"used"` or `"all"` (default `"all"`). Controls
#'   whether factor columns return only levels that appear in the data or all
#'   declared levels. The order of returned factor levels always follows the
#'   factor's level order.
#'
#' @returns A named list with one element per selected column of `df`.
#'   For factors, the element is a character vector of levels; otherwise it is
#'   the unique values (with `NA` kept last when `.sort = TRUE`).
#'
#' @examples
#' df <- data.frame(
#'   i = c(2L, 1L, 2L),
#'   c = c("b", "a", "b"),
#'   f = factor(c("low", "med", "low"),
#'              levels = c("low", "med", "high", "very high")),
#'   l = c(TRUE, NA, FALSE)
#' )
#'
#' # All columns
#' level_set(df)
#'
#' # Subset of columns
#' level_set(df, cols = c("i", "f"))
#'
#' # Keep order of first appearance for non-factors
#' level_set(df, .sort = FALSE)
#'
#' # Factors: only used levels vs all declared levels
#' level_set(df, cols = "f", .fct_levels = "used")
#' level_set(df, cols = "f", .fct_levels = "all")
#'
#' @noRd
level_set <- function(df, cols = NULL, .sort = TRUE, .fct_levels = c("all", "used")) {
  stopifnot(is.data.frame(df))
  .fct_levels <- match.arg(.fct_levels)

  df_cols <- colnames(df)
  cols <- cols %||% df_cols
  stopifnot(all(cols %in% df_cols))

  out <- lapply(cols, function(col) {
    x <- df[[col]]
    if (is.factor(x)) {
      levs <- levels(x)
      if (.fct_levels == "all") {
        levs
      } else {
        # keep only levels that actually appear, in the factor's level order
        levs[levs %in% as.character(x)]
      }
    } else {
      if (.sort) sort(unique(x), na.last = TRUE) else unique(x)
    }
  })
  stats::setNames(out, cols)
}


