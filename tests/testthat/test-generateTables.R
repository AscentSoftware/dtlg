# some common expect outputs
column_order_standard <- c("stats", "A: Drug X", "C: Combination", "B: Placebo")
column_order_alphabetical <- c("stats", "A: Drug X", "B: Placebo", "C: Combination")

# no treat_order values passed - special NULL
test_that("summary_table-sort_headers-all_missing-NULL", {
  adlb <- random.cdisc.data::cadlb |> dplyr::filter(AVISIT != "SCREENING")
  treat_order <- NULL
  out_df <- summary_table(
    dt = adlb,
    target = 'AVAL',
    treat = 'ARM',
    target_name = c('PARAM','AVISIT'),
    indent = '  ',
    .total_dt = adlb,
    pct_dec = 1,
    treat_order = treat_order,
    skip_absent = TRUE
  )
  testthat::expect_equal(
    object = colnames(out_df),
    expected = column_order_standard
  )
})

# no treat_order values passed - edge cases
test_that("summary_table-sort_headers-all_missing-", {
  adlb <- random.cdisc.data::cadlb |> dplyr::filter(AVISIT != "SCREENING")
  treat_order <- ""
  out_df <- summary_table(
    dt = adlb,
    target = 'AVAL',
    treat = 'ARM',
    target_name = c('PARAM','AVISIT'),
    indent = '  ',
    .total_dt = adlb,
    pct_dec = 1,
    treat_order = treat_order,
    skip_absent = TRUE
  )
  testthat::expect_equal(
    object = colnames(out_df),
    expected = column_order_alphabetical
  )
})
test_that("summary_table-sort_headers-all_missing-logical0", {
  adlb <- random.cdisc.data::cadlb |> dplyr::filter(AVISIT != "SCREENING")
  treat_order <- logical(0)
  out_df <- summary_table(
    dt = adlb,
    target = 'AVAL',
    treat = 'ARM',
    target_name = c('PARAM','AVISIT'),
    indent = '  ',
    .total_dt = adlb,
    pct_dec = 1,
    treat_order = treat_order,
    skip_absent = TRUE
  )
  testthat::expect_equal(
    object = colnames(out_df),
    expected = column_order_alphabetical
  )
})

# 'stats' passed to treat_order
test_that("summary_table-sort_headers-all_missing-stats", {
  adlb <- random.cdisc.data::cadlb |> dplyr::filter(AVISIT != "SCREENING")
  treat_order <- "stats"
  out_df <- summary_table(
    dt = adlb,
    target = 'AVAL',
    treat = 'ARM',
    target_name = c('PARAM','AVISIT'),
    indent = '  ',
    .total_dt = adlb,
    pct_dec = 1,
    treat_order = treat_order,
    skip_absent = TRUE
  )
  testthat::expect_equal(
    object = colnames(out_df),
    expected = column_order_alphabetical
  )
})
test_that("summary_table-sort_headers-all_missing-stats", {
  adlb <- random.cdisc.data::cadlb |> dplyr::filter(AVISIT != "SCREENING")
  treat_order <- c("stats", "A: Drug X")
  out_df <- summary_table(
    dt = adlb,
    target = 'AVAL',
    treat = 'ARM',
    target_name = c('PARAM','AVISIT'),
    indent = '  ',
    .total_dt = adlb,
    pct_dec = 1,
    treat_order = treat_order,
    skip_absent = TRUE
  )
  testthat::expect_equal(
    object = colnames(out_df),
    expected = column_order_alphabetical
  )
})
test_that("summary_table-sort_headers-all_missing-stats", {
  adlb <- random.cdisc.data::cadlb |> dplyr::filter(AVISIT != "SCREENING")
  treat_order <- c("A: Drug X", "stats")
  out_df <- summary_table(
    dt = adlb,
    target = 'AVAL',
    treat = 'ARM',
    target_name = c('PARAM','AVISIT'),
    indent = '  ',
    .total_dt = adlb,
    pct_dec = 1,
    treat_order = treat_order,
    skip_absent = TRUE
  )
  testthat::expect_equal(
    object = colnames(out_df),
    expected = column_order_alphabetical
  )
})
test_that("summary_table-sort_headers-all_missing-stats", {
  adlb <- random.cdisc.data::cadlb |> dplyr::filter(AVISIT != "SCREENING")
  treat_order <- c("stats", "stats")
  out_df <- summary_table(
    dt = adlb,
    target = 'AVAL',
    treat = 'ARM',
    target_name = c('PARAM','AVISIT'),
    indent = '  ',
    .total_dt = adlb,
    pct_dec = 1,
    treat_order = treat_order,
    skip_absent = TRUE
  )
  testthat::expect_equal(
    object = colnames(out_df),
    expected = column_order_alphabetical
  )
})
