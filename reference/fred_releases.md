# List all FRED releases

Returns all data releases available on FRED. A release is a collection
of related series published together (e.g. "Employment Situation",
"GDP").

## Usage

``` r
fred_releases()
```

## Value

A data frame of releases with columns including `id`, `name`,
`press_release`, and `link`.

## Examples

``` r
if (FALSE) { # \dontrun{
fred_releases()
} # }
```
