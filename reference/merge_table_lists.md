# Merge a list of list-wrapped data.tables into one data.table

This function is typically used to combine multiple reporting tables,
each produced by
[`event_count()`](https://AscentSoftware.github.io/dtlg/reference/event_count.md),
[`total_events()`](https://AscentSoftware.github.io/dtlg/reference/total_events.md),
or
[`multi_event_true()`](https://AscentSoftware.github.io/dtlg/reference/multi_event_true.md),
into a single summary table. These intermediate tables are often
returned as one-element lists containing a `data.table`.

## Usage

``` r
merge_table_lists(dt_l)
```

## Arguments

- dt_l:

  A list of one-element lists, where each element is a list containing a
  single `data.table`.

## Value

A single merged `data.table`, row-bound from all input tables.

## Details

This helper unwraps and merges them, row-wise, to produce a consolidated
safety report table — commonly used in clinical study reports or data
monitoring reviews.

## Examples

``` r
# Count deaths by treatment arm
death_table <- event_count(
  adsl,
  patient = "USUBJID",
  treat = "ARM",
  label = "Total number of deaths",
  .filters = "DTHFL == 'Y'"
)

# Count study withdrawals due to adverse events
withdrawal_table <- event_count(
  adsl,
  patient = "USUBJID",
  treat = "ARM",
  label = "Total number of patients withdrawn from study due to an AE",
  .filters = "DCSREAS == 'ADVERSE EVENT'"
)

# Count patients with at least one adverse event
patients_with_ae_table <- event_count(
  adae,
  patient = "USUBJID",
  treat = "ARM",
  label = "Total number of patients with at least one AE"
)

# Count total number of adverse events (not patients)
total_ae_events_table <- total_events(
  dt = adae,
  treat = "ARM",
  label = "Total number of AEs"
)

# Summarise AESIs (e.g., serious, related, severe, etc.)
aesi_vars <- c("FATAL", "SER", "SERWD", "SERDSM", "RELSER",
               "WD", "DSM", "REL", "RELWD", "RELDSM", "SEV")

aesi_table <- multi_event_true(
  dt = aesi,
  event_vars = aesi_vars,
  patient = "USUBJID",
  treat = "ARM",
  heading = "Total number of patients with at least one",
  .total_dt = adsl,
  indent = "  "
)

# Combine all safety tables into a single summary table
safety_summary <- merge_table_lists(list(
  patients_with_ae_table,
  total_ae_events_table,
  death_table,
  withdrawal_table,
  aesi_table
))

safety_summary
#>                                                          stats   A: Drug X
#>                                                         <char>      <char>
#>  1:              Total number of patients with at least one AE 122 (20.0%)
#>  2:                                        Total number of AEs         609
#>  3:                                     Total number of deaths  25 (18.7%)
#>  4: Total number of patients withdrawn from study due to an AE    3 (2.2%)
#>  5:                 Total number of patients with at least one            
#>  6:                                      AE with fatal outcome    5 (3.7%)
#>  7:                                                 Serious AE  85 (63.4%)
#>  8:            Serious AE leading to withdrawal from treatment    6 (4.5%)
#>  9:       Serious AE leading to dose modification/interruption  36 (26.9%)
#> 10:                                         Related Serious AE  64 (47.8%)
#> 11:                    AE leading to withdrawal from treatment  20 (14.9%)
#> 12:               AE leading to dose modification/interruption  63 (47.0%)
#> 13:                                                 Related AE  86 (64.2%)
#> 14:            Related AE leading to withdrawal from treatment   10 (7.5%)
#> 15:       Related AE leading to dose modification/interruption  44 (32.8%)
#> 16:                          Severe AE (at greatest intensity)  77 (57.5%)
#>      B: Placebo C: Combination
#>          <char>         <char>
#>  1: 123 (19.8%)    120 (17.1%)
#>  2:         622            703
#>  3:  23 (17.2%)     22 (16.7%)
#>  4:    6 (4.5%)       5 (3.8%)
#>  5:                           
#>  6:    5 (3.7%)       6 (4.5%)
#>  7:  80 (59.7%)     87 (65.9%)
#>  8:   12 (9.0%)       9 (6.8%)
#>  9:  40 (29.9%)     47 (35.6%)
#> 10:  52 (38.8%)     64 (48.5%)
#> 11:  24 (17.9%)     26 (19.7%)
#> 12:  70 (52.2%)     77 (58.3%)
#> 13:  85 (63.4%)     92 (69.7%)
#> 14:    9 (6.7%)      12 (9.1%)
#> 15:  44 (32.8%)     51 (38.6%)
#> 16:  70 (52.2%)     79 (59.8%)
```
