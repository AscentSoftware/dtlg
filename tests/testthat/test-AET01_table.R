test_that("Input validation of AET01 table creation works as expected", {
  expect_error(
    AET01_table(
      adsl = adsl,
      adae = aesi,
      patient_var = "USUBJID1",
      treat_var = "TRT09A",
      aesi_vars = c("FATAL", "SER")
    ),
    "The following variables are missing in `adsl`: USUBJID1, TRT09A"
  )

  expect_error(
    AET01_table(
      adsl = adsl,
      adae = iris,
      patient_var = "USUBJID",
      treat_var = "TRT01A",
      aesi_vars = c("FATAL", "SER")
    ),
    "The following variables are missing in `adae`: USUBJID, TRT01A"
  )

  expect_error(
    AET01_table(
      adsl = adsl,
      adae = aesi,
      patient_var = "USUBJID",
      treat_var = "TRT01A",
      aesi_vars = NULL
    ),
    "`aesi_vars` must be a non-empty character vector of variable names."
  )

  expect_error(
    AET01_table(
      adsl = adsl,
      adae = aesi,
      patient_var = "USUBJID",
      treat_var = "TRT01A",
      aesi_vars = c("FATALLY", "SER")
    ),
    "The following `aesi_vars` are not found in `adae`: FATALLY"
  )
})

test_that("Able to re-create the AET01 table using data.table", {
  AET01_summary <- AET01_table(
    adsl = adsl,
    adae = aesi,
    patient_var = "USUBJID",
    treat_var = "ARM",
    aesi_vars = c(
      "FATAL", "SER", "SERWD", "SERDSM", "RELSER", "WD", "DSM", "REL", "RELWD", "RELDSM", "SEV"
    )
  )

  expect_s3_class(AET01_summary, "data.table")
  expect_named(AET01_summary, c("stats", levels(adsl$ARM)))
  expect_identical(
    AET01_summary[stats == "Total number of AEs", `A: Drug X`],
    aesi[ARM == "A: Drug X", as.character(.N)]
  )

  expect_identical(
    AET01_summary[endsWith(stats, "Related AE"), `C: Combination`],
    aesi[
      ARM == "C: Combination" & REL == TRUE,
      paste(
        data.table::uniqueN(USUBJID),
        sprintf("(%.1f%%)", data.table::uniqueN(USUBJID) / sum(adsl$ARM == "C: Combination") * 100)
      )
    ]
  )
})
