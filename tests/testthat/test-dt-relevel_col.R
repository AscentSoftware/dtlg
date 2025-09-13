test_that("relevels a factor column and enforces level order", {
  dt <- data.table::data.table(g = factor(c("b","a","b","c"), levels = c("a","b","c","d")))
  res <- dt_relevel_col_(dt, col = "g", levels = c("c","a"))

  expect_s3_class(res, "data.table")
  expect_identical(levels(res$g), c("c","a"))
  # Values not in levels -> NA
  expect_equal(as.character(res$g), c(NA, "a", NA, "c"))
  expect_false(is.ordered(res$g)) # original was not ordered
})

test_that("coerces non-factor columns and converts out-of-set to NA", {
  dt <- data.table::data.table(h = c("low","med","high","med"))
  res <- dt_relevel_col_(dt, col = "h", levels = c("high","low"))

  expect_identical(levels(res$h), c("high","low"))
  expect_equal(as.character(res$h), c("low", NA, "high", NA))
  expect_false(is.ordered(res$h))
})

test_that("preserves ordered flag when input is an ordered factor", {

  x <- factor(c("b","a","b"), levels = c("a","b","c"), ordered = TRUE)
  dt <- data.table::data.table(g = x)
  res <- dt_relevel_col_(dt, col = "g", levels = c("b","a"))

  expect_true(is.ordered(res$g))
  expect_identical(levels(res$g), c("b","a"))
})

test_that("duplicate levels in argument are de-duplicated", {
  dt <- data.table::data.table(g = factor(c("a","b","a")))
  res <- dt_relevel_col_(dt, col = "g", levels = c("b","b","a","a"))

  expect_identical(levels(res$g), c("b","a"))
})

test_that("dt_relevel_col_() always modifies by reference", {

  dt <- data.table::data.table(g = factor(c("a","b","a"), levels = c("a","b","c")))
  res <- dt_relevel_col_(dt, col = "g", levels = c("b","a"))

  # original changed
  expect_identical(levels(dt$g), c("b","a"))
  # result changed
  expect_identical(levels(res$g), c("b","a"))
})

test_that("idempotent when levels already match and order preserved", {

  dt <- data.table::data.table(g = factor(c("b","a","b"), levels = c("b","a")))
  res <- dt_relevel_col_(dt, col = "g", levels = c("b","a"))

  expect_identical(levels(res$g), c("b","a"))
  expect_equal(as.character(res$g), c("b","a","b"))
})

test_that("errors when column is missing", {
  dt <- data.table::data.table(g = factor(c("a","b")))
  expect_error(
    dt_relevel_col_(dt, col = "h", levels = c("a","b")),
    "Column 'h' not found"
  )
})

test_that("augmented level set: extra levels are added but data unchanged", {

  set_dt_copy_semantics("value")
  # original factor (unordered), observed levels: a, b
  dt <- data.table::data.table(g = factor(c("a","b","a"), levels = c("a","b")))
  before_na <- sum(is.na(dt$g))

  # provide augmented target levels (includes 'c' and 'd', not present in data)
  target <- c("b", "a", "c", "d")
  res <- dt_relevel_col_(dt, col = "g", levels = target)

  # levels now match augmented set, in the requested order
  expect_identical(levels(res$g), target)

  # underlying data values remain the same (no new values introduced)
  expect_identical(as.character(res$g), c("a", "b", "a"))

  # NA count is unchanged
  expect_identical(sum(is.na(res$g)), before_na)

  # unordered preserved (input was not ordered)
  expect_false(is.ordered(res$g))
})

test_that("augmented level set preserves ordered flag for ordered factors", {


  # ordered factor, observed levels: low, high
  set_dt_copy_semantics("reference")
  x <- factor(c("low","high","low"), levels = c("low","high"), ordered = TRUE)
  dt <- data.table::data.table(h = x)

  # augmented levels include 'medium' and 'very_high' (not observed)
  set_dt_copy_semantics("value")
  target <- c("high", "low", "medium", "very_high")
  res <- dt_relevel_col_(dt, col = "h", levels = target)

  # levels updated to augmented set in requested order
  expect_identical(levels(res$h), target)

  # data values unchanged
  expect_identical(as.character(res$h), c("low","high","low"))

  # ordered flag preserved
  expect_true(is.ordered(res$h))
})

test_that("relevels multiple columns with specified target levels", {

  dt <- data.table::data.table(
    g = factor(c("b","a","b","c"), levels = c("a","b","c","d")),
    h = c("low","high","med","high")
  )

  res <- dt_relevel_col(
    dt,
    levels = list(g = c("c","a"), h = c("high","low"))
  )

  expect_s3_class(res, "data.table")
  expect_identical(levels(res$g), c("c","a"))
  expect_identical(levels(res$h), c("high","low"))

  # Data re-mapped / NA as expected
  expect_equal(as.character(res$g), c(NA,"a",NA,"c"))
  expect_equal(as.character(res$h), c("low", "high", NA, "high"))
})

test_that("augmented level sets are allowed and data remain unchanged", {

  dt <- data.table::data.table(
    g = factor(c("a","b","a"), levels = c("a","b")),
    h = factor(c("low","high","low"), levels = c("low","high"))
  )

  target <- list(g = c("b","a","c","d"), h = c("high","low","medium"))
  res <- dt_relevel_col(dt, levels = target)

  expect_identical(levels(res$g), target$g)
  expect_identical(levels(res$h), target$h)
  expect_identical(as.character(res$g), c("a","b","a"))
  expect_identical(as.character(res$h), c("low","high","low"))
})

test_that("preserves ordered flag per column where applicable", {

  dt <- data.table::data.table(
    g = factor(c("b","a","b"), levels = c("a","b"), ordered = TRUE),
    h = c("low","high","low")  # not ordered
  )

  res <- dt_relevel_col(dt, levels = list(g = c("b","a"), h = c("high","low")))
  expect_true(is.ordered(res$g))
  expect_false(is.ordered(res$h))
})

test_that("coerces non-factor columns and converts out-of-set to NA", {

  dt <- data.table::data.table(
    g = c("b","a","b","c"),
    h = c("low","high","med","high")
  )

  res <- dt_relevel_col(dt, levels = list(g = c("c","a"), h = c("high","low")))
  expect_identical(levels(res$g), c("c","a"))
  expect_identical(levels(res$h), c("high","low"))

  expect_equal(as.character(res$g), c(NA, "a", NA, "c"))
  expect_equal(as.character(res$h), c("low", "high", NA, "high"))
})

test_that("value semantics returns a modified copy and leaves input unchanged", {

  dt <- data.table::data.table(
    g = factor(c("a","b","a"), levels = c("a","b","c")),
    h = c("low","high","low")
  )

  set_dt_copy_semantics("value")
  res <- dt_relevel_col(dt, levels = list(g = c("b","a"), h = c("high","low")))

  # original unchanged
  expect_identical(levels(dt$g), c("a","b","c"))
  expect_null(attr(dt$h, "levels")) # still character

  # result changed
  expect_identical(levels(res$g), c("b","a"))
  expect_identical(levels(res$h), c("high","low"))
})

test_that("reference semantics modifies in place and returns invisibly", {

  dt <- data.table::data.table(
    g = factor(c("a","b","a"), levels = c("a","b","c")),
    h = c("low","high","low")
  )

  set_dt_copy_semantics("reference")
  dt_relevel_col(dt, levels = list(g = c("b","a"), h = c("high","low")))

  expect_identical(levels(dt$g), c("b","a"))
  expect_identical(levels(dt$h), c("high","low"))
})

test_that("idempotent when target levels already match for all columns", {

  dt <- data.table::data.table(
    g = factor(c("b","a","b"), levels = c("b","a")),
    h = factor(c("high","low","high"), levels = c("high","low"))
  )

  res <- dt_relevel_col(dt, levels = list(g = c("b","a"), h = c("high","low")))
  expect_identical(levels(res$g), c("b","a"))
  expect_identical(levels(res$h), c("high","low"))
  expect_identical(as.character(res$g), c("b","a","b"))
  expect_identical(as.character(res$h), c("high","low","high"))
})

test_that("errors if a named column in levels is missing in data", {

  dt <- data.table::data.table(g = factor(c("a","b")))

  expect_error(
    dt_relevel_col(dt, levels = list(h = c("a","b"))),
    "Column 'h' not found"
  )
})
