# Getting started with dtlg

``` r

library(dtlg)
```

## What dtlg is for

[dtlg](https://AscentSoftware.github.io/dtlg/) builds the summary tables
that populate Section 14 of a Clinical Study Report (CSR): demographics,
adverse event incidence, and laboratory summaries. The package covers
the tables in the TLG triad; listings and graphs are out of scope.
Inputs are ADaM-like analysis datasets (ADSL, ADAE, ADLB); outputs are
tidy `data.table`s ready to render with any downstream formatter
(`kableExtra`, `gt`, `flextable`, `rtables`, or a Shiny widget).

The package began as a response to a specific frustration: Shiny
dashboards for clinical review needed aggregations fast enough to
recompute on user input. The reference implementations in
[tern](https://pharmaverse.github.io/tern/) and
[rtables](https://github.com/pharmaverse/rtables) are authoritative but
were not designed for the round-trip latency of an interactive session.
Two design choices follow from that origin:

- The compute backend is `data.table`. Aggregation over populations of
  $`10^5`$ to $`10^6`$ subjects remains interactive. See
  `vignette("benchmarks")` for comparisons against
  [tern](https://pharmaverse.github.io/tern/).

- The output is always a plain `data.table` with a `stats` column and
  one column per treatment level. There is no bespoke table object, no
  print method to learn, and no rendering coupled to the computation.
  Indent strings default to HTML non-breaking spaces
  ([`nbsp()`](https://AscentSoftware.github.io/dtlg/reference/nbsp.md))
  so that the same output renders correctly in a Shiny `renderTable()`
  or `renderDT()` call without re-formatting.

This article walks through the user-facing API by reproducing three
representative tables.

## Example data

The package re-exports four ADaM-shaped datasets from
`random.cdisc.data` for illustration and testing:

| Object | Description                                                   |
|--------|---------------------------------------------------------------|
| `adsl` | Subject-level analysis dataset (one row per subject).         |
| `adae` | Adverse events analysis dataset.                              |
| `aesi` | `adae` filtered to analysis records, with derived AESI flags. |
| `adlb` | Laboratory measurements in BDS format.                        |

``` r

adsl[1:3, c("USUBJID", "ARM", "AGE", "SEX", "RACE")]
#> # A tibble: 3 × 5
#>   USUBJID               ARM              AGE SEX   RACE                     
#>   <chr>                 <fct>          <int> <fct> <fct>                    
#> 1 AB12345-CHN-3-id-128  A: Drug X         32 M     ASIAN                    
#> 2 AB12345-CHN-15-id-262 C: Combination    35 M     BLACK OR AFRICAN AMERICAN
#> 3 AB12345-RUS-3-id-378  C: Combination    30 F     ASIAN
```

## A first table: demographics

[`summary_table()`](https://AscentSoftware.github.io/dtlg/reference/summary_table.md)
is the high-level entry point. It dispatches on the type of each
`target` variable: numeric columns are summarised with
[`calc_desc()`](https://AscentSoftware.github.io/dtlg/reference/calc_desc.md)
(n, mean (SD), median, min/max, missing); categorical columns are
summarised with
[`calc_counts()`](https://AscentSoftware.github.io/dtlg/reference/calc_counts.md)
(n (%) per level, denominator from `.total_dt`).

The `indent` argument defaults to `nbsp(n = 4L)` — four HTML
non-breaking spaces — which renders correctly in Shiny and any HTML
formatter passed `escape = FALSE`. For console inspection, pass
`indent = " "` so the output is legible without HTML rendering:

``` r

dmg_vars <- c("AGE", "SEX", "RACE", "BMRKR1")
dmg_lbls <- c("Age (yr)", "Sex", "Race", "Biomarker 1")

dm_table <- summary_table(
  adsl,
  target      = dmg_vars,
  target_name = dmg_lbls,
  treat       = "ARM",
  indent      = "  "
)

dm_table
#>                                           stats  A: Drug X B: Placebo C: Combination
#>                                          <char>     <char>     <char>         <char>
#>  1:                                    Age (yr)                                     
#>  2:                                           n        134        134            132
#>  3:                                   Mean (SD) 33.8 (6.6) 35.4 (7.9)     35.4 (7.7)
#>  4:                                      Median         33         35             35
#>  5:                                    Min, Max 21.0, 50.0 21.0, 62.0     20.0, 69.0
#>  6:                                     Missing          0          0              0
#>  7:                                         Sex                                     
#>  8:                                           F 79 (59.0%) 82 (61.2%)     70 (53.0%)
#>  9:                                           M 55 (41.0%) 52 (38.8%)     62 (47.0%)
#> 10:                                        Race                                     
#> 11:            AMERICAN INDIAN OR ALASKA NATIVE   8 (6.0%)  11 (8.2%)       6 (4.5%)
#> 12:                                       ASIAN 68 (50.7%) 67 (50.0%)     73 (55.3%)
#> 13:                   BLACK OR AFRICAN AMERICAN 31 (23.1%) 28 (20.9%)     32 (24.2%)
#> 14:                                    MULTIPLE          0   1 (0.7%)              0
#> 15:   NATIVE HAWAIIAN OR OTHER PACIFIC ISLANDER          0   1 (0.7%)              0
#> 16:                                       OTHER          0          0              0
#> 17:                                     UNKNOWN          0          0              0
#> 18:                                       WHITE 27 (20.1%) 26 (19.4%)     21 (15.9%)
#> 19:                                 Biomarker 1                                     
#> 20:                                           n        134        134            132
#> 21:                                   Mean (SD)  6.0 (3.6)  5.7 (3.3)      5.6 (3.5)
#> 22:                                      Median        5.4        4.8            4.6
#> 23:                                    Min, Max  0.4, 17.7  0.6, 14.2      0.2, 21.4
#> 24:                                     Missing          0          0              0
#>                                           stats  A: Drug X B: Placebo C: Combination
#>                                          <char>     <char>     <char>         <char>
```

The first column carries the variable heading and the indented statistic
labels. The remaining columns are the levels of `treat`. Reorder columns
explicitly with `treat_order`:

``` r

summary_table(
  adsl,
  target      = "AGE",
  target_name = "Age (yr)",
  treat       = "ARM",
  treat_order = c("B: Placebo", "A: Drug X", "C: Combination"),
  indent      = "  "
)
#>          stats B: Placebo  A: Drug X C: Combination
#>         <char>     <char>     <char>         <char>
#> 1:    Age (yr)                                     
#> 2:           n        134        134            132
#> 3:   Mean (SD) 35.4 (7.9) 33.8 (6.6)     35.4 (7.7)
#> 4:      Median         35         33             35
#> 5:    Min, Max 21.0, 62.0 21.0, 50.0     20.0, 69.0
#> 6:     Missing          0          0              0
```

## Building blocks for event tables

Safety tables are constructed from small, composable primitives. Each
returns a one-element list wrapping a `data.table`;
[`merge_table_lists()`](https://AscentSoftware.github.io/dtlg/reference/merge_table_lists.md)
unwraps and row-binds them. The list wrapping exists so that mixed-shape
intermediates can be assembled without intermediate casting.

| Helper | Counts |
|----|----|
| [`event_count()`](https://AscentSoftware.github.io/dtlg/reference/event_count.md) | Patients matching a predicate (e.g. `DTHFL == 'Y'`). |
| [`total_events()`](https://AscentSoftware.github.io/dtlg/reference/total_events.md) | Records, not patients (e.g. total AEs). |
| [`multi_event_true()`](https://AscentSoftware.github.io/dtlg/reference/multi_event_true.md) | Patients flagged across many binary indicators. |
| [`event_count_by()`](https://AscentSoftware.github.io/dtlg/reference/event_count_by.md) | Patients and events nested by a grouping variable. |

A minimal example. Deaths per arm:

``` r

event_count(
  adsl,
  patient  = "USUBJID",
  treat    = "ARM",
  label    = "Total number of deaths",
  .filters = "DTHFL == 'Y'"
)[[1]]
#>                     stats  A: Drug X B: Placebo C: Combination
#>                    <char>     <char>     <char>         <char>
#> 1: Total number of deaths 25 (18.7%) 23 (17.2%)     22 (16.7%)
```

`.filters` is a character vector of unevaluated R expressions; they are
parsed and applied in the frame of `dt`. Passing multiple expressions
combines them with logical AND.

## Composing AET01 from primitives

The AET01 table is the canonical safety overview. The high-level
[`AET01_table()`](https://AscentSoftware.github.io/dtlg/reference/AET01_table.md)
wraps the composition shown below; understanding the primitives makes
the result auditable.

``` r

aesi_vars <- c(
  "FATAL", "SER", "SERWD", "SERDSM", "RELSER",
  "WD", "DSM", "REL", "RELWD", "RELDSM", "SEV"
)

deaths <- event_count(
  adsl,
  patient  = "USUBJID",
  treat    = "ARM",
  label    = "Total number of deaths",
  .filters = "DTHFL == 'Y'"
)

withdrawals <- event_count(
  adsl,
  patient  = "USUBJID",
  treat    = "ARM",
  label    = "Total number of patients withdrawn due to an AE",
  .filters = "DCSREAS == 'ADVERSE EVENT'"
)

patients_any_ae <- event_count(
  aesi,
  patient   = "USUBJID",
  treat     = "ARM",
  label     = "Total number of patients with at least one AE",
  .total_dt = adsl
)

total_ae <- total_events(
  aesi,
  treat = "ARM",
  label = "Total number of AEs"
)

aesi_block <- multi_event_true(
  aesi,
  event_vars = aesi_vars,
  patient    = "USUBJID",
  treat      = "ARM",
  heading    = "Total number of patients with at least one",
  .total_dt  = adsl,
  indent     = "  "
)

aet01 <- merge_table_lists(list(
  patients_any_ae,
  total_ae,
  deaths,
  withdrawals,
  aesi_block
))

aet01
#>                                                      stats   A: Drug X B: Placebo C: Combination
#>                                                     <char>      <char>     <char>         <char>
#>  1:          Total number of patients with at least one AE 100 (74.6%) 98 (73.1%)    103 (78.0%)
#>  2:                                    Total number of AEs         502        480            604
#>  3:                                 Total number of deaths  25 (18.7%) 23 (17.2%)     22 (16.7%)
#>  4:        Total number of patients withdrawn due to an AE    3 (2.2%)   6 (4.5%)       5 (3.8%)
#>  5:             Total number of patients with at least one                                      
#>  6:                                  AE with fatal outcome    5 (3.7%)   5 (3.7%)       6 (4.5%)
#>  7:                                             Serious AE  85 (63.4%) 80 (59.7%)     87 (65.9%)
#>  8:        Serious AE leading to withdrawal from treatment    6 (4.5%)  12 (9.0%)       9 (6.8%)
#>  9:   Serious AE leading to dose modification/interruption  36 (26.9%) 40 (29.9%)     47 (35.6%)
#> 10:                                     Related Serious AE  64 (47.8%) 52 (38.8%)     64 (48.5%)
#> 11:                AE leading to withdrawal from treatment  20 (14.9%) 24 (17.9%)     26 (19.7%)
#> 12:           AE leading to dose modification/interruption  63 (47.0%) 70 (52.2%)     77 (58.3%)
#> 13:                                             Related AE  86 (64.2%) 85 (63.4%)     92 (69.7%)
#> 14:        Related AE leading to withdrawal from treatment   10 (7.5%)   9 (6.7%)      12 (9.1%)
#> 15:   Related AE leading to dose modification/interruption  44 (32.8%) 44 (32.8%)     51 (38.6%)
#> 16:                      Severe AE (at greatest intensity)  77 (57.5%) 70 (52.2%)     79 (59.8%)
```

Two details worth noting. First, `.total_dt = adsl` supplies the
denominator for percentages; without it the denominator is `dt` itself,
which silently yields the wrong result whenever the analysis dataset is
filtered. Second, the AESI block uses the `label` attribute of each flag
variable for row labels when `label` is not supplied explicitly;
[`with_label()`](https://AscentSoftware.github.io/dtlg/reference/with_label.md)
sets that attribute.

The one-liner equivalent is
[`AET01_table()`](https://AscentSoftware.github.io/dtlg/reference/AET01_table.md):

``` r

aet01_oneliner <- AET01_table(
  adsl        = adsl,
  adae        = aesi,
  patient_var = "USUBJID",
  treat_var   = "ARM",
  aesi_vars   = aesi_vars
)

identical(aet01, aet01_oneliner)
#> [1] TRUE
```

## AE incidence by SOC and PT

[`AET02_table()`](https://AscentSoftware.github.io/dtlg/reference/AET02_table.md)
produces the System Organ Class / Preferred Term breakdown, combining
[`event_count()`](https://AscentSoftware.github.io/dtlg/reference/event_count.md),
[`total_events()`](https://AscentSoftware.github.io/dtlg/reference/total_events.md),
and
[`event_count_by()`](https://AscentSoftware.github.io/dtlg/reference/event_count_by.md):

``` r

aet02 <- AET02_table(
  adsl    = adsl,
  adae    = aesi,
  patient = "USUBJID",
  treat   = "ARM",
  target  = "AEDECOD",
  rows_by = "AEBODSYS",
  indent  = "  "
)

head(aet02, 12)
#>                                                stats   A: Drug X B: Placebo C: Combination
#>                                               <char>      <char>     <char>         <char>
#>  1:    Total number of patients with at least one AE 100 (74.6%) 98 (73.1%)    103 (78.0%)
#>  2:                              Total number of AEs         502        480            604
#>  3:                                           cl B.2                                      
#>  4:                                    dcd B.2.1.2.1  52 (38.8%) 51 (38.1%)     59 (44.7%)
#>  5:                                    dcd B.2.2.3.1  50 (37.3%) 55 (41.0%)     68 (51.5%)
#>  6:                           Total number of events         102        106            127
#>  7: Total number of patients with at least one event  62 (46.3%) 56 (41.8%)     74 (56.1%)
#>  8:                                           cl D.1                                      
#>  9:                                    dcd D.1.1.1.1  52 (38.8%) 40 (29.9%)     64 (48.5%)
#> 10:                                    dcd D.1.1.4.2  54 (40.3%) 44 (32.8%)     50 (37.9%)
#> 11:                           Total number of events         106         84            114
#> 12: Total number of patients with at least one event  64 (47.8%) 54 (40.3%)     68 (51.5%)
```

## Longitudinal laboratory summaries

For BDS-shaped data such as `adlb`,
[`summary_table_by()`](https://AscentSoftware.github.io/dtlg/reference/summary_table_by.md)
groups rows by one or more nesting variables, and
[`summary_table_by_targets()`](https://AscentSoftware.github.io/dtlg/reference/summary_table_by_targets.md)
summarises two target columns side by side — the typical layout for
value and change-from-baseline:

``` r

adlb_post <- adlb[adlb$AVISIT != "SCREENING", ]

lb_table <- summary_table_by_targets(
  dt      = adlb_post,
  target  = c("AVAL", "CHG"),
  treat   = "ARM",
  rows_by = c("PARAM", "AVISIT"),
  indent  = "  "
)

head(lb_table, 8)
#>                                   stats A: Drug X.AVAL A: Drug X.CHG B: Placebo.AVAL B: Placebo.CHG
#>                                  <char>         <char>        <char>          <char>         <char>
#> 1: Alanine Aminotransferase Measurement           <NA>          <NA>            <NA>           <NA>
#> 2:                             BASELINE                                                            
#> 3:                                    n            134           134             134            134
#> 4:                            Mean (SD)     17.7 (9.9)     0.0 (0.0)      18.7 (9.8)      0.0 (0.0)
#> 5:                               Median           17.5             0            18.2              0
#> 6:                             Min, Max      0.0, 44.1      0.0, 0.0       1.5, 54.4       0.0, 0.0
#> 7:                              Missing              0             0               0              0
#> 8:                         WEEK 1 DAY 8                                                            
#>    C: Combination.AVAL C: Combination.CHG
#>                 <char>             <char>
#> 1:                <NA>               <NA>
#> 2:                                       
#> 3:                 132                132
#> 4:          19.5 (9.1)          0.0 (0.0)
#> 5:                  19                  0
#> 6:           0.6, 39.8           0.0, 0.0
#> 7:                   0                  0
#> 8:
```

The output column names are suffixed with `.AVAL` and `.CHG` so the two
blocks remain distinguishable after the column-bind.

## Output is a plain data.table

Every constructor returns a `data.table`. Rendering is the caller’s
choice. Because the default indent and the formatted percentage strings
contain HTML entities (`&nbsp;`), pass `escape = FALSE` (or the
equivalent) to the renderer so the indentation is honoured:

``` r

dm_html <- summary_table(
  adsl,
  target      = dmg_vars,
  target_name = dmg_lbls,
  treat       = "ARM"
)

dm_html |>
  kableExtra::kable(format = "html", escape = FALSE) |>
  kableExtra::kable_styling(full_width = FALSE)
```

| stats | A: Drug X | B: Placebo | C: Combination |
|:---|:---|:---|:---|
| Age (yr) |  |  |  |
|     n | 134 | 134 | 132 |
|     Mean (SD) | 33.8 (6.6) | 35.4 (7.9) | 35.4 (7.7) |
|     Median | 33 | 35 | 35 |
|     Min, Max | 21.0, 50.0 | 21.0, 62.0 | 20.0, 69.0 |
|     Missing | 0 | 0 | 0 |
| Sex |  |  |  |
|     F | 79 (59.0%) | 82 (61.2%) | 70 (53.0%) |
|     M | 55 (41.0%) | 52 (38.8%) | 62 (47.0%) |
| Race |  |  |  |
|     AMERICAN INDIAN OR ALASKA NATIVE | 8 (6.0%) | 11 (8.2%) | 6 (4.5%) |
|     ASIAN | 68 (50.7%) | 67 (50.0%) | 73 (55.3%) |
|     BLACK OR AFRICAN AMERICAN | 31 (23.1%) | 28 (20.9%) | 32 (24.2%) |
|     MULTIPLE | 0 | 1 (0.7%) | 0 |
|     NATIVE HAWAIIAN OR OTHER PACIFIC ISLANDER | 0 | 1 (0.7%) | 0 |
|     OTHER | 0 | 0 | 0 |
|     UNKNOWN | 0 | 0 | 0 |
|     WHITE | 27 (20.1%) | 26 (19.4%) | 21 (15.9%) |
| Biomarker 1 |  |  |  |
|     n | 134 | 134 | 132 |
|     Mean (SD) | 6.0 (3.6) | 5.7 (3.3) | 5.6 (3.5) |
|     Median | 5.4 | 4.8 | 4.6 |
|     Min, Max | 0.4, 17.7 | 0.6, 14.2 | 0.2, 21.4 |
|     Missing | 0 | 0 | 0 |

In a Shiny app the same object goes straight into
`renderTable(sanitize.text.function = identity)` or
`DT::renderDT(escape = FALSE)`; no intermediate conversion is required.
This is the use case the package was shaped around: a treatment-arm
selector or a population filter recomputes the table on every input
change, and the round-trip stays interactive on ADaM datasets at
trial-realistic sizes.

For console inspection,
[`print_dtlg()`](https://AscentSoftware.github.io/dtlg/reference/print_dtlg.md)
wraps `data.table`’s print method with left-justified columns and no
truncation:

``` r

print_dtlg(head(aet01, 5))
#>                                            stats   A: Drug X B: Placebo C: Combination
#>  Total number of patients with at least one AE   100 (74.6%) 98 (73.1%)    103 (78.0%)
#>  Total number of AEs                             502         480           604        
#>  Total number of deaths                          25 (18.7%)  23 (17.2%)    22 (16.7%) 
#>  Total number of patients withdrawn due to an AE 3 (2.2%)    6 (4.5%)      5 (3.8%)   
#>  Total number of patients with at least one
```

## Copy semantics

[dtlg](https://AscentSoftware.github.io/dtlg/) exposes the `data.table`
reference-vs-value trade-off explicitly rather than silently choosing
for the user. Internally, every constructor calls
[`maybe_copy_dt()`](https://AscentSoftware.github.io/dtlg/reference/maybe_copy_dt.md),
which consults the global option `dtlg_dt_copy_semantics`:

- `"reference"` (default): a `data.frame` input is converted in place
  via `setDT()`. Subsequent operations alias the caller’s object. This
  is fastest and matches `data.table` idioms.
- `"value"`: inputs are deep-copied. Constructors never mutate the
  caller’s data, at the cost of one allocation per call.

Inspect and switch:

``` r

dt_copy_semantics()
#> [1] "reference"
old <- set_dt_copy_semantics("value")
dt_copy_semantics()
#> [1] "value"
set_dt_copy_semantics(old)
```

If you write [dtlg](https://AscentSoftware.github.io/dtlg/) calls inside
a function that should preserve `data.frame`-like inputs, set `"value"`
semantics for the scope. For production pipelines on large analysis
datasets where the inputs are already `data.table`s and not reused
downstream, the default is correct and avoids redundant allocation.

## Comparison with tern

[tern](https://pharmaverse.github.io/tern/) and
[rtables](https://github.com/pharmaverse/rtables) produce the canonical
reference output for these tables.
[dtlg](https://AscentSoftware.github.io/dtlg/) ships thin wrappers —
[`tern_summary_table()`](https://AscentSoftware.github.io/dtlg/reference/tern_summary_table.md),
[`tern_AET01_table()`](https://AscentSoftware.github.io/dtlg/reference/tern_AET01_table.md),
[`tern_AET02_table()`](https://AscentSoftware.github.io/dtlg/reference/tern_AET02_table.md)
— that build the equivalent `TableTree` through
[tern](https://pharmaverse.github.io/tern/) using the same call
signature as the [dtlg](https://AscentSoftware.github.io/dtlg/)
constructor.
[`as_dtlg_table()`](https://AscentSoftware.github.io/dtlg/reference/as_dtlg_table.md)
flattens a `TableTree` to the `data.table` shape used in this article.
Together they enable structured side-by-side checks during validation:

``` r

tt <- tern_summary_table(
  adsl,
  target      = c("AGE", "SEX"),
  target_name = c("Age (yr)", "Sex"),
  treat       = "ARM"
)

as_dtlg_table(tt)
#>        stats   A: Drug X  B: Placebo C: Combination
#>       <char>      <char>      <char>         <char>
#> 1:  Age (yr)                                       
#> 2:         n         134         134            132
#> 3: Mean (SD)  33.8 (6.6)  35.4 (7.9)     35.4 (7.7)
#> 4:    Median        33.0        35.0           35.0
#> 5: Min - Max 21.0 - 50.0 21.0 - 62.0    20.0 - 69.0
#> 6:       Sex                                       
#> 7:         n         134         134            132
#> 8:         F    79 (59%)  82 (61.2%)       70 (53%)
#> 9:         M    55 (41%)  52 (38.8%)       62 (47%)
```

## Where to go next

- `vignette("benchmarks")` — timing comparisons against
  [tern](https://pharmaverse.github.io/tern/) on realistic population
  sizes.
- The function reference, grouped by responsibility (Statistics, Events,
  Summary Tables, Clinical Tables, tern interop, Copy semantics).
- [`?aesi`](https://AscentSoftware.github.io/dtlg/reference/aesi.md) —
  documentation of the derived AESI flags used throughout the safety
  examples.
