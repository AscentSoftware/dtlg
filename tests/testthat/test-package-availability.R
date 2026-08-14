test_that("is_pkg_available() detects installed packages", {
  expect_true(is_pkg_available("base"))
  expect_false(is_pkg_available("a-package-that-does-not-exist"))
})

test_that("assert_pkg_is_installed() returns invisibly when available", {
  expect_invisible(assert_pkg_is_installed("base"))
})

test_that("assert_pkg_is_installed() errors when the package is unavailable", {
  expect_error(
    assert_pkg_is_installed("a-package-that-does-not-exist"),
    paste(
      "Package a-package-that-does-not-exist must be installed",
      "to use this function."
      ),
    fixed = TRUE
  )
})
