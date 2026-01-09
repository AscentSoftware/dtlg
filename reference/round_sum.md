# Rounds numbers while preserving the total sum

`round_sum()` rounds a numeric vector of non-negative values to a
specified number of decimal places while ensuring that the sum of the
rounded value remains as close as possible to the original total.

## Usage

``` r
round_sum(x, digits = 0L)
```

## Arguments

- x:

  A numeric vector of non-negative values that you want to round.
  Missing values (`NA`) are ignored.

- digits:

  The number of decimal places to round to. Default is `0` (integer
  rounding).

## Value

A numeric vector of the same length as `x`, with values rounded in such
a way that the total sum is preserved.

## Examples

``` r
# Rounds to integers, preserving the sum of 100.
x <- c(33.3333, 33.3333, 33.3334)
(y <- round_sum(x))
#> [1] 33 33 34
identical(sum(x), sum(y))
#> [1] TRUE

# Rounds to integers, preserving the sum of 1002.
x <- c(100.5, 200.25, 300.75, 400.5)
(y <- round_sum(x))
#> [1] 100 200 301 401
identical(sum(x), sum(y))
#> [1] TRUE

# Rounds to one decimal place, preserving the total sum.
x <- c(12.345, 67.890, 19.765)
(y <- round_sum(x))
#> [1] 12 68 20
identical(sum(x), sum(y))
#> [1] TRUE
```
