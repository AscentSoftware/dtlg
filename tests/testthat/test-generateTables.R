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
    expected = c("stats", "A: Drug X", "C: Combination", "B: Placebo")
  )
})
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
    expected = c("stats", "A: Drug X", "B: Placebo", "C: Combination")
  )
})
