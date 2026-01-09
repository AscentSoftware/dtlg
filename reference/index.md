# Package index

## Tabulation

### Statistics

- [`calc_counts()`](https://AscentSoftware.github.io/dtlg/reference/calc_counts.md)
  : Calculate counts of a categorical variable
- [`calc_desc()`](https://AscentSoftware.github.io/dtlg/reference/calc_desc.md)
  : Calculate descriptive summary statistics for a numeric variable
- [`calc_stats()`](https://AscentSoftware.github.io/dtlg/reference/calc_stats.md)
  : Calculate summary statistics for a variable

### Events

- [`event_count()`](https://AscentSoftware.github.io/dtlg/reference/event_count.md)
  : Count events
- [`event_count_by()`](https://AscentSoftware.github.io/dtlg/reference/event_count_by.md)
  : Summarise adverse events by arm and other grouping variables
- [`total_events()`](https://AscentSoftware.github.io/dtlg/reference/total_events.md)
  : Count total events
- [`multi_event_true()`](https://AscentSoftware.github.io/dtlg/reference/multi_event_true.md)
  : Summarise multiple AESI-like events per treatment arm

### Summary Tables

- [`summary_table()`](https://AscentSoftware.github.io/dtlg/reference/summary_table.md)
  : Summary Table
- [`summary_table_by()`](https://AscentSoftware.github.io/dtlg/reference/summary_table_by.md)
  : Create a summary table using multiple rows for grouping on one
  target column
- [`summary_table_by_targets()`](https://AscentSoftware.github.io/dtlg/reference/summary_table_by_targets.md)
  : Create a summary table using multiple rows for grouping on two
  target column ideal for creating change from baseline tables

### Clinical Tables

- [`AET01_table()`](https://AscentSoftware.github.io/dtlg/reference/AET01_table.md)
  : Generate Core Safety Tables for Clinical Study Reports
- [`AET02_table()`](https://AscentSoftware.github.io/dtlg/reference/AET02_table.md)
  : Create AET02-style AE summary table

## tern

Wrappers for generating tern-compatible tables to enable structured
side-by-side comparison

- [`as_dtlg_table()`](https://AscentSoftware.github.io/dtlg/reference/as_dtlg_table.md)
  : Convert a TableTree to a dtlg table

- [`tern_summary_table()`](https://AscentSoftware.github.io/dtlg/reference/tern_summary_table.md)
  : Create a clinical reporting table with tern/rtables

- [`tern_AET01_table()`](https://AscentSoftware.github.io/dtlg/reference/tern_AET01_table.md)
  :

  Generate Core Safety Tables (CSR Section 14.3.1) using
  `tern`/`rtables`

- [`tern_AET02_table()`](https://AscentSoftware.github.io/dtlg/reference/tern_AET02_table.md)
  :

  Generate AET02-style AE summary using `tern` and `rtables`

## Copy semantics

Control how objects are returned as `data.table`s: by reference (in
place) or by value (deep copy).

- [`dt_copy_semantics()`](https://AscentSoftware.github.io/dtlg/reference/dt_copy_semantics.md)
  [`set_dt_copy_semantics()`](https://AscentSoftware.github.io/dtlg/reference/dt_copy_semantics.md)
  : Get or set data.table copy semantics
- [`maybe_copy_dt()`](https://AscentSoftware.github.io/dtlg/reference/maybe_copy_dt.md)
  : Return a data.table by reference or by value

## Built in datasets

- [`adsl`](https://AscentSoftware.github.io/dtlg/reference/adsl.md) :
  Subject-Level Analysis Dataset (ADSL) example dataset
- [`adlb`](https://AscentSoftware.github.io/dtlg/reference/adlb.md) :
  ADaM Basic Data Structure (BDS) example dataset
- [`adae`](https://AscentSoftware.github.io/dtlg/reference/adae.md) :
  Adverse Event Analysis Dataset example dataset
- [`aesi`](https://AscentSoftware.github.io/dtlg/reference/aesi.md) :
  Adverse Events of Special Interest (AESI) example dataset

## Miscellanea

- [`label()`](https://AscentSoftware.github.io/dtlg/reference/label.md)
  : Retrieve the label of an object

- [`with_label()`](https://AscentSoftware.github.io/dtlg/reference/with_label.md)
  : Add a label attribute to an object

- [`round_pct()`](https://AscentSoftware.github.io/dtlg/reference/round_pct.md)
  : Rounded percentage

- [`round_sum()`](https://AscentSoftware.github.io/dtlg/reference/round_sum.md)
  : Rounds numbers while preserving the total sum

- [`merge_table_lists()`](https://AscentSoftware.github.io/dtlg/reference/merge_table_lists.md)
  : Merge a list of list-wrapped data.tables into one data.table

- [`cross_tab_to_obsv_tab()`](https://AscentSoftware.github.io/dtlg/reference/cross_tab_to_obsv_tab.md)
  : Convert a contingency table to a long-format observation-level data
  frame

- [`print_dtlg()`](https://AscentSoftware.github.io/dtlg/reference/print_dtlg.md)
  :

  Print a `dtlg` table
