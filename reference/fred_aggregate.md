# Aggregate FRED observations to a coarser frequency

Aggregates a long-format `fred_tbl` (with `date`, `series_id`, `value`)
or a wide-format `fred_tbl` (date plus one column per series) to a
coarser calendar frequency. For long format, aggregation is performed
per `series_id`; for wide format, per numeric column.

## Usage

``` r
fred_aggregate(data, fun = "mean", by = "month")
```

## Arguments

- data:

  A `fred_tbl` or `data.frame` with a `date` column.

- fun:

  Character. Aggregation function. One of `"mean"`, `"sum"`, `"first"`,
  `"last"`, `"median"`, `"min"`, `"max"`. Default `"mean"`.

- by:

  Character. Target frequency. One of `"week"`, `"month"`, `"quarter"`,
  `"year"`. Default `"month"`.

## Value

A `fred_tbl` with the same columns as the input, with `date` collapsed
to period start.

## Details

Use this when you have, say, daily Treasury yields and need a monthly
average, or weekly initial claims aggregated to monthly totals. For
server-side aggregation that mirrors FRED's own interpolation
conventions, pass `frequency = "m"` to
[`fred_series()`](https://charlescoverdale.github.io/fred/reference/fred_series.md)
instead.

## See also

Other utilities:
[`fred_event_window()`](https://charlescoverdale.github.io/fred/reference/fred_event_window.md),
[`fred_interpolate()`](https://charlescoverdale.github.io/fred/reference/fred_interpolate.md)

## Examples

``` r
# Synthetic example: aggregate daily synthetic data to monthly means
d <- seq(as.Date("2024-01-01"), as.Date("2024-06-30"), by = "day")
daily <- data.frame(date = d, series_id = "X", value = rnorm(length(d)))
fred_aggregate(daily, fun = "mean", by = "month")
#> # FRED: 6 rows
#>         date series_id       value
#> 1 2024-01-01         X -0.20970417
#> 2 2024-02-01         X  0.10408963
#> 3 2024-03-01         X  0.15213658
#> 4 2024-04-01         X  0.11632121
#> 5 2024-05-01         X  0.13332977
#> 6 2024-06-01         X -0.06317285

# Wide-format input also works
wide <- data.frame(date = d, A = rnorm(length(d)), B = rnorm(length(d)))
fred_aggregate(wide, fun = "sum", by = "quarter")
#> # FRED: 2 rows
#>         date          A         B
#> 1 2024-01-01 -0.8722382 -8.711310
#> 2 2024-04-01 25.8291942 -3.791956

# \donttest{
op <- options(fred.cache_dir = tempdir())
if (FALSE) { # \dontrun{
  daily_yields <- fred_series("DGS10", from = "2023-01-01")
  monthly_yields <- fred_aggregate(daily_yields, fun = "mean", by = "month")
} # }
options(op)
# }
```
