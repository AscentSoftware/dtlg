test_that("`assert_subject_population()` returns valid input invisibly", {
  pop <- adsl6()
  expect_invisible(assert_subject_population(pop, "USUBJID", "ARM"))
  expect_identical(assert_subject_population(pop, "USUBJID", "ARM"), pop)
})

test_that("`assert_subject_population()` accepts zero rows and factor IDs", {
  empty <- adsl6()[0L, ]
  expect_identical(assert_subject_population(empty, "USUBJID", "ARM"), empty)

  pop <- adsl6()
  pop$USUBJID <- factor(pop$USUBJID)
  expect_identical(assert_subject_population(pop, "USUBJID", "ARM"), pop)
})

test_that("`assert_subject_population()` rejects repeated patients", {
  expect_error(
    assert_subject_population(adae6(), "USUBJID", "ARM"),
    r"(one row per patient, but 'USUBJID' is duplicated \(e\.g\. "A1"\))"
  )
})

test_that("`assert_subject_population()` reports patients under two arms", {
  pop <- adsl6()
  pop <- rbind(pop, data.frame(USUBJID = "A1", ARM = "Placebo", DTHFL = "N"))
  expect_error(
    assert_subject_population(pop, "USUBJID", "ARM"),
    r"("A1" appears under "Drug A" and "Placebo")"
  )
})

test_that("`assert_subject_population()` rejects missing patient IDs", {
  pop <- adsl6()
  pop$USUBJID[2L] <- NA
  expect_error(
    assert_subject_population(pop, "USUBJID", "ARM"),
    "has missing values in 'USUBJID'",
    fixed = TRUE
  )
})

test_that("`assert_subject_population()` requires its columns", {
  expect_error(
    assert_subject_population(adsl6(), "SUBJID", "ARM"),
    "must contain the column(s) 'SUBJID'",
    fixed = TRUE
  )
})

test_that("`assert_subject_population()` names the supplied argument", {
  expect_error(
    assert_subject_population(adae6(), "USUBJID", "ARM", arg = "dt"),
    "^`dt` must have one row per patient"
  )
})
