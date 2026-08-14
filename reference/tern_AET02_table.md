# Generate AET02-style AE summary using `tern` and `rtables`

This function builds a System Organ Class (SOC) and Preferred Term (PT)
adverse event summary table, following the AET02 CSR format, using the
`tern` and `rtables` packages.

## Usage

``` r
tern_AET02_table(
  adsl,
  adae,
  patient,
  treat,
  target = "AEDECOD",
  rows_by = "AEBODSYS",
  indent = "  "
)
```

## Arguments

- adsl:

  Subject-level dataset.

- adae:

  Adverse event dataset.

- patient:

  Unique subject identifier variable.

- treat:

  Treatment arm variable.

- target:

  Preferred term variable for grouping (default: `"AEDECOD"`).

- rows_by:

  Higher-level term for nesting (default: `"AEBODSYS"`).

- indent:

  Ignored (included for compatibility).

## Value

A `TableTree` object with AE summary by SOC/PT.

## See also

[`AET02_table()`](https://AscentSoftware.github.io/dtlg/reference/AET02_table.md)

## Examples

``` r
# AE summary by System Organ Class and Preferred Term
tern_AET02_table(
  adsl = adsl,
  adae = adae,
  patient = "USUBJID",
  treat = "ARM"
)
#>                   A: Drug X    B: Placebo   C: Combination
#>                    (N=134)      (N=134)        (N=132)    
#> ——————————————————————————————————————————————————————————
#> cl A.1                                                    
#>   dcd A.1.1.1.1   50 (37.3%)   45 (33.6%)     63 (47.7%)  
#>   dcd A.1.1.1.2   48 (35.8%)   48 (35.8%)     50 (37.9%)  
#> cl B.1                                                    
#>   dcd B.1.1.1.1   47 (35.1%)   49 (36.6%)     43 (32.6%)  
#> cl B.2                                                    
#>   dcd B.2.1.2.1   49 (36.6%)   44 (32.8%)     52 (39.4%)  
#>   dcd B.2.2.3.1   48 (35.8%)   54 (40.3%)     51 (38.6%)  
#> cl C.1                                                    
#>   dcd C.1.1.1.3   43 (32.1%)   46 (34.3%)     43 (32.6%)  
#> cl C.2                                                    
#>   dcd C.2.1.2.1   35 (26.1%)   48 (35.8%)     55 (41.7%)  
#> cl D.1                                                    
#>   dcd D.1.1.1.1   50 (37.3%)   42 (31.3%)     51 (38.6%)  
#>   dcd D.1.1.4.2   48 (35.8%)   42 (31.3%)     50 (37.9%)  
#> cl D.2                                                    
#>   dcd D.2.1.5.3   47 (35.1%)   58 (43.3%)     57 (43.2%)  

# Nesting at a different level of the MedDRA hierarchy
tern_AET02_table(
  adsl = adsl,
  adae = adae,
  patient = "USUBJID",
  treat = "ARM",
  target = "AEHLT",
  rows_by = "AESOC"
)
#>                 A: Drug X    B: Placebo   C: Combination
#>                  (N=134)      (N=134)        (N=132)    
#> ————————————————————————————————————————————————————————
#> cl A                                                    
#>   hlt A.1.1.1   78 (58.2%)   75 (56.0%)     89 (67.4%)  
#> cl B                                                    
#>   hlt B.1.1.1   47 (35.1%)   49 (36.6%)     43 (32.6%)  
#>   hlt B.2.1.2   49 (36.6%)   44 (32.8%)     52 (39.4%)  
#>   hlt B.2.2.3   48 (35.8%)   54 (40.3%)     51 (38.6%)  
#> cl C                                                    
#>   hlt C.1.1.1   43 (32.1%)   46 (34.3%)     43 (32.6%)  
#>   hlt C.2.1.2   35 (26.1%)   48 (35.8%)     55 (41.7%)  
#> cl D                                                    
#>   hlt D.1.1.1   50 (37.3%)   42 (31.3%)     51 (38.6%)  
#>   hlt D.1.1.4   48 (35.8%)   42 (31.3%)     50 (37.9%)  
#>   hlt D.2.1.5   47 (35.1%)   58 (43.3%)     57 (43.2%)  
```
