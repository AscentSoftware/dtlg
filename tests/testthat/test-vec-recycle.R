#
# vec_size()
#

test_that("size is length for vectors without dimensions", {
  expect_identical(vec_size(1:3), 3L)
  expect_identical(vec_size(integer()), 0L)
  expect_identical(vec_size(list(1, 2)), 2L)
  expect_identical(vec_size(letters), 26L)
})

test_that("size of NULL is 0", {
  expect_identical(vec_size(NULL), 0L)
})

test_that("size is the first dimension for matrices and arrays", {
  expect_identical(vec_size(matrix(1:6, nrow = 2L)), 2L)
  expect_identical(vec_size(array(1:6, dim = c(1L, 3L, 2L))), 1L)
  expect_identical(vec_size(matrix(integer(), nrow = 0L, ncol = 3L)), 0L)

  # Size and length disagree here; that is the point of the abstraction.
  expect_identical(length(matrix(1:6, nrow = 2L)), 6L)
})

test_that("size of a data frame is its number of rows", {
  expect_identical(vec_size(data.frame(x = 1:3)), 3L)
  expect_identical(vec_size(data.frame(x = integer())), 0L)
  expect_identical(vec_size(data.frame(x = 1:3)[, 0L, drop = FALSE]), 3L)
})

test_that("every column of a data frame has the size of the data frame", {
  df <- data.frame(x = 1:3)
  df$m <- matrix(1:6, nrow = 3L)
  df$d <- data.frame(y = 4:6)

  sizes <- vapply(df, vec_size, integer(1L))
  expect_identical(unname(sizes), c(3L, 3L, 3L))
})

test_that("size respects vector classes", {
  expect_identical(vec_size(factor(c("a", "b"))), 2L)
  expect_identical(vec_size(as.Date("2026-01-01") + 0:4), 5L)
  expect_identical(vec_size(as.POSIXct("2026-01-01") + 0:2), 3L)
  # `length()` on POSIXlt counts date-times from R 4.3.0 onwards.
  expect_identical(vec_size(as.POSIXlt(as.Date("2026-01-01") + 0:2)), 3L)
})

test_that("scalars are rejected", {
  expect_error(vec_size(mean), class = "vec_error_scalar_type")
  expect_error(vec_size(globalenv()), class = "vec_error_scalar_type")
  expect_error(vec_size(quote(x + y)), class = "vec_error_scalar_type")
  expect_error(vec_size(lm(1 ~ 1)), class = "vec_error_scalar_type")
})

test_that("the scalar error names the offending argument", {
  expect_error(
    vec_size(mean, x_arg = "fn"),
    regexp = "`fn` must be a vector, not a function\\."
  )
  expect_error(
    vec_size(mean),
    regexp = "Input must be a vector, not a function\\."
  )
})

test_that("a classed list is a vector when it declares vector semantics", {
  expect_true(is_vector(structure(list(1, 2), class = c("my_list", "list"))))
  expect_false(is_vector(structure(list(1, 2), class = "my_record")))
  expect_false(is_vector(mean))
  expect_true(is_vector(NULL))
  expect_true(is_vector(data.frame()))
})

#
# vec_size_common()
#

test_that("common size of no input is .absent", {
  expect_identical(vec_size_common(), 0L)
  expect_identical(vec_size_common(.absent = 5L), 5L)
  expect_error(vec_size_common(.absent = -1), class = "vec_error_size")
  expect_error(vec_size_common(.absent = NULL), class = "vec_error_size")
})

test_that("NULL inputs are ignored", {
  expect_identical(vec_size_common(NULL, NULL), 0L)
  expect_identical(vec_size_common(NULL, 1:3), 3L)
  expect_identical(vec_size_common(1:3, NULL), 3L)
  expect_identical(vec_size_common(NULL, NULL, .absent = 5L), 5L)
})

test_that("size 1 adopts the size of the other input", {
  expect_identical(vec_size_common(1, 1:3), 3L)
  expect_identical(vec_size_common(1:3, 1), 3L)
  expect_identical(vec_size_common(1, 1), 1L)
})

test_that("the reduction is ordered, not a maximum", {
  # A size-1 input adopts size 0, so a later size-3 input is incompatible.
  expect_identical(vec_size_common(1, integer()), 0L)
  expect_identical(vec_size_common(integer(), 1), 0L)
  expect_error(
    vec_size_common(1, integer(), 1:3),
    class = "vec_error_incompatible_size"
  )
})

test_that("incompatible sizes are an error", {
  expect_error(vec_size_common(1:2, 1:3), class = "vec_error_incompatible_size")
  expect_error(
    vec_size_common(1:2, integer()),
    class = "vec_error_incompatible_size"
  )
})

test_that(".size overrides the inputs and is validated", {
  expect_identical(vec_size_common(1:2, 1:3, .size = 5), 5L)
  expect_error(vec_size_common(.size = -1), class = "vec_error_size")
})

#
# vec_recycle()
#

test_that("size 1 recycles to any size", {
  expect_identical(vec_recycle(1, 1), 1)
  expect_identical(vec_recycle(1, 0), numeric())
  expect_identical(vec_recycle(1, 3), c(1, 1, 1))
})

test_that("a vector already of the requested size is returned unchanged", {
  x <- 1:3
  expect_identical(vec_recycle(x, 3), x)

  x0 <- integer()
  expect_identical(vec_recycle(x0, 0), x0)
})

test_that("NULL recycles to NULL", {
  expect_null(vec_recycle(NULL, 3))
  expect_null(vec_recycle(NULL, 0))
})

test_that("any other size is an error", {
  expect_error(
    vec_recycle(1:2, 1),
    class = "vec_error_recycle_incompatible_size"
  )
  expect_error(vec_recycle(1:2, 0), class = "vec_error_incompatible_size")
  expect_error(
    vec_recycle(1:2, 3),
    regexp = "Can't recycle input of size 2 to size 3\\."
  )
  expect_error(
    vec_recycle(1:2, 3, x_arg = "foo"),
    regexp = "Can't recycle `foo` \\(size 2\\) to size 3\\."
  )
})

test_that("size is validated", {
  expect_error(vec_recycle(1, -1), class = "vec_error_size")
  expect_error(vec_recycle(1, 1.5), class = "vec_error_size")
  expect_error(vec_recycle(1, NA_integer_), class = "vec_error_size")
  expect_error(vec_recycle(1, c(1, 2)), class = "vec_error_size")
  expect_error(vec_recycle(1, "1"), class = "vec_error_size")
  expect_error(vec_recycle(1, NULL), class = "vec_error_size")
})

test_that("recycling preserves vector classes", {
  f <- factor("a", levels = c("a", "b"))
  expect_identical(vec_recycle(f, 2), factor(c("a", "a"), levels = c("a", "b")))

  d <- as.Date("2026-01-01")
  expect_identical(vec_recycle(d, 2), rep(d, 2))

  expect_identical(vec_recycle(list(1), 2), list(1, 1))
})

test_that("recycling preserves names", {
  expect_identical(vec_recycle(c(a = 1), 2), c(a = 1, a = 1))
})

test_that("matrices recycle along rows", {
  x <- matrix(1:2, nrow = 1L)

  expect_identical(vec_recycle(x, 1), x)
  expect_identical(vec_recycle(x, 2), matrix(1:2, 2L, 2L, byrow = TRUE))
  expect_identical(vec_recycle(x, 0), matrix(integer(), 0L, 2L))
})

test_that("matrix recycling preserves dimnames", {
  x <- matrix(1:2, nrow = 1L, dimnames = list("r", c("a", "b")))
  out <- vec_recycle(x, 2)

  expect_identical(dim(out), c(2L, 2L))
  expect_identical(dimnames(out), list(c("r", "r"), c("a", "b")))
})

test_that("arrays of more than two dimensions recycle along the first", {
  x <- array(1:6, dim = c(1L, 3L, 2L))
  out <- vec_recycle(x, 2)

  expect_identical(dim(out), c(2L, 3L, 2L))
  expect_identical(out[1L, , ], out[2L, , ])
})

test_that("one-dimensional arrays keep their dimensions", {
  x <- array(1L, dim = 1L)
  expect_identical(dim(vec_recycle(x, 3)), 3L)
})

test_that("list matrices recycle", {
  x <- matrix(list(1, 2), nrow = 1L)
  expect_identical(vec_recycle(x, 2), matrix(list(1, 2), 2L, 2L, byrow = TRUE))
  expect_identical(vec_recycle(x, 0), matrix(list(), 0L, 2L))
})

test_that("data frames recycle along rows with automatic row names", {
  df <- data.frame(x = 1, y = "a")
  out <- vec_recycle(df, 3)

  expect_identical(out, data.frame(x = c(1, 1, 1), y = c("a", "a", "a")))
  expect_identical(attr(out, "row.names"), 1:3)
})

test_that("data frames recycle to size 0", {
  df <- data.frame(x = 1, y = "a")
  expect_identical(vec_recycle(df, 0), data.frame(x = numeric(), y = character()))
})

test_that("data frames with a matrix column recycle", {
  df <- data.frame(x = 1)
  df$m <- matrix(1:2, nrow = 1L)
  out <- vec_recycle(df, 2)

  expect_identical(vec_size(out), 2L)
  expect_identical(dim(out$m), c(2L, 2L))
})

#
# vec_recycle_common()
#

test_that("empty input returns an empty list", {
  expect_identical(vec_recycle_common(), list())
})

test_that("NULL is idempotent", {
  expect_identical(vec_recycle_common(NULL, NULL), list(NULL, NULL))
  expect_identical(vec_recycle_common(1:5, NULL), list(1:5, NULL))
  expect_identical(vec_recycle_common(NULL, 1:5), list(NULL, 1:5))
})

test_that("equal sizes are returned unchanged", {
  x <- 1:3

  expect_identical(vec_recycle_common(x, x), list(x, x))
  expect_identical(vec_recycle_common(x[0], x[0]), list(x[0], x[0]))
})

test_that("size 1 recycles to the common size", {
  x1 <- 1
  x3 <- rep(1, 3)
  x0 <- numeric()

  expect_identical(vec_recycle_common(x1, x3), list(x3, x3))
  expect_identical(vec_recycle_common(x3, x1), list(x3, x3))
  expect_identical(vec_recycle_common(x1, x0), list(x0, x0))
})

test_that("names are retained", {
  expect_named(vec_recycle_common(a = 1, b = 2), c("a", "b"))
  expect_named(vec_recycle_common(a = 1, b = 2:3), c("a", "b"))
  expect_null(names(vec_recycle_common(1, 2)))
})

test_that("inputs are not modified", {
  x <- list(a = 1, b = 2:3)

  expect_identical(
    do.call(vec_recycle_common, x),
    list(a = c(1, 1), b = 2:3)
  )
  expect_identical(x, list(a = 1, b = 2:3))
})

test_that("incompatible sizes are an error", {
  expect_error(
    vec_recycle_common(1:2, 1:3),
    class = "vec_error_incompatible_size"
  )
  expect_error(
    vec_recycle_common(numeric(), 1:2),
    class = "vec_error_incompatible_size"
  )
})

test_that("the error names the offending arguments", {
  expect_error(
    vec_recycle_common(1:2, 1:3),
    regexp = "Can't recycle `\\.\\.1` \\(size 2\\) to match `\\.\\.2` \\(size 3\\)\\."
  )
  expect_error(
    vec_recycle_common(this = 1:2, that = 1:3),
    regexp = "Can't recycle `this` \\(size 2\\) to match `that` \\(size 3\\)\\."
  )
})

test_that(".arg qualifies the argument names", {
  expect_error(
    vec_recycle_common(this = 1:2, that = 1:3, .arg = "my_arg"),
    regexp = "`my_arg\\$this` \\(size 2\\) to match `my_arg\\$that` \\(size 3\\)"
  )
})

test_that("positional labels count NULL inputs", {
  expect_error(
    vec_recycle_common(1:2, NULL, 1:3),
    regexp = "`\\.\\.1` \\(size 2\\) to match `\\.\\.3` \\(size 3\\)"
  )
  expect_error(
    vec_recycle_common(1, NULL, lm(1 ~ 1)),
    regexp = "`\\.\\.3` must be a vector"
  )
})

test_that(".size forces the output size", {
  expect_identical(vec_recycle_common(1, 2, .size = 2), list(c(1, 1), c(2, 2)))
  expect_identical(vec_recycle_common(.size = 2), list())
  expect_identical(vec_recycle_common(NULL, .size = 2), list(NULL))
})

test_that(".size reports the input that cannot be recycled", {
  expect_error(
    vec_recycle_common(this = 1:2, that = integer(), .size = 2),
    regexp = "Can't recycle `that` \\(size 0\\) to size 2\\."
  )
})

test_that("errors are attributed to the calling function", {
  my_function <- function(...) vec_recycle_common(...)
  cnd <- tryCatch(my_function(x = 1:2, y = 1:3), error = function(cnd) cnd)

  expect_identical(conditionCall(cnd), quote(my_function(x = 1:2, y = 1:3)))
})

test_that("the call can be overridden by a wrapper", {
  wrapper <- function(...) vec_recycle_common(..., .call = sys.call())
  cnd <- tryCatch(wrapper(1:2, 1:3), error = function(cnd) cnd)

  expect_identical(conditionCall(cnd), quote(wrapper(1:2, 1:3)))
})

test_that("data frames and matrices recycle together", {
  mt <- matrix(nrow = 2L, ncol = 2L)
  df <- data.frame(x = c(1, 1), y = c(2, 2))

  expect_identical(
    vec_recycle_common(mt[1L, , drop = FALSE], df),
    list(mt, df)
  )
  expect_identical(
    vec_recycle_common(mt, df[1L, , drop = FALSE]),
    list(mt, df)
  )
})

test_that("recycling data frames respects incompatible sizes", {
  df <- data.frame(a = rep(1, 3L))

  expect_error(
    vec_recycle_common(df[1:2, , drop = FALSE], df),
    class = "vec_error_incompatible_size"
  )
  expect_error(
    vec_recycle_common(df[0L, , drop = FALSE], df),
    class = "vec_error_incompatible_size"
  )
})

test_that("classes survive recycling to a common size", {
  f <- factor("a", levels = c("a", "b"))
  d <- as.Date("2026-01-01")

  out <- vec_recycle_common(f, d, 1:2)

  expect_identical(out[[1L]], factor(c("a", "a"), levels = c("a", "b")))
  expect_identical(out[[2L]], rep(d, 2L))
  expect_identical(out[[3L]], 1:2)
})
