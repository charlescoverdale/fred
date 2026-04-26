# Summarise revision behaviour for a FRED series

For each observation date in a series' vintage history, computes summary
statistics on how the value has been revised: number of vintages, first
and final value, total revision (final minus first), mean and SD of
inter-vintage changes, and elapsed days from first publication to final.
Useful for choosing series for real-time analysis (low-revision series
are more reliable for nowcasting).

## Usage

``` r
fred_vintage_revisions(series_id, from = NULL, to = NULL, cache = TRUE)
```

## Arguments

- series_id:

  Character. A single FRED series ID.

- from, to:

  Optional observation date range.

- cache:

  Logical. Cache the underlying vintage download. Default `TRUE`.

## Value

A `fred_tbl` with columns `series_id`, `date`, `n_vintages`,
`first_value`, `final_value`, `revision_total`, `revision_total_pct`,
`revision_mean`, `revision_sd`, `days_to_final`.

## Details

Internally fetches `fred_all_vintages(series_id, ...)` and reduces. For
long-running indicators, narrow the window with `from`/`to` to keep the
API call manageable.

## See also

Other reproducibility:
[`fred_cite_series()`](https://charlescoverdale.github.io/fred/reference/fred_cite_series.md),
[`fred_manifest()`](https://charlescoverdale.github.io/fred/reference/fred_manifest.md)

## Examples

``` r
# \donttest{
op <- options(fred.cache_dir = tempdir())
if (FALSE) { # \dontrun{
  rev <- fred_vintage_revisions("GDPC1", from = "2018-01-01")
  summary(rev$revision_total_pct)
} # }
options(op)
# }
```
