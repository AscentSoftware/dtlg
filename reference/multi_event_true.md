# Summarise multiple AESI-like events per treatment arm

`multi_event_true()` generates a summary table showing the number and
percentage of patients with at least one event across multiple binary
indicator variables (e.g., flags for adverse events of special
interest).

## Usage

``` r
multi_event_true(
  dt,
  event_vars,
  patient,
  treat,
  heading,
  label = NULL,
  .total_dt = NULL,
  indent = nbsp(n = 4L),
  pct_dec = 1
)
```

## Arguments

- dt:

  A `data.frame` or `data.table` containing the binary event flags and
  subject-level data.

- event_vars:

  A character vector of column names (binary flags) to summarise.

- patient:

  A string giving the name of the variable that uniquely identifies each
  patient (e.g., `"USUBJID"`).

- treat:

  A string giving the name of the treatment variable (e.g., `"ARM"`).

- heading:

  A string to be shown as the first row in the output, usually a summary
  descriptor such as `"Total number of patients with at least one"`.

- label:

  Optional. A character vector of the same length as `event_vars` giving
  human-readable labels for the output table rows. If `NULL`, labels are
  extracted from the `label` attribute of each variable, or fall back to
  the variable name.

- .total_dt:

  A `data.frame` or `data.table` containing the total analysis
  population (denominator). If `NULL`, `dt` is used as the denominator.

- indent:

  A string to indent the row labels (e.g., `" "` or `nbsp(n = 4L)` for
  non-breaking spaces).

- pct_dec:

  An integer indicating how many decimal places to show in percentages
  (default is `1`).

## Value

A one-element list containing a `data.table` with one row per event plus
one header row. The first column is `"stats"` (row labels), and
subsequent columns are one per treatment arm, with values in `"n (x%)"`
format.

## Details

Each event is counted only once per patient. This function is typically
used for summarising *Adverse Events of Special Interest* (AESIs) or
other derived flags (e.g., `SER`, `FATAL`, `RELDSM`) that are binary
(TRUE/FALSE).

## See also

[`event_count()`](https://AscentSoftware.github.io/dtlg/reference/event_count.md),
[`total_events()`](https://AscentSoftware.github.io/dtlg/reference/total_events.md)

## Examples

``` r
aesi_vars <- c(
  "FATAL", "SER", "SERWD", "SERDSM", "RELSER",
  "WD", "DSM", "REL", "RELWD", "RELDSM", "SEV"
)

heading <- "Total number of patients with at least one AE"

multi_event_true(
  dt = aesi,
  event_vars = aesi_vars,
  patient = "USUBJID",
  treat = "ARM",
  heading = heading,
  .total_dt = adsl,
  indent = "  "
)[[1]]
#>                                                      stats  A: Drug X
#>                                                     <char>     <char>
#>  1:          Total number of patients with at least one AE           
#>  2:                                  AE with fatal outcome   5 (3.7%)
#>  3:                                             Serious AE 85 (63.4%)
#>  4:        Serious AE leading to withdrawal from treatment   6 (4.5%)
#>  5:   Serious AE leading to dose modification/interruption 36 (26.9%)
#>  6:                                     Related Serious AE 64 (47.8%)
#>  7:                AE leading to withdrawal from treatment 20 (14.9%)
#>  8:           AE leading to dose modification/interruption 63 (47.0%)
#>  9:                                             Related AE 86 (64.2%)
#> 10:        Related AE leading to withdrawal from treatment  10 (7.5%)
#> 11:   Related AE leading to dose modification/interruption 44 (32.8%)
#> 12:                      Severe AE (at greatest intensity) 77 (57.5%)
#>     B: Placebo C: Combination
#>         <char>         <char>
#>  1:                          
#>  2:   5 (3.7%)       6 (4.5%)
#>  3: 80 (59.7%)     87 (65.9%)
#>  4:  12 (9.0%)       9 (6.8%)
#>  5: 40 (29.9%)     47 (35.6%)
#>  6: 52 (38.8%)     64 (48.5%)
#>  7: 24 (17.9%)     26 (19.7%)
#>  8: 70 (52.2%)     77 (58.3%)
#>  9: 85 (63.4%)     92 (69.7%)
#> 10:   9 (6.7%)      12 (9.1%)
#> 11: 44 (32.8%)     51 (38.6%)
#> 12: 70 (52.2%)     79 (59.8%)
```
