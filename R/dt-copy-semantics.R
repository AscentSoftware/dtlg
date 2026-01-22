#' Get or set data.table copy semantics
#'
#' These functions control how [maybe_copy_dt()] decides whether to
#' return a `data.table` by reference (in place) or by value (as a deep copy).
#'
#' @details
#' The copy semantics are stored in the global option
#' `dtlg_dt_copy_semantics`. The option can take two values:
#'
#' - `"reference"` (default): inputs are treated with reference semantics.
#'   - If the input is already a `data.table`, it is returned unchanged and
#'     aliases are preserved.
#'   - If the input is a `data.frame`, it is converted to a `data.table`
#'     in place via [data.table::setDT()], mutating the caller’s object.
#'
#' - `"value"`: inputs are treated with value semantics.
#'   - The input is converted to a `data.table` (if necessary) and a deep
#'     copy is returned, leaving the original unchanged.
#'
#' @returns
#' - `dt_copy_semantics()` returns the current semantics as a string,
#'   `"reference"` or `"value"`.
#'
#' - `set_dt_copy_semantics()` sets the semantics, returning the previous
#'   semantics invisibly.
#'
#' @param dt_copy_semantics Character string. Either `"reference"` or `"value"`.
#'
#' @examples
#' # Get current semantics (defaults to "reference")
#' dt_copy_semantics()
#'
#' # Switch to value semantics
#' old <- set_dt_copy_semantics("value")
#' dt_copy_semantics()
#'
#' # Restore previous semantics
#' set_dt_copy_semantics(old)
#'
#' @seealso [maybe_copy_dt()]
#'
#' @export
dt_copy_semantics <- function() {
  getOption(x = "dtlg_dt_copy_semantics", default = "reference")
}

#' @rdname dt_copy_semantics
#' @export
set_dt_copy_semantics <- function(dt_copy_semantics = c("reference", "value")) {
  dt_copy_semantics <- match.arg(dt_copy_semantics)
  old_semantics <- dt_copy_semantics()
  options(dtlg_dt_copy_semantics = dt_copy_semantics)
  invisible(old_semantics)
}

#' Return a data.table by reference or by value
#'
#' [maybe_copy_dt()] returns its input as a `data.table`, with behaviour
#' controlled by the global copy semantics option [dt_copy_semantics()].
#'
#' - If the semantics are `"reference"` (default):
#'   * If `x` is already a `data.table`, it is returned unchanged. Aliasing
#'     holds, so mutations with `:=` will affect both input and output.
#'
#'   * If `x` is a `data.frame`, it is converted to a `data.table` in place
#'     via [data.table::setDT()], mutating the caller’s object. The returned
#'     object is a `data.table` with the same contents. For efficiency, the
#'     column vectors are reused without a deep copy.
#'
#' - If the semantics are `"value"`:
#'   * `x` is converted to a `data.table` (if necessary) and a deep copy is
#'     returned. Mutating the result does not affect the input.
#'
#' @param x A `data.table` or `data.frame`.
#'
#' @returns
#' A `data.table`. Whether the return value aliases the input depends on
#' the semantics:
#'
#' - `"reference"`: input is mutated in place, aliasing guaranteed if
#'   `x` is already a `data.table`.
#' - `"value"`: a fresh copy is returned, independent of the input.
#'
#' @seealso [dt_copy_semantics()], [set_dt_copy_semantics()]
#'
#' @examples
#' # Default: reference semantics
#' df <- data.frame(a = 1:3)
#' out <- maybe_copy_dt(df)
#' data.table::is.data.table(df) # TRUE, converted in place
#'
#' # Switch to value semantics
#' old <- set_dt_copy_semantics("value")
#' dt <- data.table::data.table(a = 1:3)
#' out2 <- maybe_copy_dt(dt)
#' out2[, b := 99L]
#' "b" %in% names(dt)  # FALSE, original unchanged
#'
#' # Restore previous semantics
#' set_dt_copy_semantics(old)
#'
#' @export
maybe_copy_dt <- function(x) {
  error_msg <- paste("Unknown data.table copy semantics option:",
                     "must be 'reference' or 'value'")

  sem <- dt_copy_semantics()

  if (identical(sem, "reference")) {
    data.table::setDT(x)       # mutates in place
    return(x)                  # return the very same object
  }

  if (identical(sem, "value")) {
    return(data.table::copy(data.table::as.data.table(x)))
  }

  stop(error_msg, call. = FALSE)
}
