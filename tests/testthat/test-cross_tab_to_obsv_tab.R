test_that("cross_tab_to_obsv_tab() expands contingency-table counts", {
  dim_names <- list(
    Sex = c("Male", "Female"),
    Response = c("Yes", "No")
  )
  cross_tab <- matrix(
    c(2L, 1L, 3L, 0L),
    nrow = 2L,
    dimnames = dim_names
  )

  result <- cross_tab_to_obsv_tab(
    cross_tab,
    strings_as_factors = FALSE
  )

  expected <- data.frame(
    Sex = c("Male", "Male", "Female", "Male", "Male", "Male"),
    Response = c("Yes", "Yes", "Yes", "No", "No", "No")
  )

  expect_s3_class(result, "data.frame")
  expect_named(result, names(dim_names))
  expect_identical(result, expected)
})

test_that("cross_tab_to_obsv_tab() supports factors and table inputs", {
  cross_tab <- table(
    Group = c("A", "A", "B"),
    Outcome = c("Yes", "No", "Yes")
  )

  result <- cross_tab_to_obsv_tab(
    cross_tab,
    strings_as_factors = TRUE
  )

  expect_s3_class(result$Group, "factor")
  expect_s3_class(result$Outcome, "factor")
  expect_identical(nrow(result), sum(cross_tab))
  expect_identical(
    unname(table(result$Group, result$Outcome)),
    unname(cross_tab)
  )
})

test_that("cross_tab_to_obsv_tab() rejects unsupported inputs", {
  invalid_inputs <- list(NULL, 1:3, data.frame(x = 1:3), list(x = 1:3))

  for (input in invalid_inputs) {
    expect_error(cross_tab_to_obsv_tab(input),
                 "Input must be a matrix or a table.",
                 fixed = TRUE)
  }
})
