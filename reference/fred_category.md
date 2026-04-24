# Get a FRED category

Returns information about a single category. The FRED category tree
starts at category 0 (the root) and branches into 8 top-level
categories: Money, Banking & Finance; Population, Employment & Labor
Markets; National Accounts; Production & Business Activity; Prices;
International Data; U.S. Regional Data; and Academic Data.

## Usage

``` r
fred_category(category_id = 0L)
```

## Arguments

- category_id:

  Integer. The category ID. Default `0` (root).

## Value

A data frame with category metadata.

## See also

Other categories:
[`fred_category_children()`](https://charlescoverdale.github.io/fred/reference/fred_category_children.md),
[`fred_category_series()`](https://charlescoverdale.github.io/fred/reference/fred_category_series.md)

## Examples

``` r
# \donttest{
op <- options(fred.cache_dir = tempdir())
# Root category
fred_category()
#> Error in fred_get_key(): No FRED API key found.
#> ℹ Set one with `fred_set_key()` or the `FRED_API_KEY` environment variable.
#> ℹ Register for a free key at <https://fredaccount.stlouisfed.org/apikeys>.

# National Accounts (category 32992)
fred_category(32992)
#> Error in fred_get_key(): No FRED API key found.
#> ℹ Set one with `fred_set_key()` or the `FRED_API_KEY` environment variable.
#> ℹ Register for a free key at <https://fredaccount.stlouisfed.org/apikeys>.
options(op)
# }
```
