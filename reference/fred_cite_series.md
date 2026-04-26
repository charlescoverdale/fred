# Generate a citation for a FRED series

Produces a citation string for a single FRED series in BibTeX, plain
text, or `bibentry` form. Works offline by default: the citation falls
back to the series ID as the title. Pass `fetch_metadata = TRUE` to call
[`fred_info()`](https://charlescoverdale.github.io/fred/reference/fred_info.md)
and use the official series title (requires an API key).

## Usage

``` r
fred_cite_series(
  series_id,
  vintage_date = NULL,
  format = c("bibtex", "text", "bibentry"),
  fetch_metadata = FALSE
)
```

## Arguments

- series_id:

  Character. A single FRED series ID.

- vintage_date:

  Optional character or Date. Vintage date the data was accessed as of.
  Defaults to today's date (the "accessed" date).

- format:

  Character. One of `"bibtex"` (default), `"text"`, or `"bibentry"` (an
  R [`utils::bibentry`](https://rdrr.io/r/utils/bibentry.html) object).

- fetch_metadata:

  Logical. If `TRUE`, call
  [`fred_info()`](https://charlescoverdale.github.io/fred/reference/fred_info.md)
  to fetch the official series title. Requires an API key. Default
  `FALSE`.

## Value

A character string (`"bibtex"`, `"text"`) or a `bibentry` object.

## Details

Cite a specific vintage by passing `vintage_date`. This is essential for
reproducible research: a 2023 GDP figure published in October 2023 may
differ materially from the same observation as it appears today.

## See also

Other reproducibility:
[`fred_manifest()`](https://charlescoverdale.github.io/fred/reference/fred_manifest.md),
[`fred_vintage_revisions()`](https://charlescoverdale.github.io/fred/reference/fred_vintage_revisions.md)

## Examples

``` r
# BibTeX without an API call
fred_cite_series("GDPC1")
#> [1] "@misc{FRED_GDPC1_2026,\n  title        = {GDPC1 [GDPC1]},\n  author       = {{Federal Reserve Bank of St. Louis}},\n  publisher    = {Federal Reserve Bank of St. Louis},\n  year         = {2026},\n  url          = {https://fred.stlouisfed.org/series/GDPC1},\n  urldate      = {2026-04-26},\n  note         = {FRED, Federal Reserve Bank of St. Louis}\n}"

# Plain-text citation pinned to a vintage date
fred_cite_series("UNRATE", vintage_date = "2024-06-01", format = "text")
#> [1] "Federal Reserve Bank of St. Louis. (2024). UNRATE [UNRATE]. FRED, Federal Reserve Bank of St. Louis. https://fred.stlouisfed.org/series/UNRATE. Accessed 01 June 2024."

if (FALSE) { # \dontrun{
  # Use the official title (requires an API key)
  fred_cite_series("GDPC1", fetch_metadata = TRUE)
} # }
```
