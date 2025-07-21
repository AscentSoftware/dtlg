#' Generate Non-Breaking Spaces for HTML Output
#'
#' [nbsp()] generates a string of HTML non-breaking spaces (`&nbsp;`).
#'
#' @param n Number of non-breaking spaces. Defaults to `1`.
#'
#' @returns A character string containing `n` HTML non-breaking spaces
#'   (`&nbsp;`).
#'
#' @examples
#' # One non-breaking space
#' nbsp()
#' nbsp(1)
#'
#' # Several non-breaking spaces
#' nbsp(n = 2)
#' nbsp(n = 5)
#'
#' # When `n` is zero, an empty string is returned.
#' nbsp(n = 0)
#'
#' @keywords internal
#'
nbsp <- function(n = 1L) {

  stopifnot(
    is.numeric(n),
    n >= 0L
  )

  strrep("&nbsp;", times = n)
}

#' Add indentation to strings
#'
#' [indent()] prefixes a string with a sequence of HTML non-breaking spaces,
#' to effectively work as indentation.
#'
#' @param x A character vector of strings to be _indented_.
#'
#' @param n Number of non-breaking spaces to use as indentation. If `n = 0` then
#' no indentation is performed.
#'
#' @returns A character vector of the same length as `x`.
#'
#' @examples
#' # Default is to indent by four non-breaking spaces.
#' indent("Mean")
#'
#' # Choose a different indentation level.
#' indent("Mean", n = 2L)
#'
#' # `indent()` is vectorised over `x`
#' indent(c("Mean", "Median", "Max, Min", "Missing"))
#'
#' @keywords internal
#'
indent <- function(x, n = 4L) {

  stopifnot(
    is.character(x),
    n >= 0L
  )

  indentation <- nbsp(n = n)
  paste0(indentation, x)
}
