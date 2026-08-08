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
  expect_length(matrix(1:6, nrow = 2L), 6L)
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
  re <-
    "Can't recycle `\\.\\.1` \\(size 2\\) to match `\\.\\.2` \\(size 3\\)\\."
  expect_error(
    vec_recycle_common(1:2, 1:3),
    regexp = re
  )
  expect_error(
    vec_recycle_common(this = 1:2, that = 1:3),
    regexp = "Can't recycle `this` \\(size 2\\) to match `that` \\(size 3\\)\\."
  )
})

test_that(".arg qualifies the argument names", {
  re <- "`my_arg\\$this` \\(size 2\\) to match `my_arg\\$that` \\(size 3\\)"
  expect_error(
    vec_recycle_common(this = 1:2, that = 1:3, .arg = "my_arg"),
    regexp = re
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

test_that("as_size() returns a non-negative integer", {
  expect_identical(as_size(0), 0L)
  expect_identical(as_size(1), 1L)
  expect_identical(as_size(3L), 3L)
})

test_that("as_size() rejects values that are not scalar numbers", {
  invalid_sizes <- list(
    NULL,
    numeric(),
    c(1, 2),
    NA_real_,
    "1",
    TRUE
  )

  for (size in invalid_sizes) {
    expect_error(
      as_size(size),
      class = "vec_error_size"
    )
  }
})

test_that("as_size() rejects invalid or unsupported sizes", {
  invalid_sizes <- list(
    -1,
    1.5,
    Inf,
    .Machine$integer.max + 1
  )

  for (size in invalid_sizes) {
    expect_error(
      as_size(size),
      class = "vec_error_size"
    )
  }
})

test_that("as_size() identifies the argument in error messages", {
  expect_error(
    as_size("invalid", arg = ".size"),
    regexp = "`\\.size` must be a single number\\."
  )

  expect_error(
    as_size(-1, arg = ".size"),
    regexp = "`\\.size` must be a whole number, zero or greater\\."
  )
})

test_that("as_size() attributes errors to the supplied call", {
  call <- quote(wrapper(size = -1))
  cnd <- tryCatch(
    as_size(-1, call = call),
    error = \(cnd) cnd
  )

  expect_identical(conditionCall(cnd), call)
})

test_that("stop_recycle_size() reports unnamed inputs", {
  cnd <- tryCatch(
    stop_recycle_size(2L, 3L, ""),
    error = \(cnd) cnd
  )

  expect_s3_class(cnd, "vec_error_recycle_incompatible_size")
  expect_s3_class(cnd, "vec_error_incompatible_size")
  expect_identical(
    conditionMessage(cnd),
    "Can't recycle input of size 2 to size 3."
  )
  expect_identical(cnd$x_size, 2L)
  expect_identical(cnd$size, 3L)
})

test_that("stop_recycle_size() identifies named inputs", {
  cnd <- tryCatch(
    stop_recycle_size(2L, 3L, "target"),
    error = \(cnd) cnd
  )

  expect_identical(
    conditionMessage(cnd),
    "Can't recycle `target` (size 2) to size 3."
  )
})

test_that("stop_recycle_size() attributes errors to the supplied call", {
  call <- quote(wrapper(target))
  cnd <- tryCatch(
    stop_recycle_size(2L, 3L, "target", call = call),
    error = \(cnd) cnd
  )

  expect_identical(conditionCall(cnd), call)
})

test_that("stop_scalar_type() describes scalar objects", {
  cases <- list(
    function_object = list(object = mean, description = "a function"),
    environment = list(object = globalenv(), description = "an environment"),
    call = list(object = quote(x + y), description = "a call")
  )

  for (case in cases) {
    cnd <- tryCatch(
      stop_scalar_type(case$object, "x"),
      error = \(cnd) cnd
    )

    expect_s3_class(cnd, "vec_error_scalar_type")
    expect_identical(
      conditionMessage(cnd),
      sprintf("`x` must be a vector, not %s.", case$description)
    )
  }
})

test_that("stop_scalar_type() reports an unnamed input", {
  cnd <- tryCatch(
    stop_scalar_type(mean, ""),
    error = \(cnd) cnd
  )

  expect_identical(
    conditionMessage(cnd),
    "Input must be a vector, not a function."
  )
})

test_that("stop_scalar_type() attributes errors to the supplied call", {
  call <- quote(wrapper(x))
  cnd <- tryCatch(
    stop_scalar_type(mean, "x", call = call),
    error = \(cnd) cnd
  )

  expect_identical(conditionCall(cnd), call)
})
