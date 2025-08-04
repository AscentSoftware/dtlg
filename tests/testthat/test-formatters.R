test_that("dbl_fmt() returns correct regex for valid integer input", {
  expect_equal(dbl_fmt(0L), "\\d+")
  expect_equal(dbl_fmt(1L), "\\d+\\.\\d{1}")
  expect_equal(dbl_fmt(2L), "\\d+\\.\\d{2}")
  expect_equal(dbl_fmt(5L), "\\d+\\.\\d{5}")
})

test_that("dbl_fmt() errors on non-integer or negative input", {
  expect_error(dbl_fmt("2"))
  expect_error(dbl_fmt(2.0))           # not strictly integer class
  expect_error(dbl_fmt(-1L))           # negative
  expect_error(dbl_fmt(NA_integer_))   # NA
})

test_that("int_fmt() is equivalent to dbl_fmt(0L)", {
  expect_identical(int_fmt(), dbl_fmt(0L))
  expect_equal(int_fmt(), "\\d+")
})

test_that("n_pct_fmt() returns correct pattern for support_zero = TRUE", {
  expect_equal(
    n_pct_fmt(0L),
    "^0$|^\\d+ \\(\\d+%\\)$"
  )

  expect_equal(
    n_pct_fmt(1L),
    "^0$|^\\d+ \\(\\d+\\.\\d{1}%\\)$"
  )

  expect_equal(
    n_pct_fmt(2L),
    "^0$|^\\d+ \\(\\d+\\.\\d{2}%\\)$"
  )
})

test_that("n_pct_fmt() returns correct pattern for support_zero = FALSE", {
  expect_equal(
    n_pct_fmt(0L, support_zero = FALSE),
    "^\\d+ \\(\\d+%\\)$"
  )

  expect_equal(
    n_pct_fmt(2L, support_zero = FALSE),
    "^\\d+ \\(\\d+\\.\\d{2}%\\)$"
  )
})

test_that("n_pct_fmt() errors on invalid input", {
  expect_error(n_pct_fmt(-1L))
  expect_error(n_pct_fmt("1"))
  expect_error(n_pct_fmt(1.5))
  expect_error(n_pct_fmt(NA_integer_))
})

test_that("detect_n_pct() correctly detects valid formatted strings", {
  expect_true(detect_n_pct("0", .pct_digits = 0L))
  expect_true(detect_n_pct("25 (18%)", .pct_digits = 0L))
  expect_true(detect_n_pct("25 (18.5%)", .pct_digits = 1L))
  expect_true(detect_n_pct("99 (100.00%)", .pct_digits = 2L))
})

test_that("detect_n_pct() returns FALSE for invalid formats", {
  expect_false(detect_n_pct("25", .pct_digits = 0L))                 # missing pct
  expect_false(detect_n_pct("25 (18.0%)", .pct_digits = 0L))         # should be int
  expect_false(detect_n_pct("25 (18%)", .pct_digits = 1L))           # missing decimal
  expect_false(detect_n_pct("25 (18.500%)", .pct_digits = 2L))       # too many decimals
  expect_false(detect_n_pct("25 18%", .pct_digits = 1L))             # no parentheses
  expect_false(detect_n_pct("n (x%)", .pct_digits = 1L))             # malformed
})

test_that("detect_n_pct() is vectorised", {
  x <- c("0", "25 (18%)", "25 (18.5%)", "wrong")
  expect_equal(
    detect_n_pct(x, .pct_digits = 1L),
    c(TRUE, FALSE, TRUE, FALSE)
  )
})

test_that("detect_n_pct() validates inputs", {
  expect_error(detect_n_pct(25, .pct_digits = 0L), "is.character")
  expect_error(detect_n_pct("25 (18%)", .pct_digits = -1L), ">= 0")
  expect_error(detect_n_pct("25 (18%)", .pct_digits = NA), "is_scalar_number")
})
