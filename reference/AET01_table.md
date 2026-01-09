# Generate Core Safety Tables for Clinical Study Reports

`AET01_table()` produces and combines the main safety summary tables
typically found in Section 14.3.1 of a Clinical Study Report (CSR). It
calculates patient counts and event totals for deaths, AE-related
withdrawals, total AEs, and adverse events of special interest (AESIs).

## Usage

``` r
AET01_table(
  adsl,
  adae,
  patient_var,
  treat_var,
  aesi_vars,
  aesi_heading = "Total number of patients with at least one",
  indent = "  "
)
```

## Arguments

- adsl:

  A subject-level dataset (typically ADaM ADSL).

- adae:

  A dataset of adverse events, preprocessed with AESI flags.

- patient_var:

  A string indicating the subject identifier variable (e.g.,
  `"USUBJID"`).

- treat_var:

  A string indicating the treatment arm variable (e.g., `"ARM"`).

- aesi_vars:

  A character vector of binary AESI flags in `adae`.

- aesi_heading:

  Optional character string used as a heading in the AESI block.

- indent:

  A string used to indent AESI row labels (default is 2 spaces).

## Value

A merged `data.table` summarising the main safety outcomes.

## Examples

``` r
AET01_summary <- AET01_table(
  adsl = adsl,
  adae = aesi,
  patient_var = "USUBJID",
  treat_var = "ARM",
  aesi_vars = c("FATAL", "SER", "SERWD", "SERDSM", "RELSER",
                "WD", "DSM", "REL", "RELWD", "RELDSM", "SEV")
)
print(AET01_summary)
#>                                                          stats   A: Drug X
#>                                                         <char>      <char>
#>  1:              Total number of patients with at least one AE 100 (74.6%)
#>  2:                                        Total number of AEs         502
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
#>     B: Placebo C: Combination
#>         <char>         <char>
#>  1: 98 (73.1%)    103 (78.0%)
#>  2:        480            604
#>  3: 23 (17.2%)     22 (16.7%)
#>  4:   6 (4.5%)       5 (3.8%)
#>  5:                          
#>  6:   5 (3.7%)       6 (4.5%)
#>  7: 80 (59.7%)     87 (65.9%)
#>  8:  12 (9.0%)       9 (6.8%)
#>  9: 40 (29.9%)     47 (35.6%)
#> 10: 52 (38.8%)     64 (48.5%)
#> 11: 24 (17.9%)     26 (19.7%)
#> 12: 70 (52.2%)     77 (58.3%)
#> 13: 85 (63.4%)     92 (69.7%)
#> 14:   9 (6.7%)      12 (9.1%)
#> 15: 44 (32.8%)     51 (38.6%)
#> 16: 70 (52.2%)     79 (59.8%)
```
