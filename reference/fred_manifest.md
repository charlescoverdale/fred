# Snapshot a session's FRED downloads as a YAML manifest

Produces a YAML manifest describing one or more `fred_tbl` objects, with
query metadata, dimensions, date ranges, and an MD5 hash of each object.
Intended to be saved alongside paper code for reproducibility checks: if
the manifest still hashes to the same values, the data underlying the
analysis has not changed.

## Usage

``` r
fred_manifest(..., file = NULL)
```

## Arguments

- ...:

  `fred_tbl` objects (positional or named) or a single list of
  `fred_tbl` objects.

- file:

  Optional path to write the YAML manifest. If `NULL` (default), the
  manifest is returned as a `fred_manifest` object (printable).

## Value

A `fred_manifest` object (a character string with an attached print
method). If `file` is supplied, written to disk and returned invisibly.

## Details

Pass `fred_tbl` objects positionally, named, or as a list. If passed a
bare list, names from the list are used; otherwise objects are labelled
`obj_1`, `obj_2`, ...

## See also

Other reproducibility:
[`fred_cite_series()`](https://charlescoverdale.github.io/fred/reference/fred_cite_series.md),
[`fred_vintage_revisions()`](https://charlescoverdale.github.io/fred/reference/fred_vintage_revisions.md)

## Examples

``` r
# \donttest{
op <- options(fred.cache_dir = tempdir())
if (FALSE) { # \dontrun{
  gdp <- fred_series("GDPC1", from = "2020-01-01")
  un  <- fred_series("UNRATE", from = "2020-01-01")
  m <- fred_manifest(gdp = gdp, unrate = un)
  print(m)
  fred_manifest(gdp = gdp, file = file.path(tempdir(), "manifest.yml"))
} # }
options(op)
# }
```
