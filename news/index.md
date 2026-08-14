# Changelog

## dtlg 0.1.2

### New features

- Added and exported
  [`aesi_heading_msg()`](https://AscentSoftware.github.io/dtlg/reference/aesi_heading_msg.md),
  which provides the shared default heading used for adverse events of
  special interest in the native and
  [tern](https://insightsengineering.github.io/tern/) AET01 tables.

### Bug fixes and behaviour changes

- [`as_dtlg_table()`](https://AscentSoftware.github.io/dtlg/reference/as_dtlg_table.md)
  now uses `where(is.character)` when selecting columns, removing a
  tidyselect deprecation warning.
- Reinstated the internal `%||%` operator and documented its explicit
  use to avoid a false-positive dead-code warning from
  [goodpractice](https://docs.ropensci.org/goodpractice/).
- Replaced
  [`vctrs::vec_recycle_common()`](https://vctrs.r-lib.org/reference/vec_recycle.html)
  with a focused base R implementation and removed
  [vctrs](https://vctrs.r-lib.org/) from package dependencies. Existing
  [`summary_table()`](https://AscentSoftware.github.io/dtlg/reference/summary_table.md)
  argument-recycling behaviour is preserved.

### Internal improvements

- Extracted input validation and table-layout helpers from
  [`AET01_table()`](https://AscentSoftware.github.io/dtlg/reference/AET01_table.md)
  and
  [`tern_AET01_table()`](https://AscentSoftware.github.io/dtlg/reference/tern_AET01_table.md).
- Extracted descriptive-statistics calculation and validation helpers
  from
  [`calc_desc()`](https://AscentSoftware.github.io/dtlg/reference/calc_desc.md).
- Removed unused column-relevel helpers and moved format-matching
  utilities from package code into the test suite.
- Expanded tests for AET01 and AET02 tables,
  [tern](https://insightsengineering.github.io/tern/) table layouts,
  [`calc_stats()`](https://AscentSoftware.github.io/dtlg/reference/calc_stats.md),
  [`as_dtlg_table()`](https://AscentSoftware.github.io/dtlg/reference/as_dtlg_table.md),
  printing, labels, package availability, contingency-table expansion,
  and vector recycling.
- Strengthened existing tests with stricter type, structure, formatting,
  and error assertions.

### Infrastructure and tooling

- Added the rOpenSci `pkgcheck` workflow.
- Refined the `lintr` configuration and added targeted exclusions for
  established API names.

## dtlg 0.1.1

### Bug fixes and behaviour changes

- [`AET01_table()`](https://AscentSoftware.github.io/dtlg/reference/AET01_table.md):
  the row label for AE-related withdrawals has been shortened from
  “Total number of patients withdrawn from study due to an AE” to “Total
  number of patients withdrawn due to an AE”, for consistency with the
  other terse event labels in the same table. Code that matches this
  label by string equality (e.g. snapshot tests) will need to be
  updated.

### Documentation

- The README and the “Getting started” article now set a wider print
  width and display the full AET01 table rather than truncating row
  labels.

## dtlg 0.1.0

CRAN release: 2026-04-29

### New features

- [`summary_table()`](https://AscentSoftware.github.io/dtlg/reference/summary_table.md),
  [`summary_table_by()`](https://AscentSoftware.github.io/dtlg/reference/summary_table_by.md)
  and
  [`summary_table_by_targets()`](https://AscentSoftware.github.io/dtlg/reference/summary_table_by_targets.md)
  gain an `inc_missing` argument controlling how the “Missing” row is
  rendered for numeric targets: `TRUE` (default) always shows it, `NA`
  shows it only when missing values are present, and `FALSE` suppresses
  it. Plumbed through to
  [`calc_desc()`](https://AscentSoftware.github.io/dtlg/reference/calc_desc.md)
  and
  [`calc_stats()`](https://AscentSoftware.github.io/dtlg/reference/calc_stats.md).
- [`summary_table_by()`](https://AscentSoftware.github.io/dtlg/reference/summary_table_by.md)
  and
  [`summary_table_by_targets()`](https://AscentSoftware.github.io/dtlg/reference/summary_table_by_targets.md)
  gain a `sep` argument to set the separator between the heading and
  group labels when grouping by more than one variable in `rows_by`
  (defaults to `"."`).

### Bug fixes and behaviour changes

- [`calc_desc()`](https://AscentSoftware.github.io/dtlg/reference/calc_desc.md):
  the `n` row now reports the count of non-missing values rather than
  the total row count (`.N`), so `n` and the `Missing` row are now
  consistent.
- [`summary_table_by_targets()`](https://AscentSoftware.github.io/dtlg/reference/summary_table_by_targets.md):
  removed the spurious “target needs to be length 2” message; multiple
  target variables are now properly supported and covered by tests.

### Infrastructure and tooling

- Adopted `lintr` with default linters across the package and added a
  `lint.yaml` GitHub Actions workflow.
- Added a code-coverage workflow that posts a coverage summary as a
  comment on pull requests, gated on `pull_request` events to avoid
  duplicate runs.
- Expanded the test suite – new tests for
  [`AET01_table()`](https://AscentSoftware.github.io/dtlg/reference/AET01_table.md),
  the rounding helpers,
  [`tern_summary_table()`](https://AscentSoftware.github.io/dtlg/reference/tern_summary_table.md),
  and additional `summary_table*()` cases (multiple targets,
  missing-value handling) – raising overall coverage.

### Documentation and metadata

- Reorganised maintainership and contact details: maintainer e-mails
  moved to the `acuityanalytics.com` domain and copyright holder updated
  to Acuity Analytics.
- Documentation cleanup for `dt_count()`, `dt_summarise()` and the
  `summary_table*()` family; minor README and benchmarks article fixes.

## dtlg 0.0.3

CRAN release: 2026-01-12

- Removed dependency of dtlg.data in the benchmark vignette

## dtlg 0.0.2

CRAN release: 2025-09-23

- Initial CRAN submission.
