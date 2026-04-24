# Get vintage dates for a FRED series

Returns the dates on which data for a series were revised. This is
useful for real-time analysis and understanding data revisions.

## Usage

``` r
fred_vintages(series_id)
```

## Arguments

- series_id:

  Character. A single FRED series ID.

## Value

A data frame with columns `series_id` and `vintage_date`.

## See also

Other series:
[`fred_info()`](https://charlescoverdale.github.io/fred/reference/fred_info.md),
[`fred_search()`](https://charlescoverdale.github.io/fred/reference/fred_search.md),
[`fred_series()`](https://charlescoverdale.github.io/fred/reference/fred_series.md),
[`fred_updates()`](https://charlescoverdale.github.io/fred/reference/fred_updates.md)

## Examples

``` r
# \donttest{
op <- options(fred.cache_dir = tempdir())
fred_vintages("GDP")
#> Error in fred_get_key(): No FRED API key found.
#> ℹ Set one with `fred_set_key()` or the `FRED_API_KEY` environment variable.
#> ℹ Register for a free key at <https://fredaccount.stlouisfed.org/apikeys>.
options(op)
# }
```
