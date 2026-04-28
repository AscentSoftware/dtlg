#
# Setup
#
adlb_arm_levels <- levels(adlb$ARM)

#
# Tests
#
test_that("`summary_table()` respects order of levels of `treat` in the output", {
  observed <- summary_table(dt = adlb, target = "AVAL", treat = "ARM")
  treat_cols <- colnames(observed)[-1L]

  expect_equal(object = treat_cols, expected = adlb_arm_levels)
})

test_that("`summary_table()`: `treat_order` works", {
  observed <- summary_table(
    dt = adlb,
    target = "AVAL",
    treat = "ARM",
    treat_order = rev(adlb_arm_levels)
  )
  treat_cols <- colnames(observed)[-1L]

  expect_equal(object = treat_cols, expected = rev(adlb_arm_levels))
})

test_that("`summary_table()`: `treat_order` plays well with `skip_absent`", {
  observed <- summary_table(
    dt = adlb,
    target = "AVAL",
    treat = "ARM",
    treat_order = c(rev(adlb_arm_levels), "PHONY"),
    skip_absent = TRUE
  )
  treat_cols <- colnames(observed)[-1L]
  expect_equal(object = treat_cols, expected = rev(adlb_arm_levels))

  expect_error(
    summary_table(
      dt = adlb,
      target = "AVAL",
      treat = "ARM",
      treat_order = c(rev(adlb_arm_levels), "PHONY"),
      skip_absent = FALSE
    )
  )
})

test_that("`summary_table()` tolerates 'stats' in `treat_order`", {

  #
  # `treat_order = "stats"` # nolint: commented_code_linter
  #
  wo_stats <- summary_table(
    dt = adlb,
    target = "AVAL",
    treat = "ARM",
    treat_order = NULL
  )

  wt_stats <- summary_table(
    dt = adlb,
    target = "AVAL",
    treat = "ARM",
    treat_order = "stats"
  )

  testthat::expect_equal(object = wt_stats, expected = wo_stats)

  #
  # `treat_order = rep("stats", 3L)` # nolint: commented_code_linter
  #
  wo_stats <- summary_table(
    dt = adlb,
    target = "AVAL",
    treat = "ARM",
    treat_order = NULL
  )

  wt_stats <- summary_table(
    dt = adlb,
    target = "AVAL",
    treat = "ARM",
    treat_order = rep("stats", 3L)
  )

  testthat::expect_equal(object = wt_stats, expected = wo_stats)

  #
  # `treat_order = c("stats", adlb_arm_levels[1])` # nolint: commented_code_linter
  #
  wo_stats <- summary_table(
    dt = adlb,
    target = "AVAL",
    treat = "ARM",
    treat_order = NULL
  )

  wt_stats <- summary_table(
    dt = adlb,
    target = "AVAL",
    treat = "ARM",
    treat_order = c("stats", adlb_arm_levels[1])
  )

  testthat::expect_equal(object = wt_stats, expected = wo_stats)

  #
  # `treat_order = c("stats", adlb_arm_levels[1])` # nolint: commented_code_linter
  #
  wo_stats <- summary_table(
    dt = adlb,
    target = "AVAL",
    treat = "ARM",
    treat_order = NULL
  )

  wt_stats <- summary_table(
    dt = adlb,
    target = "AVAL",
    treat = "ARM",
    treat_order = c(adlb_arm_levels[1], "stats")
  )

  testthat::expect_equal(object = wt_stats, expected = wo_stats)
})

test_that("`summary_table()`: `pct_dec` works", {

  pct_dec <- 0L
  observed <- summary_table(
    dt = adlb,
    target = "AVAL",
    treat = "ARM",
    pct_dec = pct_dec
  )

  n_mantissa <- tools::file_ext(observed[2L, -1L])
  median_mantissa <- tools::file_ext(observed[4L, -1L])

  # No mantissa is expected for integer variables
  expect_equal(object = 0L, expected = unique(nchar(n_mantissa)))
  # Mantissa length should match `pct_dec`.
  expect_equal(object = pct_dec, expected = unique(nchar(median_mantissa)))

  pct_dec <- 1L
  observed <- summary_table(
    dt = adlb,
    target = "AVAL",
    treat = "ARM",
    pct_dec = pct_dec
  )

  n_mantissa <- tools::file_ext(observed[2L, -1L])
  median_mantissa <- tools::file_ext(observed[4L, -1L])

  # No mantissa is expected for integer variables
  expect_equal(object = 0L, expected = unique(nchar(n_mantissa)))
  # Mantissa length should match `pct_dec`.
  expect_equal(object = pct_dec, expected = unique(nchar(median_mantissa)))

  pct_dec <- 2L
  observed <- summary_table(
    dt = adlb,
    target = "AVAL",
    treat = "ARM",
    pct_dec = pct_dec
  )

  n_mantissa <- tools::file_ext(observed[2L, -1L])
  median_mantissa <- tools::file_ext(observed[4L, -1L])

  # No mantissa is expected for integer variables
  expect_equal(object = 0L, expected = unique(nchar(n_mantissa)))
  # Mantissa length should match `pct_dec`.
  expect_equal(object = pct_dec, expected = unique(nchar(median_mantissa)))

  pct_dec <- 10L
  observed <- summary_table(
    dt = adlb,
    target = "AVAL",
    treat = "ARM",
    pct_dec = pct_dec
  )

  n_mantissa <- tools::file_ext(observed[2L, -1L])
  median_mantissa <- tools::file_ext(observed[4L, -1L])

  # No mantissa is expected for integer variables
  expect_equal(object = 0L, expected = unique(nchar(n_mantissa)))
  # Mantissa length should match `pct_dec`.
  expect_equal(object = pct_dec, expected = unique(nchar(median_mantissa)))
})

test_that("summary_table() handles missing values dynamically when inc_missing is NA", {
  adsl <- data.frame(
    USUBJID = sprintf("ID-%03d", 1:6),
    ARM = c("A", "A", "B", "B", "C", "C"),
    AGE = c(30, 35, 40, 42, 25, NA),
    AGE2 = c(30, 35, 40, 42, 25, 50)
  )

  observed <- summary_table(
    dt = adsl,
    target = c("AGE", "AGE2"),
    treat = "ARM",
    inc_missing = NA,
    indent = ""
  )

  expect_true("Missing" %in% observed$stats)
  expect_identical(sum(observed$stats == "Missing"), 1L)
})
