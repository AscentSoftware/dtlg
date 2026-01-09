# Adverse Events of Special Interest (AESI) example dataset

aesi is a modified version of the
[random.cdisc.data::cadae](https://insightsengineering.github.io/random.cdisc.data/main/reference/cadae.html)
dataset, filtered to include only analysis-flagged records
(`ANL01FL == "Y"`) and extended with binary indicator variables
corresponding to adverse events of special interest (AESIs).

## Usage

``` r
aesi
```

## Format

A `data.frame` with a subset of rows from `cadae` and additional derived
columns including:

- FATAL:

  Logical flag for fatal AEs (`AESDTH == "Y"`).

- SEV:

  Logical flag for severe AEs (`AESEV == "SEVERE"`).

- SER:

  Logical flag for serious AEs (`AESER == "Y"`).

- SERWD:

  Serious AE leading to withdrawal
  (`AESER == "Y" & AEACN == "DRUG WITHDRAWN"`).

- SERDSM:

  Serious AE leading to dose modification/interruption.

- RELSER:

  Serious and related AE.

- WD:

  AE leading to withdrawal.

- DSM:

  AE leading to dose modification/interruption.

- REL:

  Related AE.

- RELWD:

  Related AE leading to withdrawal.

- RELDSM:

  Related AE leading to dose modification/interruption.

## Details

These derived flags include seriousness, severity, fatality,
relatedness, and treatment consequence (e.g., dose modification or
withdrawal), and are used to illustrate key safety summaries in clinical
reporting.

Each derived variable is labeled using
[`with_label()`](https://AscentSoftware.github.io/dtlg/reference/with_label.md)
for compatibility with tabulation functions.

This dataset is included in `{dtlg}` to support function testing, usage
examples, and reproducible safety analyses.

## See also

[random.cdisc.data::cadae](https://insightsengineering.github.io/random.cdisc.data/main/reference/cadae.html),
[`multi_event_true()`](https://AscentSoftware.github.io/dtlg/reference/multi_event_true.md)

## Examples

``` r
aesi
#>       STUDYID              USUBJID SUBJID SITEID   AGE   AGEU    SEX   RACE
#>        <char>               <char> <char> <char> <int> <fctr> <fctr> <fctr>
#>    1: AB12345 AB12345-BRA-1-id-134 id-134  BRA-1    47  YEARS      M  WHITE
#>    2: AB12345 AB12345-BRA-1-id-134 id-134  BRA-1    47  YEARS      M  WHITE
#>    3: AB12345 AB12345-BRA-1-id-134 id-134  BRA-1    47  YEARS      M  WHITE
#>    4: AB12345 AB12345-BRA-1-id-134 id-134  BRA-1    47  YEARS      M  WHITE
#>    5: AB12345 AB12345-BRA-1-id-141 id-141  BRA-1    35  YEARS      F  WHITE
#>   ---                                                                      
#> 1582: AB12345 AB12345-USA-8-id-206 id-206  USA-8    34  YEARS      F  ASIAN
#> 1583: AB12345 AB12345-USA-8-id-206 id-206  USA-8    34  YEARS      F  ASIAN
#> 1584: AB12345 AB12345-USA-9-id-130 id-130  USA-9    40  YEARS      M  ASIAN
#> 1585: AB12345 AB12345-USA-9-id-130 id-130  USA-9    40  YEARS      M  ASIAN
#> 1586: AB12345 AB12345-USA-9-id-130 id-130  USA-9    40  YEARS      M  ASIAN
#>                       ETHNIC COUNTRY  DTHFL        INVID        INVNAM
#>                       <fctr>  <fctr> <fctr>       <char>        <char>
#>    1: NOT HISPANIC OR LATINO     BRA      Y INV ID BRA-1 Dr. BRA-1 Doe
#>    2: NOT HISPANIC OR LATINO     BRA      Y INV ID BRA-1 Dr. BRA-1 Doe
#>    3: NOT HISPANIC OR LATINO     BRA      Y INV ID BRA-1 Dr. BRA-1 Doe
#>    4: NOT HISPANIC OR LATINO     BRA      Y INV ID BRA-1 Dr. BRA-1 Doe
#>    5: NOT HISPANIC OR LATINO     BRA      N INV ID BRA-1 Dr. BRA-1 Doe
#>   ---                                                                 
#> 1582: NOT HISPANIC OR LATINO     USA      N INV ID USA-8 Dr. USA-8 Doe
#> 1583: NOT HISPANIC OR LATINO     USA      N INV ID USA-8 Dr. USA-8 Doe
#> 1584: NOT HISPANIC OR LATINO     USA      N INV ID USA-9 Dr. USA-9 Doe
#> 1585: NOT HISPANIC OR LATINO     USA      N INV ID USA-9 Dr. USA-9 Doe
#> 1586: NOT HISPANIC OR LATINO     USA      N INV ID USA-9 Dr. USA-9 Doe
#>                  ARM  ARMCD         ACTARM ACTARMCD         TRT01P
#>               <fctr> <fctr>         <fctr>   <fctr>         <fctr>
#>    1:      A: Drug X  ARM A      A: Drug X    ARM A      A: Drug X
#>    2:      A: Drug X  ARM A      A: Drug X    ARM A      A: Drug X
#>    3:      A: Drug X  ARM A      A: Drug X    ARM A      A: Drug X
#>    4:      A: Drug X  ARM A      A: Drug X    ARM A      A: Drug X
#>    5: C: Combination  ARM C C: Combination    ARM C C: Combination
#>   ---                                                             
#> 1582: C: Combination  ARM C C: Combination    ARM C C: Combination
#> 1583: C: Combination  ARM C C: Combination    ARM C C: Combination
#> 1584:      A: Drug X  ARM A      A: Drug X    ARM A      A: Drug X
#> 1585:      A: Drug X  ARM A      A: Drug X    ARM A      A: Drug X
#> 1586:      A: Drug X  ARM A      A: Drug X    ARM A      A: Drug X
#>               TRT01A         TRT02P         TRT02A       REGION1 STRATA1
#>               <fctr>         <fctr>         <fctr>        <fctr>  <fctr>
#>    1:      A: Drug X     B: Placebo      A: Drug X South America       B
#>    2:      A: Drug X     B: Placebo      A: Drug X South America       B
#>    3:      A: Drug X     B: Placebo      A: Drug X South America       B
#>    4:      A: Drug X     B: Placebo      A: Drug X South America       B
#>    5: C: Combination C: Combination C: Combination South America       B
#>   ---                                                                   
#> 1582: C: Combination     B: Placebo C: Combination North America       B
#> 1583: C: Combination     B: Placebo C: Combination North America       B
#> 1584:      A: Drug X C: Combination C: Combination North America       A
#> 1585:      A: Drug X C: Combination C: Combination North America       A
#> 1586:      A: Drug X C: Combination C: Combination North America       A
#>       STRATA2    BMRKR1 BMRKR2  ITTFL  SAFFL BMEASIFL BEP01FL AEWITHFL
#>        <fctr>     <num> <fctr> <fctr> <fctr>   <fctr>  <fctr>   <fctr>
#>    1:      S2  6.462991    LOW      Y      Y        Y       N        N
#>    2:      S2  6.462991    LOW      Y      Y        Y       N        N
#>    3:      S2  6.462991    LOW      Y      Y        Y       N        N
#>    4:      S2  6.462991    LOW      Y      Y        Y       N        N
#>    5:      S1  7.516076   HIGH      Y      Y        Y       Y        N
#>   ---                                                                 
#> 1582:      S1 14.478057   HIGH      Y      Y        Y       Y        N
#> 1583:      S1 14.478057   HIGH      Y      Y        Y       Y        N
#> 1584:      S1  1.280525 MEDIUM      Y      Y        N       N        N
#> 1585:      S1  1.280525 MEDIUM      Y      Y        N       N        N
#> 1586:      S1  1.280525 MEDIUM      Y      Y        N       N        N
#>           RANDDT             TRTSDTM             TRTEDTM           TRT01SDTM
#>           <Date>              <POSc>              <POSc>              <POSc>
#>    1: 2020-11-03 2020-11-04 04:08:58 2022-02-20 03:33:55 2020-11-04 04:08:58
#>    2: 2020-11-03 2020-11-04 04:08:58 2022-02-20 03:33:55 2020-11-04 04:08:58
#>    3: 2020-11-03 2020-11-04 04:08:58 2022-02-20 03:33:55 2020-11-04 04:08:58
#>    4: 2020-11-03 2020-11-04 04:08:58 2022-02-20 03:33:55 2020-11-04 04:08:58
#>    5: 2020-07-22 2020-07-25 14:26:21 2023-07-26 08:26:21 2020-07-25 14:26:21
#>   ---                                                                       
#> 1582: 2019-07-19 2019-07-22 10:23:30 2022-07-22 04:23:30 2019-07-22 10:23:30
#> 1583: 2019-07-19 2019-07-22 10:23:30 2022-07-22 04:23:30 2019-07-22 10:23:30
#> 1584: 2020-07-17 2020-07-18 19:43:32 2023-07-19 13:43:32 2020-07-18 19:43:32
#> 1585: 2020-07-17 2020-07-18 19:43:32 2023-07-19 13:43:32 2020-07-18 19:43:32
#> 1586: 2020-07-17 2020-07-18 19:43:32 2023-07-19 13:43:32 2020-07-18 19:43:32
#>                 TRT01EDTM           TRT02SDTM           TRT02EDTM
#>                    <POSc>              <POSc>              <POSc>
#>    1: 2021-02-19 21:33:55 2021-02-19 21:33:55 2022-02-20 03:33:55
#>    2: 2021-02-19 21:33:55 2021-02-19 21:33:55 2022-02-20 03:33:55
#>    3: 2021-02-19 21:33:55 2021-02-19 21:33:55 2022-02-20 03:33:55
#>    4: 2021-02-19 21:33:55 2021-02-19 21:33:55 2022-02-20 03:33:55
#>    5: 2022-07-26 02:26:21 2022-07-26 02:26:21 2023-07-26 08:26:21
#>   ---                                                            
#> 1582: 2021-07-21 22:23:30 2021-07-21 22:23:30 2022-07-22 04:23:30
#> 1583: 2021-07-21 22:23:30 2021-07-21 22:23:30 2022-07-22 04:23:30
#> 1584: 2022-07-19 07:43:32 2022-07-19 07:43:32 2023-07-19 13:43:32
#> 1585: 2022-07-19 07:43:32 2022-07-19 07:43:32 2023-07-19 13:43:32
#> 1586: 2022-07-19 07:43:32 2022-07-19 07:43:32 2023-07-19 13:43:32
#>                  AP01SDTM            AP01EDTM            AP02SDTM
#>                    <POSc>              <POSc>              <POSc>
#>    1: 2020-11-04 04:08:58 2021-02-19 21:33:55 2021-02-19 21:33:55
#>    2: 2020-11-04 04:08:58 2021-02-19 21:33:55 2021-02-19 21:33:55
#>    3: 2020-11-04 04:08:58 2021-02-19 21:33:55 2021-02-19 21:33:55
#>    4: 2020-11-04 04:08:58 2021-02-19 21:33:55 2021-02-19 21:33:55
#>    5: 2020-07-25 14:26:21 2022-07-26 02:26:21 2022-07-26 02:26:21
#>   ---                                                            
#> 1582: 2019-07-22 10:23:30 2021-07-21 22:23:30 2021-07-21 22:23:30
#> 1583: 2019-07-22 10:23:30 2021-07-21 22:23:30 2021-07-21 22:23:30
#> 1584: 2020-07-18 19:43:32 2022-07-19 07:43:32 2022-07-19 07:43:32
#> 1585: 2020-07-18 19:43:32 2022-07-19 07:43:32 2022-07-19 07:43:32
#> 1586: 2020-07-18 19:43:32 2022-07-19 07:43:32 2022-07-19 07:43:32
#>                  AP02EDTM       EOSSTT       EOTSTT      EOSDT EOSDY DCSREAS
#>                    <POSc>       <fctr>       <fctr>     <Date> <int>  <fctr>
#>    1: 2022-02-20 03:33:55 DISCONTINUED DISCONTINUED 2022-02-20   473   DEATH
#>    2: 2022-02-20 03:33:55 DISCONTINUED DISCONTINUED 2022-02-20   473   DEATH
#>    3: 2022-02-20 03:33:55 DISCONTINUED DISCONTINUED 2022-02-20   473   DEATH
#>    4: 2022-02-20 03:33:55 DISCONTINUED DISCONTINUED 2022-02-20   473   DEATH
#>    5: 2023-07-26 08:26:21    COMPLETED    COMPLETED 2023-07-26  1096    <NA>
#>   ---                                                                       
#> 1582: 2022-07-22 04:23:30    COMPLETED    COMPLETED 2022-07-22  1096    <NA>
#> 1583: 2022-07-22 04:23:30    COMPLETED    COMPLETED 2022-07-22  1096    <NA>
#> 1584: 2023-07-19 13:43:32    COMPLETED    COMPLETED 2023-07-19  1096    <NA>
#> 1585: 2023-07-19 13:43:32    COMPLETED    COMPLETED 2023-07-19  1096    <NA>
#> 1586: 2023-07-19 13:43:32    COMPLETED    COMPLETED 2023-07-19  1096    <NA>
#>            DTHDT       DTHCAUS        DTHCAT LDDTHELD LDDTHGR1   LSTALVDT
#>           <Date>        <fctr>        <fctr>    <int>   <fctr>     <Date>
#>    1: 2022-03-16 ADVERSE EVENT ADVERSE EVENT       24     <=30 2022-03-16
#>    2: 2022-03-16 ADVERSE EVENT ADVERSE EVENT       24     <=30 2022-03-16
#>    3: 2022-03-16 ADVERSE EVENT ADVERSE EVENT       24     <=30 2022-03-16
#>    4: 2022-03-16 ADVERSE EVENT ADVERSE EVENT       24     <=30 2022-03-16
#>    5:       <NA>          <NA>          <NA>       NA     <NA> 2023-08-08
#>   ---                                                                    
#> 1582:       <NA>          <NA>          <NA>       NA     <NA> 2022-08-07
#> 1583:       <NA>          <NA>          <NA>       NA     <NA> 2022-08-07
#> 1584:       <NA>          <NA>          <NA>       NA     <NA> 2023-08-09
#> 1585:       <NA>          <NA>          <NA>       NA     <NA> 2023-08-09
#> 1586:       <NA>          <NA>          <NA>       NA     <NA> 2023-08-09
#>       DTHADY ADTHAUT  ASEQ AESEQ        AETERM         AELLT       AEDECOD
#>        <int>  <fctr> <int> <int>        <fctr>        <fctr>        <char>
#>    1:    496     Yes     1     1 trm B.2.1.2.1 llt B.2.1.2.1 dcd B.2.1.2.1
#>    2:    496     Yes     2     2 trm D.1.1.4.2 llt D.1.1.4.2 dcd D.1.1.4.2
#>    3:    496     Yes     3     3 trm A.1.1.1.2 llt A.1.1.1.2 dcd A.1.1.1.2
#>    4:    496     Yes     4     4 trm A.1.1.1.2 llt A.1.1.1.2 dcd A.1.1.1.2
#>    5:     NA    <NA>     1     1 trm B.2.1.2.1 llt B.2.1.2.1 dcd B.2.1.2.1
#>   ---                                                                     
#> 1582:     NA    <NA>     7     7 trm B.2.2.3.1 llt B.2.2.3.1 dcd B.2.2.3.1
#> 1583:     NA    <NA>     8     8 trm C.2.1.2.1 llt C.2.1.2.1 dcd C.2.1.2.1
#> 1584:     NA    <NA>     1     1 trm D.1.1.1.1 llt D.1.1.1.1 dcd D.1.1.1.1
#> 1585:     NA    <NA>     2     2 trm D.1.1.4.2 llt D.1.1.4.2 dcd D.1.1.4.2
#> 1586:     NA    <NA>     3     3 trm D.1.1.4.2 llt D.1.1.4.2 dcd D.1.1.4.2
#>             AEHLT     AEHLGT AEBODSYS  AESOC    AESEV  AESER            AEACN
#>            <fctr>     <fctr>   <fctr> <fctr>   <fctr> <fctr>           <char>
#>    1: hlt B.2.1.2 hlgt B.2.1   cl B.2   cl B MODERATE      N DOSE NOT CHANGED
#>    2: hlt D.1.1.4 hlgt D.1.1   cl D.1   cl D MODERATE      N DOSE NOT CHANGED
#>    3: hlt A.1.1.1 hlgt A.1.1   cl A.1   cl A MODERATE      Y DOSE NOT CHANGED
#>    4: hlt A.1.1.1 hlgt A.1.1   cl A.1   cl A MODERATE      Y DOSE NOT CHANGED
#>    5: hlt B.2.1.2 hlgt B.2.1   cl B.2   cl B MODERATE      N   DRUG WITHDRAWN
#>   ---                                                                        
#> 1582: hlt B.2.2.3 hlgt B.2.2   cl B.2   cl B     MILD      Y DOSE NOT CHANGED
#> 1583: hlt C.2.1.2 hlgt C.2.1   cl C.2   cl C MODERATE      N DOSE NOT CHANGED
#> 1584: hlt D.1.1.1 hlgt D.1.1   cl D.1   cl D   SEVERE      Y DOSE NOT CHANGED
#> 1585: hlt D.1.1.4 hlgt D.1.1   cl D.1   cl D MODERATE      N DOSE NOT CHANGED
#> 1586: hlt D.1.1.4 hlgt D.1.1   cl D.1   cl D MODERATE      N DRUG INTERRUPTED
#>        AEREL                AEOUT AESDTH AESCONG AESDISAB AESHOSP AESLIFE
#>       <fctr>               <char> <char>  <fctr>   <fctr>  <fctr>  <fctr>
#>    1:      N RECOVERING/RESOLVING      N       N        Y       N       N
#>    2:      N RECOVERING/RESOLVING      N       N        Y       N       N
#>    3:      N RECOVERING/RESOLVING      N       N        Y       N       N
#>    4:      N RECOVERING/RESOLVING      Y       Y        N       N       N
#>    5:      N   RECOVERED/RESOLVED      N       N        N       Y       N
#>   ---                                                                    
#> 1582:      N   RECOVERED/RESOLVED      N       N        N       Y       N
#> 1583:      Y RECOVERING/RESOLVING      N       N        N       N       N
#> 1584:      Y                FATAL      N       N        N       N       N
#> 1585:      N RECOVERING/RESOLVING      N       N        N       N       N
#> 1586:      N RECOVERING/RESOLVING      N       N        N       Y       N
#>       AESMIE TRTEMFL AECONTRT              ASTDTM              AENDTM ASTDY
#>       <fctr>  <fctr>   <fctr>              <POSc>              <POSc> <int>
#>    1:      N       Y        Y 2021-04-15 04:08:58 2021-10-04 04:08:58   162
#>    2:      N       Y        N 2021-05-19 04:08:58 2021-10-31 04:08:58   196
#>    3:      N       Y        Y 2021-09-21 04:08:58 2022-02-16 04:08:58   321
#>    4:      N       Y        N 2021-12-02 04:08:58 2022-01-13 04:08:58   393
#>    5:      N       Y        Y 2021-08-16 14:26:21 2021-08-26 14:26:21   387
#>   ---                                                                      
#> 1582:      N       Y        N 2021-04-22 10:23:30 2022-03-17 10:23:30   640
#> 1583:      Y       Y        N 2021-05-18 10:23:30 2022-01-15 10:23:30   666
#> 1584:      N       Y        Y 2020-08-29 19:43:32 2021-10-15 19:43:32    42
#> 1585:      Y       Y        N 2022-09-30 19:43:32 2022-11-26 19:43:32   804
#> 1586:      N       Y        N 2023-04-24 19:43:32 2023-04-25 19:43:32  1010
#>       AENDY            LDOSEDTM    LDRELTM AETOXGR                 SMQ01NAM
#>       <int>              <POSc>      <num>  <fctr>                   <char>
#>    1:   334 2020-11-07 09:05:04 228663.896       3                     <NA>
#>    2:   361 2021-05-17 07:21:09   2687.814       3                     <NA>
#>    3:   469 2021-05-23 15:14:37 173574.345       2                     <NA>
#>    4:   435 2021-03-19 08:52:05 371236.878       2                     <NA>
#>    5:   397 2021-07-22 06:04:04  36502.291       3                     <NA>
#>   ---                                                                      
#> 1582:   969 2020-08-07 02:09:27 372014.055       1 C.1.1.1.3/B.2.2.3.1 AESI
#> 1583:   908 2019-08-29 14:42:51 904060.651       2                     <NA>
#> 1584:   454 2020-08-27 10:57:40   3405.874       5                     <NA>
#> 1585:   861 2021-01-10 19:19:14 904344.302       3                     <NA>
#> 1586:  1011 2022-11-05 12:59:20 245204.199       3                     <NA>
#>       SMQ02NAM SMQ01SC SMQ02SC CQ01NAM ANL01FL            AERELNST
#>         <char>  <char>  <char>  <char>  <fctr>              <fctr>
#>    1:     <NA>    <NA>    <NA>    <NA>       Y                NONE
#>    2:     <NA>    <NA>    <NA>    <NA>       Y  CONCURRENT ILLNESS
#>    3:     <NA>    <NA>    <NA>    <NA>       Y  CONCURRENT ILLNESS
#>    4:     <NA>    <NA>    <NA>    <NA>       Y  CONCURRENT ILLNESS
#>    5:     <NA>    <NA>    <NA>    <NA>       Y  CONCURRENT ILLNESS
#>   ---                                                             
#> 1582:     <NA>   BROAD    <NA>    <NA>       Y               OTHER
#> 1583:     <NA>    <NA>    <NA>    <NA>       Y               OTHER
#> 1584:     <NA>    <NA>    <NA>    <NA>       Y DISEASE UNDER STUDY
#> 1585:     <NA>    <NA>    <NA>    <NA>       Y               OTHER
#> 1586:     <NA>    <NA>    <NA>    <NA>       Y               OTHER
#>                              AEACNOTH  FATAL    SEV    SER  SERWD SERDSM RELSER
#>                                <fctr> <lgcl> <lgcl> <lgcl> <lgcl> <lgcl> <lgcl>
#>    1:               PROCEDURE/SURGERY  FALSE  FALSE  FALSE  FALSE  FALSE  FALSE
#>    2:                      MEDICATION  FALSE  FALSE  FALSE  FALSE  FALSE  FALSE
#>    3: SUBJECT DISCONTINUED FROM STUDY  FALSE  FALSE   TRUE  FALSE  FALSE  FALSE
#>    4: SUBJECT DISCONTINUED FROM STUDY   TRUE  FALSE   TRUE  FALSE  FALSE  FALSE
#>    5:               PROCEDURE/SURGERY  FALSE  FALSE  FALSE  FALSE  FALSE  FALSE
#>   ---                                                                          
#> 1582:               PROCEDURE/SURGERY  FALSE  FALSE   TRUE  FALSE  FALSE  FALSE
#> 1583:                            NONE  FALSE  FALSE  FALSE  FALSE  FALSE  FALSE
#> 1584: SUBJECT DISCONTINUED FROM STUDY  FALSE   TRUE   TRUE  FALSE  FALSE   TRUE
#> 1585: SUBJECT DISCONTINUED FROM STUDY  FALSE  FALSE  FALSE  FALSE  FALSE  FALSE
#> 1586:               PROCEDURE/SURGERY  FALSE  FALSE  FALSE  FALSE  FALSE  FALSE
#>           WD    DSM    REL  RELWD RELDSM
#>       <lgcl> <lgcl> <lgcl> <lgcl> <lgcl>
#>    1:  FALSE  FALSE  FALSE  FALSE  FALSE
#>    2:  FALSE  FALSE  FALSE  FALSE  FALSE
#>    3:  FALSE  FALSE  FALSE  FALSE  FALSE
#>    4:  FALSE  FALSE  FALSE  FALSE  FALSE
#>    5:   TRUE  FALSE  FALSE  FALSE  FALSE
#>   ---                                   
#> 1582:  FALSE  FALSE  FALSE  FALSE  FALSE
#> 1583:  FALSE  FALSE   TRUE  FALSE  FALSE
#> 1584:  FALSE  FALSE   TRUE  FALSE  FALSE
#> 1585:  FALSE  FALSE  FALSE  FALSE  FALSE
#> 1586:  FALSE   TRUE  FALSE  FALSE  FALSE
```
