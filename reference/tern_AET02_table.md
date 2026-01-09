# Generate AET02-style AE summary using `tern` and `rtables`

This function builds a System Organ Class (SOC) and Preferred Term (PT)
adverse event summary table, following the AET02 CSR format, using the
`tern` and `rtables` packages.

## Usage

``` r
tern_AET02_table(
  adsl,
  adae,
  patient,
  treat,
  target = "AEDECOD",
  rows_by = "AEBODSYS",
  indent = "  "
)
```

## Arguments

- adsl:

  Subject-level dataset.

- adae:

  Adverse event dataset.

- patient:

  Unique subject identifier variable.

- treat:

  Treatment arm variable.

- target:

  Preferred term variable (default: `"AEDECOD"`).

- rows_by:

  Higher-level nesting term (default: `"AEBODSYS"`).

- indent:

  Ignored (included for compatibility).

## Value

A `TableTree` object with AE summary by SOC/PT.

## See also

[`AET02_table()`](https://AscentSoftware.github.io/dtlg/reference/AET02_table.md)
