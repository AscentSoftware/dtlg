
# dtlg

The goal of dtlg is to create pharmaceutical tables, listings and graphs
for use at scale by utilising data.table as a back-end for processing.
Currently only tables can be created but the functions should encompass
a large number of possibilities for pharma tables.

The package was created using TLGcatalog to create examples.

Advance formatting options to follow in future.

## Installation

You can install the development version of dtlg from
[GitHub](https://github.com/) with:

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
knitr::kable(DMT01) |>
  kableExtra::kable_styling() |>
  kableExtra::scroll_box(width = '100%', height = '500px')
```

<div style="border: 1px solid #ddd; padding: 0px; overflow-y: scroll; height:500px; overflow-x: scroll; width:100%; ">

<table class="table" style="margin-left: auto; margin-right: auto;">
<thead>
<tr>
<th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;">
stats
</th>
<th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;">
A: Drug X
</th>
<th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;">
C: Combination
</th>
<th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;">
B: Placebo
</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align:left;">
Age (yr)
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
</td>
</tr>
<tr>
<td style="text-align:left;">
&nbsp;&nbsp;&nbsp;&nbsp;n
</td>
<td style="text-align:left;">
134
</td>
<td style="text-align:left;">
132
</td>
<td style="text-align:left;">
134
</td>
</tr>
<tr>
<td style="text-align:left;">
&nbsp;&nbsp;&nbsp;&nbsp;Mean (SD)
</td>
<td style="text-align:left;">
33.77 (6.55)
</td>
<td style="text-align:left;">
35.43 (7.72)
</td>
<td style="text-align:left;">
35.43 (7.9)
</td>
</tr>
<tr>
<td style="text-align:left;">
&nbsp;&nbsp;&nbsp;&nbsp;Median
</td>
<td style="text-align:left;">
33
</td>
<td style="text-align:left;">
35
</td>
<td style="text-align:left;">
35
</td>
</tr>
<tr>
<td style="text-align:left;">
&nbsp;&nbsp;&nbsp;&nbsp;Min, Max
</td>
<td style="text-align:left;">
21, 50
</td>
<td style="text-align:left;">
20, 69
</td>
<td style="text-align:left;">
21, 62
</td>
</tr>
<tr>
<td style="text-align:left;">
&nbsp;&nbsp;&nbsp;&nbsp;Missing
</td>
<td style="text-align:left;">
0
</td>
<td style="text-align:left;">
0
</td>
<td style="text-align:left;">
0
</td>
</tr>
<tr>
<td style="text-align:left;">
Age Group
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
</td>
</tr>
<tr>
<td style="text-align:left;">
&nbsp;&nbsp;&nbsp;&nbsp;18-40
</td>
<td style="text-align:left;">
113
</td>
<td style="text-align:left;">
106
</td>
<td style="text-align:left;">
103
</td>
</tr>
<tr>
<td style="text-align:left;">
&nbsp;&nbsp;&nbsp;&nbsp;41-64
</td>
<td style="text-align:left;">
21
</td>
<td style="text-align:left;">
25
</td>
<td style="text-align:left;">
31
</td>
</tr>
<tr>
<td style="text-align:left;">
&nbsp;&nbsp;&nbsp;&nbsp;\>=65
</td>
<td style="text-align:left;">
0
</td>
<td style="text-align:left;">
1
</td>
<td style="text-align:left;">
0
</td>
</tr>
<tr>
<td style="text-align:left;">
Sex
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
</td>
</tr>
<tr>
<td style="text-align:left;">
&nbsp;&nbsp;&nbsp;&nbsp;Female
</td>
<td style="text-align:left;">
79
</td>
<td style="text-align:left;">
70
</td>
<td style="text-align:left;">
82
</td>
</tr>
<tr>
<td style="text-align:left;">
&nbsp;&nbsp;&nbsp;&nbsp;Male
</td>
<td style="text-align:left;">
55
</td>
<td style="text-align:left;">
62
</td>
<td style="text-align:left;">
52
</td>
</tr>
<tr>
<td style="text-align:left;">
Ethnicity
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
</td>
</tr>
<tr>
<td style="text-align:left;">
&nbsp;&nbsp;&nbsp;&nbsp;HISPANIC OR LATINO
</td>
<td style="text-align:left;">
15
</td>
<td style="text-align:left;">
15
</td>
<td style="text-align:left;">
18
</td>
</tr>
<tr>
<td style="text-align:left;">
&nbsp;&nbsp;&nbsp;&nbsp;NOT HISPANIC OR LATINO
</td>
<td style="text-align:left;">
104
</td>
<td style="text-align:left;">
101
</td>
<td style="text-align:left;">
103
</td>
</tr>
<tr>
<td style="text-align:left;">
&nbsp;&nbsp;&nbsp;&nbsp;NOT REPORTED
</td>
<td style="text-align:left;">
6
</td>
<td style="text-align:left;">
11
</td>
<td style="text-align:left;">
10
</td>
</tr>
<tr>
<td style="text-align:left;">
&nbsp;&nbsp;&nbsp;&nbsp;UNKNOWN
</td>
<td style="text-align:left;">
9
</td>
<td style="text-align:left;">
5
</td>
<td style="text-align:left;">
3
</td>
</tr>
<tr>
<td style="text-align:left;">
Race
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
</td>
</tr>
<tr>
<td style="text-align:left;">
&nbsp;&nbsp;&nbsp;&nbsp;ASIAN
</td>
<td style="text-align:left;">
68
</td>
<td style="text-align:left;">
73
</td>
<td style="text-align:left;">
67
</td>
</tr>
<tr>
<td style="text-align:left;">
&nbsp;&nbsp;&nbsp;&nbsp;BLACK OR AFRICAN AMERICAN
</td>
<td style="text-align:left;">
31
</td>
<td style="text-align:left;">
32
</td>
<td style="text-align:left;">
28
</td>
</tr>
<tr>
<td style="text-align:left;">
&nbsp;&nbsp;&nbsp;&nbsp;WHITE
</td>
<td style="text-align:left;">
27
</td>
<td style="text-align:left;">
21
</td>
<td style="text-align:left;">
26
</td>
</tr>
<tr>
<td style="text-align:left;">
&nbsp;&nbsp;&nbsp;&nbsp;AMERICAN INDIAN OR ALASKA NATIVE
</td>
<td style="text-align:left;">
8
</td>
<td style="text-align:left;">
6
</td>
<td style="text-align:left;">
11
</td>
</tr>
<tr>
<td style="text-align:left;">
&nbsp;&nbsp;&nbsp;&nbsp;MULTIPLE
</td>
<td style="text-align:left;">
0
</td>
<td style="text-align:left;">
0
</td>
<td style="text-align:left;">
1
</td>
</tr>
<tr>
<td style="text-align:left;">
&nbsp;&nbsp;&nbsp;&nbsp;NATIVE HAWAIIAN OR OTHER PACIFIC ISLANDER
</td>
<td style="text-align:left;">
0
</td>
<td style="text-align:left;">
0
</td>
<td style="text-align:left;">
1
</td>
</tr>
<tr>
<td style="text-align:left;">
Continous Level Biomarker 1
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
</td>
</tr>
<tr>
<td style="text-align:left;">
&nbsp;&nbsp;&nbsp;&nbsp;n
</td>
<td style="text-align:left;">
134
</td>
<td style="text-align:left;">
132
</td>
<td style="text-align:left;">
134
</td>
</tr>
<tr>
<td style="text-align:left;">
&nbsp;&nbsp;&nbsp;&nbsp;Mean (SD)
</td>
<td style="text-align:left;">
5.97 (3.55)
</td>
<td style="text-align:left;">
5.62 (3.49)
</td>
<td style="text-align:left;">
5.7 (3.31)
</td>
</tr>
<tr>
<td style="text-align:left;">
&nbsp;&nbsp;&nbsp;&nbsp;Median
</td>
<td style="text-align:left;">
5.39
</td>
<td style="text-align:left;">
4.61
</td>
<td style="text-align:left;">
4.81
</td>
</tr>
<tr>
<td style="text-align:left;">
&nbsp;&nbsp;&nbsp;&nbsp;Min, Max
</td>
<td style="text-align:left;">
0.41, 17.67
</td>
<td style="text-align:left;">
0.17, 21.39
</td>
<td style="text-align:left;">
0.65, 14.24
</td>
</tr>
<tr>
<td style="text-align:left;">
&nbsp;&nbsp;&nbsp;&nbsp;Missing
</td>
<td style="text-align:left;">
0
</td>
<td style="text-align:left;">
0
</td>
<td style="text-align:left;">
0
</td>
</tr>
</tbody>
</table>

</div>

#### This example shows how to create a labs table like LBT01

``` r
adlb <- random.cdisc.data::cadlb|>dplyr::filter(AVISIT != "SCREENING")
labs <- summary_table_by_targets(adlb, c('AVAL','CHG'), 'ARM', c('PARAM','AVISIT'))
knitr::kable(labs) |>
  kableExtra::kable_styling() |>
  kableExtra::scroll_box(width = '100%', height = '500px')
```

<div style="border: 1px solid #ddd; padding: 0px; overflow-y: scroll; height:500px; overflow-x: scroll; width:100%; ">

<table class="table" style="margin-left: auto; margin-right: auto;">
<thead>
<tr>
<th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;">
stats
</th>
<th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;">
A: Drug X.AVAL
</th>
<th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;">
A: Drug X.CHG
</th>
<th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;">
C: Combination.AVAL
</th>
<th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;">
C: Combination.CHG
</th>
<th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;">
B: Placebo.AVAL
</th>
<th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;">
B: Placebo.CHG
</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align:left;">
Alanine Aminotransferase Measurement
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:left;">
NA
</td>
</tr>
<tr>
<td style="text-align:left;">
&nbsp;&nbsp;&nbsp;&nbsp;BASELINE
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
</td>
</tr>
<tr>
<td style="text-align:left;">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;n
</td>
<td style="text-align:left;">
134
</td>
<td style="text-align:left;">
134
</td>
<td style="text-align:left;">
132
</td>
<td style="text-align:left;">
132
</td>
<td style="text-align:left;">
134
</td>
<td style="text-align:left;">
134
</td>
</tr>
<tr>
<td style="text-align:left;">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Mean (SD)
</td>
<td style="text-align:left;">
17.74 (9.93)
</td>
<td style="text-align:left;">
0 (0)
</td>
<td style="text-align:left;">
19.46 (9.08)
</td>
<td style="text-align:left;">
0 (0)
</td>
<td style="text-align:left;">
18.71 (9.83)
</td>
<td style="text-align:left;">
0 (0)
</td>
</tr>
<tr>
<td style="text-align:left;">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Median
</td>
<td style="text-align:left;">
17.46
</td>
<td style="text-align:left;">
0
</td>
<td style="text-align:left;">
18.97
</td>
<td style="text-align:left;">
0
</td>
<td style="text-align:left;">
18.19
</td>
<td style="text-align:left;">
0
</td>
</tr>
<tr>
<td style="text-align:left;">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Min, Max
</td>
<td style="text-align:left;">
0, 44.06
</td>
<td style="text-align:left;">
0, 0
</td>
<td style="text-align:left;">
0.57, 39.81
</td>
<td style="text-align:left;">
0, 0
</td>
<td style="text-align:left;">
1.48, 54.4
</td>
<td style="text-align:left;">
0, 0
</td>
</tr>
<tr>
<td style="text-align:left;">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Missing
</td>
<td style="text-align:left;">
0
</td>
<td style="text-align:left;">
0
</td>
<td style="text-align:left;">
0
</td>
<td style="text-align:left;">
0
</td>
<td style="text-align:left;">
0
</td>
<td style="text-align:left;">
0
</td>
</tr>
<tr>
<td style="text-align:left;">
&nbsp;&nbsp;&nbsp;&nbsp;WEEK 1 DAY 8
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
</td>
</tr>
<tr>
<td style="text-align:left;">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;n
</td>
<td style="text-align:left;">
134
</td>
<td style="text-align:left;">
134
</td>
<td style="text-align:left;">
132
</td>
<td style="text-align:left;">
132
</td>
<td style="text-align:left;">
134
</td>
<td style="text-align:left;">
134
</td>
</tr>
<tr>
<td style="text-align:left;">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Mean (SD)
</td>
<td style="text-align:left;">
16.75 (9.08)
</td>
<td style="text-align:left;">
-0.99 (13.49)
</td>
<td style="text-align:left;">
19.61 (9.27)
</td>
<td style="text-align:left;">
0.14 (12.85)
</td>
<td style="text-align:left;">
18.93 (9.18)
</td>
<td style="text-align:left;">
0.23 (14.26)
</td>
</tr>
<tr>
<td style="text-align:left;">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Median
</td>
<td style="text-align:left;">
16.02
</td>
<td style="text-align:left;">
-1.28
</td>
<td style="text-align:left;">
19
</td>
<td style="text-align:left;">
0.06
</td>
<td style="text-align:left;">
18.22
</td>
<td style="text-align:left;">
-1.54
</td>
</tr>
<tr>
<td style="text-align:left;">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Min, Max
</td>
<td style="text-align:left;">
0.05, 36.3
</td>
<td style="text-align:left;">
-31.31, 27.89
</td>
<td style="text-align:left;">
0.91, 44.75
</td>
<td style="text-align:left;">
-32.45, 38.85
</td>
<td style="text-align:left;">
0.66, 39.89
</td>
<td style="text-align:left;">
-30.72, 33.92
</td>
</tr>
<tr>
<td style="text-align:left;">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Missing
</td>
<td style="text-align:left;">
0
</td>
<td style="text-align:left;">
0
</td>
<td style="text-align:left;">
0
</td>
<td style="text-align:left;">
0
</td>
<td style="text-align:left;">
0
</td>
<td style="text-align:left;">
0
</td>
</tr>
<tr>
<td style="text-align:left;">
&nbsp;&nbsp;&nbsp;&nbsp;WEEK 2 DAY 15
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
</td>
</tr>
<tr>
<td style="text-align:left;">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;n
</td>
<td style="text-align:left;">
134
</td>
<td style="text-align:left;">
134
</td>
<td style="text-align:left;">
132
</td>
<td style="text-align:left;">
132
</td>
<td style="text-align:left;">
134
</td>
<td style="text-align:left;">
134
</td>
</tr>
<tr>
<td style="text-align:left;">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Mean (SD)
</td>
<td style="text-align:left;">
17.82 (9.6)
</td>
<td style="text-align:left;">
0.08 (14.15)
</td>
<td style="text-align:left;">
16.55 (8.15)
</td>
<td style="text-align:left;">
-2.92 (12.64)
</td>
<td style="text-align:left;">
18.82 (9.73)
</td>
<td style="text-align:left;">
0.11 (14.45)
</td>
</tr>
<tr>
<td style="text-align:left;">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Median
</td>
<td style="text-align:left;">
15.92
</td>
<td style="text-align:left;">
0.28
</td>
<td style="text-align:left;">
17.02
</td>
<td style="text-align:left;">
-1.11
</td>
<td style="text-align:left;">
17.96
</td>
<td style="text-align:left;">
-0.93
</td>
</tr>
<tr>
<td style="text-align:left;">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Min, Max
</td>
<td style="text-align:left;">
0.4, 44.33
</td>
<td style="text-align:left;">
-32.89, 40.55
</td>
<td style="text-align:left;">
0.35, 34.69
</td>
<td style="text-align:left;">
-28.36, 23.98
</td>
<td style="text-align:left;">
0.18, 44.34
</td>
<td style="text-align:left;">
-45.93, 29.85
</td>
</tr>
<tr>
<td style="text-align:left;">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Missing
</td>
<td style="text-align:left;">
0
</td>
<td style="text-align:left;">
0
</td>
<td style="text-align:left;">
0
</td>
<td style="text-align:left;">
0
</td>
<td style="text-align:left;">
0
</td>
<td style="text-align:left;">
0
</td>
</tr>
<tr>
<td style="text-align:left;">
&nbsp;&nbsp;&nbsp;&nbsp;WEEK 3 DAY 22
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
</td>
</tr>
<tr>
<td style="text-align:left;">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;n
</td>
<td style="text-align:left;">
134
</td>
<td style="text-align:left;">
134
</td>
<td style="text-align:left;">
132
</td>
<td style="text-align:left;">
132
</td>
<td style="text-align:left;">
134
</td>
<td style="text-align:left;">
134
</td>
</tr>
<tr>
<td style="text-align:left;">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Mean (SD)
</td>
<td style="text-align:left;">
18.37 (9.3)
</td>
<td style="text-align:left;">
0.63 (13.85)
</td>
<td style="text-align:left;">
16.75 (9.54)
</td>
<td style="text-align:left;">
-2.71 (13.22)
</td>
<td style="text-align:left;">
17.65 (9.58)
</td>
<td style="text-align:left;">
-1.06 (13.58)
</td>
</tr>
<tr>
<td style="text-align:left;">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Median
</td>
<td style="text-align:left;">
18.11
</td>
<td style="text-align:left;">
1.13
</td>
<td style="text-align:left;">
15.1
</td>
<td style="text-align:left;">
-2.66
</td>
<td style="text-align:left;">
17.68
</td>
<td style="text-align:left;">
-0.49
</td>
</tr>
<tr>
<td style="text-align:left;">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Min, Max
</td>
<td style="text-align:left;">
0.59, 41.73
</td>
<td style="text-align:left;">
-40.09, 31.24
</td>
<td style="text-align:left;">
0.48, 39.23
</td>
<td style="text-align:left;">
-30.63, 26.51
</td>
<td style="text-align:left;">
0.02, 38.61
</td>
<td style="text-align:left;">
-46.3, 31.38
</td>
</tr>
<tr>
<td style="text-align:left;">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Missing
</td>
<td style="text-align:left;">
0
</td>
<td style="text-align:left;">
0
</td>
<td style="text-align:left;">
0
</td>
<td style="text-align:left;">
0
</td>
<td style="text-align:left;">
0
</td>
<td style="text-align:left;">
0
</td>
</tr>
<tr>
<td style="text-align:left;">
&nbsp;&nbsp;&nbsp;&nbsp;WEEK 4 DAY 29
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
</td>
</tr>
<tr>
<td style="text-align:left;">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;n
</td>
<td style="text-align:left;">
134
</td>
<td style="text-align:left;">
134
</td>
<td style="text-align:left;">
132
</td>
<td style="text-align:left;">
132
</td>
<td style="text-align:left;">
134
</td>
<td style="text-align:left;">
134
</td>
</tr>
<tr>
<td style="text-align:left;">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Mean (SD)
</td>
<td style="text-align:left;">
19.17 (10.95)
</td>
<td style="text-align:left;">
1.44 (15.39)
</td>
<td style="text-align:left;">
17.92 (9.32)
</td>
<td style="text-align:left;">
-1.54 (12.63)
</td>
<td style="text-align:left;">
17.22 (10.64)
</td>
<td style="text-align:left;">
-1.48 (15.2)
</td>
</tr>
<tr>
<td style="text-align:left;">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Median
</td>
<td style="text-align:left;">
17.41
</td>
<td style="text-align:left;">
0.88
</td>
<td style="text-align:left;">
17.71
</td>
<td style="text-align:left;">
-1.53
</td>
<td style="text-align:left;">
15.88
</td>
<td style="text-align:left;">
-2.96
</td>
</tr>
<tr>
<td style="text-align:left;">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Min, Max
</td>
<td style="text-align:left;">
0.93, 54.24
</td>
<td style="text-align:left;">
-32.93, 46.98
</td>
<td style="text-align:left;">
0.25, 41.27
</td>
<td style="text-align:left;">
-30.33, 27.99
</td>
<td style="text-align:left;">
0.39, 47.96
</td>
<td style="text-align:left;">
-41.45, 43.08
</td>
</tr>
<tr>
<td style="text-align:left;">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Missing
</td>
<td style="text-align:left;">
0
</td>
<td style="text-align:left;">
0
</td>
<td style="text-align:left;">
0
</td>
<td style="text-align:left;">
0
</td>
<td style="text-align:left;">
0
</td>
<td style="text-align:left;">
0
</td>
</tr>
<tr>
<td style="text-align:left;">
&nbsp;&nbsp;&nbsp;&nbsp;WEEK 5 DAY 36
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
</td>
</tr>
<tr>
<td style="text-align:left;">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;n
</td>
<td style="text-align:left;">
134
</td>
<td style="text-align:left;">
134
</td>
<td style="text-align:left;">
132
</td>
<td style="text-align:left;">
132
</td>
<td style="text-align:left;">
134
</td>
<td style="text-align:left;">
134
</td>
</tr>
<tr>
<td style="text-align:left;">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Mean (SD)
</td>
<td style="text-align:left;">
19.22 (9.47)
</td>
<td style="text-align:left;">
1.48 (14.49)
</td>
<td style="text-align:left;">
18.51 (9.43)
</td>
<td style="text-align:left;">
-0.95 (12.92)
</td>
<td style="text-align:left;">
18.01 (9.92)
</td>
<td style="text-align:left;">
-0.69 (14.65)
</td>
</tr>
<tr>
<td style="text-align:left;">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Median
</td>
<td style="text-align:left;">
19.8
</td>
<td style="text-align:left;">
2.31
</td>
<td style="text-align:left;">
19.26
</td>
<td style="text-align:left;">
-2.48
</td>
<td style="text-align:left;">
18.28
</td>
<td style="text-align:left;">
1.82
</td>
</tr>
<tr>
<td style="text-align:left;">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Min, Max
</td>
<td style="text-align:left;">
0.01, 43.42
</td>
<td style="text-align:left;">
-40.08, 30.07
</td>
<td style="text-align:left;">
0.02, 37.46
</td>
<td style="text-align:left;">
-29.78, 25
</td>
<td style="text-align:left;">
0.11, 40.64
</td>
<td style="text-align:left;">
-47.6, 26.04
</td>
</tr>
<tr>
<td style="text-align:left;">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Missing
</td>
<td style="text-align:left;">
0
</td>
<td style="text-align:left;">
0
</td>
<td style="text-align:left;">
0
</td>
<td style="text-align:left;">
0
</td>
<td style="text-align:left;">
0
</td>
<td style="text-align:left;">
0
</td>
</tr>
<tr>
<td style="text-align:left;">
C-Reactive Protein Measurement
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:left;">
NA
</td>
</tr>
<tr>
<td style="text-align:left;">
&nbsp;&nbsp;&nbsp;&nbsp;BASELINE
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
</td>
</tr>
<tr>
<td style="text-align:left;">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;n
</td>
<td style="text-align:left;">
134
</td>
<td style="text-align:left;">
134
</td>
<td style="text-align:left;">
132
</td>
<td style="text-align:left;">
132
</td>
<td style="text-align:left;">
134
</td>
<td style="text-align:left;">
134
</td>
</tr>
<tr>
<td style="text-align:left;">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Mean (SD)
</td>
<td style="text-align:left;">
9.06 (0.93)
</td>
<td style="text-align:left;">
0 (0)
</td>
<td style="text-align:left;">
8.98 (0.89)
</td>
<td style="text-align:left;">
0 (0)
</td>
<td style="text-align:left;">
8.99 (0.98)
</td>
<td style="text-align:left;">
0 (0)
</td>
</tr>
<tr>
<td style="text-align:left;">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Median
</td>
<td style="text-align:left;">
9.07
</td>
<td style="text-align:left;">
0
</td>
<td style="text-align:left;">
8.96
</td>
<td style="text-align:left;">
0
</td>
<td style="text-align:left;">
8.92
</td>
<td style="text-align:left;">
0
</td>
</tr>
<tr>
<td style="text-align:left;">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Min, Max
</td>
<td style="text-align:left;">
6.21, 11.87
</td>
<td style="text-align:left;">
0, 0
</td>
<td style="text-align:left;">
6.24, 11.18
</td>
<td style="text-align:left;">
0, 0
</td>
<td style="text-align:left;">
6.23, 11.63
</td>
<td style="text-align:left;">
0, 0
</td>
</tr>
<tr>
<td style="text-align:left;">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Missing
</td>
<td style="text-align:left;">
0
</td>
<td style="text-align:left;">
0
</td>
<td style="text-align:left;">
0
</td>
<td style="text-align:left;">
0
</td>
<td style="text-align:left;">
0
</td>
<td style="text-align:left;">
0
</td>
</tr>
<tr>
<td style="text-align:left;">
&nbsp;&nbsp;&nbsp;&nbsp;WEEK 1 DAY 8
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
</td>
</tr>
<tr>
<td style="text-align:left;">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;n
</td>
<td style="text-align:left;">
134
</td>
<td style="text-align:left;">
134
</td>
<td style="text-align:left;">
132
</td>
<td style="text-align:left;">
132
</td>
<td style="text-align:left;">
134
</td>
<td style="text-align:left;">
134
</td>
</tr>
<tr>
<td style="text-align:left;">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Mean (SD)
</td>
<td style="text-align:left;">
9.01 (1.03)
</td>
<td style="text-align:left;">
-0.05 (1.38)
</td>
<td style="text-align:left;">
8.96 (1.03)
</td>
<td style="text-align:left;">
-0.02 (1.3)
</td>
<td style="text-align:left;">
8.98 (1)
</td>
<td style="text-align:left;">
0 (1.43)
</td>
</tr>
<tr>
<td style="text-align:left;">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Median
</td>
<td style="text-align:left;">
8.93
</td>
<td style="text-align:left;">
-0.17
</td>
<td style="text-align:left;">
8.91
</td>
<td style="text-align:left;">
0.02
</td>
<td style="text-align:left;">
8.96
</td>
<td style="text-align:left;">
-0.07
</td>
</tr>
<tr>
<td style="text-align:left;">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Min, Max
</td>
<td style="text-align:left;">
6.37, 11.33
</td>
<td style="text-align:left;">
-3.56, 3.48
</td>
<td style="text-align:left;">
7.15, 12.15
</td>
<td style="text-align:left;">
-3.28, 3.33
</td>
<td style="text-align:left;">
6.84, 11.53
</td>
<td style="text-align:left;">
-3.14, 4.28
</td>
</tr>
<tr>
<td style="text-align:left;">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Missing
</td>
<td style="text-align:left;">
0
</td>
<td style="text-align:left;">
0
</td>
<td style="text-align:left;">
0
</td>
<td style="text-align:left;">
0
</td>
<td style="text-align:left;">
0
</td>
<td style="text-align:left;">
0
</td>
</tr>
<tr>
<td style="text-align:left;">
&nbsp;&nbsp;&nbsp;&nbsp;WEEK 2 DAY 15
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
</td>
</tr>
<tr>
<td style="text-align:left;">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;n
</td>
<td style="text-align:left;">
134
</td>
<td style="text-align:left;">
134
</td>
<td style="text-align:left;">
132
</td>
<td style="text-align:left;">
132
</td>
<td style="text-align:left;">
134
</td>
<td style="text-align:left;">
134
</td>
</tr>
<tr>
<td style="text-align:left;">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Mean (SD)
</td>
<td style="text-align:left;">
8.87 (1.04)
</td>
<td style="text-align:left;">
-0.19 (1.47)
</td>
<td style="text-align:left;">
9.12 (0.96)
</td>
<td style="text-align:left;">
0.15 (1.25)
</td>
<td style="text-align:left;">
8.99 (1.05)
</td>
<td style="text-align:left;">
0.01 (1.45)
</td>
</tr>
<tr>
<td style="text-align:left;">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Median
</td>
<td style="text-align:left;">
8.86
</td>
<td style="text-align:left;">
-0.27
</td>
<td style="text-align:left;">
9.17
</td>
<td style="text-align:left;">
0.15
</td>
<td style="text-align:left;">
8.99
</td>
<td style="text-align:left;">
0
</td>
</tr>
<tr>
<td style="text-align:left;">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Min, Max
</td>
<td style="text-align:left;">
6.78, 12.55
</td>
<td style="text-align:left;">
-4.53, 4.45
</td>
<td style="text-align:left;">
6.68, 11.54
</td>
<td style="text-align:left;">
-2.92, 3.28
</td>
<td style="text-align:left;">
6.55, 12.73
</td>
<td style="text-align:left;">
-3.79, 3.43
</td>
</tr>
<tr>
<td style="text-align:left;">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Missing
</td>
<td style="text-align:left;">
0
</td>
<td style="text-align:left;">
0
</td>
<td style="text-align:left;">
0
</td>
<td style="text-align:left;">
0
</td>
<td style="text-align:left;">
0
</td>
<td style="text-align:left;">
0
</td>
</tr>
<tr>
<td style="text-align:left;">
&nbsp;&nbsp;&nbsp;&nbsp;WEEK 3 DAY 22
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
</td>
</tr>
<tr>
<td style="text-align:left;">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;n
</td>
<td style="text-align:left;">
134
</td>
<td style="text-align:left;">
134
</td>
<td style="text-align:left;">
132
</td>
<td style="text-align:left;">
132
</td>
<td style="text-align:left;">
134
</td>
<td style="text-align:left;">
134
</td>
</tr>
<tr>
<td style="text-align:left;">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Mean (SD)
</td>
<td style="text-align:left;">
9.08 (0.96)
</td>
<td style="text-align:left;">
0.03 (1.38)
</td>
<td style="text-align:left;">
8.99 (0.93)
</td>
<td style="text-align:left;">
0.02 (1.34)
</td>
<td style="text-align:left;">
8.97 (1.07)
</td>
<td style="text-align:left;">
-0.02 (1.49)
</td>
</tr>
<tr>
<td style="text-align:left;">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Median
</td>
<td style="text-align:left;">
9.09
</td>
<td style="text-align:left;">
0.15
</td>
<td style="text-align:left;">
8.97
</td>
<td style="text-align:left;">
0.2
</td>
<td style="text-align:left;">
8.97
</td>
<td style="text-align:left;">
-0.04
</td>
</tr>
<tr>
<td style="text-align:left;">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Min, Max
</td>
<td style="text-align:left;">
6.46, 11.6
</td>
<td style="text-align:left;">
-3.95, 2.99
</td>
<td style="text-align:left;">
6.3, 11.33
</td>
<td style="text-align:left;">
-2.76, 3.26
</td>
<td style="text-align:left;">
5.81, 11.37
</td>
<td style="text-align:left;">
-4.28, 4.24
</td>
</tr>
<tr>
<td style="text-align:left;">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Missing
</td>
<td style="text-align:left;">
0
</td>
<td style="text-align:left;">
0
</td>
<td style="text-align:left;">
0
</td>
<td style="text-align:left;">
0
</td>
<td style="text-align:left;">
0
</td>
<td style="text-align:left;">
0
</td>
</tr>
<tr>
<td style="text-align:left;">
&nbsp;&nbsp;&nbsp;&nbsp;WEEK 4 DAY 29
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
</td>
</tr>
<tr>
<td style="text-align:left;">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;n
</td>
<td style="text-align:left;">
134
</td>
<td style="text-align:left;">
134
</td>
<td style="text-align:left;">
132
</td>
<td style="text-align:left;">
132
</td>
<td style="text-align:left;">
134
</td>
<td style="text-align:left;">
134
</td>
</tr>
<tr>
<td style="text-align:left;">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Mean (SD)
</td>
<td style="text-align:left;">
8.8 (1.06)
</td>
<td style="text-align:left;">
-0.26 (1.45)
</td>
<td style="text-align:left;">
8.97 (0.95)
</td>
<td style="text-align:left;">
-0.01 (1.17)
</td>
<td style="text-align:left;">
9.04 (0.9)
</td>
<td style="text-align:left;">
0.05 (1.24)
</td>
</tr>
<tr>
<td style="text-align:left;">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Median
</td>
<td style="text-align:left;">
8.71
</td>
<td style="text-align:left;">
-0.37
</td>
<td style="text-align:left;">
8.88
</td>
<td style="text-align:left;">
-0.06
</td>
<td style="text-align:left;">
9.04
</td>
<td style="text-align:left;">
0.1
</td>
</tr>
<tr>
<td style="text-align:left;">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Min, Max
</td>
<td style="text-align:left;">
5.87, 12.22
</td>
<td style="text-align:left;">
-3.74, 4.15
</td>
<td style="text-align:left;">
7.16, 11.96
</td>
<td style="text-align:left;">
-3.06, 3.22
</td>
<td style="text-align:left;">
6.42, 11.21
</td>
<td style="text-align:left;">
-3.34, 3.71
</td>
</tr>
<tr>
<td style="text-align:left;">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Missing
</td>
<td style="text-align:left;">
0
</td>
<td style="text-align:left;">
0
</td>
<td style="text-align:left;">
0
</td>
<td style="text-align:left;">
0
</td>
<td style="text-align:left;">
0
</td>
<td style="text-align:left;">
0
</td>
</tr>
<tr>
<td style="text-align:left;">
&nbsp;&nbsp;&nbsp;&nbsp;WEEK 5 DAY 36
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
</td>
</tr>
<tr>
<td style="text-align:left;">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;n
</td>
<td style="text-align:left;">
134
</td>
<td style="text-align:left;">
134
</td>
<td style="text-align:left;">
132
</td>
<td style="text-align:left;">
132
</td>
<td style="text-align:left;">
134
</td>
<td style="text-align:left;">
134
</td>
</tr>
<tr>
<td style="text-align:left;">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Mean (SD)
</td>
<td style="text-align:left;">
9.04 (1.04)
</td>
<td style="text-align:left;">
-0.02 (1.5)
</td>
<td style="text-align:left;">
9.01 (0.91)
</td>
<td style="text-align:left;">
0.03 (1.27)
</td>
<td style="text-align:left;">
9.06 (1.01)
</td>
<td style="text-align:left;">
0.07 (1.34)
</td>
</tr>
<tr>
<td style="text-align:left;">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Median
</td>
<td style="text-align:left;">
8.98
</td>
<td style="text-align:left;">
0.01
</td>
<td style="text-align:left;">
8.96
</td>
<td style="text-align:left;">
0.05
</td>
<td style="text-align:left;">
9.1
</td>
<td style="text-align:left;">
0.15
</td>
</tr>
<tr>
<td style="text-align:left;">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Min, Max
</td>
<td style="text-align:left;">
6.92, 12.12
</td>
<td style="text-align:left;">
-4.15, 3.96
</td>
<td style="text-align:left;">
6.64, 11.93
</td>
<td style="text-align:left;">
-3.63, 4.78
</td>
<td style="text-align:left;">
7.08, 12.5
</td>
<td style="text-align:left;">
-3.5, 3.53
</td>
</tr>
<tr>
<td style="text-align:left;">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Missing
</td>
<td style="text-align:left;">
0
</td>
<td style="text-align:left;">
0
</td>
<td style="text-align:left;">
0
</td>
<td style="text-align:left;">
0
</td>
<td style="text-align:left;">
0
</td>
<td style="text-align:left;">
0
</td>
</tr>
<tr>
<td style="text-align:left;">
Immunoglobulin A Measurement
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:left;">
NA
</td>
</tr>
<tr>
<td style="text-align:left;">
&nbsp;&nbsp;&nbsp;&nbsp;BASELINE
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
</td>
</tr>
<tr>
<td style="text-align:left;">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;n
</td>
<td style="text-align:left;">
134
</td>
<td style="text-align:left;">
134
</td>
<td style="text-align:left;">
132
</td>
<td style="text-align:left;">
132
</td>
<td style="text-align:left;">
134
</td>
<td style="text-align:left;">
134
</td>
</tr>
<tr>
<td style="text-align:left;">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Mean (SD)
</td>
<td style="text-align:left;">
2.89 (0.08)
</td>
<td style="text-align:left;">
0 (0)
</td>
<td style="text-align:left;">
2.9 (0.11)
</td>
<td style="text-align:left;">
0 (0)
</td>
<td style="text-align:left;">
2.88 (0.1)
</td>
<td style="text-align:left;">
0 (0)
</td>
</tr>
<tr>
<td style="text-align:left;">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Median
</td>
<td style="text-align:left;">
2.89
</td>
<td style="text-align:left;">
0
</td>
<td style="text-align:left;">
2.91
</td>
<td style="text-align:left;">
0
</td>
<td style="text-align:left;">
2.89
</td>
<td style="text-align:left;">
0
</td>
</tr>
<tr>
<td style="text-align:left;">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Min, Max
</td>
<td style="text-align:left;">
2.7, 3.12
</td>
<td style="text-align:left;">
0, 0
</td>
<td style="text-align:left;">
2.61, 3.15
</td>
<td style="text-align:left;">
0, 0
</td>
<td style="text-align:left;">
2.64, 3.14
</td>
<td style="text-align:left;">
0, 0
</td>
</tr>
<tr>
<td style="text-align:left;">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Missing
</td>
<td style="text-align:left;">
0
</td>
<td style="text-align:left;">
0
</td>
<td style="text-align:left;">
0
</td>
<td style="text-align:left;">
0
</td>
<td style="text-align:left;">
0
</td>
<td style="text-align:left;">
0
</td>
</tr>
<tr>
<td style="text-align:left;">
&nbsp;&nbsp;&nbsp;&nbsp;WEEK 1 DAY 8
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
</td>
</tr>
<tr>
<td style="text-align:left;">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;n
</td>
<td style="text-align:left;">
134
</td>
<td style="text-align:left;">
134
</td>
<td style="text-align:left;">
132
</td>
<td style="text-align:left;">
132
</td>
<td style="text-align:left;">
134
</td>
<td style="text-align:left;">
134
</td>
</tr>
<tr>
<td style="text-align:left;">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Mean (SD)
</td>
<td style="text-align:left;">
2.91 (0.1)
</td>
<td style="text-align:left;">
0.02 (0.14)
</td>
<td style="text-align:left;">
2.91 (0.09)
</td>
<td style="text-align:left;">
0.01 (0.14)
</td>
<td style="text-align:left;">
2.91 (0.1)
</td>
<td style="text-align:left;">
0.03 (0.15)
</td>
</tr>
<tr>
<td style="text-align:left;">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Median
</td>
<td style="text-align:left;">
2.91
</td>
<td style="text-align:left;">
0.02
</td>
<td style="text-align:left;">
2.92
</td>
<td style="text-align:left;">
0.01
</td>
<td style="text-align:left;">
2.91
</td>
<td style="text-align:left;">
0.04
</td>
</tr>
<tr>
<td style="text-align:left;">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Min, Max
</td>
<td style="text-align:left;">
2.66, 3.21
</td>
<td style="text-align:left;">
-0.32, 0.34
</td>
<td style="text-align:left;">
2.71, 3.18
</td>
<td style="text-align:left;">
-0.34, 0.32
</td>
<td style="text-align:left;">
2.69, 3.16
</td>
<td style="text-align:left;">
-0.28, 0.38
</td>
</tr>
<tr>
<td style="text-align:left;">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Missing
</td>
<td style="text-align:left;">
0
</td>
<td style="text-align:left;">
0
</td>
<td style="text-align:left;">
0
</td>
<td style="text-align:left;">
0
</td>
<td style="text-align:left;">
0
</td>
<td style="text-align:left;">
0
</td>
</tr>
<tr>
<td style="text-align:left;">
&nbsp;&nbsp;&nbsp;&nbsp;WEEK 2 DAY 15
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
</td>
</tr>
<tr>
<td style="text-align:left;">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;n
</td>
<td style="text-align:left;">
134
</td>
<td style="text-align:left;">
134
</td>
<td style="text-align:left;">
132
</td>
<td style="text-align:left;">
132
</td>
<td style="text-align:left;">
134
</td>
<td style="text-align:left;">
134
</td>
</tr>
<tr>
<td style="text-align:left;">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Mean (SD)
</td>
<td style="text-align:left;">
2.91 (0.09)
</td>
<td style="text-align:left;">
0.02 (0.13)
</td>
<td style="text-align:left;">
2.89 (0.09)
</td>
<td style="text-align:left;">
-0.01 (0.14)
</td>
<td style="text-align:left;">
2.9 (0.09)
</td>
<td style="text-align:left;">
0.02 (0.14)
</td>
</tr>
<tr>
<td style="text-align:left;">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Median
</td>
<td style="text-align:left;">
2.91
</td>
<td style="text-align:left;">
0.03
</td>
<td style="text-align:left;">
2.91
</td>
<td style="text-align:left;">
-0.01
</td>
<td style="text-align:left;">
2.91
</td>
<td style="text-align:left;">
0.02
</td>
</tr>
<tr>
<td style="text-align:left;">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Min, Max
</td>
<td style="text-align:left;">
2.67, 3.22
</td>
<td style="text-align:left;">
-0.34, 0.32
</td>
<td style="text-align:left;">
2.7, 3.15
</td>
<td style="text-align:left;">
-0.4, 0.35
</td>
<td style="text-align:left;">
2.62, 3.15
</td>
<td style="text-align:left;">
-0.42, 0.36
</td>
</tr>
<tr>
<td style="text-align:left;">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Missing
</td>
<td style="text-align:left;">
0
</td>
<td style="text-align:left;">
0
</td>
<td style="text-align:left;">
0
</td>
<td style="text-align:left;">
0
</td>
<td style="text-align:left;">
0
</td>
<td style="text-align:left;">
0
</td>
</tr>
<tr>
<td style="text-align:left;">
&nbsp;&nbsp;&nbsp;&nbsp;WEEK 3 DAY 22
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
</td>
</tr>
<tr>
<td style="text-align:left;">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;n
</td>
<td style="text-align:left;">
134
</td>
<td style="text-align:left;">
134
</td>
<td style="text-align:left;">
132
</td>
<td style="text-align:left;">
132
</td>
<td style="text-align:left;">
134
</td>
<td style="text-align:left;">
134
</td>
</tr>
<tr>
<td style="text-align:left;">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Mean (SD)
</td>
<td style="text-align:left;">
2.89 (0.1)
</td>
<td style="text-align:left;">
0 (0.13)
</td>
<td style="text-align:left;">
2.9 (0.11)
</td>
<td style="text-align:left;">
0 (0.16)
</td>
<td style="text-align:left;">
2.9 (0.09)
</td>
<td style="text-align:left;">
0.02 (0.13)
</td>
</tr>
<tr>
<td style="text-align:left;">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Median
</td>
<td style="text-align:left;">
2.89
</td>
<td style="text-align:left;">
0
</td>
<td style="text-align:left;">
2.9
</td>
<td style="text-align:left;">
0
</td>
<td style="text-align:left;">
2.91
</td>
<td style="text-align:left;">
0.03
</td>
</tr>
<tr>
<td style="text-align:left;">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Min, Max
</td>
<td style="text-align:left;">
2.65, 3.15
</td>
<td style="text-align:left;">
-0.28, 0.33
</td>
<td style="text-align:left;">
2.65, 3.26
</td>
<td style="text-align:left;">
-0.38, 0.5
</td>
<td style="text-align:left;">
2.6, 3.2
</td>
<td style="text-align:left;">
-0.46, 0.38
</td>
</tr>
<tr>
<td style="text-align:left;">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Missing
</td>
<td style="text-align:left;">
0
</td>
<td style="text-align:left;">
0
</td>
<td style="text-align:left;">
0
</td>
<td style="text-align:left;">
0
</td>
<td style="text-align:left;">
0
</td>
<td style="text-align:left;">
0
</td>
</tr>
<tr>
<td style="text-align:left;">
&nbsp;&nbsp;&nbsp;&nbsp;WEEK 4 DAY 29
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
</td>
</tr>
<tr>
<td style="text-align:left;">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;n
</td>
<td style="text-align:left;">
134
</td>
<td style="text-align:left;">
134
</td>
<td style="text-align:left;">
132
</td>
<td style="text-align:left;">
132
</td>
<td style="text-align:left;">
134
</td>
<td style="text-align:left;">
134
</td>
</tr>
<tr>
<td style="text-align:left;">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Mean (SD)
</td>
<td style="text-align:left;">
2.92 (0.1)
</td>
<td style="text-align:left;">
0.03 (0.13)
</td>
<td style="text-align:left;">
2.9 (0.11)
</td>
<td style="text-align:left;">
-0.01 (0.15)
</td>
<td style="text-align:left;">
2.91 (0.1)
</td>
<td style="text-align:left;">
0.03 (0.14)
</td>
</tr>
<tr>
<td style="text-align:left;">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Median
</td>
<td style="text-align:left;">
2.93
</td>
<td style="text-align:left;">
0.03
</td>
<td style="text-align:left;">
2.89
</td>
<td style="text-align:left;">
-0.01
</td>
<td style="text-align:left;">
2.9
</td>
<td style="text-align:left;">
0.02
</td>
</tr>
<tr>
<td style="text-align:left;">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Min, Max
</td>
<td style="text-align:left;">
2.63, 3.16
</td>
<td style="text-align:left;">
-0.39, 0.37
</td>
<td style="text-align:left;">
2.59, 3.19
</td>
<td style="text-align:left;">
-0.38, 0.37
</td>
<td style="text-align:left;">
2.58, 3.15
</td>
<td style="text-align:left;">
-0.3, 0.42
</td>
</tr>
<tr>
<td style="text-align:left;">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Missing
</td>
<td style="text-align:left;">
0
</td>
<td style="text-align:left;">
0
</td>
<td style="text-align:left;">
0
</td>
<td style="text-align:left;">
0
</td>
<td style="text-align:left;">
0
</td>
<td style="text-align:left;">
0
</td>
</tr>
<tr>
<td style="text-align:left;">
&nbsp;&nbsp;&nbsp;&nbsp;WEEK 5 DAY 36
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
</td>
</tr>
<tr>
<td style="text-align:left;">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;n
</td>
<td style="text-align:left;">
134
</td>
<td style="text-align:left;">
134
</td>
<td style="text-align:left;">
132
</td>
<td style="text-align:left;">
132
</td>
<td style="text-align:left;">
134
</td>
<td style="text-align:left;">
134
</td>
</tr>
<tr>
<td style="text-align:left;">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Mean (SD)
</td>
<td style="text-align:left;">
2.91 (0.09)
</td>
<td style="text-align:left;">
0.02 (0.12)
</td>
<td style="text-align:left;">
2.9 (0.1)
</td>
<td style="text-align:left;">
-0.01 (0.16)
</td>
<td style="text-align:left;">
2.9 (0.1)
</td>
<td style="text-align:left;">
0.02 (0.14)
</td>
</tr>
<tr>
<td style="text-align:left;">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Median
</td>
<td style="text-align:left;">
2.91
</td>
<td style="text-align:left;">
0.02
</td>
<td style="text-align:left;">
2.91
</td>
<td style="text-align:left;">
0
</td>
<td style="text-align:left;">
2.92
</td>
<td style="text-align:left;">
0.02
</td>
</tr>
<tr>
<td style="text-align:left;">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Min, Max
</td>
<td style="text-align:left;">
2.6, 3.08
</td>
<td style="text-align:left;">
-0.33, 0.28
</td>
<td style="text-align:left;">
2.61, 3.13
</td>
<td style="text-align:left;">
-0.52, 0.34
</td>
<td style="text-align:left;">
2.62, 3.13
</td>
<td style="text-align:left;">
-0.3, 0.35
</td>
</tr>
<tr>
<td style="text-align:left;">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Missing
</td>
<td style="text-align:left;">
0
</td>
<td style="text-align:left;">
0
</td>
<td style="text-align:left;">
0
</td>
<td style="text-align:left;">
0
</td>
<td style="text-align:left;">
0
</td>
<td style="text-align:left;">
0
</td>
</tr>
</tbody>
</table>

</div>

**This example shows how to create AET01**

Follow example in merge_table_lists to get the relevant tables created

``` r
a<-event_count(adsl,patient = "USUBJID",treat = "ARM", label = "Total number of deaths", .filters = "DTHFL == 'Y'", .total_dt = NULL)
b<-event_count(adsl,patient = "USUBJID",treat = "ARM", label = "Total number of patients withdrawn from study due to an AE", .filters = "DCSREAS == 'ADVERSE EVENT'", .total_dt = NULL)
d<-event_count(adae, patient = "USUBJID", treat = "ARM", label = "Total number of patients with at least one AE",.total_dt = adsl)

e <- total_events(adae, 'ARM', 'Total number of AEs')
aesi_vars <- c("FATAL", "SER", "SERWD", "SERDSM", "RELSER", "WD", "DSM", "REL", "RELWD", "RELDSM", "SEV")
f <- multi_event_true(adae, event_vars = aesi_vars, patient = "USUBJID", treat = "ARM", heading = "Total number of patients with at least one", .total_dt = adsl, indent = "  ")

AET01 <- merge_table_lists(list(d,e,a,b,f))
knitr::kable(AET01) |>
  kableExtra::kable_styling() |>
  kableExtra::scroll_box(width = '100%', height = '500px')
```

<div style="border: 1px solid #ddd; padding: 0px; overflow-y: scroll; height:500px; overflow-x: scroll; width:100%; ">

<table class="table" style="margin-left: auto; margin-right: auto;">
<thead>
<tr>
<th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;">
stats
</th>
<th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;">
A: Drug X
</th>
<th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;">
C: Combination
</th>
<th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;">
B: Placebo
</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align:left;">
Total number of patients with at least one AE
</td>
<td style="text-align:left;">
100 (74.63%)
</td>
<td style="text-align:left;">
103 (78.03%)
</td>
<td style="text-align:left;">
98 (73.13%)
</td>
</tr>
<tr>
<td style="text-align:left;">
Total number of AEs
</td>
<td style="text-align:left;">
502
</td>
<td style="text-align:left;">
604
</td>
<td style="text-align:left;">
480
</td>
</tr>
<tr>
<td style="text-align:left;">
Total number of deaths
</td>
<td style="text-align:left;">
25 (18.66%)
</td>
<td style="text-align:left;">
22 (16.67%)
</td>
<td style="text-align:left;">
23 (17.16%)
</td>
</tr>
<tr>
<td style="text-align:left;">
Total number of patients withdrawn from study due to an AE
</td>
<td style="text-align:left;">
3 (2.24%)
</td>
<td style="text-align:left;">
5 (3.79%)
</td>
<td style="text-align:left;">
6 (4.48%)
</td>
</tr>
<tr>
<td style="text-align:left;">
Total number of patients with at least one
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
</td>
<td style="text-align:left;">
</td>
</tr>
<tr>
<td style="text-align:left;">
AE with fatal outcome
</td>
<td style="text-align:left;">
5 (3.73%)
</td>
<td style="text-align:left;">
6 (4.55%)
</td>
<td style="text-align:left;">
5 (3.73%)
</td>
</tr>
<tr>
<td style="text-align:left;">
Serious AE
</td>
<td style="text-align:left;">
85 (63.43%)
</td>
<td style="text-align:left;">
87 (65.91%)
</td>
<td style="text-align:left;">
80 (59.7%)
</td>
</tr>
<tr>
<td style="text-align:left;">
Serious AE leading to withdrawal from treatment
</td>
<td style="text-align:left;">
6 (4.48%)
</td>
<td style="text-align:left;">
9 (6.82%)
</td>
<td style="text-align:left;">
12 (8.96%)
</td>
</tr>
<tr>
<td style="text-align:left;">
Serious AE leading to dose modification/interruption
</td>
<td style="text-align:left;">
36 (26.87%)
</td>
<td style="text-align:left;">
47 (35.61%)
</td>
<td style="text-align:left;">
40 (29.85%)
</td>
</tr>
<tr>
<td style="text-align:left;">
Related Serious AE
</td>
<td style="text-align:left;">
64 (47.76%)
</td>
<td style="text-align:left;">
64 (48.48%)
</td>
<td style="text-align:left;">
52 (38.81%)
</td>
</tr>
<tr>
<td style="text-align:left;">
AE leading to withdrawal from treatment
</td>
<td style="text-align:left;">
20 (14.93%)
</td>
<td style="text-align:left;">
26 (19.7%)
</td>
<td style="text-align:left;">
24 (17.91%)
</td>
</tr>
<tr>
<td style="text-align:left;">
AE leading to dose modification/interruption
</td>
<td style="text-align:left;">
63 (47.01%)
</td>
<td style="text-align:left;">
77 (58.33%)
</td>
<td style="text-align:left;">
70 (52.24%)
</td>
</tr>
<tr>
<td style="text-align:left;">
Related AE
</td>
<td style="text-align:left;">
86 (64.18%)
</td>
<td style="text-align:left;">
92 (69.7%)
</td>
<td style="text-align:left;">
85 (63.43%)
</td>
</tr>
<tr>
<td style="text-align:left;">
Related AE leading to withdrawal from treatment
</td>
<td style="text-align:left;">
10 (7.46%)
</td>
<td style="text-align:left;">
12 (9.09%)
</td>
<td style="text-align:left;">
9 (6.72%)
</td>
</tr>
<tr>
<td style="text-align:left;">
Related AE leading to dose modification/interruption
</td>
<td style="text-align:left;">
44 (32.84%)
</td>
<td style="text-align:left;">
51 (38.64%)
</td>
<td style="text-align:left;">
44 (32.84%)
</td>
</tr>
<tr>
<td style="text-align:left;">
Severe AE (at greatest intensity)
</td>
<td style="text-align:left;">
77 (57.46%)
</td>
<td style="text-align:left;">
79 (59.85%)
</td>
<td style="text-align:left;">
70 (52.24%)
</td>
</tr>
</tbody>
</table>

</div>
