# Generate Core Safety Tables (CSR Section 14.3.1) using `tern`/`rtables`

`tern_AET01_table()` produces a consolidated safety summary table using
`rtables` and `tern`. It mirrors the output and interface of
[`AET01_table()`](https://AscentSoftware.github.io/dtlg/reference/AET01_table.md),
generating standard adverse event summaries (e.g. death, withdrawal,
AESIs) for Clinical Study Reports (CSR) Section 14.3.1.

## Usage

``` r
tern_AET01_table(
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

  Ignored (included for interface compatibility).

- indent:

  Ignored (included for interface compatibility).

## Value

A `TableTree` object from the `rtables` package.

## Details

The function returns a single formatted `rtables` table summarising core
safety endpoints by treatment arm.

## Examples

``` r
tern_AET01_table(
  adsl = adsl,
  adae = aesi,
  patient_var = "USUBJID",
  treat_var = "ARM",
  aesi_vars = c("FATAL", "SER", "SERWD", "SERDSM", "RELSER",
                "WD", "DSM", "REL", "RELWD", "RELDSM", "SEV")
)
#>                                                               A: Drug X    B: Placebo   C: Combination
#>                                                                (N=134)      (N=134)        (N=132)    
#> ——————————————————————————————————————————————————————————————————————————————————————————————————————
#> Total number of patients with at least one AE                100 (74.6%)   98 (73.1%)    103 (78.0%)  
#> Total number of AEs                                              502          480            604      
#> Total number of deaths                                       25 (18.7%)    23 (17.2%)     22 (16.7%)  
#> Total number of patients withdrawn from study due to an AE    3 (2.2%)      6 (4.5%)       5 (3.8%)   
#> Total number of patients with at least one                                                            
#>   AE with fatal outcome                                       5 (3.7%)      5 (3.7%)       6 (4.5%)   
#>   Serious AE                                                 85 (63.4%)    80 (59.7%)     87 (65.9%)  
#>   Serious AE leading to withdrawal from treatment             6 (4.5%)     12 (9.0%)       9 (6.8%)   
#>   Serious AE leading to dose modification/interruption       36 (26.9%)    40 (29.9%)     47 (35.6%)  
#>   Related Serious AE                                         64 (47.8%)    52 (38.8%)     64 (48.5%)  
#>   AE leading to withdrawal from treatment                    20 (14.9%)    24 (17.9%)     26 (19.7%)  
#>   AE leading to dose modification/interruption               63 (47.0%)    70 (52.2%)     77 (58.3%)  
#>   Related AE                                                 86 (64.2%)    85 (63.4%)     92 (69.7%)  
#>   Related AE leading to withdrawal from treatment             10 (7.5%)     9 (6.7%)      12 (9.1%)   
#>   Related AE leading to dose modification/interruption       44 (32.8%)    44 (32.8%)     51 (38.6%)  
#>   Severe AE (at greatest intensity)                          77 (57.5%)    70 (52.2%)     79 (59.8%)  
```
