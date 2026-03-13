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

## Examples

``` r
if (FALSE) { # \dontrun{
fred_get_key()
} # }
```
