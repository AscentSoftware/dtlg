dbl_fmt <- function(n) {
  stopifnot(is.integer(n), n >= 0L)
  if (identical(n, 0L)) return("\\d+")
  sprintf("\\d+\\.\\d{%d}", n)
}

int_fmt <- function() {
  dbl_fmt(n = 0L)
}

n_pct_fmt <- function(n, support_zero = TRUE) {
  zero_fmt <- `if`(support_zero, "^0$|", "")
  sprintf("%s^%s \\(%s%%\\)$", zero_fmt, int_fmt(), dbl_fmt(n = n))
}

mean_sd_fmt <- function(n) {
  sprintf("^%s \\(%s\\)$", dbl_fmt(n = n), dbl_fmt(n = n))
}

min_max_fmt <- function(n) {
  sprintf("^%s, \\(%s\\)$", dbl_fmt(n = n), dbl_fmt(n = n))
}

detect_n_pct <- function(str, .pct_digits = 1L) {
  stopifnot(
    is.character(str),
    is_scalar_number(.pct_digits),
    .pct_digits >= 0L
  )

  regex <- n_pct_fmt(as.integer(.pct_digits))
  grepl(regex, str)
}

detect_mean_sd <- function(str, .pct_digits = 1L) {
  stopifnot(
    is.character(str),
    is_scalar_number(.pct_digits),
    .pct_digits >= 0L
  )

  regex <- mean_sd_fmt(as.integer(.pct_digits))
  grepl(regex, str)
}

detect_min_max <- function(str, .pct_digits = 1L) {
  stopifnot(
    is.character(str),
    is_scalar_number(.pct_digits),
    .pct_digits >= 0L
  )

  regex <- min_max_fmt(as.integer(.pct_digits))
  grepl(regex, str)
}

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

format_mean_sd <- function(mean, sd, .digits = 1L) {

  stopifnot(
    is.numeric(mean),
    is.numeric(sd),
    is_scalar_number(.digits),
    .digits >= 0L,
    identical(length(mean), length(sd))
  )

  mean_fmt <- paste0("%.", .digits, "f")
  sd_fmt <- paste0("(%.", .digits, "f)")

  mean_str <- sprintf(fmt = mean_fmt, mean)
  sd_str <- sprintf(fmt = sd_fmt, sd)
  ws_str <- rep_len(" ", length.out = length(mean))

  mean_str[is.na(mean)] <- ""
  sd_str[is.na(sd)] <- ""
  ws_str[!(!is.na(mean) & !is.na(sd))] <- ""

  sprintf(fmt = "%s%s%s", mean_str, ws_str, sd_str)
}

format_min_max <- function(min, max, .digits = 1L) {

  stopifnot(
    is.numeric(max),
    is.numeric(min),
    is_scalar_number(.digits),
    .digits >= 0L,
    identical(length(max), length(min))
  )

  fmt <- paste0("%.", .digits, "f")

  min_str <- sprintf(fmt = fmt, min)
  max_str <- sprintf(fmt = fmt, max)
  ws_str <- rep_len(", ", length.out = length(max))

  max_str[is.na(max)] <- ""
  min_str[is.na(min)] <- ""
  ws_str[!(!is.na(max) & !is.na(min))] <- ""

  sprintf(fmt = "%s%s%s", min_str, ws_str, max_str)
}
