# Fetch a series as it appeared on a given vintage date

Returns the values that were available in FRED on `date`, before any
subsequent revisions. This is the standard real-time data access
pattern: set `realtime_start = realtime_end = date`. Useful for
backtesting forecasting models against the data that was actually
available at the time, not the revised series we see today.

## Usage

``` r
fred_as_of(
  series_id,
  date,
  from = NULL,
  to = NULL,
  units = "lin",
  frequency = NULL,
  aggregation = "avg",
  cache = TRUE
)
```

## Arguments

- series_id:

  Character. One or more FRED series IDs.

- date:

  Character or Date. The vintage date (`"YYYY-MM-DD"`).

- from, to:

  Optional observation date range.

- units:

  Character. Raw FRED units code. Default `"lin"`.

- frequency, aggregation:

  Optional frequency aggregation arguments (see
  [`fred_series()`](https://charlescoverdale.github.io/fred/reference/fred_series.md)).

- cache:

  Logical. Cache results locally. Default `TRUE`.

## Value

A `fred_tbl` with columns `date`, `series_id`, `value`,
`realtime_start`, `realtime_end`.

## Details

Underneath, this calls the `series/observations` endpoint with the
realtime parameters set. Results are cached separately from the default
(latest-vintage) cache, so calling `fred_series("GDP")` and
`fred_as_of("GDP", "2020-01-15")` keep distinct cache entries.

## See also

Other vintages:
[`fred_all_vintages()`](https://charlescoverdale.github.io/fred/reference/fred_all_vintages.md),
[`fred_first_release()`](https://charlescoverdale.github.io/fred/reference/fred_first_release.md),
[`fred_real_time_panel()`](https://charlescoverdale.github.io/fred/reference/fred_real_time_panel.md)

## Examples

``` r
# \donttest{
op <- options(fred.cache_dir = tempdir())
# GDP as it looked on 1 March 2020
gdp_2020 <- fred_as_of("GDP", "2020-03-01")
#> Error in fred_get_key(): No FRED API key found.
#> ℹ Set one with `fred_set_key()` or the `FRED_API_KEY` environment variable.
#> ℹ Register for a free key at <https://fredaccount.stlouisfed.org/apikeys>.
options(op)
# }
```
