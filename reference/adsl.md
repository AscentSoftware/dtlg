# Subject-Level Analysis Dataset (ADSL) example dataset

adsl is a re-export of the
[random.cdisc.data::cadsl](https://insightsengineering.github.io/random.cdisc.data/main/reference/cadsl.html)
dataset, included in `{dtlg}` for function usage illustration and
testing.

## Usage

``` r
adsl
```

## Format

An object of class `tbl_df` (inherits from `tbl`, `data.frame`) with 400
rows and 55 columns.

## Examples

``` r
adsl
#>      STUDYID               USUBJID SUBJID SITEID   AGE   AGEU    SEX
#>       <char>                <char> <char> <char> <int> <fctr> <fctr>
#>   1: AB12345  AB12345-CHN-3-id-128 id-128  CHN-3    32  YEARS      M
#>   2: AB12345 AB12345-CHN-15-id-262 id-262 CHN-15    35  YEARS      M
#>   3: AB12345  AB12345-RUS-3-id-378 id-378  RUS-3    30  YEARS      F
#>   4: AB12345 AB12345-CHN-11-id-220 id-220 CHN-11    26  YEARS      F
#>   5: AB12345  AB12345-CHN-7-id-267 id-267  CHN-7    40  YEARS      M
#>  ---                                                                
#> 396: AB12345 AB12345-CHN-16-id-352 id-352 CHN-16    28  YEARS      M
#> 397: AB12345  AB12345-CHN-1-id-186 id-186  CHN-1    27  YEARS      M
#> 398: AB12345  AB12345-CHN-1-id-371 id-371  CHN-1    28  YEARS      F
#> 399: AB12345  AB12345-CHN-1-id-233 id-233  CHN-1    36  YEARS      F
#> 400: AB12345 AB12345-USA-12-id-131 id-131 USA-12    44  YEARS      F
#>                                  RACE                 ETHNIC COUNTRY  DTHFL
#>                                <fctr>                 <fctr>  <fctr> <fctr>
#>   1:                            ASIAN     HISPANIC OR LATINO     CHN      Y
#>   2:        BLACK OR AFRICAN AMERICAN NOT HISPANIC OR LATINO     CHN      N
#>   3:                            ASIAN NOT HISPANIC OR LATINO     RUS      N
#>   4:                            ASIAN NOT HISPANIC OR LATINO     CHN      N
#>   5:                            ASIAN NOT HISPANIC OR LATINO     CHN      N
#>  ---                                                                       
#> 396:                            ASIAN                UNKNOWN     CHN      N
#> 397:                            ASIAN NOT HISPANIC OR LATINO     CHN      N
#> 398:                            ASIAN NOT HISPANIC OR LATINO     CHN      N
#> 399:        BLACK OR AFRICAN AMERICAN NOT HISPANIC OR LATINO     CHN      Y
#> 400: AMERICAN INDIAN OR ALASKA NATIVE NOT HISPANIC OR LATINO     USA      N
#>              INVID         INVNAM            ARM  ARMCD         ACTARM ACTARMCD
#>             <char>         <char>         <fctr> <fctr>         <fctr>   <fctr>
#>   1:  INV ID CHN-3  Dr. CHN-3 Doe      A: Drug X  ARM A      A: Drug X    ARM A
#>   2: INV ID CHN-15 Dr. CHN-15 Doe C: Combination  ARM C C: Combination    ARM C
#>   3:  INV ID RUS-3  Dr. RUS-3 Doe C: Combination  ARM C C: Combination    ARM C
#>   4: INV ID CHN-11 Dr. CHN-11 Doe     B: Placebo  ARM B     B: Placebo    ARM B
#>   5:  INV ID CHN-7  Dr. CHN-7 Doe     B: Placebo  ARM B     B: Placebo    ARM B
#>  ---                                                                           
#> 396: INV ID CHN-16 Dr. CHN-16 Doe C: Combination  ARM C C: Combination    ARM C
#> 397:  INV ID CHN-1  Dr. CHN-1 Doe     B: Placebo  ARM B     B: Placebo    ARM B
#> 398:  INV ID CHN-1  Dr. CHN-1 Doe      A: Drug X  ARM A      A: Drug X    ARM A
#> 399:  INV ID CHN-1  Dr. CHN-1 Doe C: Combination  ARM C C: Combination    ARM C
#> 400: INV ID USA-12 Dr. USA-12 Doe      A: Drug X  ARM A      A: Drug X    ARM A
#>              TRT01P         TRT01A         TRT02P         TRT02A       REGION1
#>              <fctr>         <fctr>         <fctr>         <fctr>        <fctr>
#>   1:      A: Drug X      A: Drug X     B: Placebo      A: Drug X          Asia
#>   2: C: Combination C: Combination     B: Placebo C: Combination          Asia
#>   3: C: Combination C: Combination      A: Drug X     B: Placebo       Eurasia
#>   4:     B: Placebo     B: Placebo     B: Placebo     B: Placebo          Asia
#>   5:     B: Placebo     B: Placebo C: Combination      A: Drug X          Asia
#>  ---                                                                          
#> 396: C: Combination C: Combination     B: Placebo     B: Placebo          Asia
#> 397:     B: Placebo     B: Placebo      A: Drug X C: Combination          Asia
#> 398:      A: Drug X      A: Drug X C: Combination     B: Placebo          Asia
#> 399: C: Combination C: Combination C: Combination     B: Placebo          Asia
#> 400:      A: Drug X      A: Drug X C: Combination      A: Drug X North America
#>      STRATA1 STRATA2    BMRKR1 BMRKR2  ITTFL  SAFFL BMEASIFL BEP01FL AEWITHFL
#>       <fctr>  <fctr>     <num> <fctr> <fctr> <fctr>   <fctr>  <fctr>   <fctr>
#>   1:       C      S2 14.424934 MEDIUM      Y      Y        Y       Y        N
#>   2:       C      S1  4.055463    LOW      Y      Y        N       N        Y
#>   3:       A      S1  2.803240   HIGH      Y      Y        Y       N        N
#>   4:       B      S2 10.262734 MEDIUM      Y      Y        Y       Y        N
#>   5:       C      S1  6.206763    LOW      Y      Y        N       N        N
#>  ---                                                                         
#> 396:       A      S2  4.216812 MEDIUM      Y      Y        N       Y        N
#> 397:       A      S2  4.521179   HIGH      Y      Y        Y       N        N
#> 398:       A      S2  6.326863    LOW      Y      Y        N       Y        N
#> 399:       C      S1  4.076818    LOW      Y      Y        N       Y        N
#> 400:       B      S1  3.726935    LOW      Y      Y        Y       N        N
#>          RANDDT             TRTSDTM             TRTEDTM           TRT01SDTM
#>          <Date>              <POSc>              <POSc>              <POSc>
#>   1: 2019-02-22 2019-02-24 11:09:25 2022-02-12 04:28:08 2019-02-24 11:09:25
#>   2: 2019-02-26 2019-02-26 09:05:10 2022-02-26 03:05:10 2019-02-26 09:05:10
#>   3: 2019-02-24 2019-02-28 03:19:22 2022-02-27 21:19:22 2019-02-28 03:19:22
#>   4: 2019-02-27 2019-03-01 13:33:19 2022-03-01 07:33:19 2019-03-01 13:33:19
#>   5: 2019-03-01 2019-03-02 00:09:33 2022-03-01 18:09:33 2019-03-02 00:09:33
#>  ---                                                                       
#> 396: 2021-01-30 2021-02-02 09:25:56 2024-02-03 03:25:56 2021-02-02 09:25:56
#> 397: 2021-01-30 2021-02-02 19:35:51 2024-02-03 13:35:51 2021-02-02 19:35:51
#> 398: 2021-02-07 2021-02-09 05:50:09 2024-02-09 23:50:09 2021-02-09 05:50:09
#> 399: 2021-02-09 2021-02-11 21:54:30 2022-02-15 19:43:12 2021-02-11 21:54:30
#> 400: 2021-02-14 2021-02-17 15:03:58 2024-02-18 09:03:58 2021-02-17 15:03:58
#>                TRT01EDTM           TRT02SDTM           TRT02EDTM
#>                   <POSc>              <POSc>              <POSc>
#>   1: 2021-02-11 22:28:08 2021-02-11 22:28:08 2022-02-12 04:28:08
#>   2: 2021-02-25 21:05:10 2021-02-25 21:05:10 2022-02-26 03:05:10
#>   3: 2021-02-27 15:19:22 2021-02-27 15:19:22 2022-02-27 21:19:22
#>   4: 2021-03-01 01:33:19 2021-03-01 01:33:19 2022-03-01 07:33:19
#>   5: 2021-03-01 12:09:33 2021-03-01 12:09:33 2022-03-01 18:09:33
#>  ---                                                            
#> 396: 2023-02-02 21:25:56 2023-02-02 21:25:56 2024-02-03 03:25:56
#> 397: 2023-02-03 07:35:51 2023-02-03 07:35:51 2024-02-03 13:35:51
#> 398: 2023-02-09 17:50:09 2023-02-09 17:50:09 2024-02-09 23:50:09
#> 399: 2021-02-15 13:43:12 2021-02-15 13:43:12 2022-02-15 19:43:12
#> 400: 2023-02-18 03:03:58 2023-02-18 03:03:58 2024-02-18 09:03:58
#>                 AP01SDTM            AP01EDTM            AP02SDTM
#>                   <POSc>              <POSc>              <POSc>
#>   1: 2019-02-24 11:09:25 2021-02-11 22:28:08 2021-02-11 22:28:08
#>   2: 2019-02-26 09:05:10 2021-02-25 21:05:10 2021-02-25 21:05:10
#>   3: 2019-02-28 03:19:22 2021-02-27 15:19:22 2021-02-27 15:19:22
#>   4: 2019-03-01 13:33:19 2021-03-01 01:33:19 2021-03-01 01:33:19
#>   5: 2019-03-02 00:09:33 2021-03-01 12:09:33 2021-03-01 12:09:33
#>  ---                                                            
#> 396: 2021-02-02 09:25:56 2023-02-02 21:25:56 2023-02-02 21:25:56
#> 397: 2021-02-02 19:35:51 2023-02-03 07:35:51 2023-02-03 07:35:51
#> 398: 2021-02-09 05:50:09 2023-02-09 17:50:09 2023-02-09 17:50:09
#> 399: 2021-02-11 21:54:30 2021-02-15 13:43:12 2021-02-15 13:43:12
#> 400: 2021-02-17 15:03:58 2023-02-18 03:03:58 2023-02-18 03:03:58
#>                 AP02EDTM       EOSSTT       EOTSTT      EOSDT EOSDY DCSREAS
#>                   <POSc>       <fctr>       <fctr>     <Date> <int>  <fctr>
#>   1: 2022-02-12 04:28:08 DISCONTINUED DISCONTINUED 2022-02-12  1084   DEATH
#>   2: 2022-02-26 03:05:10    COMPLETED    COMPLETED 2022-02-26  1096    <NA>
#>   3: 2022-02-27 21:19:22    COMPLETED    COMPLETED 2022-02-27  1096    <NA>
#>   4: 2022-03-01 07:33:19    COMPLETED    COMPLETED 2022-03-01  1096    <NA>
#>   5: 2022-03-01 18:09:33    COMPLETED    COMPLETED 2022-03-01  1096    <NA>
#>  ---                                                                       
#> 396: 2024-02-03 03:25:56    COMPLETED    COMPLETED 2024-02-03  1096    <NA>
#> 397: 2024-02-03 13:35:51    COMPLETED    COMPLETED 2024-02-03  1096    <NA>
#> 398: 2024-02-09 23:50:09    COMPLETED    COMPLETED 2024-02-09  1096    <NA>
#> 399: 2022-02-15 19:43:12 DISCONTINUED DISCONTINUED 2022-02-15   369   DEATH
#> 400: 2024-02-18 09:03:58    COMPLETED    COMPLETED 2024-02-18  1096    <NA>
#>           DTHDT       DTHCAUS        DTHCAT LDDTHELD LDDTHGR1   LSTALVDT DTHADY
#>          <Date>        <fctr>        <fctr>    <int>   <fctr>     <Date>  <int>
#>   1: 2022-03-06 ADVERSE EVENT ADVERSE EVENT       22     <=30 2022-03-06   1105
#>   2:       <NA>          <NA>          <NA>       NA     <NA> 2022-03-17     NA
#>   3:       <NA>          <NA>          <NA>       NA     <NA> 2022-03-11     NA
#>   4:       <NA>          <NA>          <NA>       NA     <NA> 2022-03-26     NA
#>   5:       <NA>          <NA>          <NA>       NA     <NA> 2022-03-15     NA
#>  ---                                                                           
#> 396:       <NA>          <NA>          <NA>       NA     <NA> 2024-02-14     NA
#> 397:       <NA>          <NA>          <NA>       NA     <NA> 2024-02-18     NA
#> 398:       <NA>          <NA>          <NA>       NA     <NA> 2024-02-29     NA
#> 399: 2022-03-25       MISSING         OTHER       38      >30 2022-03-25    406
#> 400:       <NA>          <NA>          <NA>       NA     <NA> 2024-03-07     NA
#>      ADTHAUT
#>       <fctr>
#>   1:     Yes
#>   2:    <NA>
#>   3:    <NA>
#>   4:    <NA>
#>   5:    <NA>
#>  ---        
#> 396:    <NA>
#> 397:    <NA>
#> 398:    <NA>
#> 399:    <NA>
#> 400:    <NA>
```
