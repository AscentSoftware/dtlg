# Generate Non-Breaking Spaces for HTML Output

`nbsp()` generates a string of HTML non-breaking spaces (`&nbsp;`).

## Usage

``` r
nbsp(n = 1L)
```

## Arguments

- n:

  Number of non-breaking spaces. Defaults to `1`.

## Value

A character string containing `n` HTML non-breaking spaces (`&nbsp;`).

## Examples

``` r
# One non-breaking space
nbsp()
#> [1] "&nbsp;"
nbsp(1)
#> [1] "&nbsp;"

# Several non-breaking spaces
nbsp(n = 2)
#> [1] "&nbsp;&nbsp;"
nbsp(n = 5)
#> [1] "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"

# When `n` is zero, an empty string is returned.
nbsp(n = 0)
#> [1] ""
```
