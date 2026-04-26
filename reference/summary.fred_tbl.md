# Summary method for fred_tbl

Prints query metadata, dimensions, date range (when present), and value
range (when present), then dispatches to the standard
`summary.data.frame`.

## Usage

``` r
# S3 method for class 'fred_tbl'
summary(object, ...)
```

## Arguments

- object:

  A `fred_tbl`.

- ...:

  Passed to the underlying `summary.data.frame` method.

## Value

Invisibly returns the standard data frame summary.
