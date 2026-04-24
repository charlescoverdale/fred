# List or search FRED tags

Returns FRED tags, optionally filtered by a search query. Tags are
keywords used to categorise series (e.g. "gdp", "monthly", "usa",
"seasonally adjusted").

## Usage

``` r
fred_tags(query = NULL, limit = 1000L)
```

## Arguments

- query:

  Character. Optional search string to filter tags.

- limit:

  Integer. Maximum number of results. Default 1000.

## Value

A data frame of tags with columns including `name`, `group_id`, `notes`,
`popularity`, and `series_count`.

## See also

Other tags:
[`fred_related_tags()`](https://charlescoverdale.github.io/fred/reference/fred_related_tags.md)

## Examples

``` r
# \donttest{
op <- options(fred.cache_dir = tempdir())
fred_tags()
#> Error in fred_get_key(): No FRED API key found.
#> ℹ Set one with `fred_set_key()` or the `FRED_API_KEY` environment variable.
#> ℹ Register for a free key at <https://fredaccount.stlouisfed.org/apikeys>.
fred_tags("inflation")
#> Error in fred_get_key(): No FRED API key found.
#> ℹ Set one with `fred_set_key()` or the `FRED_API_KEY` environment variable.
#> ℹ Register for a free key at <https://fredaccount.stlouisfed.org/apikeys>.
options(op)
# }
```
