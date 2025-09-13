#
# `dt`: dummy dataset of three variables (USUBJID, ARM, DTHFL) and 60 subjects
# (observations).
#
DTHFL_Y <- c(18L, 6L, 6L)
DTHFL_N <- c(0L, 6L, 24L)
dim_names <- list(ARM = LETTERS[1:3], DTHFL = c("Y", "N"))
ARM_DTHFL_table <- matrix(c(DTHFL_Y, DTHFL_N), nrow = 3, dimnames = dim_names)

dt <- cross_tab_to_obsv_tab(ARM_DTHFL_table)
dt[["USUBJID"]] <- sprintf("id-%03d", seq_len(nrow(dt)))
dt <- dt[c("USUBJID", "ARM", "DTHFL")]

#
# Tests
#
test_that("`event_count()` can count deaths", {

  sum_stat_tbl_lst <- event_count(
    dt = dt,
    patient = "USUBJID",
    treat = "ARM",
    label = "Deaths",
    .filters = "DTHFL == 'Y'"
  )
  sum_stat_tbl <- sum_stat_tbl_lst[[1L]]

  #
  # Basic assertions on the wrapping list
  #
  expect_equal(class(sum_stat_tbl_lst), "list")
  expect_equal(typeof(sum_stat_tbl_lst), "list")
  expect_equal(length(sum_stat_tbl_lst), 1L)

  #
  # Basic assertions on the data.table within
  #
  expect_s3_class(sum_stat_tbl, "data.table")
  expect_equal(typeof(sum_stat_tbl), "list")
  expect_equal(colnames(sum_stat_tbl), c("stats", dim_names$ARM))

  # Assertions on data.table's contents
  expect_equal(sum_stat_tbl$stats[1L], "Deaths")
  expect_equal(sum_stat_tbl$A[1L], "18 (100.0%)")
  expect_equal(sum_stat_tbl$B[1L], "6 (50.0%)")
  expect_equal(sum_stat_tbl$C[1L], "6 (20.0%)")
})

test_that("`event_count()` can count lives", {

  sum_stat_tbl_lst <- event_count(
    dt = dt,
    patient = "USUBJID",
    treat = "ARM",
    label = "Lives",
    .filters = "DTHFL == 'N'"
  )
  sum_stat_tbl <- sum_stat_tbl_lst[[1L]]

  #
  # Basic assertions on the wrapping list
  #
  expect_equal(class(sum_stat_tbl_lst), "list")
  expect_equal(typeof(sum_stat_tbl_lst), "list")
  expect_equal(length(sum_stat_tbl_lst), 1L)

  #
  # Basic assertions on the data.table within
  #
  expect_s3_class(sum_stat_tbl, "data.table")
  expect_equal(typeof(sum_stat_tbl), "list")
  expect_equal(colnames(sum_stat_tbl), c("stats", dim_names$ARM))

  # Assertions on data.table's contents
  expect_equal(sum_stat_tbl$stats[1L], "Lives")
  expect_equal(sum_stat_tbl$A[1L], "0")
  expect_equal(sum_stat_tbl$B[1L], "6 (50.0%)")
  expect_equal(sum_stat_tbl$C[1L], "24 (80.0%)")
})
