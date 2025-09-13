# library(dplyr, warn.conflicts = FALSE)
# library(tidyr, warn.conflicts = FALSE)
#
# indent <- ""
#
# df <- data.frame(
#   grp = c(rep("x", 1L), rep("y", 2L)),
#   tgt =  c(rep("a", 1L), rep("b", 2L))
# )
#
# tidy_calc_counts <- function(dt, target, treat) {
#   dt |>
#     dplyr::count(dplyr::all_of(c(target, treat)))
#
#   # |>
#   #   dplyr::rename(stats = target) |>
#   #   tidyr::pivot_wider(
#   #     names_from = treat,
#   #     values_from = "n",
#   #     values_fill = 0
#   #   ) |>
#   #   dplyr::mutate(dplyr::across(dplyr::everything(), as.character)) |>
#   #   data.table::as.data.table()
# }
#
# test_that("calc_stats() can count", {
#
#   observed <- calc_stats(dt = df, target = "tgt", treat = "grp", indent = indent)[[1]][-1, ]
#   expected <- tidy_calc_counts(dt = df, target = "tgt", treat = "grp")
#
#   expect_equal(observed, expected)
# })
