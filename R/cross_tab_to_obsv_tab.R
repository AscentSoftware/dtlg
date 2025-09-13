vrep <- Vectorize(rep.int)

#' Convert a contingency table to a long-format observation-level data frame
#'
#' [cross_tab_to_obsv_tab()] expands a contingency table or matrix of counts
#' into a long-format data frame where each row represents one observation. The
#' output contains one column per dimension of the input, with repeated rows
#' according to the frequency counts.
#'
#' @param cross_tab A two-way or multi-way contingency table (`matrix` or
#'   `table`) with named `dimnames`. Each combination of factor levels is
#'   assumed to represent a count of occurrences.
#'
#' @param strings_as_factors Should character columns in the output
#'   be converted to factors?
#'
#' @returns A `data.frame` in long format with one row per implied observation
#'   and one column per dimension of the input table.
#'
#' @examples
#' dim_names <- list(Sex = c("Male", "Female"),
#'                   Response = c("Yes", "No"))
#' cross_tab <- matrix(c(2, 1, 3, 4), nrow = 2, dimnames = dim_names)
#' cross_tab_to_obsv_tab(cross_tab)
#'
#' @export
cross_tab_to_obsv_tab <- function(cross_tab, strings_as_factors = TRUE) {
  if (!is.matrix(cross_tab) && !inherits(cross_tab, "table")) {
    stop("Input must be a matrix or a table.")
  }

  comb <- expand.grid(dimnames(cross_tab), stringsAsFactors = strings_as_factors)
  df <- cbind(comb, freq = as.vector(cross_tab))
  idx <- unlist(vrep(seq_len(nrow(df)), df$freq))
  df <- df[idx, names(dimnames(cross_tab))]
  rownames(df) <- NULL
  df
}
