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
# \donttest{
op <- options(fred.cache_dir = tempdir())
if (FALSE) { # \dontrun{
  daily_yields <- fred_series("DGS10", from = "2023-01-01")
  monthly_yields <- fred_aggregate(daily_yields, fun = "mean", by = "month")
} # }
options(op)
# }
```
