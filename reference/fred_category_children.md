# List child categories

Returns the child categories for a given parent category.

## Usage

``` r
fred_category_children(category_id = 0L)
```

## Arguments

- category_id:

  Integer. The parent category ID. Default `0` (root).

## Value

A data frame of child categories.

## See also

Other categories:
[`fred_category()`](https://charlescoverdale.github.io/fred/reference/fred_category.md),
[`fred_category_series()`](https://charlescoverdale.github.io/fred/reference/fred_category_series.md)

## Examples

``` r
# \donttest{
op <- options(fred.cache_dir = tempdir())
# Top-level categories
fred_category_children()
#> Error in fred_get_key(): No FRED API key found.
#> ℹ Set one with `fred_set_key()` or the `FRED_API_KEY` environment variable.
#> ℹ Register for a free key at <https://fredaccount.stlouisfed.org/apikeys>.
options(op)
# }
```
