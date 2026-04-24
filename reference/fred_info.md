# Get metadata for a FRED series

Returns descriptive information about a series, including its title,
units, frequency, seasonal adjustment, and notes.

## Usage

``` r
fred_info(series_id)
```

## Arguments

- series_id:

  Character. A single FRED series ID.

## Value

A data frame with one row containing series metadata.

## See also

Other series:
[`fred_search()`](https://charlescoverdale.github.io/fred/reference/fred_search.md),
[`fred_series()`](https://charlescoverdale.github.io/fred/reference/fred_series.md),
[`fred_updates()`](https://charlescoverdale.github.io/fred/reference/fred_updates.md),
[`fred_vintages()`](https://charlescoverdale.github.io/fred/reference/fred_vintages.md)

## Examples

``` r
# \donttest{
op <- options(fred.cache_dir = tempdir())
fred_info("GDP")
#> Error in fred_get_key(): No FRED API key found.
#> ℹ Set one with `fred_set_key()` or the `FRED_API_KEY` environment variable.
#> ℹ Register for a free key at <https://fredaccount.stlouisfed.org/apikeys>.
options(op)
# }
```
