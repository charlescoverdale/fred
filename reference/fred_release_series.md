# List series in a release

Returns all series belonging to a given release.

## Usage

``` r
fred_release_series(release_id)
```

## Arguments

- release_id:

  Integer. The release ID.

## Value

A data frame of series metadata.

## See also

Other releases:
[`fred_release_dates()`](https://charlescoverdale.github.io/fred/reference/fred_release_dates.md),
[`fred_releases()`](https://charlescoverdale.github.io/fred/reference/fred_releases.md)

## Examples

``` r
# \donttest{
op <- options(fred.cache_dir = tempdir())
# GDP release
fred_release_series(53)
#> Error in fred_get_key(): No FRED API key found.
#> ℹ Set one with `fred_set_key()` or the `FRED_API_KEY` environment variable.
#> ℹ Register for a free key at <https://fredaccount.stlouisfed.org/apikeys>.
options(op)
# }
```
