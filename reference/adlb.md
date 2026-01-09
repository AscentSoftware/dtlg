# ADaM Basic Data Structure (BDS) example dataset

adlb is a re-export of the
[random.cdisc.data::cadlb](https://insightsengineering.github.io/random.cdisc.data/main/reference/cadlb.html)
dataset, included in `{dtlg}` for function usage illustration and
testing.

## Usage

``` r
adlb
```

## Format

An object of class `data.table` (inherits from `data.frame`) with 8400
rows and 102 columns.

## Examples

``` r
adlb
#>       STUDYID              USUBJID SUBJID SITEID   AGE   AGEU    SEX
#>        <char>               <char> <char> <char> <int> <fctr> <fctr>
#>    1: AB12345 AB12345-BRA-1-id-105 id-105  BRA-1    38  YEARS      M
#>    2: AB12345 AB12345-BRA-1-id-105 id-105  BRA-1    38  YEARS      M
#>    3: AB12345 AB12345-BRA-1-id-105 id-105  BRA-1    38  YEARS      M
#>    4: AB12345 AB12345-BRA-1-id-105 id-105  BRA-1    38  YEARS      M
#>    5: AB12345 AB12345-BRA-1-id-105 id-105  BRA-1    38  YEARS      M
#>   ---                                                               
#> 8396: AB12345 AB12345-USA-8-id-206 id-206  USA-8    34  YEARS      F
#> 8397: AB12345 AB12345-USA-8-id-206 id-206  USA-8    34  YEARS      F
#> 8398: AB12345 AB12345-USA-8-id-206 id-206  USA-8    34  YEARS      F
#> 8399: AB12345 AB12345-USA-8-id-206 id-206  USA-8    34  YEARS      F
#> 8400: AB12345 AB12345-USA-8-id-206 id-206  USA-8    34  YEARS      F
#>                            RACE                 ETHNIC COUNTRY  DTHFL
#>                          <fctr>                 <fctr>  <fctr> <fctr>
#>    1: BLACK OR AFRICAN AMERICAN     HISPANIC OR LATINO     BRA      N
#>    2: BLACK OR AFRICAN AMERICAN     HISPANIC OR LATINO     BRA      N
#>    3: BLACK OR AFRICAN AMERICAN     HISPANIC OR LATINO     BRA      N
#>    4: BLACK OR AFRICAN AMERICAN     HISPANIC OR LATINO     BRA      N
#>    5: BLACK OR AFRICAN AMERICAN     HISPANIC OR LATINO     BRA      N
#>   ---                                                                
#> 8396:                     ASIAN NOT HISPANIC OR LATINO     USA      N
#> 8397:                     ASIAN NOT HISPANIC OR LATINO     USA      N
#> 8398:                     ASIAN NOT HISPANIC OR LATINO     USA      N
#> 8399:                     ASIAN NOT HISPANIC OR LATINO     USA      N
#> 8400:                     ASIAN NOT HISPANIC OR LATINO     USA      N
#>              INVID        INVNAM            ARM  ARMCD         ACTARM ACTARMCD
#>             <char>        <char>         <fctr> <fctr>         <fctr>   <fctr>
#>    1: INV ID BRA-1 Dr. BRA-1 Doe      A: Drug X  ARM A      A: Drug X    ARM A
#>    2: INV ID BRA-1 Dr. BRA-1 Doe      A: Drug X  ARM A      A: Drug X    ARM A
#>    3: INV ID BRA-1 Dr. BRA-1 Doe      A: Drug X  ARM A      A: Drug X    ARM A
#>    4: INV ID BRA-1 Dr. BRA-1 Doe      A: Drug X  ARM A      A: Drug X    ARM A
#>    5: INV ID BRA-1 Dr. BRA-1 Doe      A: Drug X  ARM A      A: Drug X    ARM A
#>   ---                                                                         
#> 8396: INV ID USA-8 Dr. USA-8 Doe C: Combination  ARM C C: Combination    ARM C
#> 8397: INV ID USA-8 Dr. USA-8 Doe C: Combination  ARM C C: Combination    ARM C
#> 8398: INV ID USA-8 Dr. USA-8 Doe C: Combination  ARM C C: Combination    ARM C
#> 8399: INV ID USA-8 Dr. USA-8 Doe C: Combination  ARM C C: Combination    ARM C
#> 8400: INV ID USA-8 Dr. USA-8 Doe C: Combination  ARM C C: Combination    ARM C
#>               TRT01P         TRT01A         TRT02P         TRT02A       REGION1
#>               <fctr>         <fctr>         <fctr>         <fctr>        <fctr>
#>    1:      A: Drug X      A: Drug X C: Combination      A: Drug X South America
#>    2:      A: Drug X      A: Drug X C: Combination      A: Drug X South America
#>    3:      A: Drug X      A: Drug X C: Combination      A: Drug X South America
#>    4:      A: Drug X      A: Drug X C: Combination      A: Drug X South America
#>    5:      A: Drug X      A: Drug X C: Combination      A: Drug X South America
#>   ---                                                                          
#> 8396: C: Combination C: Combination     B: Placebo C: Combination North America
#> 8397: C: Combination C: Combination     B: Placebo C: Combination North America
#> 8398: C: Combination C: Combination     B: Placebo C: Combination North America
#> 8399: C: Combination C: Combination     B: Placebo C: Combination North America
#> 8400: C: Combination C: Combination     B: Placebo C: Combination North America
#>       STRATA1 STRATA2    BMRKR1 BMRKR2  ITTFL  SAFFL BMEASIFL BEP01FL AEWITHFL
#>        <fctr>  <fctr>     <num> <fctr> <fctr> <fctr>   <fctr>  <fctr>   <fctr>
#>    1:       B      S1  4.156914 MEDIUM      Y      Y        Y       Y        N
#>    2:       B      S1  4.156914 MEDIUM      Y      Y        Y       Y        N
#>    3:       B      S1  4.156914 MEDIUM      Y      Y        Y       Y        N
#>    4:       B      S1  4.156914 MEDIUM      Y      Y        Y       Y        N
#>    5:       B      S1  4.156914 MEDIUM      Y      Y        Y       Y        N
#>   ---                                                                         
#> 8396:       B      S1 14.478057   HIGH      Y      Y        Y       Y        N
#> 8397:       B      S1 14.478057   HIGH      Y      Y        Y       Y        N
#> 8398:       B      S1 14.478057   HIGH      Y      Y        Y       Y        N
#> 8399:       B      S1 14.478057   HIGH      Y      Y        Y       Y        N
#> 8400:       B      S1 14.478057   HIGH      Y      Y        Y       Y        N
#>           RANDDT             TRTSDTM             TRTEDTM           TRT01SDTM
#>           <Date>              <POSc>              <POSc>              <POSc>
#>    1: 2020-03-08 2020-03-08 05:39:28 2022-02-14 20:58:26 2020-03-08 05:39:28
#>    2: 2020-03-08 2020-03-08 05:39:28 2022-02-14 20:58:26 2020-03-08 05:39:28
#>    3: 2020-03-08 2020-03-08 05:39:28 2022-02-14 20:58:26 2020-03-08 05:39:28
#>    4: 2020-03-08 2020-03-08 05:39:28 2022-02-14 20:58:26 2020-03-08 05:39:28
#>    5: 2020-03-08 2020-03-08 05:39:28 2022-02-14 20:58:26 2020-03-08 05:39:28
#>   ---                                                                       
#> 8396: 2019-07-19 2019-07-22 10:23:30 2022-07-22 04:23:30 2019-07-22 10:23:30
#> 8397: 2019-07-19 2019-07-22 10:23:30 2022-07-22 04:23:30 2019-07-22 10:23:30
#> 8398: 2019-07-19 2019-07-22 10:23:30 2022-07-22 04:23:30 2019-07-22 10:23:30
#> 8399: 2019-07-19 2019-07-22 10:23:30 2022-07-22 04:23:30 2019-07-22 10:23:30
#> 8400: 2019-07-19 2019-07-22 10:23:30 2022-07-22 04:23:30 2019-07-22 10:23:30
#>                 TRT01EDTM           TRT02SDTM           TRT02EDTM
#>                    <POSc>              <POSc>              <POSc>
#>    1: 2021-02-14 14:58:26 2021-02-14 14:58:26 2022-02-14 20:58:26
#>    2: 2021-02-14 14:58:26 2021-02-14 14:58:26 2022-02-14 20:58:26
#>    3: 2021-02-14 14:58:26 2021-02-14 14:58:26 2022-02-14 20:58:26
#>    4: 2021-02-14 14:58:26 2021-02-14 14:58:26 2022-02-14 20:58:26
#>    5: 2021-02-14 14:58:26 2021-02-14 14:58:26 2022-02-14 20:58:26
#>   ---                                                            
#> 8396: 2021-07-21 22:23:30 2021-07-21 22:23:30 2022-07-22 04:23:30
#> 8397: 2021-07-21 22:23:30 2021-07-21 22:23:30 2022-07-22 04:23:30
#> 8398: 2021-07-21 22:23:30 2021-07-21 22:23:30 2022-07-22 04:23:30
#> 8399: 2021-07-21 22:23:30 2021-07-21 22:23:30 2022-07-22 04:23:30
#> 8400: 2021-07-21 22:23:30 2021-07-21 22:23:30 2022-07-22 04:23:30
#>                  AP01SDTM            AP01EDTM            AP02SDTM
#>                    <POSc>              <POSc>              <POSc>
#>    1: 2020-03-08 05:39:28 2021-02-14 14:58:26 2021-02-14 14:58:26
#>    2: 2020-03-08 05:39:28 2021-02-14 14:58:26 2021-02-14 14:58:26
#>    3: 2020-03-08 05:39:28 2021-02-14 14:58:26 2021-02-14 14:58:26
#>    4: 2020-03-08 05:39:28 2021-02-14 14:58:26 2021-02-14 14:58:26
#>    5: 2020-03-08 05:39:28 2021-02-14 14:58:26 2021-02-14 14:58:26
#>   ---                                                            
#> 8396: 2019-07-22 10:23:30 2021-07-21 22:23:30 2021-07-21 22:23:30
#> 8397: 2019-07-22 10:23:30 2021-07-21 22:23:30 2021-07-21 22:23:30
#> 8398: 2019-07-22 10:23:30 2021-07-21 22:23:30 2021-07-21 22:23:30
#> 8399: 2019-07-22 10:23:30 2021-07-21 22:23:30 2021-07-21 22:23:30
#> 8400: 2019-07-22 10:23:30 2021-07-21 22:23:30 2021-07-21 22:23:30
#>                  AP02EDTM       EOSSTT       EOTSTT      EOSDT EOSDY
#>                    <POSc>       <fctr>       <fctr>     <Date> <int>
#>    1: 2022-02-14 20:58:26 DISCONTINUED DISCONTINUED 2022-02-14   709
#>    2: 2022-02-14 20:58:26 DISCONTINUED DISCONTINUED 2022-02-14   709
#>    3: 2022-02-14 20:58:26 DISCONTINUED DISCONTINUED 2022-02-14   709
#>    4: 2022-02-14 20:58:26 DISCONTINUED DISCONTINUED 2022-02-14   709
#>    5: 2022-02-14 20:58:26 DISCONTINUED DISCONTINUED 2022-02-14   709
#>   ---                                                               
#> 8396: 2022-07-22 04:23:30    COMPLETED    COMPLETED 2022-07-22  1096
#> 8397: 2022-07-22 04:23:30    COMPLETED    COMPLETED 2022-07-22  1096
#> 8398: 2022-07-22 04:23:30    COMPLETED    COMPLETED 2022-07-22  1096
#> 8399: 2022-07-22 04:23:30    COMPLETED    COMPLETED 2022-07-22  1096
#> 8400: 2022-07-22 04:23:30    COMPLETED    COMPLETED 2022-07-22  1096
#>                  DCSREAS  DTHDT DTHCAUS DTHCAT LDDTHELD LDDTHGR1   LSTALVDT
#>                   <fctr> <Date>  <fctr> <fctr>    <int>   <fctr>     <Date>
#>    1: PROTOCOL VIOLATION   <NA>    <NA>   <NA>       NA     <NA> 2022-03-09
#>    2: PROTOCOL VIOLATION   <NA>    <NA>   <NA>       NA     <NA> 2022-03-09
#>    3: PROTOCOL VIOLATION   <NA>    <NA>   <NA>       NA     <NA> 2022-03-09
#>    4: PROTOCOL VIOLATION   <NA>    <NA>   <NA>       NA     <NA> 2022-03-09
#>    5: PROTOCOL VIOLATION   <NA>    <NA>   <NA>       NA     <NA> 2022-03-09
#>   ---                                                                      
#> 8396:               <NA>   <NA>    <NA>   <NA>       NA     <NA> 2022-08-07
#> 8397:               <NA>   <NA>    <NA>   <NA>       NA     <NA> 2022-08-07
#> 8398:               <NA>   <NA>    <NA>   <NA>       NA     <NA> 2022-08-07
#> 8399:               <NA>   <NA>    <NA>   <NA>       NA     <NA> 2022-08-07
#> 8400:               <NA>   <NA>    <NA>   <NA>       NA     <NA> 2022-08-07
#>       DTHADY ADTHAUT  ASEQ LBSEQ LBTESTCD                               LBTEST
#>        <int>  <fctr> <int> <int>   <fctr>                               <fctr>
#>    1:     NA    <NA>     1     1      ALT Alanine Aminotransferase Measurement
#>    2:     NA    <NA>     4     4      ALT Alanine Aminotransferase Measurement
#>    3:     NA    <NA>     7     7      ALT Alanine Aminotransferase Measurement
#>    4:     NA    <NA>    10    10      ALT Alanine Aminotransferase Measurement
#>    5:     NA    <NA>    13    13      ALT Alanine Aminotransferase Measurement
#>   ---                                                                         
#> 8396:     NA    <NA>     9     9      IGA         Immunoglobulin A Measurement
#> 8397:     NA    <NA>    12    12      IGA         Immunoglobulin A Measurement
#> 8398:     NA    <NA>    15    15      IGA         Immunoglobulin A Measurement
#> 8399:     NA    <NA>    18    18      IGA         Immunoglobulin A Measurement
#> 8400:     NA    <NA>    21    21      IGA         Immunoglobulin A Measurement
#>            LBCAT LBSTRESC ASPID                                PARAM PARAMCD
#>           <fctr>   <char> <int>                               <fctr>  <fctr>
#>    1:  CHEMISTRY       <7  6364 Alanine Aminotransferase Measurement     ALT
#>    2:  CHEMISTRY       <7  1658 Alanine Aminotransferase Measurement     ALT
#>    3:  CHEMISTRY       <7  7407 Alanine Aminotransferase Measurement     ALT
#>    4:  CHEMISTRY       <7  7315 Alanine Aminotransferase Measurement     ALT
#>    5:  CHEMISTRY       <7  1986 Alanine Aminotransferase Measurement     ALT
#>   ---                                                                       
#> 8396: IMMUNOLOGY       >3  2272         Immunoglobulin A Measurement     IGA
#> 8397: IMMUNOLOGY       >3  7143         Immunoglobulin A Measurement     IGA
#> 8398: IMMUNOLOGY       >3  4733         Immunoglobulin A Measurement     IGA
#> 8399: IMMUNOLOGY       >3  2104         Immunoglobulin A Measurement     IGA
#> 8400: IMMUNOLOGY       >3  6942         Immunoglobulin A Measurement     IGA
#>            AVAL  AVALU    BASE2      BASE BASETYPE ABLFL2  ABLFL         CHG2
#>           <num> <fctr>    <num>     <num>   <fctr> <fctr> <fctr>        <num>
#>    1:  4.297921    U/L 4.297921        NA     LAST      Y         0.000000000
#>    2: 24.695882    U/L 4.297921 24.695882     LAST             Y 20.397960615
#>    3: 24.872255    U/L 4.297921 24.695882     LAST               20.574333510
#>    4:  3.666809    U/L 4.297921 24.695882     LAST               -0.631111790
#>    5: 18.548449    U/L 4.297921 24.695882     LAST               14.250527824
#>   ---                                                                        
#> 8396:  2.758459    g/L 2.955814  3.076949     LAST               -0.197354442
#> 8397:  2.739585    g/L 2.955814  3.076949     LAST               -0.216228534
#> 8398:  2.946323    g/L 2.955814  3.076949     LAST               -0.009491096
#> 8399:  2.966002    g/L 2.955814  3.076949     LAST                0.010187788
#> 8400:  2.710396    g/L 2.955814  3.076949     LAST               -0.245418028
#>             PCHG2         CHG        PCHG  DTYPE ANRIND BNRIND           SHIFT1
#>             <num>       <num>       <num> <lgcl> <fctr> <fctr>           <fctr>
#>    1:   0.0000000          NA          NA     NA    LOW NORMAL                 
#>    2: 474.6006162   0.0000000   0.0000000     NA NORMAL NORMAL                 
#>    3: 478.7042953   0.1763729   0.7141794     NA NORMAL NORMAL NORMAL to NORMAL
#>    4: -14.6841172 -21.0290724 -85.1521421     NA    LOW NORMAL    NORMAL to LOW
#>    5: 331.5679157  -6.1474328 -24.8925421     NA NORMAL NORMAL NORMAL to NORMAL
#>   ---                                                                          
#> 8396:  -6.6768223  -0.3184894 -10.3508191     NA NORMAL   HIGH   HIGH to NORMAL
#> 8397:  -7.3153635  -0.3373635 -10.9642219     NA NORMAL   HIGH   HIGH to NORMAL
#> 8398:  -0.3210992  -0.1306261  -4.2453116     NA NORMAL   HIGH   HIGH to NORMAL
#> 8399:   0.3446695  -0.1109472  -3.6057532     NA NORMAL   HIGH   HIGH to NORMAL
#> 8400:  -8.3028917  -0.3665530 -11.9128725     NA NORMAL   HIGH   HIGH to NORMAL
#>       ATOXGR BTOXGR                ADTM   ADY ATPTN        AVISIT AVISITN
#>       <fctr> <fctr>              <POSc> <int> <int>        <fctr>   <int>
#>    1:     -4      0 2020-05-27 05:39:28    80     1     SCREENING      -1
#>    2:      0      0 2020-08-04 05:39:28   149     1      BASELINE       0
#>    3:      0      0 2021-01-16 05:39:28   314     1  WEEK 1 DAY 8       1
#>    4:     -3      0 2021-04-10 05:39:28   398     1 WEEK 2 DAY 15       2
#>    5:      0      0 2021-06-21 05:39:28   470     1 WEEK 3 DAY 22       3
#>   ---                                                                    
#> 8396:      0      3 2020-01-30 10:23:30   192     1  WEEK 1 DAY 8       1
#> 8397:      0      3 2020-02-26 10:23:30   219     1 WEEK 2 DAY 15       2
#> 8398:      0      3 2020-09-24 10:23:30   430     1 WEEK 3 DAY 22       3
#> 8399:      0      3 2021-07-29 10:23:30   738     1 WEEK 4 DAY 29       4
#> 8400:      0      3 2021-10-29 10:23:30   830     1 WEEK 5 DAY 36       5
#>        LOQFL ONTRTFL WORS01FL WGRHIFL WGRLOFL WGRHIVFL WGRLOVFL ANL01FL ANRLO
#>       <fctr>  <fctr>   <fctr>  <fctr>  <fctr>   <fctr>   <fctr>  <fctr> <num>
#>    1:      Y                                                              7.0
#>    2:      N                                                          Y   7.0
#>    3:      N       Y        Y       Y                Y        Y       Y   7.0
#>    4:      Y       Y        Y               Y        Y        Y       Y   7.0
#>    5:      N       Y        Y                        Y        Y       Y   7.0
#>   ---                                                                        
#> 8396:      N       Y        Y       Y       Y        Y        Y       Y   0.8
#> 8397:      N       Y        Y                        Y        Y       Y   0.8
#> 8398:      N       Y        Y                        Y        Y       Y   0.8
#> 8399:      N       Y        Y                        Y        Y       Y   0.8
#> 8400:      N       Y        Y                        Y        Y       Y   0.8
#>       ANRHI   BTOXGRL BTOXGRH ATOXGRL   ATOXGRH ATOXDSCL
#>       <num>    <fctr>  <fctr>  <fctr>    <fctr>   <char>
#>    1:    55         0       0       4 <Missing>     <NA>
#>    2:    55         0       0       0         0     <NA>
#>    3:    55         0       0       0         0     <NA>
#>    4:    55         0       0       3 <Missing>     <NA>
#>    5:    55         0       0       0         0     <NA>
#>   ---                                                   
#> 8396:     3 <Missing>       3       0         0     <NA>
#> 8397:     3 <Missing>       3       0         0     <NA>
#> 8398:     3 <Missing>       3       0         0     <NA>
#> 8399:     3 <Missing>       3       0         0     <NA>
#> 8400:     3 <Missing>       3       0         0     <NA>
#>                                 ATOXDSCH
#>                                   <char>
#>    1: Alanine aminotransferase increased
#>    2: Alanine aminotransferase increased
#>    3: Alanine aminotransferase increased
#>    4: Alanine aminotransferase increased
#>    5: Alanine aminotransferase increased
#>   ---                                   
#> 8396:         Immunoglobulin A increased
#> 8397:         Immunoglobulin A increased
#> 8398:         Immunoglobulin A increased
#> 8399:         Immunoglobulin A increased
#> 8400:         Immunoglobulin A increased
```
