# Get release dates

Returns the dates on which data for a release were published. Useful for
understanding the data calendar and when revisions occurred.

## Usage

``` r
fred_release_dates(release_id)
```

## Arguments

- release_id:

  Integer. The release ID.

## Value

A data frame with columns `release_id` and `date`.

## Examples

``` r
if (FALSE) { # \dontrun{
fred_release_dates(53)
} # }
```
