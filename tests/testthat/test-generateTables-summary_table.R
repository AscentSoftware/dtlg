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
    skip_absent = TRUE,
    include_missing_treat = FALSE
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
  treat_order <- c("stats", "stats") # could happen!
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

# treat_order items that are not in the data set
test_that("summary_table-sort_headers-not_in_data-skip", {
  # "D: NotInDataSet" is not in the input data set, and skip_absent = TRUE
  adlb <- random.cdisc.data::cadlb |> dplyr::filter(AVISIT != "SCREENING")
  treat_order <- c("D: NotInDataSet")
  out_df <- summary_table(
    dt = adlb,
    target = 'AVAL',
    treat = 'ARM',
    target_name = c('PARAM','AVISIT'),
    indent = '  ',
    .total_dt = adlb,
    pct_dec = 1,
    treat_order = treat_order,
    skip_absent = TRUE,
    include_missing_treat = FALSE
  )
  testthat::expect_equal(
    object = colnames(out_df),
    expected = column_order_alphabetical # treat_order is not NULL so sort alphabetically
  )
})
test_that("summary_table-sort_headers-not_in_data-error", {
  # "D: NotInDataSet" is not in the input data set, and skip_absent = FALSE, therefore ERROR
  adlb <- random.cdisc.data::cadlb |> dplyr::filter(AVISIT != "SCREENING")
  treat_order <- c("D: NotInDataSet")
  testthat::expect_error(
    summary_table(
      dt = adlb,
      target = 'AVAL',
      treat = 'ARM',
      target_name = c('PARAM','AVISIT'),
      indent = '  ',
      .total_dt = adlb,
      pct_dec = 1,
      treat_order = treat_order,
      skip_absent = FALSE,
      include_missing_treat = FALSE
    )
  )
})

test_that("summary_table-sort_headers-custom_order-stats_A", {
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
    expected = c("stats", "A: Drug X", "B: Placebo", "C: Combination")
  )
})
test_that("summary_table-sort_headers-custom_order-A", {
  adlb <- random.cdisc.data::cadlb |> dplyr::filter(AVISIT != "SCREENING")
  treat_order <- c("A: Drug X")
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
test_that("summary_table-sort_headers-custom_order-stats_B", {
  adlb <- random.cdisc.data::cadlb |> dplyr::filter(AVISIT != "SCREENING")
  treat_order <- c("stats", "B: Placebo")
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
    expected = c("stats", "B: Placebo", "A: Drug X", "C: Combination")
  )
})
test_that("summary_table-sort_headers-custom_order-B", {
  adlb <- random.cdisc.data::cadlb |> dplyr::filter(AVISIT != "SCREENING")
  treat_order <- c("B: Placebo")
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
    expected = c("stats", "B: Placebo", "A: Drug X", "C: Combination")
  )
})
test_that("summary_table-sort_headers-custom_order-stats_C", {
  adlb <- random.cdisc.data::cadlb |> dplyr::filter(AVISIT != "SCREENING")
  treat_order <- c("stats", "C: Combination")
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
    expected = c("stats", "C: Combination", "A: Drug X", "B: Placebo")
  )
})
test_that("summary_table-sort_headers-custom_order-C", {
  adlb <- random.cdisc.data::cadlb |> dplyr::filter(AVISIT != "SCREENING")
  treat_order <- c("C: Combination")
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
    expected = c("stats", "C: Combination", "A: Drug X", "B: Placebo")
  )
})
test_that("summary_table-sort_headers-custom_order-stats_D-skip", {
  adlb <- random.cdisc.data::cadlb |> dplyr::filter(AVISIT != "SCREENING")
  treat_order <- c("stats", "D: NotInDataSet")
  out_df <- summary_table(
    dt = adlb,
    target = 'AVAL',
    treat = 'ARM',
    target_name = c('PARAM','AVISIT'),
    indent = '  ',
    .total_dt = adlb,
    pct_dec = 1,
    treat_order = treat_order,
    skip_absent = TRUE,
    include_missing_treat = FALSE
  )
  testthat::expect_equal(
    object = colnames(out_df),
    expected = c("stats", "A: Drug X", "B: Placebo", "C: Combination")
  )
})
test_that("summary_table-sort_headers-custom_order-stats_D-error", {
  adlb <- random.cdisc.data::cadlb |> dplyr::filter(AVISIT != "SCREENING")
  treat_order <- c("stats", "D: NotInDataSet")
  testthat::expect_error(
    summary_table(
      dt = adlb,
      target = 'AVAL',
      treat = 'ARM',
      target_name = c('PARAM','AVISIT'),
      indent = '  ',
      .total_dt = adlb,
      pct_dec = 1,
      treat_order = treat_order,
      skip_absent = FALSE,
      include_missing_treat = FALSE
    )
  )
})
test_that("summary_table-sort_headers-custom_order-D-skip", {
  adlb <- random.cdisc.data::cadlb |> dplyr::filter(AVISIT != "SCREENING")
  treat_order <- c("D: NotInDataSet")
  out_df <- summary_table(
    dt = adlb,
    target = 'AVAL',
    treat = 'ARM',
    target_name = c('PARAM','AVISIT'),
    indent = '  ',
    .total_dt = adlb,
    pct_dec = 1,
    treat_order = treat_order,
    skip_absent = TRUE,
    include_missing_treat = FALSE
  )
  testthat::expect_equal(
    object = colnames(out_df),
    expected = c("stats", "A: Drug X", "B: Placebo", "C: Combination")
  )
})

test_that("summary_table-sort_headers-custom_order-D-Include", {
  adlb <- random.cdisc.data::cadlb |> dplyr::filter(AVISIT != "SCREENING")
  treat_order <- c("D: NotInDataSet")
  out_df <- summary_table(
    dt = adlb,
    target = 'AVAL',
    treat = 'ARM',
    target_name = c('PARAM','AVISIT'),
    indent = '  ',
    .total_dt = adlb,
    pct_dec = 1,
    treat_order = treat_order,
    skip_absent = TRUE,
    include_missing_treat = TRUE
  )
  testthat::expect_equal(
    object = colnames(out_df),
    expected = c("stats", "D: NotInDataSet","A: Drug X", "B: Placebo", "C: Combination")
  )
})

test_that("summary_table-sort_headers-custom_order-D-error", {
  adlb <- random.cdisc.data::cadlb |> dplyr::filter(AVISIT != "SCREENING")
  treat_order <- c("D: NotInDataSet")
  testthat::expect_error(
    summary_table(
      dt = adlb,
      target = 'AVAL',
      treat = 'ARM',
      target_name = c('PARAM','AVISIT'),
      indent = '  ',
      .total_dt = adlb,
      pct_dec = 1,
      treat_order = treat_order,
      skip_absent = FALSE,
      include_missing_treat = FALSE
    )
  )
})

# Assert that decimal places can be controlled via pct_dec
test_that("summary_table-pct_dec_comparison", {
  adlb <- random.cdisc.data::cadlb |> dplyr::filter(AVISIT != "SCREENING")
  out_pct1 <- summary_table(
    dt = adlb,
    target = 'AVAL',
    treat = 'ARM',
    target_name = c('PARAM','AVISIT'),
    indent = '  ',
    .total_dt = adlb,
    pct_dec = 1,
    treat_order = NULL,
    skip_absent = FALSE
  )
  out_pct5 <- summary_table(
    dt = adlb,
    target = 'AVAL',
    treat = 'ARM',
    target_name = c('PARAM','AVISIT'),
    indent = '  ',
    .total_dt = adlb,
    pct_dec = 5,
    treat_order = NULL,
    skip_absent = FALSE
  )
  val_pct1 <- as.double(unname(unlist(out_pct1[4,2])))
  val_pct5 <- as.double(unname(unlist(out_pct5[4,2])))
  testthat::expect_false(val_pct1 == val_pct5)
})
