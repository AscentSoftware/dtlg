test_that("dbl_fmt() returns correct regex for valid integer input", {
  expect_equal(dbl_fmt(0L), "[-+]?\\d+")
  expect_equal(dbl_fmt(1L), "[-+]?\\d+\\.\\d{1}")
  expect_equal(dbl_fmt(2L), "[-+]?\\d+\\.\\d{2}")
  expect_equal(dbl_fmt(5L), "[-+]?\\d+\\.\\d{5}")
})

test_that("dbl_fmt() errors on non-integer or negative input", {
  expect_error(dbl_fmt("2"))
  expect_error(dbl_fmt(2.0))           # not strictly integer class
  expect_error(dbl_fmt(-1L))           # negative
  expect_error(dbl_fmt(NA_integer_))   # NA
})

test_that("int_fmt() is equivalent to dbl_fmt(0L)", {
  expect_identical(int_fmt(), dbl_fmt(0L))
  expect_equal(int_fmt(), "[-+]?\\d+")
})

test_that("n_pct_fmt() returns correct pattern for support_zero = TRUE", {
  expect_equal(
    n_pct_fmt(0L),
    "^0$|^[+]?\\d+ \\([+]?\\d+%\\)$"
  )

  expect_equal(
    n_pct_fmt(1L),
    "^0$|^[+]?\\d+ \\([+]?\\d+\\.\\d{1}%\\)$"
  )

  expect_equal(
    n_pct_fmt(2L),
    "^0$|^[+]?\\d+ \\([+]?\\d+\\.\\d{2}%\\)$"
  )
})

test_that("n_pct_fmt() returns correct pattern for support_zero = FALSE", {
  expect_equal(
    n_pct_fmt(0L, support_zero = FALSE),
    "^[+]?\\d+ \\([+]?\\d+%\\)$"
  )

  expect_equal(
    n_pct_fmt(2L, support_zero = FALSE),
    "^[+]?\\d+ \\([+]?\\d+\\.\\d{2}%\\)$"
  )
})

test_that("n_pct_fmt() errors on invalid input", {
  expect_error(n_pct_fmt(-1L))
  expect_error(n_pct_fmt("1"))
  expect_error(n_pct_fmt(1.5))
  expect_error(n_pct_fmt(NA_integer_))
})

test_that("detect_fmt() correctly detects valid formatted strings", {
  expect_true(detect_fmt("0", fmt = n_pct_fmt()))
  expect_true(detect_fmt("25 (18%)", n_pct_fmt()))
  expect_true(detect_fmt("25 (18.5%)", n_pct_fmt(1L)))
  expect_true(detect_fmt("99 (100.00%)", n_pct_fmt(2L)))
})

test_that("detect_fmt() returns FALSE for invalid formats", {
  expect_false(detect_fmt("25", n_pct_fmt()))             # missing pct
  expect_false(detect_fmt("25 (18.0%)", n_pct_fmt()))     # should be int
  expect_false(detect_fmt("25 (18%)", n_pct_fmt(1L)))     # missing decimal
  expect_false(detect_fmt("25 (18.500%)", n_pct_fmt(2L))) # too many decimals
  expect_false(detect_fmt("25 18%", n_pct_fmt(1L)))       # no parentheses
  expect_false(detect_fmt("n (x%)", n_pct_fmt(1L)))       # malformed
})

test_that("detect_fmt() is vectorised", {
  x <- c("0", "25 (18%)", "25 (18.5%)", "wrong")
  expect_equal(
    detect_fmt(x,  n_pct_fmt(1L)),
    c(TRUE, FALSE, TRUE, FALSE)
  )
})

test_that("detect_fmt() works with mean_sd_fmt()", {
  fmt <- mean_sd_fmt(1L)

  # Valid cases
  expect_true(detect_fmt("12.3 (4.5)", fmt))
  expect_true(detect_fmt("-12.3 (0.0)", fmt))
  expect_true(detect_fmt("+12.3 (10.0)", fmt))
  expect_true(detect_fmt("12.3", fmt))  # SD missing is allowed

  # Invalid cases
  expect_false(detect_fmt("12.3 (4.56)", fmt))   # too many decimals
  expect_false(detect_fmt("12.3 (4)", fmt))      # missing decimal digits
  expect_false(detect_fmt("12.3 ()", fmt))       # empty parentheses
  expect_false(detect_fmt("12.3 (4.5", fmt))     # missing closing parenthesis
  expect_false(detect_fmt("12.3 4.5", fmt))      # missing parentheses
  expect_false(detect_fmt("abc (4.5)", fmt))     # non-numeric
})

test_that("detect_fmt() works with min_max_fmt()", {
  fmt <- min_max_fmt(1L)

  # Valid cases
  expect_true(detect_fmt("1.0, 5.0", fmt))
  expect_true(detect_fmt("-2.3, -1.2", fmt))
  expect_true(detect_fmt("+2.3, +3.4", fmt))

  # Invalid cases
  expect_false(detect_fmt("1.00, 5.0", fmt))  # too many decimals
  expect_false(detect_fmt("1.0 5.0", fmt))    # missing comma
  expect_false(detect_fmt("1.0,5.0", fmt))    # missing space after comma
  expect_false(detect_fmt("1.0, ", fmt))      # missing max
  expect_false(detect_fmt("a, b", fmt))       # non-numeric
})
