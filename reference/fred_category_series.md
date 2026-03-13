# List series in a category

Returns all series belonging to a given category. Automatically
paginates through all results.

## Usage

``` r
fred_category_series(category_id, limit = 1000L)
```

## Arguments

- category_id:

  Integer. The category ID.

- limit:

  Integer. Maximum number of results to return. Default 1000.

## Value

A data frame of series metadata.

## Examples

``` r
if (FALSE) { # \dontrun{
fred_category_series(32992)
} # }
```
