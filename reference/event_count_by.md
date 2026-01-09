# Summarise adverse events by arm and other grouping variables

`event_count_by()` creates a tabular summary of adverse events grouped
by a higher-level classification variable (e.g., system organ class),
and counts both the number of events and the number of unique patients
per treatment arm.

## Usage

``` r
event_count_by(
  dt,
  patient,
  treat,
  rows_by,
  target,
  .total_dt = dt,
  indent = nbsp(n = 4L),
  pct_dec = 1
)
```

## Arguments

- dt:

  A `data.frame` or `data.table` containing the adverse event data and
  patient-level identifiers.

- patient:

  A string giving the name of the patient identifier variable (e.g.,
  `"USUBJID"`).

- treat:

  A string giving the name of the treatment arm variable (e.g.,
  `"ARM"`).

- rows_by:

  A string giving the name of the grouping variable (e.g., `"AEBODSYS"`
  for body system).

- target:

  A string giving the name of the variable to report within each group
  (e.g., `"AEDECOD"` for preferred term).

- .total_dt:

  A `data.frame` or `data.table` containing the denominator population.
  Defaults to `dt`.

- indent:

  A string used to indent row labels (e.g., `" "` or `nbsp(n = 4L)`).

- pct_dec:

  Integer. Number of decimal places to show in percentages. Defaults to
  `1`.

## Value

A `data.table` with the following structure:

- One row per combination of `rows_by` and `target`

- One row per group total (`Total number of events`)

- One row per patient-level total
  (`Total number of patients with at least one event`)

Columns include:

- `stats`: character column with labels

- one column per level of the `treat` variable, formatted as `"n (x%)"`

## See also

[`event_count()`](https://AscentSoftware.github.io/dtlg/reference/event_count.md),
[`calc_stats()`](https://AscentSoftware.github.io/dtlg/reference/calc_stats.md),
[`total_events()`](https://AscentSoftware.github.io/dtlg/reference/total_events.md)

## Examples

``` r
event_count_by(
  dt = adae[adae$ANL01FL == "Y"],
  patient = 'USUBJID',
  treat = 'ARM',
  rows_by = 'AEBODSYS',
  target = 'AEDECOD',
  .total_dt = adsl,
  indent = ' '
)
#>                                                stats  A: Drug X B: Placebo
#>                                               <char>     <char>     <char>
#>  1:                                           cl B.2                      
#>  2:                                    dcd A.1.1.1.1          0          0
#>  3:                                    dcd A.1.1.1.2          0          0
#>  4:                                    dcd B.1.1.1.1          0          0
#>  5:                                    dcd B.2.1.2.1 52 (38.8%) 51 (38.1%)
#>  6:                                    dcd B.2.2.3.1 50 (37.3%) 55 (41.0%)
#>  7:                                    dcd C.1.1.1.3          0          0
#>  8:                                    dcd C.2.1.2.1          0          0
#>  9:                                    dcd D.1.1.1.1          0          0
#> 10:                                    dcd D.1.1.4.2          0          0
#> 11:                                    dcd D.2.1.5.3          0          0
#> 12:                           Total number of events        102        106
#> 13: Total number of patients with at least one event 62 (46.3%) 56 (41.8%)
#> 14:                                           cl D.1                      
#> 15:                                    dcd A.1.1.1.1          0          0
#> 16:                                    dcd A.1.1.1.2          0          0
#> 17:                                    dcd B.1.1.1.1          0          0
#> 18:                                    dcd B.2.1.2.1          0          0
#> 19:                                    dcd B.2.2.3.1          0          0
#> 20:                                    dcd C.1.1.1.3          0          0
#> 21:                                    dcd C.2.1.2.1          0          0
#> 22:                                    dcd D.1.1.1.1 52 (38.8%) 40 (29.9%)
#> 23:                                    dcd D.1.1.4.2 54 (40.3%) 44 (32.8%)
#> 24:                                    dcd D.2.1.5.3          0          0
#> 25:                           Total number of events        106         84
#> 26: Total number of patients with at least one event 64 (47.8%) 54 (40.3%)
#> 27:                                           cl A.1                      
#> 28:                                    dcd A.1.1.1.1 57 (42.5%) 43 (32.1%)
#> 29:                                    dcd A.1.1.1.2 58 (43.3%) 56 (41.8%)
#> 30:                                    dcd B.1.1.1.1          0          0
#> 31:                                    dcd B.2.1.2.1          0          0
#> 32:                                    dcd B.2.2.3.1          0          0
#> 33:                                    dcd C.1.1.1.3          0          0
#> 34:                                    dcd C.2.1.2.1          0          0
#> 35:                                    dcd D.1.1.1.1          0          0
#> 36:                                    dcd D.1.1.4.2          0          0
#> 37:                                    dcd D.2.1.5.3          0          0
#> 38:                           Total number of events        115         99
#> 39: Total number of patients with at least one event 68 (50.7%) 58 (43.3%)
#> 40:                                           cl D.2                      
#> 41:                                    dcd A.1.1.1.1          0          0
#> 42:                                    dcd A.1.1.1.2          0          0
#> 43:                                    dcd B.1.1.1.1          0          0
#> 44:                                    dcd B.2.1.2.1          0          0
#> 45:                                    dcd B.2.2.3.1          0          0
#> 46:                                    dcd C.1.1.1.3          0          0
#> 47:                                    dcd C.2.1.2.1          0          0
#> 48:                                    dcd D.1.1.1.1          0          0
#> 49:                                    dcd D.1.1.4.2          0          0
#> 50:                                    dcd D.2.1.5.3 49 (36.6%) 57 (42.5%)
#> 51:                           Total number of events         49         57
#> 52: Total number of patients with at least one event 37 (27.6%) 46 (34.3%)
#> 53:                                           cl B.1                      
#> 54:                                    dcd A.1.1.1.1          0          0
#> 55:                                    dcd A.1.1.1.2          0          0
#> 56:                                    dcd B.1.1.1.1 44 (32.8%) 43 (32.1%)
#> 57:                                    dcd B.2.1.2.1          0          0
#> 58:                                    dcd B.2.2.3.1          0          0
#> 59:                                    dcd C.1.1.1.3          0          0
#> 60:                                    dcd C.2.1.2.1          0          0
#> 61:                                    dcd D.1.1.1.1          0          0
#> 62:                                    dcd D.1.1.4.2          0          0
#> 63:                                    dcd D.2.1.5.3          0          0
#> 64:                           Total number of events         44         43
#> 65: Total number of patients with at least one event 38 (28.4%) 37 (27.6%)
#> 66:                                           cl C.2                      
#> 67:                                    dcd A.1.1.1.1          0          0
#> 68:                                    dcd A.1.1.1.2          0          0
#> 69:                                    dcd B.1.1.1.1          0          0
#> 70:                                    dcd B.2.1.2.1          0          0
#> 71:                                    dcd B.2.2.3.1          0          0
#> 72:                                    dcd C.1.1.1.3          0          0
#> 73:                                    dcd C.2.1.2.1 39 (29.1%) 40 (29.9%)
#> 74:                                    dcd D.1.1.1.1          0          0
#> 75:                                    dcd D.1.1.4.2          0          0
#> 76:                                    dcd D.2.1.5.3          0          0
#> 77:                           Total number of events         39         40
#> 78: Total number of patients with at least one event 28 (20.9%) 36 (26.9%)
#> 79:                                           cl C.1                      
#> 80:                                    dcd A.1.1.1.1          0          0
#> 81:                                    dcd A.1.1.1.2          0          0
#> 82:                                    dcd B.1.1.1.1          0          0
#> 83:                                    dcd B.2.1.2.1          0          0
#> 84:                                    dcd B.2.2.3.1          0          0
#> 85:                                    dcd C.1.1.1.3 47 (35.1%) 51 (38.1%)
#> 86:                                    dcd C.2.1.2.1          0          0
#> 87:                                    dcd D.1.1.1.1          0          0
#> 88:                                    dcd D.1.1.4.2          0          0
#> 89:                                    dcd D.2.1.5.3          0          0
#> 90:                           Total number of events         47         51
#> 91: Total number of patients with at least one event 36 (26.9%) 34 (25.4%)
#>                                                stats  A: Drug X B: Placebo
#>                                               <char>     <char>     <char>
#>     C: Combination
#>             <char>
#>  1:               
#>  2:              0
#>  3:              0
#>  4:              0
#>  5:     59 (44.7%)
#>  6:     68 (51.5%)
#>  7:              0
#>  8:              0
#>  9:              0
#> 10:              0
#> 11:              0
#> 12:            127
#> 13:     74 (56.1%)
#> 14:               
#> 15:              0
#> 16:              0
#> 17:              0
#> 18:              0
#> 19:              0
#> 20:              0
#> 21:              0
#> 22:     64 (48.5%)
#> 23:     50 (37.9%)
#> 24:              0
#> 25:            114
#> 26:     68 (51.5%)
#> 27:               
#> 28:     74 (56.1%)
#> 29:     63 (47.7%)
#> 30:              0
#> 31:              0
#> 32:              0
#> 33:              0
#> 34:              0
#> 35:              0
#> 36:              0
#> 37:              0
#> 38:            137
#> 39:     76 (57.6%)
#> 40:               
#> 41:              0
#> 42:              0
#> 43:              0
#> 44:              0
#> 45:              0
#> 46:              0
#> 47:              0
#> 48:              0
#> 49:              0
#> 50:     65 (49.2%)
#> 51:             65
#> 52:     50 (37.9%)
#> 53:               
#> 54:              0
#> 55:              0
#> 56:     50 (37.9%)
#> 57:              0
#> 58:              0
#> 59:              0
#> 60:              0
#> 61:              0
#> 62:              0
#> 63:              0
#> 64:             50
#> 65:     36 (27.3%)
#> 66:               
#> 67:              0
#> 68:              0
#> 69:              0
#> 70:              0
#> 71:              0
#> 72:              0
#> 73:     57 (43.2%)
#> 74:              0
#> 75:              0
#> 76:              0
#> 77:             57
#> 78:     48 (36.4%)
#> 79:               
#> 80:              0
#> 81:              0
#> 82:              0
#> 83:              0
#> 84:              0
#> 85:     54 (40.9%)
#> 86:              0
#> 87:              0
#> 88:              0
#> 89:              0
#> 90:             54
#> 91:     36 (27.3%)
#>     C: Combination
#>             <char>
```
