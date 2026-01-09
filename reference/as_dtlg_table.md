# Convert a TableTree to a dtlg table

`as_dtlg_table()` reformats a TableTree object into a format close to
that of dtlg's `data.table`.

## Usage

``` r
as_dtlg_table(tt, .label_col = "stats")
```

## Arguments

- tt:

  A TableTree object. Typically obtained with
  [`tern_summary_table()`](https://AscentSoftware.github.io/dtlg/reference/tern_summary_table.md).

- .label_col:

  Label for stats' column.

## Value

A data.table.

## Examples

``` r
vars <- c('AGE', 'RACE', 'ETHNIC', 'BMRKR1')
var_labels <- c("Age (yr)", "Race", "Ethnicity", "Continuous Level Biomarker 1")

# Summary statistics table split by ARM with custom labels.
(tt <- tern_summary_table(
  adsl,
  target = vars,
  treat = 'ARM',
  target_name = var_labels
))
#> Registered S3 method overwritten by 'tern':
#>   method   from 
#>   tidy.glm broom
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
#> Continuous Level Biomarker 1                                                            
#>   n                                               134           134            132      
#>   Mean (SD)                                    6.0 (3.6)     5.7 (3.3)      5.6 (3.5)   
#>   Median                                          5.4           4.8            4.6      
#>   Min - Max                                   0.4 - 17.7    0.6 - 14.2      0.2 - 21.4  

# Format as a dtlg table
as_dtlg_table(tt)
#>                                         stats   A: Drug X  B: Placebo
#>                                        <char>      <char>      <char>
#>  1:                                  Age (yr)                        
#>  2:                                         n         134         134
#>  3:                                 Mean (SD)  33.8 (6.6)  35.4 (7.9)
#>  4:                                    Median        33.0        35.0
#>  5:                                 Min - Max 21.0 - 50.0 21.0 - 62.0
#>  6:                                      Race                        
#>  7:                                         n         134         134
#>  8:                                     ASIAN  68 (50.7%)    67 (50%)
#>  9:                 BLACK OR AFRICAN AMERICAN  31 (23.1%)  28 (20.9%)
#> 10:                                     WHITE  27 (20.1%)  26 (19.4%)
#> 11:          AMERICAN INDIAN OR ALASKA NATIVE      8 (6%)   11 (8.2%)
#> 12:                                  MULTIPLE           0    1 (0.7%)
#> 13: NATIVE HAWAIIAN OR OTHER PACIFIC ISLANDER           0    1 (0.7%)
#> 14:                                     OTHER           0           0
#> 15:                                   UNKNOWN           0           0
#> 16:                                 Ethnicity                        
#> 17:                                         n         134         134
#> 18:                        HISPANIC OR LATINO  15 (11.2%)  18 (13.4%)
#> 19:                    NOT HISPANIC OR LATINO 104 (77.6%) 103 (76.9%)
#> 20:                              NOT REPORTED    6 (4.5%)   10 (7.5%)
#> 21:                                   UNKNOWN    9 (6.7%)    3 (2.2%)
#> 22:              Continuous Level Biomarker 1                        
#> 23:                                         n         134         134
#> 24:                                 Mean (SD)   6.0 (3.6)   5.7 (3.3)
#> 25:                                    Median         5.4         4.8
#> 26:                                 Min - Max  0.4 - 17.7  0.6 - 14.2
#>                                         stats   A: Drug X  B: Placebo
#>                                        <char>      <char>      <char>
#>     C: Combination
#>             <char>
#>  1:               
#>  2:            132
#>  3:     35.4 (7.7)
#>  4:           35.0
#>  5:    20.0 - 69.0
#>  6:               
#>  7:            132
#>  8:     73 (55.3%)
#>  9:     32 (24.2%)
#> 10:     21 (15.9%)
#> 11:       6 (4.5%)
#> 12:              0
#> 13:              0
#> 14:              0
#> 15:              0
#> 16:               
#> 17:            132
#> 18:     15 (11.4%)
#> 19:    101 (76.5%)
#> 20:      11 (8.3%)
#> 21:       5 (3.8%)
#> 22:               
#> 23:            132
#> 24:      5.6 (3.5)
#> 25:            4.6
#> 26:     0.2 - 21.4
#>     C: Combination
#>             <char>
```
