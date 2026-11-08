#
# Setup
#
adlb_arm_levels <- levels(adlb$ARM)

#### summary_table ####
test_that(
  "`summary_table()` respects order of levels of `treat` in the output", {
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

#### summary_table_by_targets ####
test_that(
  "summary_table_by_targets: Using custom separator does not affect data", {
  summary_dot <- suppressWarnings(
    summary_table_by_targets(
      dt = adlb,
      target = c("AVAL", "CHG"),
      treat = "ARM",
      rows_by = c("PARAM", "AVISIT"),
      indent = "  "
    )
  )

  summary_dash <- suppressWarnings(
    summary_table_by_targets(
      dt = adlb,
      target = c("AVAL", "CHG"),
      treat = "ARM",
      rows_by = c("PARAM", "AVISIT"),
      indent = "  ",
      sep = " - "
    )
  )

  treat_aval_cols <- as.vector(t(outer(
    adlb_arm_levels, c("AVAL", "CHG"), paste, sep = " - "
  )))
  expect_named(summary_dash, c("stats", treat_aval_cols))
  expect_identical(unname(summary_dash), unname(summary_dot))
})

test_that(
  "summary_table_by_targets: Able to use more than 2 target variables", {
  target_vars <- c("AVAL", "CHG", "ANRLO", "ANRHI")

  summary_dt <- suppressWarnings(
    summary_table_by_targets(
      dt = adlb,
      target = target_vars,
      treat = "ARM",
      rows_by = c("PARAM", "AVISIT"),
      indent = "  "
    )
  )

  treat_aval_cols <-
    as.vector(t(outer(adlb_arm_levels, target_vars, paste, sep = ".")))
  expect_named(summary_dt, c("stats", treat_aval_cols))
})

#### inc_missing in grouped summaries ####

# Two visits; V1 has one missing AVAL, V2 has none. CHG is complete.
labs_fixture <- function() {
  data.frame(
    USUBJID = rep(c("s1", "s2", "s3", "s4"), times = 2L),
    ARM = rep(c("A", "A", "B", "B"), times = 2L),
    AVISIT = rep(c("V1", "V2"), each = 4L),
    AVAL = c(1, NA, 3, 4, 5, 6, 7, 8),
    CHG = c(0, 0, 0, 0, 4, 4, 4, 4)
  )
}

n_missing_rows <- function(tbl) sum(endsWith(tbl$stats, "Missing"))

test_that("`summary_table_by()` honours `inc_missing`", {
  by_visit <- function(inc_missing) {
    summary_table_by(
      labs_fixture(),
      target = "AVAL",
      treat = "ARM",
      rows_by = "AVISIT",
      inc_missing = inc_missing
    )[[1L]]
  }

  expect_identical(n_missing_rows(by_visit(TRUE)), 2L)
  expect_identical(n_missing_rows(by_visit(FALSE)), 0L)
  # `NA` is decided per group: only V1 has a missing value.
  expect_identical(n_missing_rows(by_visit(NA)), 1L)

  missing_row <- by_visit(TRUE)[endsWith(stats, "Missing")]
  expect_identical(missing_row$A, c("1", "0"))
  expect_identical(missing_row$B, c("0", "0"))
})

test_that("`summary_table_by()` defaults to showing the Missing row", {
  res <- summary_table_by(
    labs_fixture(),
    target = "AVAL",
    treat = "ARM",
    rows_by = "AVISIT"
  )[[1L]]

  expect_identical(n_missing_rows(res), 2L)
})

test_that("`summary_table_by_targets()` honours `inc_missing`", {
  by_targets <- function(inc_missing, data = labs_fixture()) {
    summary_table_by_targets(
      data,
      target = c("AVAL", "CHG"),
      treat = "ARM",
      rows_by = "AVISIT",
      inc_missing = inc_missing
    )
  }

  expect_identical(n_missing_rows(by_targets(TRUE)), 2L)
  expect_identical(n_missing_rows(by_targets(FALSE)), 0L)

  # `NA` with a missing AVAL: the row appears in every group, keeping the
  # AVAL and CHG columns aligned.
  res_na <- by_targets(NA)
  expect_identical(n_missing_rows(res_na), 2L)
  expect_identical(
    res_na[endsWith(stats, "Missing")][["A.AVAL"]],
    c("1", "0")
  )
  expect_identical(
    res_na[endsWith(stats, "Missing")][["A.CHG"]],
    c("0", "0")
  )

  # `NA` without missing values: no Missing row.
  complete <- labs_fixture()
  complete$AVAL[2L] <- 2
  expect_identical(n_missing_rows(by_targets(NA, data = complete)), 0L)
})
