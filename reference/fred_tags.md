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

## Examples

``` r
if (FALSE) { # \dontrun{
fred_tags()
fred_tags("inflation")
} # }
```
