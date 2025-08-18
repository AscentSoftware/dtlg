test_that("default semantics is 'reference'", {
  withr::local_options(list(dtlg_dt_copy_semantics = NULL))
  expect_identical(dt_copy_semantics(), "reference")
})

test_that("option state does not leak", {
  withr::local_options(list(dtlg_dt_copy_semantics = "reference"))
  expect_identical(dt_copy_semantics(), "reference")
})


test_that("set_dt_copy_semantics() validates and returns previous value",
          {
            withr::with_options(list(dtlg_dt_copy_semantics = "reference"), {
              old <- set_dt_copy_semantics("value")
              expect_identical(old, "reference")
              expect_identical(dt_copy_semantics(), "value")

              old2 <- set_dt_copy_semantics("reference")
              expect_identical(old2, "value")
              expect_identical(dt_copy_semantics(), "reference")

              expect_error(set_dt_copy_semantics("bogus"))
            })
          })

test_that("maybe_copy_dt() returns a data.table in both modes", {
  df1 <- data.frame(a = 1:3)
  df2 <- data.frame(a = 1:3)

  withr::with_options(list(dtlg_dt_copy_semantics = "reference"), {
    out_ref <- maybe_copy_dt(df1)
    expect_true(data.table::is.data.table(df1))
    expect_true(data.table::is.data.table(out_ref))
  })

  withr::with_options(list(dtlg_dt_copy_semantics = "value"), {
    out_val <- maybe_copy_dt(df2)
    expect_false(data.table::is.data.table(df2))
    expect_true(data.table::is.data.table(out_val))
  })
})

test_that("reference semantics: in-place mutation holds", {
  withr::with_options(list(dtlg_dt_copy_semantics = "reference"), {
    # Case 1: input is already a data.table
    x_dt <- data.table::data.table(a = 1:3)
    y_dt <- maybe_copy_dt(x_dt)
    y_dt[, b := 99L]
    expect_true("b" %in% names(x_dt))
    expect_identical(x_dt$b, rep.int(99L, 3))

    # Case 2: input is a data.frame
    x_df <- data.frame(a = 1:3)
    y2 <- maybe_copy_dt(x_df)
    expect_true(data.table::is.data.table(x_df))   # original mutated in place
    expect_equal(x_df, y2)                         # contents identical
    # but DO NOT test aliasing between x_df and y2
  })
})

test_that("maybe_copy_dt avoids deep copy for regular (non-ALTREP) columns", {
  # Use explicitly materialised vectors (not 1:3)
  df <- data.frame(
    a = as.integer(c(1L, 2L, 3L)),
    b = c("x1", "x2", "x3"),
    stringsAsFactors = FALSE
  )

  addr_a_before <- data.table::address(df$a)
  addr_b_before <- data.table::address(df$b)

  df2 <- maybe_copy_dt(df)

  expect_true(data.table::is.data.table(df2))
  expect_identical(data.table::address(df2$a), addr_a_before)
  expect_identical(data.table::address(df2$b), addr_b_before)
})

test_that("reference semantics: data.table input aliases (:= propagates)", {
  withr::local_options(list(dtlg_dt_copy_semantics = "reference"))
  x <- data.table::data.table(a = 1:3)
  y <- maybe_copy_dt(x)
  y[, b := 9L]
  expect_true("b" %in% names(x))
  expect_identical(x$b, rep.int(9L, 3))
})

test_that("reference semantics: data.frame converts in place (no deep copy of cols)", {
  withr::local_options(list(dtlg_dt_copy_semantics = "reference"))
  df <- data.frame(
    a = as.integer(c(1L, 2L, 3L)),
    b = c("x1", "x2", "x3"),
    stringsAsFactors = FALSE
  )
  a_addr <- data.table::address(df$a)
  b_addr <- data.table::address(df$b)

  res <- maybe_copy_dt(df)

  expect_true(data.table::is.data.table(df))   # caller mutated
  expect_true(data.table::is.data.table(res))  # return is DT
  # same column vectors reused (no deep copy)
  expect_identical(data.table::address(df$a), a_addr)
  expect_identical(data.table::address(df$b), b_addr)
})

test_that("value semantics: always a fresh copy (independent of input type)", {
  withr::local_options(list(dtlg_dt_copy_semantics = "value"))

  # data.table input
  dt <- data.table::data.table(a = 1:3)
  out1 <- maybe_copy_dt(dt)
  expect_true(data.table::is.data.table(out1))
  out1[, b := 1L]
  expect_false("b" %in% names(dt))

  # data.frame input
  df <- data.frame(a = 1:3)
  out2 <- maybe_copy_dt(df)
  expect_true(data.table::is.data.table(out2))
  expect_false(data.table::is.data.table(df))
})

test_that("value semantics: DT input returns a deep copy (pointer differs)", {
  withr::local_options(list(dtlg_dt_copy_semantics = "value"))
  x <- data.table::data.table(a = 1:3)
  addr_before <- data.table::address(x)
  y <- maybe_copy_dt(x)
  expect_false(identical(data.table::address(y), addr_before))
})

test_that("setter/getter semantics lifecycle", {
  withr::local_options(list(dtlg_dt_copy_semantics = "reference"))
  old <- set_dt_copy_semantics("value")
  expect_identical(old, "reference")
  expect_identical(dt_copy_semantics(), "value")
  old2 <- set_dt_copy_semantics("reference")
  expect_identical(old2, "value")
  expect_identical(dt_copy_semantics(), "reference")
  expect_error(set_dt_copy_semantics("bogus"))
})

test_that("invalid option triggers clear error", {
  withr::local_options(list(dtlg_dt_copy_semantics = "neither"))
  expect_error(
    maybe_copy_dt(data.frame(a = 1)),
    "Unknown data.table copy semantics option:.*'reference' or 'value'"
  )
})

test_that("inline expression in reference mode returns DT but cannot mutate caller", {
  withr::local_options(list(dtlg_dt_copy_semantics = "reference"))
  res <- maybe_copy_dt(data.frame(a = 1:3))
  expect_true(data.table::is.data.table(res))
  # no caller symbol exists; just document this behaviour (no expect here)
})

test_that("reference semantics: DT input keeps same pointer", {
  withr::local_options(list(dtlg_dt_copy_semantics = "reference"))
  x <- data.table::data.table(a = 1:3)
  addr_before <- data.table::address(x)
  y <- maybe_copy_dt(x)
  expect_identical(data.table::address(y), addr_before)
})

test_that("idempotency across repeated calls", {
  # reference
  withr::local_options(list(dtlg_dt_copy_semantics = "reference"))
  x <- data.table::data.table(a = 1:3)
  y1 <- maybe_copy_dt(x)
  y2 <- maybe_copy_dt(y1)
  expect_identical(data.table::address(y2), data.table::address(x))

  # value
  withr::local_options(list(dtlg_dt_copy_semantics = "value"))
  x2 <- data.table::data.table(a = 1:3)
  yv1 <- maybe_copy_dt(x2)
  yv2 <- maybe_copy_dt(yv1)
  # second call still returns a fresh copy
  expect_false(identical(data.table::address(yv2), data.table::address(yv1)))
})

test_that("zero-row inputs behave consistently", {
  withr::local_options(list(dtlg_dt_copy_semantics = "reference"))
  df0 <- data.frame(a = integer())
  out_ref <- maybe_copy_dt(df0)
  expect_true(data.table::is.data.table(df0))
  expect_true(data.table::is.data.table(out_ref))
  expect_identical(nrow(out_ref), 0L)

  withr::local_options(list(dtlg_dt_copy_semantics = "value"))
  df0b <- data.frame(a = integer())
  out_val <- maybe_copy_dt(df0b)
  expect_false(data.table::is.data.table(df0b))
  expect_true(data.table::is.data.table(out_val))
  expect_identical(nrow(out_val), 0L)
})

test_that("class and names are preserved/expected", {
  withr::local_options(list(dtlg_dt_copy_semantics = "reference"))
  df <- structure(data.frame(a = 1:3, b = 4:6), my_attr = 1L)
  out <- maybe_copy_dt(df)
  expect_identical(class(out), c("data.table", "data.frame"))
  expect_identical(names(out), c("a", "b"))
})

test_that("reference semantics with inline expr: returns DT, no external mutation", {
  withr::local_options(list(dtlg_dt_copy_semantics = "reference"))
  res <- maybe_copy_dt(data.frame(a = 1:3))
  expect_true(data.table::is.data.table(res))
})
