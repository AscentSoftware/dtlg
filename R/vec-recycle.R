#
# Recycling
#
# A base R replacement for the subset of the vctrs API used by this package:
# `vec_size()`, `vec_size_common()`, `vec_recycle()` and `vec_recycle_common()`.
# The semantics follow vctrs; the deviations are recorded in `vec_recycle()`.
#

#' Number of observations
#'
#' The size of a vector is its number of observations: the number of rows for
#' data frames, matrices and arrays, and the length for every other vector.
#' Size is the unit in which recycling is expressed, and unlike [length()] it
#' is invariant across the columns of a data frame.
#'
#' The size of `NULL` is 0. `NULL` denotes an absent input, and 0 is the
#' identity of sizes under addition.
#'
#' @param x A vector, or `NULL`.
#' @param x_arg Argument name for `x`, used in error messages. An empty string
#'   suppresses the name.
#' @param call Call reported in errors. Defaults to the caller of `vec_size()`.
#'
#' @return A single integer, or a double for long vectors.
#' @noRd
vec_size <- function(x, x_arg = "", call = sys.call(-1L)) {
  if (is.null(x)) {
    return(0L)
  }

  assert_vector(x, x_arg = x_arg, call = call)

  if (is.data.frame(x)) {
    return(.row_names_info(x, type = 2L))
  }

  dimensions <- dim(x)

  if (is.null(dimensions)) {
    length(x)
  } else {
    dimensions[[1L]]
  }
}

#' Common size of several vectors
#'
#' Reduces the sizes of `...` pairwise, from left to right, under the recycling
#' rules: two equal sizes agree, a size of 1 adopts the size of the other input,
#' and anything else is an error. `NULL` inputs are ignored.
#'
#' The reduction is ordered, not a maximum. `vec_size_common(1, integer())` is
#' 0, because the size-1 input adopts the size of the empty one, whereas
#' `vec_size_common(1:2, integer())` is an error.
#'
#' @param ... Vectors, or `NULL`.
#' @param .size Overrides the computed size. Validated and returned unchanged.
#' @param .absent Size returned when `...` is empty or contains only `NULL`.
#'   Validated as a size, so negative and missing sentinels are rejected.
#'   `NULL` makes that case an error.
#' @param .arg Name of the argument holding `...` in the calling function, used
#'   to qualify element names in error messages.
#' @param .call Call reported in errors.
#'
#' @return A single integer, or a double for long vectors.
#' @noRd
vec_size_common <- function(
    ...,
    .size = NULL,
    .absent = 0L,
    .arg = "",
    .call = sys.call(-1L)
) {
  if (!is.null(.size)) {
    return(as_size(.size, arg = ".size", call = .call))
  }

  size <- size_common(list(...), arg = .arg, call = .call)

  if (!is.null(size)) {
    return(size)
  }

  if (is.null(.absent)) {
    stop_vec(
      "`.absent` must be supplied when `...` is empty.",
      class = "vec_error_size",
      call = .call
    )
  }

  as_size(.absent, arg = ".absent", call = .call)
}

#' Recycle a vector to a given size
#'
#' A vector already of `size` is returned unchanged. A vector of size 1 is
#' recycled to `size`, including to size 0. Any other size is an error.
#' `NULL` is returned unchanged.
#'
#' @section Deviations from vctrs:
#'
#' * Attributes survive only as far as `[` preserves them. Classes with a `[`
#'   method (factors, dates, tibbles) round-trip; a bare atomic vector carrying
#'   custom attributes loses them, because base R has no proxy/restore
#'   mechanism.
#' * Recycled data frames are given automatic row names, rather than the
#'   duplicated labels `[.data.frame` would otherwise produce.
#' * A classed list is treated as a vector when it inherits from `"list"` or
#'   defines a `length()` method; otherwise it is rejected as a scalar. vctrs
#'   uses `vec_proxy()` for this test, which is unavailable here.
#'
#' @param x A vector, or `NULL`.
#' @param size Size to recycle to. A single non-negative whole number.
#' @param x_arg Argument name for `x`, used in error messages.
#' @param call Call reported in errors.
#'
#' @return `x` recycled to `size`, or `NULL` if `x` is `NULL`.
#' @noRd
vec_recycle <- function(x, size, x_arg = "", call = sys.call(-1L)) {
  if (is.null(x)) {
    return(NULL)
  }

  size <- as_size(size, arg = "size", call = call)
  recycle_to(x, size, x_arg = x_arg, call = call)
}

#' Recycle vectors to their common size
#'
#' Determines a common size for the supplied vectors and recycles size-one
#' inputs to that size. Inputs with incompatible sizes produce an error.
#'
#' @param ... Vectors to recycle, or `NULL`. Names are preserved.
#' @param .size Optional size to use instead of determining a common size.
#' @param .arg Name of the argument containing `...`, used to qualify argument
#'   names in error messages.
#' @param .call Call reported in errors.
#'
#' @return A list with the same length and names as `...`. Each non-`NULL`
#'   element is recycled to the common size.
#' @noRd
vec_recycle_common <- function(
    ...,
    .size = NULL,
    .arg = "",
    .call = sys.call(-1L)
) {
  xs <- list(...)
  arg_names <- names(xs)

  size <- if (is.null(.size)) {
    size_common(xs, arg = .arg, call = .call)
  } else {
    as_size(.size, arg = ".size", call = .call)
  }

  # Every input was absent or `NULL`; there is no size to recycle to.
  if (is.null(size)) {
    return(xs)
  }

  for (i in seq_along(xs)) {
    if (is.null(xs[[i]])) {
      next
    }

    xs[[i]] <- recycle_to(
      xs[[i]],
      size,
      x_arg = arg_label(arg_names, i, .arg),
      call = .call
    )
  }

  xs
}

#
# Implementation
#

# Returns `NULL` when every input is absent or `NULL`, which the callers
# distinguish from a size of 0.
size_common <- function(xs, arg = "", call = NULL) {
  nms <- names(xs)

  size <- NULL
  # Index of the input that contributed `size`, for error attribution.
  size_i <- 0L

  for (i in seq_along(xs)) {
    x <- xs[[i]]

    if (is.null(x)) {
      next
    }

    x_arg <- arg_label(nms, i, arg)
    n <- vec_size(x, x_arg = x_arg, call = call)

    if (is.null(size) || size == 1L) {
      size <- n
      size_i <- i
      next
    }

    if (n == size || n == 1L) {
      next
    }

    stop_incompatible_size(
      size,
      n,
      arg_label(nms, size_i, arg),
      x_arg,
      call = call
    )
  }

  size
}

recycle_to <- function(x, size, x_arg = "", call = NULL) {
  n <- vec_size(x, x_arg = x_arg, call = call)

  if (n == size) {
    return(x)
  }

  if (n != 1L) {
    stop_recycle_size(n, size, x_arg, call = call)
  }

  recycle_one(x, size)
}

recycle_one <- function(x, size) {
  i <- rep_len(1L, size)

  if (is.data.frame(x)) {
    return(recycle_data_frame(x, i, size))
  }

  d <- dim(x)

  if (is.null(d)) {
    x[i]
  } else {
    recycle_array(x, i, length(d))
  }
}

recycle_data_frame <- function(x, i, size) {
  out <- x[i, , drop = FALSE]
  # `[.data.frame` disambiguates the repeated row label as "1", "1.1", ...
  # Automatic row names keep the result comparable with a natively sized input.
  attr(out, "row.names") <- .set_row_names(size)
  out
}

# Indexes the first dimension and leaves the others missing. `quote = TRUE`
# keeps the empty symbols unevaluated so they arrive at `[` as missing
# arguments.
recycle_array <- function(x, i, n_dim) {
  missing_args <- rep(list(quote(expr = )), n_dim - 1L)
  args <- c(list(x, i), missing_args, list(drop = FALSE))
  do.call(`[`, args, quote = TRUE)
}

#' Is `x` a vector?
#'
#' `NULL`, atomic vectors, bare lists and data frames are vectors. A classed
#' list is a vector when it inherits from `"list"` or defines a `length()`
#' method, the closest base R equivalent of declaring vector semantics.
#' Functions, environments, calls and expressions are not vectors.
#'
#' @param x An object.
#' @return `TRUE` or `FALSE`.
#' @noRd
is_vector <- function(x) {
  if (is.null(x) || is.data.frame(x)) {
    return(TRUE)
  }

  # Checked after `NULL`, which `is.atomic()` reports differently before and
  # after R 4.4.0.
  if (is.atomic(x)) {
    return(TRUE)
  }

  if (!is.list(x)) {
    return(FALSE)
  }

  !is.object(x) || inherits(x, "list") || has_length_method(x)
}

#' Assert that `x` is a vector
#'
#' @inheritParams vec_size
#' @return `x`, invisibly.
#' @noRd
assert_vector <- function(x, x_arg = "", call = sys.call(-1L)) {
  if (!is_vector(x)) {
    stop_scalar_type(x, x_arg, call = call)
  }

  invisible(x)
}

has_length_method <- function(x) {
  for (cls in class(x)) {
    if (!is.null(utils::getS3method("length", cls, optional = TRUE))) {
      return(TRUE)
    }
  }

  FALSE
}

as_size <- function(size, arg = "size", call = NULL) {
  if (!is.numeric(size) || length(size) != 1L || is.na(size)) {
    stop_vec(
      sprintf("%s must be a single number.", fmt_arg(arg)),
      class = "vec_error_size",
      call = call
    )
  }

  if (size < 0 || size != trunc(size)) {
    stop_vec(
      sprintf("%s must be a whole number, zero or greater.", fmt_arg(arg)),
      class = "vec_error_size",
      call = call
    )
  }

  if (size > .Machine$integer.max) {
    stop_vec(
      sprintf("%s is too large; long vectors are not supported.", fmt_arg(arg)),
      class = "vec_error_size",
      call = call
    )
  }

  as.integer(size)
}

#
# Errors
#

stop_vec <- function(message, class, call = NULL, ...) {
  stop(errorCondition(
    message,
    ...,
    class = c(class, "vec_error"),
    call = call
  ))
}

stop_incompatible_size <- function(x_size, y_size, x_arg, y_arg, call = NULL) {
  message <- sprintf(
    "Can't recycle %s (size %s) to match %s (size %s).",
    fmt_arg(x_arg),
    fmt_size(x_size),
    fmt_arg(y_arg),
    fmt_size(y_size)
  )

  stop_vec(
    message,
    class = "vec_error_incompatible_size",
    call = call,
    x_size = x_size,
    y_size = y_size
  )
}

stop_recycle_size <- function(x_size, size, x_arg, call = NULL) {
  message <- if (nzchar(x_arg)) {
    sprintf(
      "Can't recycle %s (size %s) to size %s.",
      fmt_arg(x_arg),
      fmt_size(x_size),
      fmt_size(size)
    )
  } else {
    sprintf(
      "Can't recycle input of size %s to size %s.",
      fmt_size(x_size),
      fmt_size(size)
    )
  }

  stop_vec(
    message,
    class = c("vec_error_recycle_incompatible_size", "vec_error_incompatible_size"),
    call = call,
    x_size = x_size,
    size = size
  )
}

stop_scalar_type <- function(x, x_arg, call = NULL) {
  subject <- if (nzchar(x_arg)) fmt_arg(x_arg) else "Input"

  stop_vec(
    sprintf("%s must be a vector, not %s.", subject, obj_desc(x)),
    class = "vec_error_scalar_type",
    call = call
  )
}

#
# Formatting
#

arg_label <- function(nms, i, arg = "") {
  nm <- if (is.null(nms)) "" else nms[[i]]

  if (is.na(nm) || !nzchar(nm)) {
    nm <- paste0("..", i)
  }

  if (nzchar(arg)) paste0(arg, "$", nm) else nm
}

fmt_arg <- function(arg) {
  sprintf("`%s`", arg)
}

fmt_size <- function(size) {
  format(size, scientific = FALSE, trim = TRUE)
}

obj_desc <- function(x) {
  if (is.function(x)) {
    return("a function")
  }

  if (is.environment(x)) {
    return("an environment")
  }

  if (is.symbol(x) || is.call(x)) {
    return("a call")
  }

  sprintf("a <%s> object", paste0(class(x), collapse = "/"))
}
