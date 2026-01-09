# Adverse Event Analysis Dataset example dataset

adae is a re-export of the
[random.cdisc.data::cadae](https://insightsengineering.github.io/random.cdisc.data/main/reference/cadae.html)
dataset, included in `{dtlg}` for function usage illustration and
testing.

## Usage

``` r
adae
```

## Format

An object of class `tbl_df` (inherits from `tbl`, `data.frame`) with
1934 rows and 92 columns.

## Examples

``` r
adae
#> # A tibble: 1,934 × 92
#>    STUDYID USUBJID    SUBJID SITEID   AGE AGEU  SEX   RACE  ETHNIC COUNTRY DTHFL
#>    <chr>   <chr>      <chr>  <chr>  <int> <fct> <fct> <fct> <fct>  <fct>   <fct>
#>  1 AB12345 AB12345-B… id-134 BRA-1     47 YEARS M     WHITE NOT H… BRA     Y    
#>  2 AB12345 AB12345-B… id-134 BRA-1     47 YEARS M     WHITE NOT H… BRA     Y    
#>  3 AB12345 AB12345-B… id-134 BRA-1     47 YEARS M     WHITE NOT H… BRA     Y    
#>  4 AB12345 AB12345-B… id-134 BRA-1     47 YEARS M     WHITE NOT H… BRA     Y    
#>  5 AB12345 AB12345-B… id-141 BRA-1     35 YEARS F     WHITE NOT H… BRA     N    
#>  6 AB12345 AB12345-B… id-141 BRA-1     35 YEARS F     WHITE NOT H… BRA     N    
#>  7 AB12345 AB12345-B… id-141 BRA-1     35 YEARS F     WHITE NOT H… BRA     N    
#>  8 AB12345 AB12345-B… id-141 BRA-1     35 YEARS F     WHITE NOT H… BRA     N    
#>  9 AB12345 AB12345-B… id-141 BRA-1     35 YEARS F     WHITE NOT H… BRA     N    
#> 10 AB12345 AB12345-B… id-141 BRA-1     35 YEARS F     WHITE NOT H… BRA     N    
#> # ℹ 1,924 more rows
#> # ℹ 81 more variables: INVID <chr>, INVNAM <chr>, ARM <fct>, ARMCD <fct>,
#> #   ACTARM <fct>, ACTARMCD <fct>, TRT01P <fct>, TRT01A <fct>, TRT02P <fct>,
#> #   TRT02A <fct>, REGION1 <fct>, STRATA1 <fct>, STRATA2 <fct>, BMRKR1 <dbl>,
#> #   BMRKR2 <fct>, ITTFL <fct>, SAFFL <fct>, BMEASIFL <fct>, BEP01FL <fct>,
#> #   AEWITHFL <fct>, RANDDT <date>, TRTSDTM <dttm>, TRTEDTM <dttm>,
#> #   TRT01SDTM <dttm>, TRT01EDTM <dttm>, TRT02SDTM <dttm>, TRT02EDTM <dttm>, …
```
