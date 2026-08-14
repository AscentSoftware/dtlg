test_that("tern_AET02_table() validates its inputs", {
  expect_error(
    tern_AET02_table(
      adsl = list(),
      adae = aesi,
      patient = "USUBJID",
      treat = "ARM"
    ),
    "is.data.frame(adsl)",
    fixed = TRUE
  )

  expect_error(
    tern_AET02_table(
      adsl = iris,
      adae = aesi,
      patient = "USUBJID",
      treat = "ARM"
    ),
    "all(c(patient, treat) %in% names(adsl))",
    fixed = TRUE
  )

  expect_error(
    tern_AET02_table(
      adsl = adsl,
      adae = iris,
      patient = "USUBJID",
      treat = "ARM"
    ),
    "all(c(patient, treat, target, rows_by) %in% names(adae))",
    fixed = TRUE
  )
})

test_that("tern_AET02_table() creates the expected adverse-event table", {
  tbl <- tern_AET02_table(
    adsl = adsl,
    adae = aesi,
    patient = "USUBJID",
    treat = "ARM",
    target = "AEDECOD",
    rows_by = "AEBODSYS"
  )

  expect_s4_class(tbl, "TableTree")
  expect_named(tbl@col_info@subset_exprs, levels(adsl$ARM))
  expect_gt(nrow(tbl), 0L)
})
