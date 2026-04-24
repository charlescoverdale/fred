# Fetch the first-release ("real-time") version of a series

Returns only the value that was published when each observation first
appeared in FRED, with no subsequent revisions. Internally this fetches
the full revision history and keeps the earliest `realtime_start` row
for each observation date. Useful when you want a clean comparison
between what policymakers saw at the time versus what the data look like
after revisions.

## Usage

``` r
fred_first_release(
  series_id,
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
[`fred_real_time_panel()`](https://charlescoverdale.github.io/fred/reference/fred_real_time_panel.md)

## Examples

``` r
# \donttest{
op <- options(fred.cache_dir = tempdir())
# Initial-release GDP, never revised
gdp_first <- fred_first_release("GDP", from = "2018-01-01")
#> Error in fred_get_key(): No FRED API key found.
#> ℹ Set one with `fred_set_key()` or the `FRED_API_KEY` environment variable.
#> ℹ Register for a free key at <https://fredaccount.stlouisfed.org/apikeys>.
options(op)
# }
```
