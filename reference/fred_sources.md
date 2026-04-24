# List all FRED data sources

Returns all data sources that contribute series to FRED. Sources include
the Bureau of Labor Statistics, Bureau of Economic Analysis, Federal
Reserve Board, U.S. Census Bureau, and over 100 others.

## Usage

``` r
fred_sources()
```

## Value

A data frame of sources with columns including `id`, `name`, and `link`.

## See also

Other sources:
[`fred_source_releases()`](https://charlescoverdale.github.io/fred/reference/fred_source_releases.md)

## Examples

``` r
# \donttest{
op <- options(fred.cache_dir = tempdir())
fred_sources()
#> Error in fred_get_key(): No FRED API key found.
#> ℹ Set one with `fred_set_key()` or the `FRED_API_KEY` environment variable.
#> ℹ Register for a free key at <https://fredaccount.stlouisfed.org/apikeys>.
options(op)
# }
```
