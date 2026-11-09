test_that("`multi_event_true()` rejects character and factor flags", {
  ae <- adae6()
  ae$SER <- ifelse(ae$SER, "Y", "N")

  expect_error(
    multi_event_true(
      ae,
      event_vars = "SER",
      patient = "USUBJID",
      treat = "ARM",
      heading = "Patients with at least one",
      .total_dt = adsl6()
    ),
    "`event_vars` must be logical (or numeric 0/1) flags; not: SER.",
    fixed = TRUE
  )

  ae$SER <- factor(ae$SER)
  expect_error(
    multi_event_true(
      ae,
      event_vars = "SER",
      patient = "USUBJID",
      treat = "ARM",
      heading = "Patients with at least one",
      .total_dt = adsl6()
    ),
    "not: SER.",
    fixed = TRUE
  )
})

test_that("`multi_event_true()` accepts numeric 0/1 flags", {
  ae <- adae6()
  ae$SER <- as.integer(ae$SER)

  res <- multi_event_true(
    ae,
    event_vars = "SER",
    patient = "USUBJID",
    treat = "ARM",
    heading = "Patients with at least one",
    .total_dt = adsl6(),
    indent = ""
  )[[1L]]

  expect_identical(res$`Drug A`[2L], "1 (33.3%)")
  expect_identical(res$Placebo[2L], "1 (33.3%)")
})
