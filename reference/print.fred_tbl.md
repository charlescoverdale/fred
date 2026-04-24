# Print method for fred_tbl

Adds a one-line provenance header above the data frame body. The header
summarises the query: number of series, observation count,
transformation in effect, and any vintage information.

## Usage

``` r
# S3 method for class 'fred_tbl'
print(x, ...)
```

## Arguments

- x:

  A `fred_tbl`.

- ...:

  Passed to the underlying `print.data.frame` method.

## Value

`x`, invisibly.
