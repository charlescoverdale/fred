# Fetch observations for one or more FRED series

The main function in the package. Downloads time series observations
from FRED and returns a tidy data frame. Multiple series can be fetched
in a single call, in either long or wide format.

## Usage

``` r
fred_series(
  series_id,
  from = NULL,
  to = NULL,
  units = "lin",
  transform = NULL,
  frequency = NULL,
  aggregation = "avg",
  format = c("long", "wide"),
  cache = TRUE
)
```

## Arguments

- series_id:

  Character. One or more FRED series IDs (e.g. `"GDP"`,
  `c("GDP", "UNRATE", "CPIAUCSL")`).

- from:

  Optional start date. Character (`"YYYY-MM-DD"`) or Date.

- to:

  Optional end date. Character (`"YYYY-MM-DD"`) or Date.

- units:

  Character. Raw FRED units code. Default `"lin"` (levels). Mutually
  exclusive with `transform`.

- transform:

  Character. Readable transformation name. See Details.

- frequency:

  Character. Frequency aggregation. One of `"d"` (daily), `"w"`
  (weekly), `"bw"` (biweekly), `"m"` (monthly), `"q"` (quarterly),
  `"sa"` (semiannual), `"a"` (annual), or `NULL` (native frequency, the
  default).

- aggregation:

  Character. Aggregation method when `frequency` is specified. One of
  `"avg"` (default), `"sum"`, or `"eop"` (end of period).

- format:

  Character. `"long"` (default) returns one row per `(series_id, date)`.
  `"wide"` returns one row per date with one column per series.

- cache:

  Logical. If `TRUE` (the default), results are cached locally and
  returned from the cache on subsequent calls. Set to `FALSE` to force a
  fresh download from the API.

## Value

A `fred_tbl` (a `data.frame` subclass that prints with a one-line
provenance header). In long format, columns are `date`, `series_id`,
`value`. In wide format, columns are `date` plus one numeric column per
series.

## Details

FRED supports server-side unit transformations via the `units` argument.
This avoids the need to compute growth rates or log transforms locally.
For readability you can pass `transform` instead of `units`:

- `"level"`, `"raw"` -levels (the default)

- `"diff"`, `"change"` -change from previous period

- `"yoy_diff"` -change from one year ago

- `"qoq_pct"`, `"mom_pct"`, `"pop_pct"` -percent change from previous
  period

- `"yoy_pct"` -percent change from one year ago

- `"annualised"`, `"qoq_annualised"` -compounded annual rate of change

- `"log"` -natural log

- `"log_diff"` -continuously compounded rate of change

- `"log_diff_annualised"` -continuously compounded annual rate

Raw FRED `units` codes (`"lin"`, `"chg"`, `"ch1"`, `"pch"`, `"pc1"`,
`"pca"`, `"cch"`, `"cca"`, `"log"`) are also accepted.

## See also

Other series:
[`fred_info()`](https://charlescoverdale.github.io/fred/reference/fred_info.md),
[`fred_search()`](https://charlescoverdale.github.io/fred/reference/fred_search.md),
[`fred_updates()`](https://charlescoverdale.github.io/fred/reference/fred_updates.md),
[`fred_vintages()`](https://charlescoverdale.github.io/fred/reference/fred_vintages.md)

## Examples

``` r
# \donttest{
op <- options(fred.cache_dir = tempdir())
# Single series
gdp <- fred_series("GDP")
#> Error in fred_get_key(): No FRED API key found.
#> ℹ Set one with `fred_set_key()` or the `FRED_API_KEY` environment variable.
#> ℹ Register for a free key at <https://fredaccount.stlouisfed.org/apikeys>.

# Multiple series, long format
macro <- fred_series(c("GDP", "UNRATE", "CPIAUCSL"))
#> Error in fred_get_key(): No FRED API key found.
#> ℹ Set one with `fred_set_key()` or the `FRED_API_KEY` environment variable.
#> ℹ Register for a free key at <https://fredaccount.stlouisfed.org/apikeys>.

# Multiple series, wide format
macro_w <- fred_series(c("GDP", "UNRATE"), format = "wide")
#> Error in fred_get_key(): No FRED API key found.
#> ℹ Set one with `fred_set_key()` or the `FRED_API_KEY` environment variable.
#> ℹ Register for a free key at <https://fredaccount.stlouisfed.org/apikeys>.

# Readable transformation: year-on-year percent change
gdp_growth <- fred_series("GDP", transform = "yoy_pct")
#> Error in fred_get_key(): No FRED API key found.
#> ℹ Set one with `fred_set_key()` or the `FRED_API_KEY` environment variable.
#> ℹ Register for a free key at <https://fredaccount.stlouisfed.org/apikeys>.

# Aggregate daily to monthly
rates <- fred_series("DGS10", frequency = "m")
#> Error in fred_get_key(): No FRED API key found.
#> ℹ Set one with `fred_set_key()` or the `FRED_API_KEY` environment variable.
#> ℹ Register for a free key at <https://fredaccount.stlouisfed.org/apikeys>.
options(op)
# }
```
