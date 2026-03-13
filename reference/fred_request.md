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

## Examples

``` r
if (FALSE) { # \dontrun{
fred_request("series", series_id = "GDP")
} # }
```
