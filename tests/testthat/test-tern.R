test_that("DMT01 Demographics Table can be replicated using tern functions", {
  dmg_vars <- c("AGE", "RACE", "ETHNIC")
  dmg_var_lbls <- c("Age (yr)", "Race", "Ethnicity")

  # Demographics table (DMT01)
  dmt_01 <- tern_summary_table(
    adsl,
    target = dmg_vars,
    treat = "ARM",
    target_name = dmg_var_lbls
  )

  expect_s4_class(dmt_01, "TableTree")
  expect_named(dmt_01@children, dmg_vars)
  expect_named(dmt_01@col_info@subset_exprs, levels(adsl$ARM))
})
