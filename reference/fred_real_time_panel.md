# Fetch a real-time panel of a series across selected vintages

Returns the values that were available on each of a chosen set of
vintage dates. This is the FRED API's `vintage_dates` parameter: instead
of asking for every revision (potentially huge), you ask for only the
snapshots you care about, e.g. quarterly vintages aligned to GDP release
dates.

## Usage

``` r
fred_real_time_panel(
  series_id,
  vintages,
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

- vintages:

  Character or Date vector. Vintage dates to fetch.

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

## See also

Other vintages:
[`fred_all_vintages()`](https://charlescoverdale.github.io/fred/reference/fred_all_vintages.md),
[`fred_as_of()`](https://charlescoverdale.github.io/fred/reference/fred_as_of.md),
[`fred_first_release()`](https://charlescoverdale.github.io/fred/reference/fred_first_release.md)

## Examples

``` r
# \donttest{
op <- options(fred.cache_dir = tempdir())
# GDP as published at three quarterly snapshots
gdp_panel <- fred_real_time_panel(
  "GDP",
  vintages = c("2023-04-30", "2023-07-31", "2023-10-31")
)
#> Error in fred_get_key(): No FRED API key found.
#> ℹ Set one with `fred_set_key()` or the `FRED_API_KEY` environment variable.
#> ℹ Register for a free key at <https://fredaccount.stlouisfed.org/apikeys>.
options(op)
# }
```
