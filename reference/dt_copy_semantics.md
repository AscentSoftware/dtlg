# Get or set data.table copy semantics

These functions control how
[`maybe_copy_dt()`](https://AscentSoftware.github.io/dtlg/reference/maybe_copy_dt.md)
decides whether to return a `data.table` by reference (in place) or by
value (as a deep copy).

## Usage

``` r
dt_copy_semantics()

set_dt_copy_semantics(dt_copy_semantics = c("reference", "value"))
```

## Arguments

- dt_copy_semantics:

  Character string. Either `"reference"` or `"value"`.

## Value

- `dt_copy_semantics()` returns the current semantics as a string,
  `"reference"` or `"value"`.

- `set_dt_copy_semantics()` sets the semantics, returning the previous
  semantics invisibly.

## Details

The copy semantics are stored in the global option
`dtlg_dt_copy_semantics`. The option can take two values:

- `"reference"` (default): inputs are treated with reference semantics.

  - If the input is already a `data.table`, it is returned unchanged and
    aliases are preserved.

  - If the input is a `data.frame`, it is converted to a `data.table` in
    place via
    [`data.table::setDT()`](https://rdatatable.gitlab.io/data.table/reference/setDT.html),
    mutating the caller’s object.

- `"value"`: inputs are treated with value semantics.

  - The input is converted to a `data.table` (if necessary) and a deep
    copy is returned, leaving the original unchanged.

## See also

[`maybe_copy_dt()`](https://AscentSoftware.github.io/dtlg/reference/maybe_copy_dt.md)

## Examples

``` r
# Get current semantics (defaults to "reference")
dt_copy_semantics()
#> [1] "reference"

# Switch to value semantics
old <- set_dt_copy_semantics("value")
dt_copy_semantics()
#> [1] "value"

# Restore previous semantics
set_dt_copy_semantics(old)
```
