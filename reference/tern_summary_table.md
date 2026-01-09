# Create a clinical reporting table with tern/rtables

`tern_summary_table()` is a convenience wrapper around `{rtables}` and
`{tern}` commands to generate a clinical reporting summary statistics
tables whilst using a similar interface as
[`summary_table()`](https://AscentSoftware.github.io/dtlg/reference/summary_table.md).
This can be helpful for side by side comparisons of the two functions.

## Usage

``` r
tern_summary_table(dt, target, treat, target_name = target)
```

## Arguments

- dt:

  A `data.frame` containing, at least, the variables indicated in
  `target` and `treat`.

- target:

  Target variable passed as a string for which summary statistics are to
  be calculated.

- treat:

  A string indicating the grouping variable, e.g. the variable
  specifying the treatment population.

- target_name:

  Heading for the target variable as a string. Defaults to `target`.

## Value

A `data.table` of summary statistics. The format depends on the type of
the `target` variable:

- If the `target` variable is categorical, i.e. type `character`,
  `factor` or `logical` then the output is that of
  [`calc_counts()`](https://AscentSoftware.github.io/dtlg/reference/calc_counts.md).

- If the `target` variable is numeric, then the output is that of
  [`calc_desc()`](https://AscentSoftware.github.io/dtlg/reference/calc_desc.md).

## See also

[`summary_table()`](https://AscentSoftware.github.io/dtlg/reference/summary_table.md)

## Examples

``` r
dmg_vars <- c("AGE", "RACE", "ETHNIC")
dmg_var_lbls <- c("Age (yr)", "Race", "Ethnicity")

# Demographics table (DMT01)
tern_summary_table(
  adsl,
  target = dmg_vars,
  treat = 'ARM',
  target_name = dmg_var_lbls
)
#>                                                A: Drug X    B: Placebo    C: Combination
#>                                                 (N=134)       (N=134)        (N=132)    
#> ————————————————————————————————————————————————————————————————————————————————————————
#> Age (yr)                                                                                
#>   n                                               134           134            132      
#>   Mean (SD)                                   33.8 (6.6)    35.4 (7.9)      35.4 (7.7)  
#>   Median                                         33.0          35.0            35.0     
#>   Min - Max                                   21.0 - 50.0   21.0 - 62.0    20.0 - 69.0  
#> Race                                                                                    
#>   n                                               134           134            132      
#>   ASIAN                                       68 (50.7%)     67 (50%)       73 (55.3%)  
#>   BLACK OR AFRICAN AMERICAN                   31 (23.1%)    28 (20.9%)      32 (24.2%)  
#>   WHITE                                       27 (20.1%)    26 (19.4%)      21 (15.9%)  
#>   AMERICAN INDIAN OR ALASKA NATIVE              8 (6%)       11 (8.2%)       6 (4.5%)   
#>   MULTIPLE                                         0         1 (0.7%)           0       
#>   NATIVE HAWAIIAN OR OTHER PACIFIC ISLANDER        0         1 (0.7%)           0       
#>   OTHER                                            0             0              0       
#>   UNKNOWN                                          0             0              0       
#> Ethnicity                                                                               
#>   n                                               134           134            132      
#>   HISPANIC OR LATINO                          15 (11.2%)    18 (13.4%)      15 (11.4%)  
#>   NOT HISPANIC OR LATINO                      104 (77.6%)   103 (76.9%)    101 (76.5%)  
#>   NOT REPORTED                                 6 (4.5%)      10 (7.5%)      11 (8.3%)   
#>   UNKNOWN                                      9 (6.7%)      3 (2.2%)        5 (3.8%)   

# Demographics table (DMT01) with continuous variable (e.g., BMRKR1)
tern_summary_table(
  adsl,
  target = c(dmg_vars, "BMRKR1"),
  treat = 'ARM',
  target_name = c(dmg_var_lbls, "Biomarker 1")
)
#>                                                A: Drug X    B: Placebo    C: Combination
#>                                                 (N=134)       (N=134)        (N=132)    
#> ————————————————————————————————————————————————————————————————————————————————————————
#> Age (yr)                                                                                
#>   n                                               134           134            132      
#>   Mean (SD)                                   33.8 (6.6)    35.4 (7.9)      35.4 (7.7)  
#>   Median                                         33.0          35.0            35.0     
#>   Min - Max                                   21.0 - 50.0   21.0 - 62.0    20.0 - 69.0  
#> Race                                                                                    
#>   n                                               134           134            132      
#>   ASIAN                                       68 (50.7%)     67 (50%)       73 (55.3%)  
#>   BLACK OR AFRICAN AMERICAN                   31 (23.1%)    28 (20.9%)      32 (24.2%)  
#>   WHITE                                       27 (20.1%)    26 (19.4%)      21 (15.9%)  
#>   AMERICAN INDIAN OR ALASKA NATIVE              8 (6%)       11 (8.2%)       6 (4.5%)   
#>   MULTIPLE                                         0         1 (0.7%)           0       
#>   NATIVE HAWAIIAN OR OTHER PACIFIC ISLANDER        0         1 (0.7%)           0       
#>   OTHER                                            0             0              0       
#>   UNKNOWN                                          0             0              0       
#> Ethnicity                                                                               
#>   n                                               134           134            132      
#>   HISPANIC OR LATINO                          15 (11.2%)    18 (13.4%)      15 (11.4%)  
#>   NOT HISPANIC OR LATINO                      104 (77.6%)   103 (76.9%)    101 (76.5%)  
#>   NOT REPORTED                                 6 (4.5%)      10 (7.5%)      11 (8.3%)   
#>   UNKNOWN                                      9 (6.7%)      3 (2.2%)        5 (3.8%)   
#> Biomarker 1                                                                             
#>   n                                               134           134            132      
#>   Mean (SD)                                    6.0 (3.6)     5.7 (3.3)      5.6 (3.5)   
#>   Median                                          5.4           4.8            4.6      
#>   Min - Max                                   0.4 - 17.7    0.6 - 14.2      0.2 - 21.4  
```
