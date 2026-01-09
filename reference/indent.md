# Add indentation to strings

`indent()` prefixes a string with a sequence of HTML non-breaking
spaces, to effectively work as indentation.

## Usage

``` r
indent(x, n = 4L, indentation = nbsp(n = n))
```

## Arguments

- x:

  A character vector of strings to be *indented*.

- n:

  Number of non-breaking spaces to use as indentation. If `n = 0` then
  no indentation is performed.

- indentation:

  As an alternative to the number of spaces `n` you may pass the actual
  sequence of HTML non-breaking spaces as a string to this parameter, or
  any other string for that matter. Defaults to an indentation of four
  spaces (`n = 4`).

## Value

A character vector of the same length as `x`.

## Examples

``` r
# Default is to indent by four non-breaking spaces.
indent("Mean")
#> [1] "&nbsp;&nbsp;&nbsp;&nbsp;Mean"

# Choose a different indentation level.
indent("Mean", n = 2L)
#> [1] "&nbsp;&nbsp;Mean"

# `indent()` is vectorised over `x`
indent(c("Mean", "Median", "Max, Min", "Missing"))
#> [1] "&nbsp;&nbsp;&nbsp;&nbsp;Mean"     "&nbsp;&nbsp;&nbsp;&nbsp;Median"  
#> [3] "&nbsp;&nbsp;&nbsp;&nbsp;Max, Min" "&nbsp;&nbsp;&nbsp;&nbsp;Missing" 
```
