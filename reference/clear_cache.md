# Clear the fred cache

Deletes all locally cached FRED data files. The next call to any data
function will re-download from the FRED API.

## Usage

``` r
clear_cache()
```

## Value

Invisible `NULL`.

## See also

Other configuration:
[`fred_cache_info()`](https://charlescoverdale.github.io/fred/reference/fred_cache_info.md),
[`fred_get_key()`](https://charlescoverdale.github.io/fred/reference/fred_get_key.md),
[`fred_request()`](https://charlescoverdale.github.io/fred/reference/fred_request.md),
[`fred_set_key()`](https://charlescoverdale.github.io/fred/reference/fred_set_key.md)

## Examples

``` r
# \donttest{
op <- options(fred.cache_dir = tempdir())
clear_cache()
#> Cache cleared.
options(op)
# }
```
