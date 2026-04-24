# Fetch every vintage of a series

Returns the full revision history: one row per (observation date,
realtime range) combination. This is the FRED API's `output_type = 2`
mode. The result can be reshaped into a vintage matrix or used to
compute revision statistics.

## Usage

``` r
fred_all_vintages(
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
`realtime_start`, `realtime_end`. The `realtime_start` and
`realtime_end` columns identify the vintage window for each row.

## Details

Be aware that some series have hundreds of thousands of vintage rows, so
consider narrowing the date range with `from`/`to` for long-running
indicators like GDP.

## See also

Other vintages:
[`fred_as_of()`](https://charlescoverdale.github.io/fred/reference/fred_as_of.md),
[`fred_first_release()`](https://charlescoverdale.github.io/fred/reference/fred_first_release.md),
[`fred_real_time_panel()`](https://charlescoverdale.github.io/fred/reference/fred_real_time_panel.md)

## Examples

``` r
# \donttest{
op <- options(fred.cache_dir = tempdir())
# All vintages of recent GDP releases
gdp_vint <- fred_all_vintages("GDP", from = "2020-01-01")
#> Error in fred_get_key(): No FRED API key found.
#> ℹ Set one with `fred_set_key()` or the `FRED_API_KEY` environment variable.
#> ℹ Register for a free key at <https://fredaccount.stlouisfed.org/apikeys>.
options(op)
# }
```
