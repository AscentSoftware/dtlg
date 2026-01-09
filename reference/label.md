# Retrieve the label of an object

`label()` gets the attached label to an object.

## Usage

``` r
label(x)
```

## Arguments

- x:

  An R object.

## Value

The label attribute (string) associated with object passed in `x` or
`NULL` if the label attribute does not exist.

## See also

[`with_label()`](https://AscentSoftware.github.io/dtlg/reference/with_label.md)

## Examples

``` r
label(1)
#> NULL
label(with_label(1, "my label"))
#> [1] "my label"
```
