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

A `fred_tbl` with `NA`s filled.

## See also

Other utilities:
[`fred_aggregate()`](https://charlescoverdale.github.io/fred/reference/fred_aggregate.md),
[`fred_event_window()`](https://charlescoverdale.github.io/fred/reference/fred_event_window.md)

## Examples

``` r
# \donttest{
op <- options(fred.cache_dir = tempdir())
if (FALSE) { # \dontrun{
  gdp <- fred_series("GDPC1", from = "2020-01-01")
  gdp_monthly <- fred_interpolate(gdp, method = "linear")
} # }
options(op)
# }
```
