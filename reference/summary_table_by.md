# Create a summary table using multiple rows for grouping on one target column

Create a summary table using multiple rows for grouping on one target
column

## Usage

``` r
summary_table_by(
  dt,
  target,
  treat,
  rows_by,
  indent = nbsp(n = 4L),
  .total_dt = dt,
  pct_dec = 1,
  treat_order = NULL,
  skip_absent = TRUE
)
```

## Arguments

- dt:

  A `data.frame` containing, at least, the variables indicated in
  `target` and `treat`.

- target:

  Target variable passed as a string for which summary statistics are to
  be calculated.

- treat:

  A string indicating the grouping variable, e.g. the variable
  specifying the treatment population.

- rows_by:

  string, grouping variable to split events by.

- indent:

  A string to be used as indentation of summary statistics labels.
  Defaults to four HTML non-breaking spaces (`&nbsp;`).

- .total_dt:

  Separate table from `dt` from which to derive total counts per group.

- pct_dec:

  Decimal places for reported figures.

- treat_order:

  Customise the column order of the output table.

- skip_absent:

  Whether to ignore variables passed in `treat_order` that are absent
  from `dt`. Default is `TRUE`; `FALSE` will throw an error in case
  there are missing variables.

## Value

The same output as
[`summary_table()`](https://AscentSoftware.github.io/dtlg/reference/summary_table.md)
except that folded by variables indicated in `rows_by`.

## Examples

``` r
summary_table_by(adlb, target = "AVAL", treat = "ARM", rows_by = c("PARAM","AVISIT"))
#> [[1]]
#>                                                          stats  A: Drug X
#>                                                         <char>     <char>
#>   1:                      Alanine Aminotransferase Measurement       <NA>
#>   2:                         &nbsp;&nbsp;&nbsp;&nbsp;SCREENING           
#>   3:         &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;n        134
#>   4: &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Mean (SD) 18.2 (8.5)
#>   5:    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Median       17.6
#>  ---                                                                     
#> 125:         &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;n        134
#> 126: &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Mean (SD)  2.9 (0.1)
#> 127:    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Median        2.9
#> 128:  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Min, Max   2.6, 3.1
#> 129:   &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Missing          0
#>      B: Placebo C: Combination
#>          <char>         <char>
#>   1:       <NA>           <NA>
#>   2:                          
#>   3:        134            132
#>   4: 19.3 (9.8)     18.5 (9.1)
#>   5:       18.1           17.6
#>  ---                          
#> 125:        134            132
#> 126:  2.9 (0.1)      2.9 (0.1)
#> 127:        2.9            2.9
#> 128:   2.6, 3.1       2.6, 3.1
#> 129:          0              0
#> 
```
