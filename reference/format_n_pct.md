# Format count(s) and percentage(s) (`n (pct%)`)

`format_n_pct()` formats counts (`n`) and respective percentages (`pct`)
as `"n (pct%)"`.

## Usage

``` r
format_n_pct(n, pct, .pct_digits = 1L)
```

## Arguments

- n:

  An integer vector of counts. Length must match that of `pct`.

- pct:

  A numeric vector of percentages. Length must match that of `n`.

- .pct_digits:

  Number of decimal places to format percentage values. Defaults to `1`.

## Value

A character vector of strings following the format `"n (pct%)"`, except
if `n` is zero, then the format is simply `"0"`.

## Examples

``` r
# Simple cases.
format_n_pct(n = 25, pct = 18.66)
#> [1] "25 (18.7%)"
format_n_pct(n = 25, pct = 18.66, .pct_digits = 2)
#> [1] "25 (18.66%)"

# If both `n` and `pct` are zero then the format is special, i.e. simply "0".
format_n_pct(n = 0, pct = 0)
#> [1] "0"

# `format_n_pct()` is vectorised over `n` and `pct` but their length must
# match.
format_n_pct(n = c(20, 50), pct = c(10, 25))
#> [1] "20 (10.0%)" "50 (25.0%)"

# Missing values result in empty strings in the output.
format_n_pct(n = c(20, NA), pct = c(10, 25))
#> [1] "20 (10.0%)" "(25.0%)"   
format_n_pct(n = c(20, 50), pct = c(10, NA))
#> [1] "20 (10.0%)" "50"        
```
