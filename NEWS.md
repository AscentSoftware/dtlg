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
