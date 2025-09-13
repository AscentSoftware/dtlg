#' Retrieve the label of an object
#'
#' [label()] gets the attached label to an object.
#'
#' @param x An R object.
#'
#' @returns The label attribute (string) associated with object passed in `x` or
#'   `NULL` if the label attribute does not exist.
#'
#' @examples
#' label(1)
#' label(with_label(1, "my label"))
#'
#' @seealso [with_label()]
#'
#' @export
label <- function(x) {
  attr(x, "label")
}

#' Add a label attribute to an object
#'
#' @param x An R object.
#' @param label A label provided as a single string.
#'
#' @return `x` labeled by `label`.
#'
#' @examples
#' label(1)
#' label(with_label(1, "my label"))
#'
#' @seealso [label()]
#'
#' @export
with_label <- function(x, label) {

  stopifnot(is_string(label))
  attr(x, "label") <- label
  x
}
