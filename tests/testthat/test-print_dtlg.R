print_dtlg_data <- data.frame(
  label = c("Alpha", "Beta"),
  value = c(10L, 20L)
)

test_that("print_dtlg() invisibly returns a data.table", {
  output <- capture.output(
    result <- withVisible(print_dtlg(print_dtlg_data))
  )

  expect_false(result$visible)
  expect_s3_class(result$value, "data.table")
  expect_identical(as.data.frame(result$value), print_dtlg_data)
  expect_length(output, 3L)
})

test_that("print_dtlg() controls row names and class annotations", {
  default_output <- capture.output(
    print_dtlg(print_dtlg_data)
  )
  detailed_output <- capture.output(
    print_dtlg(
      print_dtlg_data,
      row.names = TRUE,
      class = TRUE
    )
  )

  expect_false(any(grepl("^\\s*1:", default_output)))
  expect_true(any(grepl("^\\s*1:", detailed_output)))
  expect_false(any(grepl("<int>", default_output, fixed = TRUE)))
  expect_true(any(grepl("<int>", detailed_output, fixed = TRUE)))
})

test_that("print_dtlg() supports documented column justification", {
  justify_values <- c("left", "right", "centre", "none")

  for (justify in justify_values) {
    expect_no_error(
      capture.output(
        print_dtlg(print_dtlg_data, justify = justify)
      )
    )
  }
})

test_that("print_dtlg() forwards the row limit", {
  dt <- data.frame(value = sprintf("row-%02d", 1:20))

  output <- capture.output(
    print_dtlg(dt, nrows = 2L)
  )

  expect_true(any(grepl("row-01", output, fixed = TRUE)))
  expect_true(any(grepl("row-20", output, fixed = TRUE)))
  expect_false(any(grepl("row-10", output, fixed = TRUE)))
})
