# List recently updated FRED series

Returns series that have been recently updated or revised.

## Usage

``` r
fred_updates(limit = 100L)
```

## Arguments

- limit:

  Integer. Maximum number of results. Default 100, maximum 100.

## Value

A data frame of recently updated series.

## See also

Other series:
[`fred_info()`](https://charlescoverdale.github.io/fred/reference/fred_info.md),
[`fred_search()`](https://charlescoverdale.github.io/fred/reference/fred_search.md),
[`fred_series()`](https://charlescoverdale.github.io/fred/reference/fred_series.md),
[`fred_vintages()`](https://charlescoverdale.github.io/fred/reference/fred_vintages.md)

## Examples

``` r
# \donttest{
op <- options(fred.cache_dir = tempdir())
fred_updates()
#> Error in fred_get_key(): No FRED API key found.
#> ℹ Set one with `fred_set_key()` or the `FRED_API_KEY` environment variable.
#> ℹ Register for a free key at <https://fredaccount.stlouisfed.org/apikeys>.
options(op)
# }
```
