# Create a summary table using multiple rows for grouping on two target column ideal for creating change from baseline tables

Create a summary table using multiple rows for grouping on two target
column ideal for creating change from baseline tables

## Usage

``` r
summary_table_by_targets(
  dt,
  target,
  treat,
  rows_by,
  indent = nbsp(n = 4L),
  .total_dt = NULL,
  pct_dec = 1,
  treat_order = NULL,
  skip_absent = TRUE
)
```

## Arguments

- dt:

  table to perform function on

- target:

  vector of column names desired to obtain information on

- treat:

  string of treatment variable used for splitting / grouping data

- rows_by:

  string, grouping variable to split events by.

- indent:

  indent to be used for display and formatting purposes

- .total_dt:

  optional table for total counts to be derived

- pct_dec:

  decimal places for percentages

- treat_order:

  customise the column order of output table

- skip_absent:

  Logical, default TRUE. Passed to data.table::setcolorder, if
  treat_order includes columns not present in dt, TRUE will silently
  ignore them, FALSE will throw an error.

## Value

data.table

## Examples

``` r
adlb <- random.cdisc.data::cadlb|>dplyr::filter(AVISIT != "SCREENING")
labs <- summary_table_by_targets(adlb, c('AVAL','CHG'), 'ARM', c('PARAM','AVISIT'), '  ', NULL)
```
