# List releases from a source

Returns all releases published by a given data source.

## Usage

``` r
fred_source_releases(source_id)
```

## Arguments

- source_id:

  Integer. The source ID.

## Value

A data frame of releases.

## See also

Other sources:
[`fred_sources()`](https://charlescoverdale.github.io/fred/reference/fred_sources.md)

## Examples

``` r
# \donttest{
op <- options(fred.cache_dir = tempdir())
# Bureau of Labor Statistics
fred_source_releases(22)
#> Error in fred_get_key(): No FRED API key found.
#> ℹ Set one with `fred_set_key()` or the `FRED_API_KEY` environment variable.
#> ℹ Register for a free key at <https://fredaccount.stlouisfed.org/apikeys>.
options(op)
# }
```
