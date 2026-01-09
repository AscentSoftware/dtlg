# Count total events

`total_events()` counts the number of observations in `dt` in each group
defined by `treat` levels. Counts are returned in wide format, i.e. one
column per level in `treat`.

## Usage

``` r
total_events(dt, treat, label)
```

## Arguments

- dt:

  A `data.frame` containing, at least, the variable indicated in
  `treat`.

- treat:

  A string indicating the grouping variable, e.g. the variable
  specifying the treatment population.

- label:

  A string to be used as label in the output reporting table. This
  should be a text descriptive of the event being counted.

## Value

A list wrapping a one-row `data.table` of `1 + n` variables, where `n`
is the number of levels in `treat`. First variable is `stats`,
`character` type, whose value is the argument passed in as `label`.
Following variables are of `integer` type and provide the counts.

## Examples

``` r
# In the absence of pre-filtering, `total_events()`, actually, just counts
# observations in `dt`.
total_events(dt = adsl, treat = "ARM", label = "Subjects")[[1]]
#>       stats A: Drug X B: Placebo C: Combination
#>      <char>     <int>      <int>          <int>
#> 1: Subjects       134        134            132

# If `dt` is pre-filtered, e.g. with a condition matching an event, then
# `total_events()` can be used to (effectively) count events.
total_events(dt = adsl[adsl$DTHFL == 'Y'], treat = "ARM", label = "Deaths")[[1]]
#>     stats A: Drug X B: Placebo C: Combination
#>    <char>     <int>      <int>          <int>
#> 1: Deaths        25         23             22

# Another example using the complement predicate condition.
total_events(dt = adsl[adsl$DTHFL == 'N'], treat = "ARM", label = "Lives")[[1]]
#>     stats A: Drug X B: Placebo C: Combination
#>    <char>     <int>      <int>          <int>
#> 1:  Lives       109        111            110
```
