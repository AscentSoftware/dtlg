# Convert a contingency table to a long-format observation-level data frame

`cross_tab_to_obsv_tab()` expands a contingency table or matrix of
counts into a long-format data frame where each row represents one
observation. The output contains one column per dimension of the input,
with repeated rows according to the frequency counts.

## Usage

``` r
cross_tab_to_obsv_tab(cross_tab, strings_as_factors = TRUE)
```

## Arguments

- cross_tab:

  A two-way or multi-way contingency table (`matrix` or `table`) with
  named `dimnames`. Each combination of factor levels is assumed to
  represent a count of occurrences.

- strings_as_factors:

  Should character columns in the output be converted to factors?

## Value

A `data.frame` in long format with one row per implied observation and
one column per dimension of the input table.

## Examples

``` r
dim_names <- list(Sex = c("Male", "Female"),
                  Response = c("Yes", "No"))
cross_tab <- matrix(c(2, 1, 3, 4), nrow = 2, dimnames = dim_names)
cross_tab_to_obsv_tab(cross_tab)
#>       Sex Response
#> 1    Male      Yes
#> 2    Male      Yes
#> 3  Female      Yes
#> 4    Male       No
#> 5    Male       No
#> 6    Male       No
#> 7  Female       No
#> 8  Female       No
#> 9  Female       No
#> 10 Female       No
```
