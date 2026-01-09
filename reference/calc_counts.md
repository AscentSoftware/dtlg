# Calculate counts of a categorical variable

`calc_counts()` counts observations of a categorical variable (`target`)
by another (`treat`) and reports summary statistics in clinical trial
reporting format.

## Usage

``` r
calc_counts(
  dt,
  target,
  target_name = target,
  treat,
  indent = nbsp(n = 4L),
  .total_dt = NULL,
  pct_dec = 1
)
```

## Arguments

- dt:

  A `data.frame` containing, at least, the variables indicated in
  `target` and `treat`.

- target:

  Target variable passed as a string for which summary statistics are to
  be calculated.

- target_name:

  Heading for the target variable as a string. Defaults to `target`.

- treat:

  A string indicating the grouping variable, e.g. the variable
  specifying the treatment population.

- indent:

  A string to be used as indentation of summary statistics labels.
  Defaults to four HTML non-breaking spaces (`&nbsp;`).

- .total_dt:

  Separate table from `dt` from which to derive total counts per group.

- pct_dec:

  This argument is ignored, and is only kept for backward compatibility
  reasons.

## Value

A list containing a `data.table` formatted as follows:

- First column is named `stats` and contains the target variable name
  indicated in `target` in the first row. Subsequent rows contain the
  levels of `target`.

- Other columns are for the levels of the grouping variable (`treat`).

- All columns are of character type.

This table is structured for easy integration with Shiny output widgets.

## Examples

``` r
calc_counts(dt = adsl, "RACE", treat = "ARM", indent = "  ")[[1]]
#>                                          stats A: Drug X B: Placebo
#>                                         <char>    <char>     <char>
#> 1:                                        RACE                     
#> 2:            AMERICAN INDIAN OR ALASKA NATIVE         8         11
#> 3:                                       ASIAN        68         67
#> 4:                   BLACK OR AFRICAN AMERICAN        31         28
#> 5:                                    MULTIPLE         0          1
#> 6:   NATIVE HAWAIIAN OR OTHER PACIFIC ISLANDER         0          1
#> 7:                                       OTHER         0          0
#> 8:                                     UNKNOWN         0          0
#> 9:                                       WHITE        27         26
#>    C: Combination
#>            <char>
#> 1:               
#> 2:              6
#> 3:             73
#> 4:             32
#> 5:              0
#> 6:              0
#> 7:              0
#> 8:              0
#> 9:             21
```
