# Make a raw request to the FRED API

Low-level function that sends a request to any FRED API endpoint and
returns the parsed JSON as a list. Most users should use the
higher-level functions such as
[`fred_series()`](https://charlescoverdale.github.io/fred/reference/fred_series.md)
or
[`fred_search()`](https://charlescoverdale.github.io/fred/reference/fred_search.md).

## Usage

``` r
fred_request(endpoint, ...)
```

## Arguments

- endpoint:

  Character. The API endpoint path (e.g. `"series/observations"`).

- ...:

  Named parameters passed as query string arguments to the API.

## Value

A list parsed from the JSON response.

## See also

Other configuration:
[`clear_cache()`](https://charlescoverdale.github.io/fred/reference/clear_cache.md),
[`fred_cache_info()`](https://charlescoverdale.github.io/fred/reference/fred_cache_info.md),
[`fred_get_key()`](https://charlescoverdale.github.io/fred/reference/fred_get_key.md),
[`fred_set_key()`](https://charlescoverdale.github.io/fred/reference/fred_set_key.md)

## Examples

``` r
# \donttest{
op <- options(fred.cache_dir = tempdir())
fred_request("series", series_id = "GDP")
#> Error in fred_get_key(): No FRED API key found.
#> ℹ Set one with `fred_set_key()` or the `FRED_API_KEY` environment variable.
#> ℹ Register for a free key at <https://fredaccount.stlouisfed.org/apikeys>.
options(op)
# }
```
