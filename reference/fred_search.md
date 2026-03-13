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

## Examples

``` r
if (FALSE) { # \dontrun{
# Keyword search
fred_search("unemployment rate")

# Filter to monthly series only
fred_search("consumer price index", filter_variable = "frequency",
            filter_value = "Monthly")

# Search by series ID pattern
fred_search("GDP*", type = "series_id")
} # }
```
