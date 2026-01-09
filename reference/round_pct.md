# Rounded percentage

`round_pct()` returns the rounded percentages of `x` values.

## Usage

``` r
round_pct(x, digits = 1L, method = c("round", "round_sum"))
```

## Arguments

- x:

  A numeric vector of non-negative values for which you want percentages
  to be determined and rounded. Missing values (`NA`) are ignored.

- digits:

  The number of decimal places to round to. Default is `0` (integer
  rounding).

- method:

  Rounding method: `"round"` that uses R's base
  [`round()`](https://rdrr.io/r/base/Round.html) or `"round_sum"` that
  uses
  [dtlg::round_sum](https://AscentSoftware.github.io/dtlg/reference/round_sum.md).

## Value

A numeric vector of the same length as `x` with rounded percentages.

## Examples

``` r
x <- c(1 / 3, 1 / 3, 1 / 3)

# Default method ensures precise rounding but total might not be 100%.
round_pct(x = x)
#> [1] 33.3 33.3 33.3
sum(round_pct(x = x))
#> [1] 99.9

# You can trade off rounding precision for precision on the total with the
# method `"round_sum"`.
round_pct(x = x, method = "round_sum")
#> [1] 33.3 33.3 33.4
sum(round_pct(x = x, method = "round_sum"))
#> [1] 100

# Vary the number of decimal places, e.g. increase to three.
round_pct(x = x, digits = 3, method = "round_sum")
#> [1] 33.333 33.333 33.334

# Missing values are ignored.
x <- c(1, 2, NA)
round_pct(x = x, digits = 3)
#> [1] 33.333 66.667     NA
```
