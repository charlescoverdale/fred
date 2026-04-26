# Extract data windows around event dates

Given a `fred_tbl` (or any data frame with a `date` column) and a vector
of event dates, returns one row per (event, observation) pair where the
observation falls inside the requested window. Useful for event studies
around FOMC decisions, recession peaks, or release dates.

## Usage

``` r
fred_event_window(data, events, window = c(-30L, 90L))
```

## Arguments

- data:

  A `fred_tbl` or `data.frame` with a `date` column.

- events:

  A character or Date vector of event dates.

- window:

  Integer length-2. Days before (negative or zero) and after (positive
  or zero) each event date. Default `c(-30L, 90L)`.

## Value

A `fred_tbl` with the original columns plus `event_date` and
`days_from_event`.

## Details

Long-format input with `series_id`/`value` is supported, as is
wide-format input from `fred_series(..., format = "wide")`. The window
is in calendar days; for monthly or quarterly data, choose a window
large enough to capture at least one observation.

## See also

Other utilities:
[`fred_aggregate()`](https://charlescoverdale.github.io/fred/reference/fred_aggregate.md),
[`fred_interpolate()`](https://charlescoverdale.github.io/fred/reference/fred_interpolate.md)

## Examples

``` r
# \donttest{
op <- options(fred.cache_dir = tempdir())
# Plot UNRATE around the last three FOMC SEP meetings
if (FALSE) { # \dontrun{
  ur <- fred_series("UNRATE", from = "2023-01-01")
  sep <- fred_fomc_dates(year = 2024, sep_only = TRUE)
  fred_event_window(ur, events = sep$date, window = c(-60L, 60L))
} # }
options(op)
# }
```
