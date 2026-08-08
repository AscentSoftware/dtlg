test_that("Input validation of AET02 table creation works as expected", {
  expect_error(
    AET02_table(
      adsl = adsl,
      adae = iris,
      patient = "USUBJID",
      treat = "ARM"
    )
  )

  expect_error(
    AET02_table(
      adsl = iris,
      adae = aesi,
      patient = "USUBJID",
      treat = "ARM"
    )
  )

  expect_error(
    AET02_table(
      adsl = adsl,
      adae = aesi,
      patient = "USUBJID",
      treat = "ARM",
      target = "UNKNOWN"
    )
  )

  expect_error(
    AET02_table(
      adsl = adsl,
      adae = aesi,
      patient = "USUBJID",
      treat = "ARM",
      rows_by = "UNKNOWN"
    )
  )
})

test_that("Able to create the AET02 table using data.table", {
  indent <- "  "

  AET02_summary <- AET02_table(
    adsl = adsl,
    adae = aesi,
    patient = "USUBJID",
    treat = "ARM",
    target = "AEDECOD",
    rows_by = "AEBODSYS",
    indent = indent
  )

  expect_s3_class(AET02_summary, "data.table")
  expect_named(AET02_summary, c("stats", levels(adsl$ARM)))

  arm <- as.character(aesi$ARM[[1L]])
  n_patients <- data.table::uniqueN(aesi$USUBJID[aesi$ARM == arm])
  total_patients <- sum(adsl$ARM == arm)
  patient_value <- AET02_summary[
    stats == "Total number of patients with at least one AE"
  ][[arm]]

  expect_true(detect_fmt(patient_value, n_pct_fmt(n = 1L)))
  expect_identical(
    patient_value,
    paste(n_patients, sprintf("(%.1f%%)", 100 * n_patients / total_patients))
  )

  expect_identical(
    AET02_summary[stats == "Total number of AEs"][[arm]],
    as.character(sum(aesi$ARM == arm))
  )

  event_index <- which(!is.na(aesi$AEBODSYS) & !is.na(aesi$AEDECOD))[1L]
  soc <- as.character(aesi$AEBODSYS[[event_index]])
  term <- as.character(aesi$AEDECOD[[event_index]])
  arm <- as.character(aesi$ARM[[event_index]])

  soc_row <- which(AET02_summary$stats == soc)
  term_row <- which(
    seq_len(nrow(AET02_summary)) > soc_row &
      AET02_summary$stats == paste0(indent, term)
  )[1L]

  n_events <- sum(
    aesi$AEBODSYS == soc &
      aesi$AEDECOD == term &
      aesi$ARM == arm,
    na.rm = TRUE
  )
  term_value <- AET02_summary[[arm]][term_row]

  expect_true(detect_fmt(term_value, n_pct_fmt(n = 1L)))
  expect_identical(
    term_value,
    paste(
      n_events,
      sprintf("(%.1f%%)", 100 * n_events / sum(adsl$ARM == arm))
    )
  )
})
