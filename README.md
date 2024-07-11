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

#### This example shows you how to create a demography table:

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

Creating DMT01

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

#### This example shows how to create a labs table like LBT01

``` r
adlb <- random.cdisc.data::cadlb|>dplyr::filter(AVISIT != "SCREENING")
labs <- summary_table_by_targets(adlb, c('AVAL','CHG'), 'ARM', c('PARAM','AVISIT'))
knitr::kable(labs)
```

| stats                                | A: Drug X.AVAL | A: Drug X.CHG | C: Combination.AVAL | C: Combination.CHG | B: Placebo.AVAL | B: Placebo.CHG |
|:-------------------------------------|:---------------|:--------------|:--------------------|:-------------------|:----------------|:---------------|
| Alanine Aminotransferase Measurement | NA             | NA            | NA                  | NA                 | NA              | NA             |
|     BASELINE                         |                |               |                     |                    |                 |                |
|         n                            | 134            | 134           | 132                 | 132                | 134             | 134            |
|         Mean (SD)                    | 17.74 (9.93)   | 0 (0)         | 19.46 (9.08)        | 0 (0)              | 18.71 (9.83)    | 0 (0)          |
|         Median                       | 17.46          | 0             | 18.97               | 0                  | 18.19           | 0              |
|         Min, Max                     | 0, 44.06       | 0, 0          | 0.57, 39.81         | 0, 0               | 1.48, 54.4      | 0, 0           |
|         Missing                      | 0              | 0             | 0                   | 0                  | 0               | 0              |
|     WEEK 1 DAY 8                     |                |               |                     |                    |                 |                |
|         n                            | 134            | 134           | 132                 | 132                | 134             | 134            |
|         Mean (SD)                    | 16.75 (9.08)   | -0.99 (13.49) | 19.61 (9.27)        | 0.14 (12.85)       | 18.93 (9.18)    | 0.23 (14.26)   |
|         Median                       | 16.02          | -1.28         | 19                  | 0.06               | 18.22           | -1.54          |
|         Min, Max                     | 0.05, 36.3     | -31.31, 27.89 | 0.91, 44.75         | -32.45, 38.85      | 0.66, 39.89     | -30.72, 33.92  |
|         Missing                      | 0              | 0             | 0                   | 0                  | 0               | 0              |
|     WEEK 2 DAY 15                    |                |               |                     |                    |                 |                |
|         n                            | 134            | 134           | 132                 | 132                | 134             | 134            |
|         Mean (SD)                    | 17.82 (9.6)    | 0.08 (14.15)  | 16.55 (8.15)        | -2.92 (12.64)      | 18.82 (9.73)    | 0.11 (14.45)   |
|         Median                       | 15.92          | 0.28          | 17.02               | -1.11              | 17.96           | -0.93          |
|         Min, Max                     | 0.4, 44.33     | -32.89, 40.55 | 0.35, 34.69         | -28.36, 23.98      | 0.18, 44.34     | -45.93, 29.85  |
|         Missing                      | 0              | 0             | 0                   | 0                  | 0               | 0              |
|     WEEK 3 DAY 22                    |                |               |                     |                    |                 |                |
|         n                            | 134            | 134           | 132                 | 132                | 134             | 134            |
|         Mean (SD)                    | 18.37 (9.3)    | 0.63 (13.85)  | 16.75 (9.54)        | -2.71 (13.22)      | 17.65 (9.58)    | -1.06 (13.58)  |
|         Median                       | 18.11          | 1.13          | 15.1                | -2.66              | 17.68           | -0.49          |
|         Min, Max                     | 0.59, 41.73    | -40.09, 31.24 | 0.48, 39.23         | -30.63, 26.51      | 0.02, 38.61     | -46.3, 31.38   |
|         Missing                      | 0              | 0             | 0                   | 0                  | 0               | 0              |
|     WEEK 4 DAY 29                    |                |               |                     |                    |                 |                |
|         n                            | 134            | 134           | 132                 | 132                | 134             | 134            |
|         Mean (SD)                    | 19.17 (10.95)  | 1.44 (15.39)  | 17.92 (9.32)        | -1.54 (12.63)      | 17.22 (10.64)   | -1.48 (15.2)   |
|         Median                       | 17.41          | 0.88          | 17.71               | -1.53              | 15.88           | -2.96          |
|         Min, Max                     | 0.93, 54.24    | -32.93, 46.98 | 0.25, 41.27         | -30.33, 27.99      | 0.39, 47.96     | -41.45, 43.08  |
|         Missing                      | 0              | 0             | 0                   | 0                  | 0               | 0              |
|     WEEK 5 DAY 36                    |                |               |                     |                    |                 |                |
|         n                            | 134            | 134           | 132                 | 132                | 134             | 134            |
|         Mean (SD)                    | 19.22 (9.47)   | 1.48 (14.49)  | 18.51 (9.43)        | -0.95 (12.92)      | 18.01 (9.92)    | -0.69 (14.65)  |
|         Median                       | 19.8           | 2.31          | 19.26               | -2.48              | 18.28           | 1.82           |
|         Min, Max                     | 0.01, 43.42    | -40.08, 30.07 | 0.02, 37.46         | -29.78, 25         | 0.11, 40.64     | -47.6, 26.04   |
|         Missing                      | 0              | 0             | 0                   | 0                  | 0               | 0              |
| C-Reactive Protein Measurement       | NA             | NA            | NA                  | NA                 | NA              | NA             |
|     BASELINE                         |                |               |                     |                    |                 |                |
|         n                            | 134            | 134           | 132                 | 132                | 134             | 134            |
|         Mean (SD)                    | 9.06 (0.93)    | 0 (0)         | 8.98 (0.89)         | 0 (0)              | 8.99 (0.98)     | 0 (0)          |
|         Median                       | 9.07           | 0             | 8.96                | 0                  | 8.92            | 0              |
|         Min, Max                     | 6.21, 11.87    | 0, 0          | 6.24, 11.18         | 0, 0               | 6.23, 11.63     | 0, 0           |
|         Missing                      | 0              | 0             | 0                   | 0                  | 0               | 0              |
|     WEEK 1 DAY 8                     |                |               |                     |                    |                 |                |
|         n                            | 134            | 134           | 132                 | 132                | 134             | 134            |
|         Mean (SD)                    | 9.01 (1.03)    | -0.05 (1.38)  | 8.96 (1.03)         | -0.02 (1.3)        | 8.98 (1)        | 0 (1.43)       |
|         Median                       | 8.93           | -0.17         | 8.91                | 0.02               | 8.96            | -0.07          |
|         Min, Max                     | 6.37, 11.33    | -3.56, 3.48   | 7.15, 12.15         | -3.28, 3.33        | 6.84, 11.53     | -3.14, 4.28    |
|         Missing                      | 0              | 0             | 0                   | 0                  | 0               | 0              |
|     WEEK 2 DAY 15                    |                |               |                     |                    |                 |                |
|         n                            | 134            | 134           | 132                 | 132                | 134             | 134            |
|         Mean (SD)                    | 8.87 (1.04)    | -0.19 (1.47)  | 9.12 (0.96)         | 0.15 (1.25)        | 8.99 (1.05)     | 0.01 (1.45)    |
|         Median                       | 8.86           | -0.27         | 9.17                | 0.15               | 8.99            | 0              |
|         Min, Max                     | 6.78, 12.55    | -4.53, 4.45   | 6.68, 11.54         | -2.92, 3.28        | 6.55, 12.73     | -3.79, 3.43    |
|         Missing                      | 0              | 0             | 0                   | 0                  | 0               | 0              |
|     WEEK 3 DAY 22                    |                |               |                     |                    |                 |                |
|         n                            | 134            | 134           | 132                 | 132                | 134             | 134            |
|         Mean (SD)                    | 9.08 (0.96)    | 0.03 (1.38)   | 8.99 (0.93)         | 0.02 (1.34)        | 8.97 (1.07)     | -0.02 (1.49)   |
|         Median                       | 9.09           | 0.15          | 8.97                | 0.2                | 8.97            | -0.04          |
|         Min, Max                     | 6.46, 11.6     | -3.95, 2.99   | 6.3, 11.33          | -2.76, 3.26        | 5.81, 11.37     | -4.28, 4.24    |
|         Missing                      | 0              | 0             | 0                   | 0                  | 0               | 0              |
|     WEEK 4 DAY 29                    |                |               |                     |                    |                 |                |
|         n                            | 134            | 134           | 132                 | 132                | 134             | 134            |
|         Mean (SD)                    | 8.8 (1.06)     | -0.26 (1.45)  | 8.97 (0.95)         | -0.01 (1.17)       | 9.04 (0.9)      | 0.05 (1.24)    |
|         Median                       | 8.71           | -0.37         | 8.88                | -0.06              | 9.04            | 0.1            |
|         Min, Max                     | 5.87, 12.22    | -3.74, 4.15   | 7.16, 11.96         | -3.06, 3.22        | 6.42, 11.21     | -3.34, 3.71    |
|         Missing                      | 0              | 0             | 0                   | 0                  | 0               | 0              |
|     WEEK 5 DAY 36                    |                |               |                     |                    |                 |                |
|         n                            | 134            | 134           | 132                 | 132                | 134             | 134            |
|         Mean (SD)                    | 9.04 (1.04)    | -0.02 (1.5)   | 9.01 (0.91)         | 0.03 (1.27)        | 9.06 (1.01)     | 0.07 (1.34)    |
|         Median                       | 8.98           | 0.01          | 8.96                | 0.05               | 9.1             | 0.15           |
|         Min, Max                     | 6.92, 12.12    | -4.15, 3.96   | 6.64, 11.93         | -3.63, 4.78        | 7.08, 12.5      | -3.5, 3.53     |
|         Missing                      | 0              | 0             | 0                   | 0                  | 0               | 0              |
| Immunoglobulin A Measurement         | NA             | NA            | NA                  | NA                 | NA              | NA             |
|     BASELINE                         |                |               |                     |                    |                 |                |
|         n                            | 134            | 134           | 132                 | 132                | 134             | 134            |
|         Mean (SD)                    | 2.89 (0.08)    | 0 (0)         | 2.9 (0.11)          | 0 (0)              | 2.88 (0.1)      | 0 (0)          |
|         Median                       | 2.89           | 0             | 2.91                | 0                  | 2.89            | 0              |
|         Min, Max                     | 2.7, 3.12      | 0, 0          | 2.61, 3.15          | 0, 0               | 2.64, 3.14      | 0, 0           |
|         Missing                      | 0              | 0             | 0                   | 0                  | 0               | 0              |
|     WEEK 1 DAY 8                     |                |               |                     |                    |                 |                |
|         n                            | 134            | 134           | 132                 | 132                | 134             | 134            |
|         Mean (SD)                    | 2.91 (0.1)     | 0.02 (0.14)   | 2.91 (0.09)         | 0.01 (0.14)        | 2.91 (0.1)      | 0.03 (0.15)    |
|         Median                       | 2.91           | 0.02          | 2.92                | 0.01               | 2.91            | 0.04           |
|         Min, Max                     | 2.66, 3.21     | -0.32, 0.34   | 2.71, 3.18          | -0.34, 0.32        | 2.69, 3.16      | -0.28, 0.38    |
|         Missing                      | 0              | 0             | 0                   | 0                  | 0               | 0              |
|     WEEK 2 DAY 15                    |                |               |                     |                    |                 |                |
|         n                            | 134            | 134           | 132                 | 132                | 134             | 134            |
|         Mean (SD)                    | 2.91 (0.09)    | 0.02 (0.13)   | 2.89 (0.09)         | -0.01 (0.14)       | 2.9 (0.09)      | 0.02 (0.14)    |
|         Median                       | 2.91           | 0.03          | 2.91                | -0.01              | 2.91            | 0.02           |
|         Min, Max                     | 2.67, 3.22     | -0.34, 0.32   | 2.7, 3.15           | -0.4, 0.35         | 2.62, 3.15      | -0.42, 0.36    |
|         Missing                      | 0              | 0             | 0                   | 0                  | 0               | 0              |
|     WEEK 3 DAY 22                    |                |               |                     |                    |                 |                |
|         n                            | 134            | 134           | 132                 | 132                | 134             | 134            |
|         Mean (SD)                    | 2.89 (0.1)     | 0 (0.13)      | 2.9 (0.11)          | 0 (0.16)           | 2.9 (0.09)      | 0.02 (0.13)    |
|         Median                       | 2.89           | 0             | 2.9                 | 0                  | 2.91            | 0.03           |
|         Min, Max                     | 2.65, 3.15     | -0.28, 0.33   | 2.65, 3.26          | -0.38, 0.5         | 2.6, 3.2        | -0.46, 0.38    |
|         Missing                      | 0              | 0             | 0                   | 0                  | 0               | 0              |
|     WEEK 4 DAY 29                    |                |               |                     |                    |                 |                |
|         n                            | 134            | 134           | 132                 | 132                | 134             | 134            |
|         Mean (SD)                    | 2.92 (0.1)     | 0.03 (0.13)   | 2.9 (0.11)          | -0.01 (0.15)       | 2.91 (0.1)      | 0.03 (0.14)    |
|         Median                       | 2.93           | 0.03          | 2.89                | -0.01              | 2.9             | 0.02           |
|         Min, Max                     | 2.63, 3.16     | -0.39, 0.37   | 2.59, 3.19          | -0.38, 0.37        | 2.58, 3.15      | -0.3, 0.42     |
|         Missing                      | 0              | 0             | 0                   | 0                  | 0               | 0              |
|     WEEK 5 DAY 36                    |                |               |                     |                    |                 |                |
|         n                            | 134            | 134           | 132                 | 132                | 134             | 134            |
|         Mean (SD)                    | 2.91 (0.09)    | 0.02 (0.12)   | 2.9 (0.1)           | -0.01 (0.16)       | 2.9 (0.1)       | 0.02 (0.14)    |
|         Median                       | 2.91           | 0.02          | 2.91                | 0                  | 2.92            | 0.02           |
|         Min, Max                     | 2.6, 3.08      | -0.33, 0.28   | 2.61, 3.13          | -0.52, 0.34        | 2.62, 3.13      | -0.3, 0.35     |
|         Missing                      | 0              | 0             | 0                   | 0                  | 0               | 0              |
