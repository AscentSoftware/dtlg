adsl <- data.frame(
  USUBJID = sprintf("ID-%03d", 1:6),
  ARM = c("A", "A", "B", "B", "C", "C"),
  AGE = c(30, 35, 40, 42, 25, NA),
  stringsAsFactors = FALSE
)

test_that("calc_desc() returns expected structure and types", {
  tbl <- calc_desc(adsl, target = "AGE", treat = "ARM", indent = "")[[1]]

  expect_s3_class(tbl, "data.table")
  expect_identical(colnames(tbl), c("stats", "A", "B", "C"))
  expect_identical(tbl$stats[1], "AGE")
  expect_type(tbl$A, "character")
  expect_type(tbl$B, "character")
  expect_type(tbl$C, "character")
})

test_that("calc_desc() reports five statistics per group", {
  tbl <- calc_desc(adsl, target = "AGE", treat = "ARM", indent = "")[[1]]
  expect_identical(nrow(tbl), 1L + 5L)  # 1 for header + 5 stats
  expect_identical(tbl$stats[-1L],
               c("n", "Mean (SD)", "Median", "Min, Max", "Missing"))
})

test_that("calc_desc() calculates correct n and Missing", {
  tbl <- calc_desc(adsl, target = "AGE", treat = "ARM", indent = "")[[1]]

  expect_identical(tbl[stats == "n", A], "2")
  expect_identical(tbl[stats == "n", C], "1")

  expect_identical(tbl[stats == "Missing", A], "0")
  expect_identical(tbl[stats == "Missing", C], "1")
})

test_that("calc_desc() formats summary strings correctly", {
  tbl <- calc_desc(adsl, target = "AGE", treat = "ARM", indent = "")[[1]]
  mean_sd_values <- tbl[stats == "Mean (SD)", -1]
  min_max_values <- tbl[stats == "Min, Max", -1]

  expect_true(all(detect_fmt(unlist(mean_sd_values), mean_sd_fmt(n = 1L))))
  expect_true(all(detect_fmt(unlist(min_max_values), min_max_fmt(n = 1L))))
})

test_that(
  "calc_desc() only displays Missing when required if inc_missing is NA", {
  tbl <-
    calc_desc(adsl, target = "AGE", treat = "ARM", indent = "",
              inc_missing = NA)[[1]]
  expect_true("Missing" %in% tbl$stats)

  tbl <- calc_desc(adsl[1:5], target = "AGE", treat = "ARM", indent = "",
                   inc_missing = NA)[[1]]
  expect_false("Missing" %in% tbl$stats)
})

test_that("calc_desc() does not display Missing if inc_missing is FALSE", {
  tbl <- calc_desc(adsl, target = "AGE", treat = "ARM", indent = "",
                   inc_missing = FALSE)[[1]]
  expect_false("Missing" %in% tbl$stats)
})

test_that("min_or_na() and max_or_na() return NA without observed values", {
  expect_identical(min_or_na(c(NA_real_, NA_real_)), NA_real_)
  expect_identical(max_or_na(numeric(0L)), NA_real_)
  expect_identical(min_or_na(c(3, NA, 1)), 1)
  expect_identical(max_or_na(c(3L, NA, 1L)), 3L)
})

test_that("calc_desc() leaves statistics empty for a group with no values", {
  dt <- data.frame(ARM = c("A", "A", "B", "B"), AVAL = c(1, 3, NA, NA))

  expect_no_warning(
    calc_desc(dt, target = "AVAL", treat = "ARM", indent = "")
  )

  tbl <- calc_desc(dt, target = "AVAL", treat = "ARM", indent = "")[[1L]]
  expect_identical(tbl$B, c("", "0", "", "", "", "2"))
  expect_identical(tbl$A, c("", "2", "2.0 (1.4)", "2", "1.0, 3.0", "0"))
})
