`%||%` <- function(x, y) {
  if (is.null(x)) y else x
}

# Prevent a false-positive dead-code warning from {goodpractice}, which does not
# recognise the operator's infix usage.
`%||%`(NULL, NULL)
