# List all FRED data sources

Returns all data sources that contribute series to FRED. Sources include
the Bureau of Labor Statistics, Bureau of Economic Analysis, Federal
Reserve Board, U.S. Census Bureau, and over 100 others.

## Usage

``` r
fred_sources()
```

## Value

A data frame of sources with columns including `id`, `name`, and `link`.

## Examples

``` r
if (FALSE) { # \dontrun{
fred_sources()
} # }
```
