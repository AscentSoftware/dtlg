# Add a label attribute to an object

Add a label attribute to an object

## Usage

``` r
with_label(x, label)
```

## Arguments

- x:

  An R object.

- label:

  A label provided as a single string.

## Value

`x` labeled by `label`.

## See also

[`label()`](https://AscentSoftware.github.io/dtlg/reference/label.md)

## Examples

``` r
label(1)
#> NULL
label(with_label(1, "my label"))
#> [1] "my label"
```
