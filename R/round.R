# `round_sum_()`: Assumes `x` does not contain NA values.
round_sum_ <- function(x, digits = 0L) {

  stopifnot(
    is.numeric(x),
    is_scalar_number(digits),
    all(x >= 0),
    digits >= 0L
  )

  up <- 10 ^ digits
  x <- x * up
  y <- floor(x)
  indices <- utils::tail(order(x - y), round(sum(x)) - sum(y))
  y[indices] <- y[indices] + 1
  y / up
}

#' Rounds numbers while preserving the total sum
#'
#' [round_sum()] rounds a numeric vector of non-negative values to a specified
#' number of decimal places while ensuring that the sum of the rounded value
#' remains as close as possible to the original total.
#'
#' @param x A numeric vector of non-negative values that you want to round.
#' Missing values (`NA`) are ignored.
#'
#' @param digits The number of decimal places to round to. Default is `0`
#' (integer rounding).
#'
#' @returns A numeric vector of the same length as `x`, with values rounded in
#' such a way that the total sum is preserved.
#'
#' @examples
#' # Rounds to integers, preserving the sum of 100.
#' x <- c(33.3333, 33.3333, 33.3334)
#' (y <- round_sum(x))
#' identical(sum(x), sum(y))
#'
#' # Rounds to integers, preserving the sum of 1002.
#' x <- c(100.5, 200.25, 300.75, 400.5)
#' (y <- round_sum(x))
#' identical(sum(x), sum(y))
#'
#' # Rounds to one decimal place, preserving the total sum.
#' x <- c(12.345, 67.890, 19.765)
#' (y <- round_sum(x))
#' identical(sum(x), sum(y))
#'
#' @export
#'
round_sum <- function(x, digits = 0L) {

  stopifnot(
    is.numeric(x),
    is_scalar_number(digits),
    all(is.na(x) | x >= 0),
    digits >= 0L
  )

  x[!is.na(x)] <- round_sum_(x[!is.na(x)], digits = digits)
  x
}

round_pct_ <- function(
    x,
    digits = 1L,
    method = c("round", "round_sum")) {

  stopifnot(
    is.numeric(x),
    is.numeric(digits),
    all(x >= 0),
    digits >= 0L
  )

  method <- match.arg(method)
  round <- match.fun(method)

  pct <- 100 * x / sum(x)
  rounded_pct <- round(pct, digits = digits)
  rounded_pct
}

#' Rounded percentage
#'
#' [round_pct()] returns the rounded percentages of `x` values.
#'
#' @param x A numeric vector of non-negative values for which you want
#'   percentages to be determined and rounded. Missing values (`NA`) are
#'   ignored.
#'
#' @param digits The number of decimal places to round to. Default is `0`
#' (integer rounding).
#'
#' @param method Rounding method: `"round"` that uses R's base [round()] or
#' `"round_sum"` that uses [dtlg::round_sum][round_sum()].
#'
#' @returns A numeric vector of the same length as `x` with rounded percentages.
#'
#' @examples
#' x <- c(1 / 3, 1 / 3, 1 / 3)
#'
#' # Default method ensures precise rounding but total might not be 100%.
#' round_pct(x = x)
#' sum(round_pct(x = x))
#'
#' # You can trade off rounding precision for precision on the total with the
#' # method `"round_sum"`.
#' round_pct(x = x, method = "round_sum")
#' sum(round_pct(x = x, method = "round_sum"))
#'
#' # Vary the number of decimal places, e.g. increase to three.
#' round_pct(x = x, digits = 3, method = "round_sum")
#'
#' # Missing values are ignored.
#' x <- c(1, 2, NA)
#' round_pct(x = x, digits = 3)
#'
#' @export
#'
round_pct <- function(
    x,
    digits = 1L,
    method = c("round", "round_sum")) {

  stopifnot(
    is.numeric(x),
    is_scalar_number(digits),
    all(is.na(x) | x >= 0),
    digits >= 0L
  )

  method <- match.arg(method)
  x[!is.na(x)] <- round_pct_(x[!is.na(x)], digits = digits, method = method)
  x
}


