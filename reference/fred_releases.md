# List all FRED releases

Returns all data releases available on FRED. A release is a collection
of related series published together (e.g. "Employment Situation",
"GDP").

## Usage

``` r
fred_releases()
```

## Value

A data frame of releases with columns including `id`, `name`,
`press_release`, and `link`.

## See also

Other releases:
[`fred_release_dates()`](https://charlescoverdale.github.io/fred/reference/fred_release_dates.md),
[`fred_release_series()`](https://charlescoverdale.github.io/fred/reference/fred_release_series.md)

## Examples

``` r
# \donttest{
op <- options(fred.cache_dir = tempdir())
fred_releases()
#> Error in fred_get_key(): No FRED API key found.
#> ℹ Set one with `fred_set_key()` or the `FRED_API_KEY` environment variable.
#> ℹ Register for a free key at <https://fredaccount.stlouisfed.org/apikeys>.
options(op)
# }
```
