adsl <- data.frame(
  USUBJID = sprintf("ID-%03d", 1:6),
  ARM = c("A", "A", "B", "B", "C", "C"),
  AGE = c(30, 35, 40, 42, 25, NA),
  stringsAsFactors = FALSE
)


test_that("calc_desc() returns expected structure and types", {
  tbl <- calc_desc(adsl, target = "AGE", treat = "ARM", indent = "")[[1]]

  expect_s3_class(tbl, "data.table")
  expect_equal(colnames(tbl), c("stats", "A", "B", "C"))
  expect_equal(tbl$stats[1], "AGE")
  expect_type(tbl$A, "character")
  expect_type(tbl$B, "character")
  expect_type(tbl$C, "character")
})

test_that("calc_desc() reports five statistics per group", {
  tbl <- calc_desc(adsl, target = "AGE", treat = "ARM", indent = "")[[1]]
  expect_equal(nrow(tbl), 1 + 5)  # 1 for header + 5 stats
  expect_equal(tbl$stats[-1], c("n", "Mean (SD)", "Median", "Min, Max", "Missing"))
})

test_that("calc_desc() calculates correct n and Missing", {
  tbl <- calc_desc(adsl, target = "AGE", treat = "ARM", indent = "")[[1]]

  expect_equal(tbl[stats == "n", A], "2")
  expect_equal(tbl[stats == "n", C], "2")

  expect_equal(tbl[stats == "Missing", A], "0")
  expect_equal(tbl[stats == "Missing", C], "1")
})

test_that("calc_desc() formats summary strings correctly", {
  tbl <- calc_desc(adsl, target = "AGE", treat = "ARM", indent = "")[[1]]
  mean_sd_values <- tbl[stats == "Mean (SD)", -1]
  min_max_values <- tbl[stats == "Min, Max", -1]

  expect_true(all(detect_fmt(unlist(mean_sd_values), mean_sd_fmt(n = 1L))))
  expect_true(all(detect_fmt(unlist(min_max_values), min_max_fmt(n = 1L))))
})
