# dtlg (development version)

## Bug fixes and behaviour changes

- `event_count()` now passes `pct_dec` on to the percentage calculation;
  previously the argument was accepted but ignored, and percentages always
  used one decimal place.
- `summary_table_by()` and `summary_table_by_targets()` gain the
  `inc_missing` argument announced in 0.1.0, with the same meaning as in
  `summary_table()`. It is appended after existing arguments, so positional
  calls are unaffected. In `summary_table_by_targets()`, `inc_missing = NA`
  shows the Missing row in every group when any target has a missing value,
  so that the per-target columns stay aligned.
- Corrected the `calc_counts()` documentation of `pct_dec`, which is used
  when `.total_dt` is supplied.
- `event_count()`, `event_count_by()` and `multi_event_true()` now check that
  the denominator population `.total_dt` has one row per patient, no missing
  patient identifiers and one treatment per patient. Previously, calling them
  on event-level data such as ADAE without `.total_dt` silently divided
  patient counts by the number of event records (e.g. 20% instead of 91% of
  subjects with an AE in the bundled data); this now raises an informative
  error asking for a subject-level population such as ADSL.
- `multi_event_true()` now defaults to `.total_dt = dt`, as its documentation
  described. Previously the `NULL` default caused an error.
- In the event helpers, `.total_dt = NULL` now reports counts without
  percentages, consistent with `calc_counts()`.
- `summary_table_by()` and `summary_table_by_targets()` now pass `.total_dt`
  on, so categorical targets report percentages against the supplied
  population. `summary_table_by()` now defaults to `.total_dt = NULL`; output
  without a supplied population is unchanged (counts only).
- `.total_dt` is documented consistently across the package as the
  subject-level population used for percentages.
- Numeric summaries of a group with no observed values now show empty Mean
  (SD), Median and Min, Max cells, instead of `Inf, -Inf` with warnings.
- `multi_event_true()`, and therefore `AET01_table()`, now reject character or
  factor flags in `event_vars`, which previously counted zero patients
  silently because they never equal `TRUE`.
- `event_count()` no longer fails when no record matches its filters, for
  example a study without deaths or an AESI flag without events. It reports
  `0` in every arm instead. This also fixes `multi_event_true()`,
  `AET01_table()` and `AET02_table()` in those situations.
- `AET01_table()` now checks that `adsl` contains `DTHFL` and `DCSREAS`, and
  `AET02_table()` that `adsl` contains the treatment column, reporting a clear
  error instead of failing later.

# dtlg 0.1.2

## New features

- Added and exported `aesi_heading_msg()`, which provides the shared default
  heading used for adverse events of special interest in the native and
  `{tern}` AET01 tables.

## Bug fixes and behaviour changes

- `as_dtlg_table()` now uses `where(is.character)` when selecting columns,
  removing a tidyselect deprecation warning.
- Reinstated the internal `%||%` operator and documented its explicit use to
  avoid a false-positive dead-code warning from `{goodpractice}`.
- Replaced `vctrs::vec_recycle_common()` with a focused base R implementation
  and removed `{vctrs}` from package dependencies. Existing
  `summary_table()` argument-recycling behaviour is preserved.

## Internal improvements

- Extracted input validation and table-layout helpers from `AET01_table()` and
  `tern_AET01_table()`.
- Extracted descriptive-statistics calculation and validation helpers from
  `calc_desc()`.
- Removed unused column-relevel helpers and moved format-matching utilities
  from package code into the test suite.
- Expanded tests for AET01 and AET02 tables, `{tern}` table layouts,
  `calc_stats()`, `as_dtlg_table()`, printing, labels, package availability,
  contingency-table expansion, and vector recycling.
- Strengthened existing tests with stricter type, structure, formatting, and
  error assertions.

## Infrastructure and tooling

- Added the rOpenSci `pkgcheck` workflow.
- Refined the `lintr` configuration and added targeted exclusions for
  established API names.

# dtlg 0.1.1

## Bug fixes and behaviour changes

* `AET01_table()`: the row label for AE-related withdrawals has been
  shortened from "Total number of patients withdrawn from study due to an
  AE" to "Total number of patients withdrawn due to an AE", for
  consistency with the other terse event labels in the same table. Code
  that matches this label by string equality (e.g. snapshot tests) will
  need to be updated.

## Documentation

* The README and the "Getting started" article now set a wider print
  width and display the full AET01 table rather than truncating row
  labels.

# dtlg 0.1.0

## New features

* `summary_table()`, `summary_table_by()` and `summary_table_by_targets()` gain
  an `inc_missing` argument controlling how the "Missing" row is rendered for
  numeric targets: `TRUE` (default) always shows it, `NA` shows it only when
  missing values are present, and `FALSE` suppresses it. Plumbed through to
  `calc_desc()` and `calc_stats()`.
* `summary_table_by()` and `summary_table_by_targets()` gain a `sep` argument
  to set the separator between the heading and group labels when grouping by
  more than one variable in `rows_by` (defaults to `"."`).

## Bug fixes and behaviour changes

* `calc_desc()`: the `n` row now reports the count of non-missing values
rather than the total row count (`.N`), so `n` and the `Missing` row are now
consistent.
* `summary_table_by_targets()`: removed the spurious "target needs to be
  length 2" message; multiple target variables are now properly supported and
  covered by tests.

## Infrastructure and tooling

* Adopted `lintr` with default linters across the package and added a
`lint.yaml` GitHub Actions workflow.
* Added a code-coverage workflow that posts a coverage summary as a comment on
  pull requests, gated on `pull_request` events to avoid duplicate runs.
* Expanded the test suite -- new tests for `AET01_table()`, the rounding
  helpers, `tern_summary_table()`, and additional `summary_table*()` cases
  (multiple targets, missing-value handling) -- raising overall coverage.

## Documentation and metadata

* Reorganised maintainership and contact details: maintainer e-mails moved to
  the `acuityanalytics.com` domain and copyright holder updated to Acuity
  Analytics.
* Documentation cleanup for `dt_count()`, `dt_summarise()` and the
  `summary_table*()` family; minor README and benchmarks article fixes.

# dtlg 0.0.3

* Removed dependency of dtlg.data in the benchmark vignette

# dtlg 0.0.2

* Initial CRAN submission.
