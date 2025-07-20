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
nbsp <- function(n = 1L) {

  stopifnot(
    is.numeric(n),
    n >= 0L
  )

  strrep("&nbsp;", times = n)
}
