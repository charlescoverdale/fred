# Subset method for fred_tbl

Preserves the `fred_tbl` class and `fred_query` attribute when
subsetting rows or columns. Falls back to a plain vector when
`drop = TRUE` reduces the result to a single column (matching
`data.frame` behaviour).

## Usage

``` r
# S3 method for class 'fred_tbl'
x[i, j, ..., drop = TRUE]
```

## Arguments

- x:

  A `fred_tbl`.

- i:

  Row selector.

- j:

  Column selector.

- ...:

  Other arguments passed to `[.data.frame`.

- drop:

  Logical. As in `[.data.frame`.

## Value

A `fred_tbl` (or a vector if `drop` collapses the result).
