# Clear the fred cache

Deletes all locally cached FRED data files. The next call to any data
function will re-download from the FRED API.

## Usage

``` r
clear_cache()
```

## Value

Invisible `NULL`.

## Examples

``` r
if (FALSE) { # \dontrun{
clear_cache()
} # }
```
