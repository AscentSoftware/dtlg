df <- data.frame(
  int_var  = rep(1:6, each = 3)[1:18],
  char_var = rep(c("A", "B", "C"), times = 6),
  fac_var  = factor(
    rep(c("low", "med", "high"), times = 6)[1:18],
    levels = c("low", "med", "high", "very high")  # "very high" unused
  ),
  log_var  = c(TRUE, FALSE, NA, TRUE, FALSE, TRUE,
               FALSE, TRUE, NA, TRUE, TRUE, FALSE,
               FALSE, NA, TRUE, FALSE, TRUE, TRUE)
)

test_that("single group: int_var (default name 'n')", {
  res <- dt_count(df, "int_var")
  expect_s3_class(res, "data.table")
  expect_identical(names(res), c("int_var", "n"))

  expect_equal(res$int_var, 1:6)
  expect_equal(res$n, rep(3L, 6))          # each appears 3 times
  expect_true(is.integer(res$n))
})

test_that("single group: char_var (default name 'n')", {
  res <- dt_count(df, "char_var")

  expect_identical(names(res), c("char_var", "n"))
  expect_equal(res$char_var, c("A", "B", "C"))
  expect_equal(res$n, rep(6L, 3))          # each appears 6 times
})

test_that("single group: fac_var without `.fct_levels = 'used'` excludes unused level", {
  res <- dt_count(df, "fac_var", .fct_levels = "used")

  expect_identical(names(res), c("fac_var", "n"))
  expect_equal(as.character(res$fac_var), c("low", "med", "high")) # no "very high"
  expect_false(any(as.character(res$fac_var) == "very high"))
  expect_equal(sort(res$n), rep(6L, 3))
})

test_that("single group: fac_var with `.fct_levels = 'all'` includes unused level with 0", {
  res <- dt_count(df, "fac_var", .fct_levels = "all")

  expect_identical(names(res), c("fac_var", "n"))
  expect_equal(as.character(res$fac_var), c("low", "med", "high", "very high"))
  expect_true(res[fac_var == "very high", n][[1]] == 0L)
  expect_true(is.integer(res$n))
})

test_that("Enabling NAs to be included in factor counts adds extra 'missing' row to table", {
  # fac_var has no NA observed; .include_na = TRUE should add NA with 0
  res <- dt_count(df, "fac_var", .fct_levels = "all", .include_na = TRUE)

  expect_true(any(is.na(res$fac_var)))
  expect_equal(res[is.na(fac_var), n][[1]], 0L)
})

test_that("single group: log_var includes TRUE, FALSE, and NA counts", {
  res <- dt_count(df, "log_var")

  # Expected counts from df definition:
  # TRUE = 9, FALSE = 6, NA = 3
  expect_equal(res[log_var == TRUE, n][[1]], 9L)
  expect_equal(res[log_var == FALSE, n][[1]], 6L)
  expect_equal(res[is.na(log_var), n][[1]], 3L)
})

test_that("single group: .fct_levels = 'all' with non-factor (int_var) keeps uniques", {
  res1 <- dt_count(df, "int_var", .fct_levels = "all")
  expect_equal(res1$int_var, 1:6)
  expect_false(any(is.na(res1$int_var)))
})

test_that("Enabling NAs to be included in non-factor counts adds extra 'missing' row to table", {
  res2 <- dt_count(df, "int_var", .fct_levels = "all", .include_na = TRUE)
  expect_true(any(is.na(res2$int_var)))
  expect_equal(res2[is.na(int_var), n][[1]], 0L)
})

test_that("single group: custom .name works", {
  res <- dt_count(df, "char_var", .name = "Nobs")
  expect_identical(names(res), c("char_var", "Nobs"))
  expect_true(is.integer(res$Nobs))
})

test_that("single group: renaming grouping variable works", {
  res <- dt_count(df, grp = "int_var")
  expect_identical(names(res), c("grp", "n"))

  expect_equal(res$grp, 1:6)
  expect_equal(res$n, rep(3L, 6))
})

test_that("multi-group: int_var x char_var counts are correct", {
  res <- dt_count(df, "int_var", "char_var")
  # For this construction, each (int, char) appears exactly once
  expect_equal(nrow(res), 18L)
  expect_true(all(res$n == 1L))
})

test_that("multi-group: char_var x fac_var with .fct_levels='all' completes cartesian space", {
  res <- dt_count(df, "char_var", "fac_var", .fct_levels = "all")
  # 3 chars * 4 factor levels = 12 rows
  expect_equal(nrow(res), 12L)

  # Only these pairs are observed in df: (A,low), (B,med), (C,high) — each with 6
  expect_equal(res[char_var == "A" & fac_var == "low", n][[1]], 6L)
  expect_equal(res[char_var == "B" & fac_var == "med", n][[1]], 6L)
  expect_equal(res[char_var == "C" & fac_var == "high", n][[1]], 6L)

  # Unused level 'very high' should be present with 0
  expect_equal(res[fac_var == "very high", n] |> as.integer(), rep(0L, 3))
  expect_true(is.integer(res$n))
})

test_that("multi-group: add NA via .include_na across cartesian space", {
  res <- dt_count(df, "char_var", "fac_var",
                  .fct_levels = "all", .include_na = TRUE)
  # char gains an NA level; factor has 4 levels, plus NA → 4 * 5 = 20
  expect_equal(nrow(res), 20L)
  expect_true(any(is.na(res$char_var)))
  # The NA x fac_var rows should all be zero
  expect_true(all(res[is.na(char_var), n] == 0L))
})

test_that("renaming two grouping variables works", {
  res <- dt_count(df, i = "int_var", f = "fac_var", .fct_levels = "used")
  expect_identical(names(res), c("i", "f", "n"))
  # Only three observed pairs by construction
  expect_equal(nrow(res), 18L)  # 6 ints * 3 used fac levels = 18 rows
})

test_that("error on non-existent columns", {
  expect_error(dt_count(df, "no_such_col"), regexp = "no_such_col")
})

test_that("defensive: duplicate grouping columns should error", {
  # If you decide to support this, change this test; for now, expect error.
  expect_error(dt_count(df, "int_var", a = "int_var"))
})

test_that(".name collision with existing column is handled", {
  # Decide your policy. If you want to forbid, change dt_count to check and stop().
  # Here we expect an error to be safer.
  expect_error(dt_count(df, "char_var", .name = "char_var"))
})

test_that(".include_na does not duplicate NA rows when NA already present", {
  # log_var already has NA; .include_na should not create a second NA row
  res1 <- dt_count(df, "log_var")
  res2 <- dt_count(df, "log_var", .include_na = TRUE)
  n_na1 <- res1[is.na(log_var), n][[1]]
  n_na2 <- res2[is.na(log_var), n][[1]]
  expect_equal(n_na1, 3L)
  expect_equal(n_na2, 3L)
})

test_that("zeros introduced by completion remain integer", {
  res <- dt_count(df, "fac_var", .fct_levels = "all", .include_na = TRUE)
  expect_true(is.integer(res$n))
  expect_true(all(res[fac_var == "very high" | is.na(fac_var), n] == 0L))
})

test_that("non-factors: Inf and NaN are retained; NaN treated as NA in sort()", {
  df2 <- data.frame(x = c(1, Inf, NaN, 1))
  res <- dt_count(df2, "x", .fct_levels = "all", .include_na = TRUE)
  # Expect rows for 1, Inf, and NA (NaN merges into NA via sort/unique semantics)
  expect_true(all(c(1, Inf) %in% res$x))
  expect_true(any(is.na(res$x)))
})
