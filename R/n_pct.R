#' Format count(s) and percentage(s) (`n (pct%)`)
#'
#' [format_n_pct()] formats counts (`n`) and respective percentages (`pct`) as
#' `"n (pct%)"`.
#'
#' @param n An integer vector of counts. Length must match that of `pct`.
#' @param pct A numeric vector of percentages. Length must match that of `n`.
#' @param .pct_digits Number of decimal places to format percentage values.
#'   Defaults to `1`.
#'
#' @returns A character vector of strings following the format `"n (pct%)"`.
#'
#' @examples
#' # Simple cases.
#' format_n_pct(n = 25, pct = 18.66)
#' format_n_pct(n = 25, pct = 18.66, .pct_digits = 2)
#' format_n_pct(n = 0, pct = 0)
#'
#' # `format_n_pct()` is vectorised over `n` and `pct` but their length must
#' # match.
#' format_n_pct(n = c(20, 50), pct = c(10, 25))
#'
#' # Missing values result in empty strings in the output.
#' format_n_pct(n = c(20, NA), pct = c(10, 25))
#' format_n_pct(n = c(20, 50), pct = c(10, NA))
#'
#' @keywords internal
#' @export
format_n_pct <- function(n, pct, .pct_digits = 1L) {

  stopifnot(
    is.numeric(n),
    is.numeric(pct),
    is_scalar_number(.pct_digits),
    .pct_digits >= 0L,
    identical(length(n), length(pct))
  )

  n_fmt <- "%d"
  pct_fmt <- paste0("(%2.", .pct_digits, "f%%)")

  n_str <- sprintf(fmt = n_fmt, n)
  pct_str <- sprintf(fmt = pct_fmt, pct)
  ws_str <- rep_len(" ", length.out = length(n))

  n_str[is.na(n)] <- ""
  pct_str[is.na(pct)] <- ""
  ws_str[!(!is.na(n) & !is.na(pct))] <- ""

  sprintf(fmt = "%s%s%s", n_str, ws_str, pct_str)
}
