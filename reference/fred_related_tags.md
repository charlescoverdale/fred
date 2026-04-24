# Find tags related to a given tag

Returns tags that are frequently used together with the specified tag.

## Usage

``` r
fred_related_tags(tag_names)
```

## Arguments

- tag_names:

  Character. One or more tag names, separated by semicolons (e.g.
  `"gdp"`, `"usa;quarterly"`).

## Value

A data frame of related tags.

## See also

Other tags:
[`fred_tags()`](https://charlescoverdale.github.io/fred/reference/fred_tags.md)

## Examples

``` r
# \donttest{
op <- options(fred.cache_dir = tempdir())
fred_related_tags("gdp")
#> Error in fred_get_key(): No FRED API key found.
#> ℹ Set one with `fred_set_key()` or the `FRED_API_KEY` environment variable.
#> ℹ Register for a free key at <https://fredaccount.stlouisfed.org/apikeys>.
options(op)
# }
```
