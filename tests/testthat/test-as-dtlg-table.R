test_that("as_dtlg_table() converts a TableTree to a data.table", {
  dt <- data.frame(
    ARM = factor(rep(c("A", "B"), each = 3L)),
    AGE = c(20, 30, NA, 40, 50, 60)
  )

  tt <- tern_summary_table(
    dt,
    target = "AGE",
    treat = "ARM",
    target_name = "Age (years)"
  )

  source <- rtables::as_result_df(
    tt,
    simplify = TRUE,
    keep_label_rows = TRUE,
    data_format = "strings"
  )
  expected_labels <- source$label_name
  expected_labels[is.na(expected_labels)] <- ""

  result <- as_dtlg_table(tt)

  expect_s3_class(result, "data.table")
  expect_identical(names(result)[1L], "stats")
  expect_identical(nrow(result), nrow(source))
  expect_identical(ncol(result), 1L + nlevels(dt$ARM))
  expect_identical(result$stats, expected_labels)
  expect_true(all(vapply(result, is.character, logical(1L))))
})

test_that(
  "as_dtlg_table() replaces missing character values with empty strings", {
  dt <- data.frame(
    ARM = factor(rep(c("A", "B"), each = 3L)),
    AGE = c(20, 30, NA, 40, 50, 60)
  )

  tt <- tern_summary_table(
    dt,
    target = "AGE",
    treat = "ARM",
    target_name = "Age (years)"
  )

  result <- as_dtlg_table(tt)
  character_columns <- vapply(result, is.character, logical(1L))

  expect_false(anyNA(result[, character_columns, with = FALSE]))
})

test_that("as_dtlg_table() supports a custom label-column name", {
  dt <- data.frame(
    ARM = factor(rep(c("A", "B"), each = 3L)),
    AGE = c(20, 30, NA, 40, 50, 60)
  )

  tt <- tern_summary_table(
    dt,
    target = "AGE",
    treat = "ARM",
    target_name = "Age (years)"
  )

  default_result <- as_dtlg_table(tt)
  custom_result <- as_dtlg_table(tt, .label_col = "row_label")

  expect_identical(names(custom_result)[1L], "row_label")
  expect_false("stats" %in% names(custom_result))
  expect_identical(custom_result$row_label, default_result$stats)
  expect_identical(custom_result[, -1L], default_result[, -1L])
})
