test_that("label() returns NULL for an unlabelled object", {
  expect_null(label(1:3))
})

test_that("with_label() assigns a label retrievable by label()", {
  x <- c(first = 1, second = 2)
  result <- with_label(x, "Example label")

  expect_identical(label(result), "Example label")
  expect_identical(
    result,
    structure(x, label = "Example label")
  )
})

test_that("with_label() does not modify the original object", {
  x <- 1:3
  result <- with_label(x, "Example label")

  expect_null(label(x))
  expect_identical(label(result), "Example label")
})

test_that("with_label() replaces an existing label", {
  result <- 1:3 |>
    with_label("Original label") |>
    with_label("Replacement label")

  expect_identical(label(result), "Replacement label")
})

test_that("with_label() requires a non-missing scalar string", {
  invalid_labels <- list(
    NULL,
    character(),
    NA_character_,
    c("First", "Second"),
    1,
    TRUE,
    factor("Label"),
    list("Label")
  )

  for (invalid_label in invalid_labels) {
    expect_error(
      with_label(1:3, invalid_label),
      "is_string\\(label\\)"
    )
  }
})
