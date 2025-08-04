adsl <- data.frame(
  USUBJID = sprintf("ID-%03d", 1:6),
  ARM = c("A", "A", "B", "B", "C", "C"),
  RACE = c("White", "Black", "White", "White", "Asian", "Asian"),
  FLAG = c(TRUE, FALSE, TRUE, TRUE, NA, FALSE),
  stringsAsFactors = FALSE
)

adsl_total <- data.frame(
  USUBJID = sprintf("ID-%03d", 7:18),
  ARM = rep(c("A", "B", "C"), each = 4),
  RACE = rep(c("White", "Black", "Asian", "Other"), times = 3),
  stringsAsFactors = FALSE
)


test_that("calc_counts() returns a list with a single data.table", {
  out <- calc_counts(dt = adsl, target = "RACE", treat = "ARM", indent = "  ")
  expect_type(out, "list")
  expect_length(out, 1L)
  expect_s3_class(out[[1]], "data.table")
})

test_that("calc_counts() correctly counts and casts values", {
  tbl <- calc_counts(dt = adsl, target = "RACE", treat = "ARM", indent = "")[[1]]
  expect_equal(colnames(tbl), c("stats", "A", "B", "C"))
  expect_equal(tbl[2L, C], "2")  # Asian
  expect_equal(tbl[3L, A], "1")  # Black
  expect_equal(tbl[4L, A], "1")  # White
  expect_equal(tbl[4L, B], "2")  # White
})

test_that("calc_counts() handles .total_dt and percentage formatting", {
  tbl <- calc_counts(dt = adsl, target = "RACE", treat = "ARM",
                     .total_dt = adsl_total, indent = "")[[1]]
  expect_match(tbl[2L, A], "0")
  expect_match(tbl[3L, A], "\\(25.0%\\)")
  expect_match(tbl[4L, B], "\\(50.0%\\)")
})

test_that("calc_counts() applies indentation correctly", {
  indent <- "&nbsp;&nbsp;"
  tbl <- calc_counts(dt = adsl, target = "RACE", treat = "ARM", indent = indent)[[1]]
  expect_true(startsWith(tbl$stats[2], indent))
})

test_that("calc_counts() works with logical variables", {
  tbl <- calc_counts(dt = adsl, target = "FLAG", treat = "ARM", indent = "")[[1]]
  expect_true(all(c("FLAG", "TRUE", "FALSE", "NA") %in% tbl$stats))
})

test_that("calc_counts() fails if `dt` is not a data.frame", {
  non_df_inputs <- list(NULL, 42, "not a data frame", matrix(1:4, nrow = 2), list(a = 1, b = 2))

  for (bad_dt in non_df_inputs) {
    expect_error(calc_counts(
      dt = bad_dt,
      target = "RACE",
      treat = "ARM"
    ))
  }
})

test_that("calc_counts() fails if `.total_dt` is not NULL or a data.frame", {
  bad_total_dt_values <- list(
    42,
    "invalid",
    matrix(1:4, nrow = 2),
    list(a = 1, b = 2),
    TRUE
  )

  for (bad_total_dt in bad_total_dt_values) {
    expect_error(calc_counts(
      dt = data.frame(
        USUBJID = 1:2,
        ARM = c("A", "B"),
        RACE = c("X", "Y")
      ),
      target = "RACE",
      treat = "ARM",
      .total_dt = bad_total_dt
    ))
  }
})

test_that("calc_counts() fails if `target` or `treat` are not scalar strings", {
  valid_dt <- data.frame(
    USUBJID = 1:2,
    ARM = c("A", "B"),
    RACE = c("X", "Y"),
    stringsAsFactors = FALSE
  )

  invalid_inputs <- list(
    NULL,
    42,
    TRUE,
    c("A", "B"),
    character(0),
    list("RACE"),
    factor("RACE")
  )

  for (bad_target in invalid_inputs) {
    expect_error(
      calc_counts(dt = valid_dt, target = bad_target, treat = "ARM"),
      regexp = "is_string\\(target\\)"
    )
  }

  for (bad_treat in invalid_inputs) {
    expect_error(
      calc_counts(dt = valid_dt, target = "RACE", treat = bad_treat),
      regexp = "is_string\\(treat\\)"
    )
  }
})

test_that("calc_counts() fails if `indent` is not a scalar string", {
  valid_dt <- data.frame(
    USUBJID = 1:2,
    ARM = c("A", "B"),
    RACE = c("X", "Y"),
    stringsAsFactors = FALSE
  )

  invalid_indent_values <- list(
    NULL,
    1L,
    TRUE,
    character(0),
    c("&nbsp;", "&nbsp;"),
    list("&nbsp;"),
    factor("&nbsp;")
  )

  for (bad_indent in invalid_indent_values) {
    expect_error(
      calc_counts(dt = valid_dt, target = "RACE", treat = "ARM", indent = bad_indent),
      regexp = "is_string\\(indent\\)"
    )
  }
})

test_that("calc_counts() formats percentages correctly with pct_dec = 0", {

  tbl <- calc_counts(
    dt = adsl,
    target = "RACE",
    treat = "ARM",
    .total_dt = adsl_total,
    pct_dec = 0,
    indent = ""
  )[[1]]

  values <- unlist(tbl[-1, -1, drop = FALSE])
  expect_true(all(detect_n_pct(values, .pct_digits = 0)))
})

test_that("calc_counts() formats percentages correctly with pct_dec = 1", {

  tbl <- calc_counts(
    dt = adsl,
    target = "RACE",
    treat = "ARM",
    .total_dt = adsl_total,
    pct_dec = 1,
    indent = ""
  )[[1]]

  values <- unlist(tbl[-1, -1, drop = FALSE])
  expect_true(all(detect_n_pct(values, .pct_digits = 1)))
})

test_that("calc_counts() formats percentages correctly with pct_dec = 5", {

  tbl <- calc_counts(
    dt = adsl,
    target = "RACE",
    treat = "ARM",
    .total_dt = adsl_total,
    pct_dec = 5,
    indent = ""
  )[[1]]

  values <- unlist(tbl[-1, -1, drop = FALSE])
  expect_true(all(detect_n_pct(values, .pct_digits = 5)))
})
