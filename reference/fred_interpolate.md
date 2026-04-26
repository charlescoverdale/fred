# Fill missing values in a FRED series

Fills `NA` values in the `value` column (long format) or in numeric
columns (wide format). Two methods are supported:
last-observation-carry-forward (`"locf"`) and linear interpolation
between adjacent observed values (`"linear"`). Use this for
mixed-frequency analysis where a low-frequency series needs to be
interpolated to a higher frequency.

## Usage

``` r
fred_interpolate(data, method = c("locf", "linear"))
```

## Arguments

- data:

  A `fred_tbl` or `data.frame` with a `date` column.

- method:

  Character. `"locf"` (default) carries the last observed value forward.
  `"linear"` does linear interpolation between adjacent non-`NA` values.

## Value

A `fred_tbl` with interior `NA`s filled (see boundary note above).

## Details

Boundary behaviour: with `method = "locf"`, leading `NA`s remain `NA`
because there is no prior observation to carry forward. With
`method = "linear"`, neither leading nor trailing `NA`s are filled
because [`stats::approx()`](https://rdrr.io/r/stats/approxfun.html) is
called with `rule = 1` (no extrapolation). If you need extrapolation,
post-process the result.

## See also

Other utilities:
[`fred_aggregate()`](https://charlescoverdale.github.io/fred/reference/fred_aggregate.md),
[`fred_event_window()`](https://charlescoverdale.github.io/fred/reference/fred_event_window.md)

## Examples

``` r
# Synthetic example: fill interior NAs
d <- seq(as.Date("2024-01-01"), by = "month", length.out = 6L)
df <- data.frame(date = d, series_id = "X",
                 value = c(NA, 2, NA, NA, 5, NA))
fred_interpolate(df, method = "locf")
#> # FRED: 6 rows
#>         date series_id value
#> 1 2024-01-01         X    NA
#> 2 2024-02-01         X     2
#> 3 2024-03-01         X     2
#> 4 2024-04-01         X     2
#> 5 2024-05-01         X     5
#> 6 2024-06-01         X     5
fred_interpolate(df, method = "linear")
#> # FRED: 6 rows
#>         date series_id value
#> 1 2024-01-01         X    NA
#> 2 2024-02-01         X     2
#> 3 2024-03-01         X     3
#> 4 2024-04-01         X     4
#> 5 2024-05-01         X     5
#> 6 2024-06-01         X    NA

# \donttest{
op <- options(fred.cache_dir = tempdir())
if (FALSE) { # \dontrun{
  gdp <- fred_series("GDPC1", from = "2020-01-01")
  gdp_monthly <- fred_interpolate(gdp, method = "linear")
} # }
options(op)
# }
```
