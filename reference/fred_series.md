# Fetch observations for one or more FRED series

The main function in the package. Downloads time series observations
from FRED and returns a tidy data frame. Multiple series can be fetched
in a single call.

## Usage

``` r
fred_series(
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

  Character. One or more FRED series IDs (e.g. `"GDP"`,
  `c("GDP", "UNRATE", "CPIAUCSL")`).

- from:

  Optional start date. Character (`"YYYY-MM-DD"`) or Date.

- to:

  Optional end date. Character (`"YYYY-MM-DD"`) or Date.

- units:

  Character. Unit transformation to apply. Default `"lin"` (levels). See
  Details.

- frequency:

  Character. Frequency aggregation. One of `"d"` (daily), `"w"`
  (weekly), `"bw"` (biweekly), `"m"` (monthly), `"q"` (quarterly),
  `"sa"` (semiannual), `"a"` (annual), or `NULL` (native frequency, the
  default).

- aggregation:

  Character. Aggregation method when `frequency` is specified. One of
  `"avg"` (default), `"sum"`, or `"eop"` (end of period).

- cache:

  Logical. If `TRUE` (the default), results are cached locally and
  returned from the cache on subsequent calls. Set to `FALSE` to force a
  fresh download from the API.

## Value

A data frame with columns:

- date:

  Date. The observation date.

- series_id:

  Character. The FRED series identifier.

- value:

  Numeric. The observation value.

## Details

FRED supports server-side unit transformations via the `units` argument.
This avoids the need to compute growth rates or log transforms locally.
Supported values:

- `"lin"` -levels (no transformation, the default)

- `"chg"` -change from previous period

- `"ch1"` -change from one year ago

- `"pch"` -percent change from previous period

- `"pc1"` -percent change from one year ago

- `"pca"` -compounded annual rate of change

- `"cch"` -continuously compounded rate of change

- `"cca"` -continuously compounded annual rate of change

- `"log"` -natural log

## Examples

``` r
if (FALSE) { # \dontrun{
# Single series
gdp <- fred_series("GDP")

# Multiple series
macro <- fred_series(c("GDP", "UNRATE", "CPIAUCSL"))

# With transformation: year-on-year percent change
gdp_growth <- fred_series("GDP", units = "pc1")

# Aggregate daily to monthly
rates <- fred_series("DGS10", frequency = "m")
} # }
```
