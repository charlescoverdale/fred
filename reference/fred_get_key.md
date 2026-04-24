# Get the current FRED API key

Returns the API key set via
[`fred_set_key()`](https://charlescoverdale.github.io/fred/reference/fred_set_key.md)
or the `FRED_API_KEY` environment variable. Raises an error if no key is
found.

## Usage

``` r
fred_get_key()
```

## Value

Character. The API key.

## See also

Other configuration:
[`clear_cache()`](https://charlescoverdale.github.io/fred/reference/clear_cache.md),
[`fred_cache_info()`](https://charlescoverdale.github.io/fred/reference/fred_cache_info.md),
[`fred_request()`](https://charlescoverdale.github.io/fred/reference/fred_request.md),
[`fred_set_key()`](https://charlescoverdale.github.io/fred/reference/fred_set_key.md)

## Examples

``` r
# \donttest{
op <- options(fred.cache_dir = tempdir())
fred_get_key()
#> Error in fred_get_key(): No FRED API key found.
#> ℹ Set one with `fred_set_key()` or the `FRED_API_KEY` environment variable.
#> ℹ Register for a free key at <https://fredaccount.stlouisfed.org/apikeys>.
options(op)
# }
```
