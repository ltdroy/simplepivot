
<!-- README.md is generated from README.Rmd. Please edit that file -->

# simplepivot

<!-- badges: start -->

<!-- badges: end -->

The goal of simplepivot is to facilitate simple pivot-table summaries
and manipulations of data frames.

Spreadsheet users enjoy the simplicity and intuitiveness of pivot-tables
for data summary and manipulation. R users can achieve similar results
using standard data manipulation libraries like dplyr. However, the
process is less intuitive and the barrier to entry is higher for new
users. This package supplies a simple wrapper to dplyr functionality, to
allow users to do pivot-table style manipulations, and create summary
tables (in data-frame form).

The main function ‘simple\_pivot’ fits into a standard data pipeline,
and returns a pivoted version of the input data. The package also
includes ‘helper’ functions, which are used to create formatted values
for the pivot table output.

## Basic Pivot Table

It is extremely simple to build a basic pivot table using `simplepivot`.
Pivot table transformations are done with `simple_pivot()`. Similar to
MS Excel and Google Sheets, the user supplies the data-frame, the row
variables, the column variables, the values, and a function to summarise
the values:

The required arguments are:

  - `df` (a dataframe)
  - `row_vars` (a character vector with the names of the row variables)
  - `col_vars` (a character vector with the names of the column
    variables)
  - `value_variable` (a string with the variable to be summarised)
  - `value_function` (a function that takes a sub-vector of the value
    variable, and summaries it, e.g. `mean`, `sd`, etc.)

Note: At least one row variable, and one column variable should be used.
If you don’t want to have row **and** column categories, then the
easiest way is to use `group_by` then `summarise` verbs from the dplyr
package.

Let’s use `simple_pivot` to build a simple summary of the ChickWeight
dataset. This dataset records the weights of multiple baby chickens,
from birth up to 21 days. Different chickens were put on different diets
(an experiment), so the dataset allows potential evaluation of the
optimal diet for chicks (in terms of weight).

1.  First, we will filter the dataset to select the time 0 and time 21
    observations, using dplyr’s filter verb.
2.  Next, we will pivot the data, using the Diet as rows (the
    experimental conditions), the time points (first and last) as
    columns, and the average weight of the chicks as cells.

**Notice that the `simple_pivot` function fits nicely into the dplyr
pipeline**

``` r

library(dplyr)
#> 
#> Attaching package: 'dplyr'
#> The following objects are masked from 'package:plyr':
#> 
#>     arrange, count, desc, failwith, id, mutate, rename, summarise,
#>     summarize
#> The following object is masked from 'package:testthat':
#> 
#>     matches
#> The following objects are masked from 'package:stats':
#> 
#>     filter, lag
#> The following objects are masked from 'package:base':
#> 
#>     intersect, setdiff, setequal, union
library(simplepivot)
library(knitr)

data("ChickWeight")

ChickWeight %>%
  filter(Time == 0 | Time == 21) %>%
  simple_pivot(
    row_vars = "Diet",
    col_vars = "Time",
    value_variable = "weight",
    value_function = mean
    ) %>%
  knitr::kable()
```

| Diet | (Time) 0 | (Time) 21 |
| :--- | -------: | --------: |
| 1    |     41.4 |  177.7500 |
| 2    |     40.7 |  214.7000 |
| 3    |     40.8 |  270.3000 |
| 4    |     41.0 |  238.5556 |

Here we can see that all groups of chicks had a similar average weight
at time 0. But by time 21, there were clear differences between the
groups, with the Diet 3 group having a considerably higher average
weight.

## Adding some summary information

Let’s say we wanted to report the spread as well as the mean value for
each of the groups. For this we can use `simplepivot`‘s
`simplepivot_mean_sd` summary function, in place of the `mean` function
in base R. This will produce a similar dataframe, with nicely formatted
string values in each ’cell’, showing the mean and standard deviation of
the `weight` data variable.

``` r

library(dplyr)
library(simplepivot)
library(knitr)

data("ChickWeight")

ChickWeight %>%
  filter(Time == 0 | Time == 21) %>%
  simple_pivot(
    row_vars = "Diet",
    col_vars = "Time",
    value_variable = "weight",
    value_function = simplepivot_mean_sd
    ) %>%
  knitr::kable()
```

| Diet | (Time) 0         | (Time) 21            |
| :--- | :--------------- | :------------------- |
| 1    | 41.4 (SD: 0.995) | 177.75 (SD: 58.702)  |
| 2    | 40.7 (SD: 1.494) | 214.7 (SD: 78.138)   |
| 3    | 40.8 (SD: 1.033) | 270.3 (SD: 71.623)   |
| 4    | 41 (SD: 1.054)   | 238.556 (SD: 43.348) |

Median and inter-quartile range (IQR) can sometimes provide more robust
summaries, because they are less sensitive to extreme values
(i.e. outliers). To repeat the above analysis using median and IQR, we
can use `simplepivot`’s `simplepivot_median_IQR` function instead:

``` r

library(dplyr)
library(simplepivot)
library(knitr)

data("ChickWeight")

ChickWeight %>%
  filter(Time == 0 | Time == 21) %>%
  simple_pivot(
    row_vars = "Diet",
    col_vars = "Time",
    value_variable = "weight",
    value_function = simplepivot_median_IQR
    ) %>%
  knitr::kable()
```

| Diet | (Time) 0         | (Time) 21         |
| :--- | :--------------- | :---------------- |
| 1    | 41 (IQR: 1)      | 166 (IQR: 70)     |
| 2    | 40.5 (IQR: 2.75) | 212.5 (IQR: 92.5) |
| 3    | 41 (IQR: 0)      | 281 (IQR: 88)     |
| 4    | 41 (IQR: 1.75)   | 237 (IQR: 60)     |

Now, we can see that the spread of data within groups (SD, IQR) is quite
large. This will likely lead us to wonder about the extent to which the
differences between groups could be dismissed as sampling variation.
Answering this question formally, would involve application of ANOVA or
a similar technique. However, we can get an initial intuition using the
`simple_pivot` package’s `simplepivot_mean_SE` function. This is similar
to the functions above, except the figure in the brackets becomes an
estimate of the Standard Error of the mean (\(\frac{SD}{\sqrt(n)}\)).
This is not a formal test of the Null hypothesis. However, we can
reasonably expect that if the SE is many times smaller than the
different between the groups, then the differences between the groups
are likely to be significant using more formal tests.

``` r

library(dplyr)
library(simplepivot)
library(knitr)

data("ChickWeight")

ChickWeight %>%
  filter(Time == 0 | Time == 21) %>%
  simple_pivot(
    row_vars = "Diet",
    col_vars = "Time",
    value_variable = "weight",
    value_function = simplepivot_mean_SE
    ) %>%
  knitr::kable()
```

| Diet | (Time) 0         | (Time) 21            |
| :--- | :--------------- | :------------------- |
| 1    | 41.4 (SE: 0.222) | 177.75 (SE: 14.676)  |
| 2    | 40.7 (SE: 0.473) | 214.7 (SE: 24.709)   |
| 3    | 40.8 (SE: 0.327) | 270.3 (SE: 22.649)   |
| 4    | 41 (SE: 0.333)   | 238.556 (SE: 14.449) |

Now, we can get even more sophisticated using the
`simplepivot_mean_95CI` function, which will place the 95% confidence
intervals for the mean in the brackets.

``` r

library(dplyr)
library(simplepivot)
library(knitr)

data("ChickWeight")

ChickWeight %>%
  filter(Time == 0 | Time == 21) %>%
  simple_pivot(
    row_vars = "Diet",
    col_vars = "Time",
    value_variable = "weight",
    value_function = simplepivot_mean_95CI
    ) %>%
  knitr::kable()
```

| Diet | (Time) 0                       | (Time) 21                           |
| :--- | :----------------------------- | :---------------------------------- |
| 1    | 41.4 (95% CI: 40.934 - 41.866) | 177.75 (95% CI: 146.47 - 209.03)    |
| 2    | 40.7 (95% CI: 39.631 - 41.769) | 214.7 (95% CI: 158.803 - 270.597)   |
| 3    | 40.8 (95% CI: 40.061 - 41.539) | 270.3 (95% CI: 219.064 - 321.536)   |
| 4    | 41 (95% CI: 40.246 - 41.754)   | 238.556 (95% CI: 205.236 - 271.876) |

## Part of the data pipeline

Some of the summary functions noted above output strings in the cells of
the table (e.g. “20 (16-24)”). But if base R functions are used, then
analysis can continue on the resulting dataframe. Let’s use the mean
summary of chick weight over groups, then add additional variables later
in the pipeline, using dplyr verbs.

``` r

library(dplyr)
library(simplepivot)
library(knitr)

data("ChickWeight")

ChickWeight %>%
  filter(Time == 0 | Time == 21) %>%
  simple_pivot(
    row_vars = "Diet",
    col_vars = "Time",
    value_variable = "weight",
    value_function = mean
    ) %>%
  mutate(
    `Percentage Change` = ((`(Time) 21` - `(Time) 0`) / `(Time) 0`) * 100
  ) %>%
  knitr::kable()
```

| Diet | (Time) 0 | (Time) 21 | Percentage Change |
| :--- | -------: | --------: | ----------------: |
| 1    |     41.4 |  177.7500 |          329.3478 |
| 2    |     40.7 |  214.7000 |          427.5184 |
| 3    |     40.8 |  270.3000 |          562.5000 |
| 4    |     41.0 |  238.5556 |          481.8428 |

## Additional row and column variables

Description TBC - the package does support multiple row and column
variables.

## Installation

**Not yet available on CRAN.**

You can install the development version from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("ltdroy/simplepivot")
```
