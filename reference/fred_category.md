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

## Examples

``` r
if (FALSE) { # \dontrun{
# Root category
fred_category()

# National Accounts (category 32992)
fred_category(32992)
} # }
```
