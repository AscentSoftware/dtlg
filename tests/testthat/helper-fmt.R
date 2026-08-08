#' Regex for number sign
#'
#' @param sign Whether the number can have a any sign (`"any"`), or be a
#' positive or negative number.
#'
#' @returns A regex as a string.
#'
#' @examples
#' sign_fmt("any")
#'
#' # Strictly positive
#' sign_fmt("any")
#'
#' # Strictly negative
#' sign_fmt("negative")
#'
#' @noRd
#'
sign_fmt <- function(sign = c("any", "positive", "negative")) {
  sign <- match.arg(sign)
  fmt <- c(any = "[-+]?", positive = "[+]?", negative = "-")
  unname(fmt[sign])
}

#' Regex for fractional part of a number
#'
#' @param n Number of decimal places.
#'
#' @returns A regex as a string.
#'
#' @examples
#' fractional_fmt(0L)
#'
#' # One decimal place
#' fractional_fmt(1L)
#'
#' @noRd
#'
fractional_fmt <- function(n = 1L) {
  stopifnot(is.integer(n), n >= 0L)

  if (identical(n, 0L)) {
    ""
  } else {
    sprintf("\\.\\d{%d}", n)
  }
}

#' Regex for a whole number
#'
#' @param sign Whether the number can have a any sign (`"any"`), or be a
#' positive or negative number.
#'
#' @returns A regex as a string.
#'
#' @examples
#' # Positive or negative whole number
#' int_fmt()
#'
#' # Strictly positive number
#' int_fmt("positive")
#'
#' # Strictly negative number
#' int_fmt("negative")
#'
#' @noRd
#'
int_fmt <- function(sign = c("any", "positive", "negative")) {
  sign <- match.arg(sign)
  sprintf("%s\\d+", sign_fmt(sign = sign))
}

#' Regex for a number with fractional part
#'
#' @param n Number of decimal places.
#'
#' @param sign Whether the number can have a any sign (`"any"`), or be a
#' positive or negative number.
#'
#' @returns A regex as a string.
#'
#' @examples
#' # Positive or negative whole number
#' dbl_fmt(0L)
#'
#' # Strictly positive number with one decimal place
#' dbl_fmt(1L, "positive")
#'
#' # Strictly negative number with two decimal places
#' dbl_fmt(2L, "negative")
#'
#' @noRd
#'
dbl_fmt <- function(n = 1L, sign = c("any", "positive", "negative")) {
  stopifnot(is.integer(n), n >= 0L)
  sign <- match.arg(sign)
  sprintf("%s%s", int_fmt(sign = sign), fractional_fmt(n = n))
}

#' Regex for mean and standard deviation (`<mean> (<sd>)`)
#'
#' @param n Number of decimal places for the mean and standard deviation,
#' defaults to 1.
#'
#' @returns A regex as a string matching the pattern `<mean> (<sd>)`. The
#' standard deviation can't be negative, but may be missing.
#'
#' @examples
#' # Mean and standard deviation as whole numbers
#' mean_sd_fmt(n = 0L)
#'
#' # Mean and standard deviation with one decimal place
#' #' mean_sd_fmt(n = 1L)
#'
#' @noRd
#'
mean_sd_fmt <- function(n = 1L) {
  mean_fmt <- dbl_fmt(n = n)
  sd_fmt <- dbl_fmt(n = n, sign = "positive")
  ws_fmt <- " "
  sprintf("^%s(%s\\(%s\\))?$", mean_fmt, ws_fmt, sd_fmt)
}

min_max_fmt <- function(n = 1L) {
  sprintf("^%s, %s$", dbl_fmt(n = n), dbl_fmt(n = n))
}

detect_fmt <- function(x, fmt) {
  grepl(pattern = fmt, x = x)
}

#' Regex for count and percentage (`<n> (<pct>%)`)
#'
#' @param n Number of decimal places for the percentage number.
#'
#' @param support_zero Whether the regex should also support the pattern of a
#'   single zero (`"0"`), i.e. with the percentage omitted. Default is `TRUE`.
#'
#' @returns A regex as a string.
#'
#' @examples
#' # Count and percentage as integer numbers
#' n_pct_fmt(n = 0L, support_zero = FALSE)
#'
#' # Percentage with one decimal place
#' n_pct_fmt(n = 1L, support_zero = FALSE)
#'
#' # Also accept a pattern that is a single `"0"`
#' n_pct_fmt(n = 1L, support_zero = TRUE)
#'
#' @noRd
#'
n_pct_fmt <- function(n = 0L, support_zero = TRUE) {
  zero_fmt <- `if`(support_zero, "^0$|", "")
  sprintf("%s^%s \\(%s%%\\)$",
          zero_fmt,
          int_fmt("positive"),
          dbl_fmt(n = n, "positive"))
}


