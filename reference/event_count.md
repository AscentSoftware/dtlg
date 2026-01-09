# Count events

`event_count()` counts events defined by predicate expressions passed in
`.filters`.

## Usage

``` r
event_count(
  dt,
  patient,
  treat,
  label,
  .filters = NULL,
  .total_dt = dt,
  pct_dec = 1
)
```

## Arguments

- dt:

  A `data.frame` containing, at least, the variables indicated in
  `target` and `treat`.

- patient:

  A string indicating the subject identifying variable.

- treat:

  A string indicating the grouping variable, e.g. the variable
  specifying the treatment population.

- label:

  A string to be used as label in the output reporting table. This
  should be a text descriptive of the event being counted.

- .filters:

  Predicate expressions identifying events in `dt`. Argument should be
  passed as a `character` vector of expressions to be evaluated in the
  frame of `dt`.

- .total_dt:

  Separate table from `dt` from which to derive total counts per group.

- pct_dec:

  This argument is ignored, and is only kept for backward compatibility
  reasons.

## Value

A one-element list, where the element is a `data.table`.

## Examples

``` r
# Count deaths per arm.
event_count(
  adsl,
  patient = "USUBJID",
  treat = "ARM",
  label = "Total number of deaths",
  .filters = "DTHFL == 'Y'"
)[[1]]
#>                     stats  A: Drug X B: Placebo C: Combination
#>                    <char>     <char>     <char>         <char>
#> 1: Total number of deaths 25 (18.7%) 23 (17.2%)     22 (16.7%)

# Count patients withdraw from study due to an adverse event.
withdrawn_lbl <- "Total number of patients withdrawn from study due to an AE"
event_count(
  adsl,
  patient = "USUBJID",
  treat = "ARM",
  label = withdrawn_lbl,
  .filters = "DCSREAS == 'ADVERSE EVENT'"
)[[1]]
#>                                                         stats A: Drug X
#>                                                        <char>    <char>
#> 1: Total number of patients withdrawn from study due to an AE  3 (2.2%)
#>    B: Placebo C: Combination
#>        <char>         <char>
#> 1:   6 (4.5%)       5 (3.8%)

# Count patients with at least one adverse event.
# NB: When `.filters` is `NULL` (i.e., omitted), all records in `dt` are used
# for counting events.
event_count(
  adae,
  patient = "USUBJID",
  treat = "ARM",
  label = "Total number of patients with at least one AE",
  .filters = "ANL01FL == 'Y'",
  .total_dt = adsl
)[[1]]
#>                                            stats   A: Drug X B: Placebo
#>                                           <char>      <char>     <char>
#> 1: Total number of patients with at least one AE 100 (74.6%) 98 (73.1%)
#>    C: Combination
#>            <char>
#> 1:    103 (78.0%)
```
