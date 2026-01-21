test_that("`dt_expand_grid()` basic two-vector grid preserves order and duplicates", {
  a <- c("x", "x", "y")
  b <- c(1L, 2L)

  g <- dt_expand_grid(a = a, b = b)

  # dimensions: length(a) * length(b)
  expect_equal(nrow(g), length(a) * length(b))
  expect_identical(names(g), c("a", "b"))

  # Expected row-wise expansion (no dedup, order preserved)
  expect_identical(as.character(g$a), rep(a, each = length(b)))
  expect_identical(g$b, rep(b, times = length(a)))
})

test_that("`dt_expand_grid()` preserves types: integer, double, logical, character", {
  a <- 1:3              # integer
  b <- c(0.5, 1.5)      # double
  c <- c(TRUE, FALSE)   # logical
  d <- c("a", "b")      # character

  g <- dt_expand_grid(a = a, b = b, c = c, d = d)

  expect_identical(vapply(g, class, character(1)),
                   c(a = "integer", b = "numeric", c = "logical", d = "character"))
  expect_equal(nrow(g), length(a) * length(b) * length(c) * length(d))
})

test_that("`dt_expand_grid()` preserves factor and ordered factor with level order", {
  f  <- factor(c("low", "med", "high"), levels = c("low", "med", "high"), ordered = FALSE)
  fo <- factor(c("A", "B"), levels = c("A", "B"), ordered = TRUE)

  g <- dt_expand_grid(severity = f, group = fo)

  # Classes preserved
  expect_true(is.factor(g$severity))
  expect_true(is.ordered(g$group))

  # Level orders preserved exactly
  expect_identical(levels(g$severity), c("low", "med", "high"))
  expect_identical(levels(g$group), c("A", "B"))

  # Row count as product of input lengths (not unique levels)
  expect_equal(nrow(g), length(f) * length(fo))
})

test_that("`dt_expand_grid()`: .include_na appends NA only when absent", {
  a <- c("x", "y")
  b <- c(1L, 2L)

  g1 <- dt_expand_grid(a = a, b = b, .include_na = TRUE)
  expect_true(anyNA(g1$a))
  expect_true(anyNA(g1$b))

  # If NA already present, do not add extra
  a2 <- c("x", NA)
  g2 <- dt_expand_grid(a = a2, b = b, .include_na = TRUE)
  expect_equal(sum(is.na(g2$a)), length(unique(g2$b))) # exactly one NA per b value
})

test_that("`dt_expand_grid()` works with a single input vector", {
  a <- c("x", "y", "z")
  g <- dt_expand_grid(a = a)
  expect_identical(g$a, a)
  expect_equal(nrow(g), length(a))
})

test_that("`dt_expand_grid()` returns empty data.table when called with no arguments", {
  g <- dt_expand_grid()
  expect_s3_class(g, "data.table")
  expect_equal(nrow(g), 0L)
  expect_equal(ncol(g), 0L)
})

test_that("`dt_expand_grid()` throws error when arguments are unnamed or have empty names", {
  expect_error(dt_expand_grid(c("a", "b")), "must be \\*named\\*")
  expect_error({
    v <- c("a", "b")
    dt_expand_grid(v)
  }, "must be \\*named\\*")
})
