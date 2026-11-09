#
# Denominator contract of the event helpers and grouped summaries.
#
# Expected values are hand-calculated from the fixtures in
# helper-population.R: three subjects per arm, two subjects per arm with any
# adverse event.
#

# event_count

test_that("`event_count()` rejects event-level data as its own denominator", {
  expect_error(
    event_count(adae6(), "USUBJID", "ARM", "Any AE"),
    "must have one row per patient"
  )
})

test_that("`event_count()` divides by the supplied subject population", {
  res <- event_count(
    adae6(), "USUBJID", "ARM", "Any AE", .total_dt = adsl6()
  )[[1L]]

  expect_identical(res$`Drug A`, "2 (66.7%)")
  expect_identical(res$Placebo, "2 (66.7%)")
})

test_that("`event_count()` keeps subject-level `dt` as default population", {
  res <- event_count(
    adsl6(), "USUBJID", "ARM", "Deaths", .filters = "DTHFL == 'Y'"
  )[[1L]]

  expect_identical(res$Placebo, "1 (33.3%)")
})

test_that("`event_count()` reports counts only when `.total_dt` is NULL", {
  res <- event_count(
    adae6(), "USUBJID", "ARM", "Any AE", .total_dt = NULL
  )[[1L]]

  expect_identical(as.character(res$`Drug A`), "2")
  expect_identical(as.character(res$Placebo), "2")
})

test_that("`event_count()` validates a supplied population", {
  pop <- adsl6()
  pop <- rbind(pop, pop[1L, ])
  expect_error(
    event_count(adae6(), "USUBJID", "ARM", "Any AE", .total_dt = pop),
    r"(duplicated \(e\.g\. "A1"\))"
  )
})

test_that("`event_count()` gives patient incidence on the bundled data", {
  # Without a population this used to return 122 (20.0%) for Drug X:
  # 122 patients divided by the number of AE records.
  expect_error(
    event_count(adae, "USUBJID", "ARM", "Any AE"),
    "must have one row per patient"
  )

  res <- event_count(adae, "USUBJID", "ARM", "Any AE", .total_dt = adsl)[[1L]]
  expect_identical(res$`A: Drug X`, "122 (91.0%)")
})

# multi_event_true

test_that("`multi_event_true()` falls back to `dt` and validates it", {
  expect_error(
    multi_event_true(
      adae6(),
      event_vars = "SER",
      patient = "USUBJID",
      treat = "ARM",
      heading = "Patients with at least one"
    ),
    "must have one row per patient"
  )
})

test_that("`multi_event_true()` uses subject-level `dt` by default", {
  pop <- adsl6()
  pop$DIED <- pop$DTHFL == "Y"

  res <- multi_event_true(
    pop,
    event_vars = "DIED",
    patient = "USUBJID",
    treat = "ARM",
    heading = "Patients who",
    indent = ""
  )[[1L]]

  expect_identical(res$stats, c("Patients who", "DIED"))
  expect_identical(res$Placebo[2L], "1 (33.3%)")
})

test_that("`multi_event_true()` divides by the supplied population", {
  res <- multi_event_true(
    adae6(),
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

# event_count_by

test_that("`event_count_by()` rejects event-level data as denominator", {
  expect_error(
    event_count_by(
      adae6(),
      patient = "USUBJID",
      treat = "ARM",
      rows_by = "AEBODSYS",
      target = "AEDECOD"
    ),
    "must have one row per patient"
  )
})

test_that("`event_count_by()` divides by the supplied population", {
  res <- event_count_by(
    adae6(),
    patient = "USUBJID",
    treat = "ARM",
    rows_by = "AEBODSYS",
    target = "AEDECOD",
    .total_dt = adsl6(),
    indent = ""
  )

  headache <- res[res$stats == "Headache", ]
  expect_identical(headache$`Drug A`, "2 (66.7%)")
  expect_identical(headache$Placebo, "1 (33.3%)")
})

# summary_table_by

by_visit <- function(...) {
  summary_table_by(
    labs6(), # nolint: object_usage_linter. Defined in helper-population.R.
    target = "ANRIND",
    treat = "ARM",
    rows_by = "AVISIT",
    indent = "",
    ...
  )[[1L]]
}

test_that("`summary_table_by()` reports counts only by default", {
  res <- by_visit()

  expect_identical(
    res$stats,
    c("Baseline", "High", "Normal", "Week 4", "High", "Normal")
  )
  expect_identical(
    as.character(res$`Drug A`),
    c("", "1", "2", "", "2", "1")
  )
})

test_that("`summary_table_by()` uses the supplied population in every group", {
  res <- by_visit(.total_dt = adsl6())

  expect_identical(
    res$`Drug A`,
    c("", "1 (33.3%)", "2 (66.7%)", "", "2 (66.7%)", "1 (33.3%)")
  )
  expect_identical(
    res$Placebo,
    c("", "0", "3 (100.0%)", "", "1 (33.3%)", "2 (66.7%)")
  )
})
