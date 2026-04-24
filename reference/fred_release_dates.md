# Get release dates

Returns the dates on which data for a release were published. Useful for
understanding the data calendar and when revisions occurred.

## Usage

``` r
fred_release_dates(release_id)
```

## Arguments

- release_id:

  Integer. The release ID.

## Value

A data frame with columns `release_id` and `date`.

## See also

Other releases:
[`fred_release_series()`](https://charlescoverdale.github.io/fred/reference/fred_release_series.md),
[`fred_releases()`](https://charlescoverdale.github.io/fred/reference/fred_releases.md)

## Examples

``` r
# \donttest{
op <- options(fred.cache_dir = tempdir())
fred_release_dates(53)
#> Error in fred_get_key(): No FRED API key found.
#> ℹ Set one with `fred_set_key()` or the `FRED_API_KEY` environment variable.
#> ℹ Register for a free key at <https://fredaccount.stlouisfed.org/apikeys>.
options(op)
# }
```
