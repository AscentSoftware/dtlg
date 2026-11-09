#
# Event counts when no record matches. A single arm without events is shown
# as "0" (see the deaths case below), so every arm should be "0" when nothing
# matches at all, in the same layout.
#

test_that("`event_count()` reports zero in every arm when nothing matches", {
  none <- event_count(
    adsl6(), "USUBJID", "ARM", "Deaths", .filters = "DTHFL == 'X'"
  )[[1L]]
  some <- event_count(
    adsl6(), "USUBJID", "ARM", "Deaths", .filters = "DTHFL == 'Y'"
  )[[1L]]

  expect_identical(names(none), names(some))
  expect_identical(vapply(none, typeof, ""), vapply(some, typeof, ""))
  expect_identical(none$stats, "Deaths")
  expect_identical(none$`Drug A`, "0")
  expect_identical(none$Placebo, "0")
})

test_that("`event_count()` keeps factor level order when nothing matches", {
  pop <- adsl6()
  pop$ARM <- factor(pop$ARM, levels = c("Placebo", "Drug A"))

  none <- event_count(
    pop, "USUBJID", "ARM", "Deaths", .filters = "DTHFL == 'X'"
  )[[1L]]
  expect_identical(names(none), c("stats", "Placebo", "Drug A"))
})

test_that("`event_count()` without a population uses the arms of `dt`", {
  none <- event_count(
    adsl6(), "USUBJID", "ARM", "Deaths",
    .filters = "DTHFL == 'X'", .total_dt = NULL
  )[[1L]]

  expect_identical(none$`Drug A`, "0")
  expect_identical(none$Placebo, "0")
})

test_that("`multi_event_true()` reports zero for a flag without events", {
  ae <- adae6()
  ae$SER <- FALSE

  res <- multi_event_true(
    ae,
    event_vars = "SER",
    patient = "USUBJID",
    treat = "ARM",
    heading = "Patients with at least one",
    .total_dt = adsl6(),
    indent = ""
  )[[1L]]

  expect_identical(res$stats, c("Patients with at least one", "SER"))
  expect_identical(res$`Drug A`, c("", "0"))
  expect_identical(res$Placebo, c("", "0"))
})

test_that("`AET01_table()` works for a study without deaths", {
  no_deaths <- as.data.frame(adsl)
  no_deaths$DTHFL <- "N"

  res <- AET01_table(
    adsl = no_deaths,
    adae = aesi,
    patient_var = "USUBJID",
    treat_var = "ARM",
    aesi_vars = c("FATAL", "SER")
  )

  deaths <- unlist(res[res$stats == "Total number of deaths", ])
  expect_identical(unname(deaths[-1L]), rep("0", nlevels(adsl$ARM)))
})
