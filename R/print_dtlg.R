#' Print a `dtlg` table
#'
#' A convenience wrapper around [print()] for printing `dtlg` tables with
#' consistent formatting options.
#'
#' @param dt A `dtlg` table, typically a `data.frame` or `data.table`.
#' @inheritParams data.table::print.data.table
#' @param justify String. Column alignment; one of `"left"`, `"right"`,
#'   `"centre"`, or `"none"`. Defaults to `"left"`.
#'
#' @returns Invisibly returns the printed object.
#' @export
#'
#' @examples
#' calc_stats(dt = adsl, "AGE", treat = "ARM", indent = "  ")[[1]] |>
#'   print_dtlg()
#'
print_dtlg <- function(dt,
                       row.names = FALSE,
                       trunc.cols = TRUE,
                       class = FALSE,
                       nrows = Inf,
                       justify = "left") {
  print(
    data.table::as.data.table(dt),
    row.names = row.names,
    trunc.cols = trunc.cols,
    class = class,
    nrows = nrows,
    justify = justify
  )
}
