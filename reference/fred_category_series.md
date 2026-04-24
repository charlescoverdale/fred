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

## See also

Other categories:
[`fred_category()`](https://charlescoverdale.github.io/fred/reference/fred_category.md),
[`fred_category_children()`](https://charlescoverdale.github.io/fred/reference/fred_category_children.md)

## Examples

``` r
# \donttest{
op <- options(fred.cache_dir = tempdir())
fred_category_series(32992)
#> Error in fred_get_key(): No FRED API key found.
#> ℹ Set one with `fred_set_key()` or the `FRED_API_KEY` environment variable.
#> ℹ Register for a free key at <https://fredaccount.stlouisfed.org/apikeys>.
options(op)
# }
```
