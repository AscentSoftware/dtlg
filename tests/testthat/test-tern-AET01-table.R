test_that("tern AET01 input validation works as expected", {
  expect_invisible(
    assert_tern_aet01_table_inputs(
      adsl = adsl,
      adae = aesi,
      patient_var = "USUBJID",
      treat_var = "ARM",
      aesi_vars = c("FATAL", "SER")
    )
  )

  expect_error(
    assert_tern_aet01_table_inputs(
      adsl = list(),
      adae = aesi,
      patient_var = "USUBJID",
      treat_var = "ARM",
      aesi_vars = c("FATAL", "SER")
    ),
    "is.data.frame(adsl)",
    fixed = TRUE
  )

  expect_error(
    assert_tern_aet01_table_inputs(
      adsl = adsl,
      adae = aesi,
      patient_var = "USUBJID1",
      treat_var = "TRT09A",
      aesi_vars = c("FATAL", "SER")
    ),
    "The following variables are missing in `adsl`: USUBJID1, TRT09A"
  )

  expect_error(
    assert_tern_aet01_table_inputs(
      adsl = adsl,
      adae = iris,
      patient_var = "USUBJID",
      treat_var = "ARM",
      aesi_vars = c("FATAL", "SER")
    ),
    "The following variables are missing in `adae`: USUBJID, ARM"
  )

  expect_error(
    assert_tern_aet01_table_inputs(
      adsl = adsl,
      adae = aesi,
      patient_var = "USUBJID",
      treat_var = "ARM",
      aesi_vars = NULL
    ),
    "`aesi_vars` must be a non-empty character vector.",
    fixed = TRUE
  )

  expect_error(
    assert_tern_aet01_table_inputs(
      adsl = adsl,
      adae = aesi,
      patient_var = "USUBJID",
      treat_var = "ARM",
      aesi_vars = c("FATALLY", "SER")
    ),
    "The following `aesi_vars` are not in `adae`: FATALLY",
    fixed = TRUE
  )
})

test_that("tern_AET01_adsl_layout() builds the expected subject layout", {
  lyt <- tern_AET01_adsl_layout(
    patient_var = "USUBJID",
    treat_var = "ARM"
  )
  tbl <- rtables::build_table(
    lyt,
    df = adsl,
    alt_counts_df = adsl
  )

  expect_s4_class(lyt, "PreDataTableLayouts")
  expect_s4_class(tbl, "TableTree")
  expect_named(tbl@col_info@subset_exprs, levels(adsl$ARM))
  expect_identical(nrow(tbl), 2L)
})

test_that("tern_AET01_adae_layout() builds the expected adverse-event layout", {
  aesi_vars <- c("FATAL", "SER")
  aesi_labels <- c(
    FATAL = "AE with fatal outcome",
    SER = "Serious AE"
  )
  aesi_heading <- "Total number of patients with at least one"

  lyt <- tern_AET01_adae_layout(
    patient_var = "USUBJID",
    treat_var = "ARM",
    aesi_vars = aesi_vars,
    aesi_labels = aesi_labels,
    aesi_heading = aesi_heading
  )
  tbl <- rtables::build_table(
    lyt,
    df = aesi,
    alt_counts_df = adsl
  )

  expect_s4_class(lyt, "PreDataTableLayouts")
  expect_s4_class(tbl, "TableTree")
  expect_named(tbl@col_info@subset_exprs, levels(adsl$ARM))
  expect_identical(nrow(tbl), 3L + length(aesi_vars))
})

test_that("tern_AET01_table() creates the expected safety table", {
  aesi_vars <- c("FATAL", "SER")

  tbl <- tern_AET01_table(
    adsl = adsl,
    adae = aesi,
    patient_var = "USUBJID",
    treat_var = "ARM",
    aesi_vars = aesi_vars
  )

  expect_s4_class(tbl, "TableTree")
  expect_named(tbl@col_info@subset_exprs, levels(adsl$ARM))
  expect_identical(nrow(tbl), 5L + length(aesi_vars))
})
