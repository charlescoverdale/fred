# Search for FRED series

Searches the FRED database by keywords or series ID substring. Returns
matching series with their metadata, ordered by relevance.

## Usage

``` r
fred_search(
  query,
  type = "full_text",
  limit = 100L,
  order_by = "search_rank",
  filter_variable = NULL,
  filter_value = NULL,
  tag_names = NULL
)
```

## Arguments

- query:

  Character. Search terms (e.g. `"GDP"`, `"unemployment rate"`).

- type:

  Character. Either `"full_text"` (default) for keyword search or
  `"series_id"` for series ID substring matching (supports `*`
  wildcards).

- limit:

  Integer. Maximum number of results to return. Default 100, maximum
  1000.

- order_by:

  Character. How to order results. One of `"search_rank"` (default),
  `"series_id"`, `"title"`, `"units"`, `"frequency"`,
  `"seasonal_adjustment"`, `"last_updated"`, `"popularity"`,
  `"group_popularity"`.

- filter_variable:

  Character. Optional variable to filter by. One of `"frequency"`,
  `"units"`, or `"seasonal_adjustment"`.

- filter_value:

  Character. The value to filter on (e.g. `"Monthly"`, `"Quarterly"`).
  Required if `filter_variable` is specified.

- tag_names:

  Character. Optional comma-separated tag names to filter results (e.g.
  `"gdp"`, `"usa;quarterly"`).

## Value

A data frame of matching series with columns including `id`, `title`,
`frequency`, `units`, `seasonal_adjustment`, `last_updated`,
`popularity`, and `notes`.

## See also

Other series:
[`fred_info()`](https://charlescoverdale.github.io/fred/reference/fred_info.md),
[`fred_series()`](https://charlescoverdale.github.io/fred/reference/fred_series.md),
[`fred_updates()`](https://charlescoverdale.github.io/fred/reference/fred_updates.md),
[`fred_vintages()`](https://charlescoverdale.github.io/fred/reference/fred_vintages.md)

## Examples

``` r
# \donttest{
op <- options(fred.cache_dir = tempdir())
# Keyword search
fred_search("unemployment rate")
#> Error in fred_get_key(): No FRED API key found.
#> ℹ Set one with `fred_set_key()` or the `FRED_API_KEY` environment variable.
#> ℹ Register for a free key at <https://fredaccount.stlouisfed.org/apikeys>.

# Filter to monthly series only
fred_search("consumer price index", filter_variable = "frequency",
            filter_value = "Monthly")
#> Error in fred_get_key(): No FRED API key found.
#> ℹ Set one with `fred_set_key()` or the `FRED_API_KEY` environment variable.
#> ℹ Register for a free key at <https://fredaccount.stlouisfed.org/apikeys>.

# Search by series ID pattern
fred_search("GDP*", type = "series_id")
#> Error in fred_get_key(): No FRED API key found.
#> ℹ Set one with `fred_set_key()` or the `FRED_API_KEY` environment variable.
#> ℹ Register for a free key at <https://fredaccount.stlouisfed.org/apikeys>.
options(op)
# }
```
