# dtlg

The goal of dtlg is to create pharmaceutical tables, listings and graphs for use at scale by utilising data.table as a back-end for processing. Currently only tables can be created but the functions should encompass a large number of possibilities for pharma tables.

The package was created using TLGcatalog to create examples.

Advance formatting options to follow in future.

## Installation

You can install the development version of dtlg from [GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("AscentSoftware/dtlg")
```

## Example

#### This is a basic example which shows you how to create the demography table:

Carrying out data prep from TLG catalog DMT01

``` r
library(dtlg)
#Recreating data prep from TLG Catalog DMT01
adsl <- random.cdisc.data::cadsl
adsl <- adsl|>
  dplyr::mutate(adsl,
    SEX = factor(dplyr::case_when(
      SEX == "M" ~ "Male",
      SEX == "F" ~ "Female",
      SEX == "U" ~ "Unknown",
      SEX == "UNDIFFERENTIATED" ~ "Undifferentiated"
    )),
    AGEGR1 = factor(
      dplyr::case_when(
        dplyr::between(AGE, 18, 40) ~ "18-40",
        dplyr::between(AGE, 41, 64) ~ "41-64",
        AGE > 64 ~ ">=65"
      ),
      levels = c("18-40", "41-64", ">=65")
    ))
```

#### Creating DMT01 table

``` r
vars <- c("AGE", "AGEGR1", "SEX", "ETHNIC", "RACE", "BMRKR1")
var_labels <- c(
  "Age (yr)",
  "Age Group",
  "Sex",
  "Ethnicity",
  "Race",
  "Continous Level Biomarker 1"
)
DMT01<-summary_table(adsl, target = vars, treat = 'ARM', target_name = var_labels)
knitr::kable(DMT01)
```

| stats                                         | A: Drug X    | C: Combination | B: Placebo  |
|:----------------------------------------------|:-------------|:---------------|:------------|
| Age (yr)                                      |              |                |             |
|     n                                         | 134          | 132            | 134         |
|     Mean (SD)                                 | 33.77 (6.55) | 35.43 (7.72)   | 35.43 (7.9) |
|     Median                                    | 33           | 35             | 35          |
|     Min, Max                                  | 21, 50       | 20, 69         | 21, 62      |
|     Missing                                   | 0            | 0              | 0           |
| Age Group                                     |              |                |             |
|     18-40                                     | 113          | 106            | 103         |
|     41-64                                     | 21           | 25             | 31          |
|     \>=65                                     | 0            | 1              | 0           |
| Sex                                           |              |                |             |
|     Female                                    | 79           | 70             | 82          |
|     Male                                      | 55           | 62             | 52          |
| Ethnicity                                     |              |                |             |
|     HISPANIC OR LATINO                        | 15           | 15             | 18          |
|     NOT HISPANIC OR LATINO                    | 104          | 101            | 103         |
|     NOT REPORTED                              | 6            | 11             | 10          |
|     UNKNOWN                                   | 9            | 5              | 3           |
| Race                                          |              |                |             |
|     ASIAN                                     | 68           | 73             | 67          |
|     BLACK OR AFRICAN AMERICAN                 | 31           | 32             | 28          |
|     WHITE                                     | 27           | 21             | 26          |
|     AMERICAN INDIAN OR ALASKA NATIVE          | 8            | 6              | 11          |
|     MULTIPLE                                  | 0            | 0              | 1           |
|     NATIVE HAWAIIAN OR OTHER PACIFIC ISLANDER | 0            | 0              | 1           |
| Continous Level Biomarker 1                   |              |                |             |
|     n                                         | 134          | 132            | 134         |
|     Mean (SD)                                 | 5.97 (3.55)  | 5.62 (3.49)    | 5.7 (3.31)  |
|     Median                                    | 5.39         | 4.61           | 4.81        |
|     Min, Max                                  | 0.41, 17.67  | 0.17, 21.39    | 0.65, 14.24 |
|     Missing                                   | 0            | 0              | 0           |
