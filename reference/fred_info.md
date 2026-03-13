# Get metadata for a FRED series

Returns descriptive information about a series, including its title,
units, frequency, seasonal adjustment, and notes.

## Usage

``` r
fred_info(series_id)
```

## Arguments

- series_id:

  Character. A single FRED series ID.

## Value

A data frame with one row containing series metadata.

## Examples

``` r
if (FALSE) { # \dontrun{
fred_info("GDP")
} # }
```
