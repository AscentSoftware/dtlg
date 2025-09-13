test_that("factors return full levels including unused", {
  df <- data.frame(
    f = factor(c("low", "med", "low"),
               levels = c("low", "med", "high", "very high"))
  )
  out <- level_set(df)
  expect_named(out, "f")
  expect_identical(out$f, c("low", "med", "high", "very high"))
})

test_that("non-factors sorted keep NA at end", {
  df <- data.frame(
    i = c(3L, NA, 1L, 2L, 1L),
    c = c("b", "a", NA, "b", "c"),
    l = c(TRUE, NA, FALSE, TRUE, FALSE)
  )
  out <- level_set(df, .sort = TRUE)

  expect_identical(out$i, c(1L, 2L, 3L, NA))
  expect_identical(out$c, c("a", "b", "c", NA))
  # For logical, FALSE < TRUE; NA last.
  expect_identical(out$l, c(FALSE, TRUE, NA))
})

test_that("non-factors unsorted preserve first-appearance order incl. NA", {
  df <- data.frame(
    i = c(3L, NA, 1L, 2L, 1L),
    c = c("b", "a", NA, "b", "c"),
    l = c(TRUE, NA, FALSE, TRUE, FALSE)
  )
  out <- level_set(df, .sort = FALSE)

  expect_identical(out$i, c(3L, NA, 1L, 2L))
  expect_identical(out$c, c("b", "a", NA, "c"))
  expect_identical(out$l, c(TRUE, NA, FALSE))
})

test_that("cols subset works and errors on invalid names", {
  df <- data.frame(
    a = 1:3,
    b = factor(c("x", "y", "x"), levels = c("x", "y", "z"))
  )
  out <- level_set(df, cols = c("b"))
  expect_named(out, "b")
  expect_identical(out$b, c("x", "y", "z"))

  expect_error(level_set(df, cols = c("a", "nope")))
})

test_that("empty cols produces empty named list", {
  df <- data.frame(a = 1:3)
  out <- level_set(df, cols = character(0))
  expect_true(is.list(out) && length(out) == 0L)
  expect_identical(names(out), character(0))
})

test_that("factor levels: used vs all", {
  df <- data.frame(f = factor(
    c("low", "med", "low"),
    levels = c("low", "med", "high", "very high")
  ))
  used <- level_set(df, cols = "f", .fct_levels = "used")$f
  allv <- level_set(df, cols = "f", .fct_levels = "all")$f

  expect_identical(used, c("low", "med"))
  expect_identical(allv, c("low", "med", "high", "very high"))
})

test_that(".sort ignored for factors; respected for non-factors", {
  df <- data.frame(f = factor(c("b", "a", "b", "b", "a"), levels = c("a", "b", "c")), i = c(3L, NA, 1L, 2L, 1L))
  # factors follow level order regardless of .sort
  expect_identical(level_set(df, cols = "f", .sort = TRUE)$f, c("a", "b", "c"))
  expect_identical(level_set(df, cols = "f", .sort = FALSE)$f, c("a", "b", "c"))

  # non-factors: .sort controls ordering and NA placement
  expect_identical(level_set(df, cols = "i", .sort = TRUE)$i, c(1L, 2L, 3L, NA))
  expect_identical(level_set(df, cols = "i", .sort = FALSE)$i, c(3L, NA, 1L, 2L))
})
