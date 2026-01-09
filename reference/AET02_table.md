# Create AET02-style AE summary table

Summarises adverse events in a format similar to the AET02 table from a
CSR, showing total AE counts, patients with AEs, and a breakdown by
System Organ Class (SOC) and Preferred Term (PT).

## Usage

``` r
AET02_table(
  adsl,
  adae,
  patient,
  treat,
  target = "AEDECOD",
  rows_by = "AEBODSYS",
  indent = nbsp(n = 4L)
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

  Character or string to indent nested rows (default: 4 non-breaking
  spaces).

## Value

A merged data.table containing AE summary.

## Examples

``` r
# Create a AET02 table
AET02_table(
  adsl = adsl,
  adae = aesi,
  patient = "USUBJID",
  treat = "ARM",
  target = "AEDECOD",
  rows_by = "AEBODSYS",
  indent = "  "
)
#>                                                stats   A: Drug X B: Placebo
#>                                               <char>      <char>     <char>
#>  1:    Total number of patients with at least one AE 100 (74.6%) 98 (73.1%)
#>  2:                              Total number of AEs         502        480
#>  3:                                           cl B.2                       
#>  4:                                    dcd B.2.1.2.1  52 (38.8%) 51 (38.1%)
#>  5:                                    dcd B.2.2.3.1  50 (37.3%) 55 (41.0%)
#>  6:                           Total number of events         102        106
#>  7: Total number of patients with at least one event  62 (46.3%) 56 (41.8%)
#>  8:                                           cl D.1                       
#>  9:                                    dcd D.1.1.1.1  52 (38.8%) 40 (29.9%)
#> 10:                                    dcd D.1.1.4.2  54 (40.3%) 44 (32.8%)
#> 11:                           Total number of events         106         84
#> 12: Total number of patients with at least one event  64 (47.8%) 54 (40.3%)
#> 13:                                           cl A.1                       
#> 14:                                    dcd A.1.1.1.1  57 (42.5%) 43 (32.1%)
#> 15:                                    dcd A.1.1.1.2  58 (43.3%) 56 (41.8%)
#> 16:                           Total number of events         115         99
#> 17: Total number of patients with at least one event  68 (50.7%) 58 (43.3%)
#> 18:                                           cl D.2                       
#> 19:                                    dcd D.2.1.5.3  49 (36.6%) 57 (42.5%)
#> 20:                           Total number of events          49         57
#> 21: Total number of patients with at least one event  37 (27.6%) 46 (34.3%)
#> 22:                                           cl B.1                       
#> 23:                                    dcd B.1.1.1.1  44 (32.8%) 43 (32.1%)
#> 24:                           Total number of events          44         43
#> 25: Total number of patients with at least one event  38 (28.4%) 37 (27.6%)
#> 26:                                           cl C.2                       
#> 27:                                    dcd C.2.1.2.1  39 (29.1%) 40 (29.9%)
#> 28:                           Total number of events          39         40
#> 29: Total number of patients with at least one event  28 (20.9%) 36 (26.9%)
#> 30:                                           cl C.1                       
#> 31:                                    dcd C.1.1.1.3  47 (35.1%) 51 (38.1%)
#> 32:                           Total number of events          47         51
#> 33: Total number of patients with at least one event  36 (26.9%) 34 (25.4%)
#>                                                stats   A: Drug X B: Placebo
#>                                               <char>      <char>     <char>
#>     C: Combination
#>             <char>
#>  1:    103 (78.0%)
#>  2:            604
#>  3:               
#>  4:     59 (44.7%)
#>  5:     68 (51.5%)
#>  6:            127
#>  7:     74 (56.1%)
#>  8:               
#>  9:     64 (48.5%)
#> 10:     50 (37.9%)
#> 11:            114
#> 12:     68 (51.5%)
#> 13:               
#> 14:     74 (56.1%)
#> 15:     63 (47.7%)
#> 16:            137
#> 17:     76 (57.6%)
#> 18:               
#> 19:     65 (49.2%)
#> 20:             65
#> 21:     50 (37.9%)
#> 22:               
#> 23:     50 (37.9%)
#> 24:             50
#> 25:     36 (27.3%)
#> 26:               
#> 27:     57 (43.2%)
#> 28:             57
#> 29:     48 (36.4%)
#> 30:               
#> 31:     54 (40.9%)
#> 32:             54
#> 33:     36 (27.3%)
#>     C: Combination
#>             <char>
```
