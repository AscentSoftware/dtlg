# Return a data.table by reference or by value

`maybe_copy_dt()` returns its input as a `data.table`, with behaviour
controlled by the global copy semantics option
[`dt_copy_semantics()`](https://AscentSoftware.github.io/dtlg/reference/dt_copy_semantics.md).

## Usage

``` r
maybe_copy_dt(x)
```

## Arguments

- x:

  A `data.table` or `data.frame`.

## Value

A `data.table`. Whether the return value aliases the input depends on
the semantics:

- `"reference"`: input is mutated in place, aliasing guaranteed if `x`
  is already a `data.table`.

- `"value"`: a fresh copy is returned, independent of the input.

## Details

- If the semantics are `"reference"` (default):

  - If `x` is already a `data.table`, it is returned unchanged. Aliasing
    holds, so mutations with `:=` will affect both input and output.

  - If `x` is a `data.frame`, it is converted to a `data.table` in place
    via
    [`data.table::setDT()`](https://rdatatable.gitlab.io/data.table/reference/setDT.html),
    mutating the caller’s object. The returned object is a `data.table`
    with the same contents. For efficiency, the column vectors are
    reused without a deep copy.

- If the semantics are `"value"`:

  - `x` is converted to a `data.table` (if necessary) and a deep copy is
    returned. Mutating the result does not affect the input.

## See also

[`dt_copy_semantics()`](https://AscentSoftware.github.io/dtlg/reference/dt_copy_semantics.md),
[`set_dt_copy_semantics()`](https://AscentSoftware.github.io/dtlg/reference/dt_copy_semantics.md)

## Examples

``` r
# Default: reference semantics
df <- data.frame(a = 1:3)
out <- maybe_copy_dt(df)
data.table::is.data.table(df) # TRUE, converted in place
#> [1] TRUE

# Switch to value semantics
old <- set_dt_copy_semantics("value")
dt <- data.table::data.table(a = 1:3)
out2 <- maybe_copy_dt(dt)
out2[, b := 99L]
#>        a     b
#>    <int> <int>
#> 1:     1    99
#> 2:     2    99
#> 3:     3    99
"b" %in% names(dt)  # FALSE, original unchanged
#> [1] FALSE

# Restore previous semantics
set_dt_copy_semantics(old)
```
