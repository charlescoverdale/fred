# Browse the FRED category tree

Pretty-prints the FRED category tree. With no arguments, shows the eight
top-level FRED categories from a built-in static reference (no API
call). Pass a `category_id` to drill into its children, which fetches
from the API (and is cached). Use this to discover where series live
before searching inside a category with
[`fred_category_series()`](https://charlescoverdale.github.io/fred/reference/fred_category_series.md).

## Usage

``` r
fred_browse(category_id = 0L, depth = 1L)
```

## Arguments

- category_id:

  Integer. Category to browse. Default `0` (root). The root prints from
  a static reference and does not call the API.

- depth:

  Integer. How many levels deep to recurse. Default `1` (only immediate
  children). Higher values trigger one API call per parent category
  visited.

## Value

A `fred_tbl` of categories at the requested level (invisibly).

## See also

Other catalogue:
[`fred_catalogue()`](https://charlescoverdale.github.io/fred/reference/fred_catalogue.md)

## Examples

``` r
# \donttest{
# Top-level categories (no API call)
fred_browse()
#> FRED top-level categories
#> -------------------------
#>    32991  Money, Banking, & Finance
#>       10  Population, Employment, & Labor Markets
#>    32992  National Accounts
#>        1  Production & Business Activity
#>    32455  Prices
#>    32263  International Data
#>     3008  U.S. Regional Data
#>    33060  Academic Data
#> 
#> Use fred_browse(id) to drill into a category.

op <- options(fred.cache_dir = tempdir())
# Drill into "National Accounts" (id 32992)
fred_browse(32992)
#> Error in fred_get_key(): No FRED API key found.
#> ℹ Set one with `fred_set_key()` or the `FRED_API_KEY` environment variable.
#> ℹ Register for a free key at <https://fredaccount.stlouisfed.org/apikeys>.
options(op)
# }
```
