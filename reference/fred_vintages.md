# Get vintage dates for a FRED series

Returns the dates on which data for a series were revised. This is
useful for real-time analysis and understanding data revisions.

## Usage

``` r
fred_vintages(series_id)
```

## Arguments

- series_id:

  Character. A single FRED series ID.

## Value

A data frame with columns `series_id` and `vintage_date`.

## Examples

``` r
if (FALSE) { # \dontrun{
fred_vintages("GDP")
} # }
```
