calc_stats_dt <- data.frame(
  ARM = rep(c("A", "B"), each = 3L),
  VALUE = c(1.25, 2.50, NA, 3.50, 4.75, 6.00),
  COUNT = seq_len(6L),
  CATEGORY = c("X", "Y", "X", "Y", "Y", "X"),
  CATEGORY_FACTOR = factor(c("X", "Y", "X", "Y", "Y", "X")),
  FLAG = c(TRUE, FALSE, NA, TRUE, TRUE, FALSE),
  DATE = as.Date("2026-01-01") + 0:5
)

test_that("calc_stats() dispatches numeric variables to calc_desc()", {
  for (target in c("VALUE", "COUNT")) {
    actual <- calc_stats(
      calc_stats_dt,
      target = target,
      treat = "ARM",
      target_name = "Heading",
      indent = "  ",
      pct_dec = 2,
      inc_missing = FALSE
    )

    expected <- calc_desc(
      calc_stats_dt,
      target = target,
      treat = "ARM",
      target_name = "Heading",
      indent = "  ",
      pct_dec = 2,
      inc_missing = FALSE
    )

    expect_identical(actual, expected)
  }
})

test_that("calc_stats() dispatches categorical variables to calc_counts()", {
  for (target in c("CATEGORY", "CATEGORY_FACTOR", "FLAG")) {
    actual <- calc_stats(
      calc_stats_dt,
      target = target,
      treat = "ARM",
      target_name = "Heading",
      indent = "  ",
      .total_dt = calc_stats_dt,
      pct_dec = 2
    )

    expected <- calc_counts(
      calc_stats_dt,
      target = target,
      treat = "ARM",
      target_name = "Heading",
      indent = "  ",
      .total_dt = calc_stats_dt,
      pct_dec = 2
    )

    expect_identical(actual, expected)
  }
})

test_that("calc_stats() rejects unsupported target classes", {
  expect_error(
    calc_stats(calc_stats_dt, target = "DATE", treat = "ARM"),
    regexp = "does not support dispatch.*Date"
  )
})
