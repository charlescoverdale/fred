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

## Examples

``` r
if (FALSE) { # \dontrun{
fred_related_tags("gdp")
} # }
```
