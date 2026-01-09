# Calculate descriptive summary statistics for a numeric variable

`calc_desc()` summarises a numeric variable (`target`) by another
(`treat`) and reports summary statistics in clinical trial reporting
format. The following statistics are calculated for `target`, per group,
i.e. by variable `treat` levels:

- `n`: number of observations

- `Mean (SD)`: mean and standard deviation of `target`

- `Median`: median of `target`

- `Min, Max`: minimum and maximum of `target`

- `Missing`: number of missing `target` values

## Usage

``` r
calc_desc(
  dt,
  target,
  target_name = target,
  treat,
  indent = nbsp(n = 4L),
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

- pct_dec:

  Decimal places for reported figures.

## Value

A list containing a `data.table` formatted as follows:

- First column is named `stats` and contains the target variable name
  indicated in `target` in the first row. Subsequent rows contain the
  summarised statistics labels.

- Other columns are for the levels of the grouping variable (`treat`).

- All columns are of character type.

This table is structured for easy integration with Shiny output widgets.

## Examples

``` r
# Calculate summary statistics for the age of the subjects in each region.
calc_stats(dt = adsl, "AGE", treat = "REGION1")[[1]]
#>                                stats     Africa       Asia    Eurasia
#>                               <char>     <char>     <char>     <char>
#> 1:                               AGE                                 
#> 2:         &nbsp;&nbsp;&nbsp;&nbsp;n         26        268         19
#> 3: &nbsp;&nbsp;&nbsp;&nbsp;Mean (SD) 32.3 (7.7) 34.6 (6.9) 35.9 (8.3)
#> 4:    &nbsp;&nbsp;&nbsp;&nbsp;Median         31         34         36
#> 5:  &nbsp;&nbsp;&nbsp;&nbsp;Min, Max 20.0, 50.0 21.0, 58.0 25.0, 58.0
#> 6:   &nbsp;&nbsp;&nbsp;&nbsp;Missing          0          0          0
#>         Europe North America South America
#>         <char>        <char>        <char>
#> 1:                                        
#> 2:           9            48            30
#> 3: 38.4 (16.1)    36.2 (6.8)    36.1 (8.1)
#> 4:          30            35          35.5
#> 5:  26.0, 69.0    24.0, 57.0    24.0, 64.0
#> 6:           0             0             0

# Calculate summary statistics for biomarker 1 in each of the three arms
# (`ARM`).
calc_stats(dt = adsl, "BMRKR1", treat = "ARM")[[1]]
#>                                stats A: Drug X B: Placebo C: Combination
#>                               <char>    <char>     <char>         <char>
#> 1:                            BMRKR1                                    
#> 2:         &nbsp;&nbsp;&nbsp;&nbsp;n       134        134            132
#> 3: &nbsp;&nbsp;&nbsp;&nbsp;Mean (SD) 6.0 (3.6)  5.7 (3.3)      5.6 (3.5)
#> 4:    &nbsp;&nbsp;&nbsp;&nbsp;Median       5.4        4.8            4.6
#> 5:  &nbsp;&nbsp;&nbsp;&nbsp;Min, Max 0.4, 17.7  0.6, 14.2      0.2, 21.4
#> 6:   &nbsp;&nbsp;&nbsp;&nbsp;Missing         0          0              0
```
