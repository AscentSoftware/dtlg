# round_sum_ ----
test_that("Able to correctly round numbers to specified digits - internal", {
  x <- c(1, 1.2345, 0, 5.001, 10.9994)

  expect_identical(round_sum_(x, 1), c(1.0, 1.2, 0.0, 5.0, 11.0))
  expect_identical(round_sum_(x, 3), c(1.000, 1.235, 0.000, 5.001, 10.999))
})

test_that("Able to correctly round numbers to expected sum - internal", {
  x <- rep(1/7, 7L)

  expect_identical(round_sum_(x, 1), rep(c(0.1, 0.2), times = c(4L, 3L)))
  expect_identical(round_sum_(x, 3), c(0.142, rep(0.143, 6L)))
})

test_that("Rounding errors when non-positive numbers are passed - internal", {
  expect_error(round_sum_(-1, 1))
  expect_error(round_sum_(NA_real_, 1))
  expect_error(round_sum_("2.3", 1))
})

# round_sum ----
test_that("Able to correctly round numbers to specified digits", {
  x <- c(1, 1.2345, 0, 5.001, 10.9994)

  expect_identical(round_sum(x, 1), c(1.0, 1.2, 0.0, 5.0, 11.0))
  expect_identical(round_sum(x, 3), c(1.000, 1.235, 0.000, 5.001, 10.999))
})

test_that("Able to correctly round numbers to expected sum", {
  x <- rep(1/7, 7L)

  expect_identical(round_sum(x, 1), rep(c(0.1, 0.2), times = c(4L, 3L)))
  expect_identical(round_sum(x, 3), c(0.142, rep(0.143, 6L)))
})

test_that("Able to correctly round numbers with missing values", {
  x <- c(1, 1.2345, 0, NA_real_, 10.9994)

  expect_identical(round_sum(x, 1), c(1.0, 1.2, 0.0, NA_real_, 11.0))
})

test_that("Rounding errors when non-positive numbers are passed", {
  expect_error(round_sum(-1, 1))
  expect_error(round_sum("2.3", 1))
})

# round_pct_ ----
test_that("Able to correctly round percentages to specified digits - internal", {
  x <- c(1.0001, 1.9999, 3, 4)

  expect_identical(round_pct_(x, 1), c(10, 20, 30, 40))
  expect_identical(round_pct_(x, 3), c(10.001, 19.999, 30, 40))
})

test_that("Able to correctly sum rounded percentages to 100", {
  x <- rep(1/7, 7L)

  expect_identical(round_pct_(x, 1), rep(14.3, 7L))
  expect_identical(
    round_pct_(x, 1, method = "round_sum"),
    c(14.2, rep(14.3, 6L))
  )
  expect_identical(
    round_pct_(x, 3, method = "round_sum"),
    rep(c(14.285, 14.286), times = c(2, 5))
  )
})

# round_pct ----
test_that("Able to correctly round percentages to specified digits", {
  x <- c(1.0001, 1.9999, 3, 4)

  expect_identical(round_pct(x, 1), c(10, 20, 30, 40))
  expect_identical(round_pct(x, 3), c(10.001, 19.999, 30, 40))
})
