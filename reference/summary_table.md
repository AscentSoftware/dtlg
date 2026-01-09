# Summary Table

`summary_table()` summarises clinical variables into a report table
using `data.table` as backend.

## Usage

``` r
summary_table(
  dt,
  target,
  treat,
  target_name = target,
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

- target_name:

  Heading for the target variable as a string. Defaults to `target`.

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

A `data.table` of summary statistics. The format depends on the type of
the `target` variable:

- If the `target` variable is categorical, i.e. type `character`,
  `factor` or `logical` then the output is that of
  [`calc_counts()`](https://AscentSoftware.github.io/dtlg/reference/calc_counts.md).

- If the `target` variable is numeric, then the output is that of
  [`calc_desc()`](https://AscentSoftware.github.io/dtlg/reference/calc_desc.md).

## See also

[`tern_summary_table()`](https://AscentSoftware.github.io/dtlg/reference/tern_summary_table.md)

## Examples

``` r
dmg_vars <- c("AGE", "RACE", "ETHNIC")
dmg_var_lbls <- c("Age (yr)", "Race", "Ethnicity")

# Demographics table (DMT01)
summary_table(
  adsl,
  target = dmg_vars,
  treat = 'ARM',
  target_name = dmg_var_lbls
)
#>                                                                 stats
#>                                                                <char>
#>  1:                                                          Age (yr)
#>  2:                                         &nbsp;&nbsp;&nbsp;&nbsp;n
#>  3:                                 &nbsp;&nbsp;&nbsp;&nbsp;Mean (SD)
#>  4:                                    &nbsp;&nbsp;&nbsp;&nbsp;Median
#>  5:                                  &nbsp;&nbsp;&nbsp;&nbsp;Min, Max
#>  6:                                   &nbsp;&nbsp;&nbsp;&nbsp;Missing
#>  7:                                                              Race
#>  8:          &nbsp;&nbsp;&nbsp;&nbsp;AMERICAN INDIAN OR ALASKA NATIVE
#>  9:                                     &nbsp;&nbsp;&nbsp;&nbsp;ASIAN
#> 10:                 &nbsp;&nbsp;&nbsp;&nbsp;BLACK OR AFRICAN AMERICAN
#> 11:                                  &nbsp;&nbsp;&nbsp;&nbsp;MULTIPLE
#> 12: &nbsp;&nbsp;&nbsp;&nbsp;NATIVE HAWAIIAN OR OTHER PACIFIC ISLANDER
#> 13:                                     &nbsp;&nbsp;&nbsp;&nbsp;OTHER
#> 14:                                   &nbsp;&nbsp;&nbsp;&nbsp;UNKNOWN
#> 15:                                     &nbsp;&nbsp;&nbsp;&nbsp;WHITE
#> 16:                                                         Ethnicity
#> 17:                        &nbsp;&nbsp;&nbsp;&nbsp;HISPANIC OR LATINO
#> 18:                    &nbsp;&nbsp;&nbsp;&nbsp;NOT HISPANIC OR LATINO
#> 19:                              &nbsp;&nbsp;&nbsp;&nbsp;NOT REPORTED
#> 20:                                   &nbsp;&nbsp;&nbsp;&nbsp;UNKNOWN
#>                                                                 stats
#>                                                                <char>
#>       A: Drug X  B: Placebo C: Combination
#>          <char>      <char>         <char>
#>  1:                                       
#>  2:         134         134            132
#>  3:  33.8 (6.6)  35.4 (7.9)     35.4 (7.7)
#>  4:          33          35             35
#>  5:  21.0, 50.0  21.0, 62.0     20.0, 69.0
#>  6:           0           0              0
#>  7:                                       
#>  8:    8 (6.0%)   11 (8.2%)       6 (4.5%)
#>  9:  68 (50.7%)  67 (50.0%)     73 (55.3%)
#> 10:  31 (23.1%)  28 (20.9%)     32 (24.2%)
#> 11:           0    1 (0.7%)              0
#> 12:           0    1 (0.7%)              0
#> 13:           0           0              0
#> 14:           0           0              0
#> 15:  27 (20.1%)  26 (19.4%)     21 (15.9%)
#> 16:                                       
#> 17:  15 (11.2%)  18 (13.4%)     15 (11.4%)
#> 18: 104 (77.6%) 103 (76.9%)    101 (76.5%)
#> 19:    6 (4.5%)   10 (7.5%)      11 (8.3%)
#> 20:    9 (6.7%)    3 (2.2%)       5 (3.8%)
#>       A: Drug X  B: Placebo C: Combination
#>          <char>      <char>         <char>

# Demographics table (DMT01) with continuous variable (e.g., BMRKR1)
summary_table(
  adsl,
  target = c(dmg_vars, "BMRKR1"),
  treat = 'ARM',
  target_name = c(dmg_var_lbls, "Biomarker 1")
)
#>                                                                 stats
#>                                                                <char>
#>  1:                                                          Age (yr)
#>  2:                                         &nbsp;&nbsp;&nbsp;&nbsp;n
#>  3:                                 &nbsp;&nbsp;&nbsp;&nbsp;Mean (SD)
#>  4:                                    &nbsp;&nbsp;&nbsp;&nbsp;Median
#>  5:                                  &nbsp;&nbsp;&nbsp;&nbsp;Min, Max
#>  6:                                   &nbsp;&nbsp;&nbsp;&nbsp;Missing
#>  7:                                                              Race
#>  8:          &nbsp;&nbsp;&nbsp;&nbsp;AMERICAN INDIAN OR ALASKA NATIVE
#>  9:                                     &nbsp;&nbsp;&nbsp;&nbsp;ASIAN
#> 10:                 &nbsp;&nbsp;&nbsp;&nbsp;BLACK OR AFRICAN AMERICAN
#> 11:                                  &nbsp;&nbsp;&nbsp;&nbsp;MULTIPLE
#> 12: &nbsp;&nbsp;&nbsp;&nbsp;NATIVE HAWAIIAN OR OTHER PACIFIC ISLANDER
#> 13:                                     &nbsp;&nbsp;&nbsp;&nbsp;OTHER
#> 14:                                   &nbsp;&nbsp;&nbsp;&nbsp;UNKNOWN
#> 15:                                     &nbsp;&nbsp;&nbsp;&nbsp;WHITE
#> 16:                                                         Ethnicity
#> 17:                        &nbsp;&nbsp;&nbsp;&nbsp;HISPANIC OR LATINO
#> 18:                    &nbsp;&nbsp;&nbsp;&nbsp;NOT HISPANIC OR LATINO
#> 19:                              &nbsp;&nbsp;&nbsp;&nbsp;NOT REPORTED
#> 20:                                   &nbsp;&nbsp;&nbsp;&nbsp;UNKNOWN
#> 21:                                                       Biomarker 1
#> 22:                                         &nbsp;&nbsp;&nbsp;&nbsp;n
#> 23:                                 &nbsp;&nbsp;&nbsp;&nbsp;Mean (SD)
#> 24:                                    &nbsp;&nbsp;&nbsp;&nbsp;Median
#> 25:                                  &nbsp;&nbsp;&nbsp;&nbsp;Min, Max
#> 26:                                   &nbsp;&nbsp;&nbsp;&nbsp;Missing
#>                                                                 stats
#>                                                                <char>
#>       A: Drug X  B: Placebo C: Combination
#>          <char>      <char>         <char>
#>  1:                                       
#>  2:         134         134            132
#>  3:  33.8 (6.6)  35.4 (7.9)     35.4 (7.7)
#>  4:          33          35             35
#>  5:  21.0, 50.0  21.0, 62.0     20.0, 69.0
#>  6:           0           0              0
#>  7:                                       
#>  8:    8 (6.0%)   11 (8.2%)       6 (4.5%)
#>  9:  68 (50.7%)  67 (50.0%)     73 (55.3%)
#> 10:  31 (23.1%)  28 (20.9%)     32 (24.2%)
#> 11:           0    1 (0.7%)              0
#> 12:           0    1 (0.7%)              0
#> 13:           0           0              0
#> 14:           0           0              0
#> 15:  27 (20.1%)  26 (19.4%)     21 (15.9%)
#> 16:                                       
#> 17:  15 (11.2%)  18 (13.4%)     15 (11.4%)
#> 18: 104 (77.6%) 103 (76.9%)    101 (76.5%)
#> 19:    6 (4.5%)   10 (7.5%)      11 (8.3%)
#> 20:    9 (6.7%)    3 (2.2%)       5 (3.8%)
#> 21:                                       
#> 22:         134         134            132
#> 23:   6.0 (3.6)   5.7 (3.3)      5.6 (3.5)
#> 24:         5.4         4.8            4.6
#> 25:   0.4, 17.7   0.6, 14.2      0.2, 21.4
#> 26:           0           0              0
#>       A: Drug X  B: Placebo C: Combination
#>          <char>      <char>         <char>
```
