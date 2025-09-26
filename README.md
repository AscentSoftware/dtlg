
# dtlg

<!-- badges: start -->

[![](https://www.r-pkg.org/badges/version/dtlg)](https://cran.r-project.org/package=dtlg)
[![R-CMD-check](https://github.com/AscentSoftware/dtlg/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/AscentSoftware/dtlg/actions/workflows/R-CMD-check.yaml)
[![License:
MIT](https://img.shields.io/badge/license-MIT-blue.svg)](https://cran.r-project.org/web/licenses/MIT)
[![](http://cranlogs.r-pkg.org/badges/last-month/dtlg)](https://cran.r-project.org/package=dtlg)
<!-- badges: end -->

Create high-performance clinical reporting tables (TLGs) from ADaM-like
inputs. The package provides a consistent, programmatic API to generate
common tables such as demographics, adverse event incidence, and
laboratory summaries, using ‘data.table’ for fast aggregation over large
populations. Functions support flexible target-variable selection,
stratification by treatment, and customizable summary statistics, and
return tidy, machine-readable results ready to render with downstream
table/formatting packages in analysis pipelines.

## Installation

``` r
install.packages("dtlg")
```

## Example

Creating an AET01 table:

``` r
library(dtlg)

head(adsl[, c("USUBJID", "ARM")])
#>                 USUBJID            ARM
#> 1  AB12345-CHN-3-id-128      A: Drug X
#> 2 AB12345-CHN-15-id-262 C: Combination
#> 3  AB12345-RUS-3-id-378 C: Combination
#> 4 AB12345-CHN-11-id-220     B: Placebo
#> 5  AB12345-CHN-7-id-267     B: Placebo
#> 6 AB12345-CHN-15-id-201 C: Combination

head(aesi[, c("USUBJID", "ARM", "FATAL")])
#>                 USUBJID            ARM  FATAL
#>                  <char>         <fctr> <lgcl>
#> 1: AB12345-BRA-1-id-134      A: Drug X  FALSE
#> 2: AB12345-BRA-1-id-134      A: Drug X  FALSE
#> 3: AB12345-BRA-1-id-134      A: Drug X  FALSE
#> 4: AB12345-BRA-1-id-134      A: Drug X   TRUE
#> 5: AB12345-BRA-1-id-141 C: Combination  FALSE
#> 6: AB12345-BRA-1-id-141 C: Combination  FALSE

AET01 <-
  AET01_table(
    adsl = adsl,
    adae = aesi,
    patient_var = "USUBJID",
    treat_var = "ARM",
    aesi_vars = c("FATAL", "SER", "SERWD", "SERDSM", "RELSER",
                  "WD", "DSM", "REL", "RELWD", "RELDSM", "SEV")
  )

AET01[, stats := strtrim(stats, 35)][]
#>                                   stats   A: Drug X B: Placebo C: Combination
#>                                  <char>      <char>     <char>         <char>
#>  1: Total number of patients with at le 100 (74.6%) 98 (73.1%)    103 (78.0%)
#>  2:                 Total number of AEs         502        480            604
#>  3:              Total number of deaths  25 (18.7%) 23 (17.2%)     22 (16.7%)
#>  4: Total number of patients withdrawn     3 (2.2%)   6 (4.5%)       5 (3.8%)
#>  5: Total number of patients with at le                                      
#>  6:               AE with fatal outcome    5 (3.7%)   5 (3.7%)       6 (4.5%)
#>  7:                          Serious AE  85 (63.4%) 80 (59.7%)     87 (65.9%)
#>  8:   Serious AE leading to withdrawal     6 (4.5%)  12 (9.0%)       9 (6.8%)
#>  9:   Serious AE leading to dose modifi  36 (26.9%) 40 (29.9%)     47 (35.6%)
#> 10:                  Related Serious AE  64 (47.8%) 52 (38.8%)     64 (48.5%)
#> 11:   AE leading to withdrawal from tre  20 (14.9%) 24 (17.9%)     26 (19.7%)
#> 12:   AE leading to dose modification/i  63 (47.0%) 70 (52.2%)     77 (58.3%)
#> 13:                          Related AE  86 (64.2%) 85 (63.4%)     92 (69.7%)
#> 14:   Related AE leading to withdrawal    10 (7.5%)   9 (6.7%)      12 (9.1%)
#> 15:   Related AE leading to dose modifi  44 (32.8%) 44 (32.8%)     51 (38.6%)
#> 16:   Severe AE (at greatest intensity)  77 (57.5%) 70 (52.2%)     79 (59.8%)
```
