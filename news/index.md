# Changelog

## fred 0.3.0

A research-grade upgrade in three logical blocks: (1) discoverability
and reference data, (2) workflow utilities and the default plot method,
and (3) reproducibility helpers. 35 exports + 4 S3 methods, 275 tests,
three new vignettes.

### Discoverability and reference data

- New
  [`fred_catalogue()`](https://charlescoverdale.github.io/fred/reference/fred_catalogue.md)
  returns an offline curated catalogue of around 50 widely used FRED
  series (GDP, employment, inflation, rates, housing, financial,
  money/credit, trade/FX, consumer, fiscal). Filter by category or
  free-text. No API call required.
- New
  [`fred_browse()`](https://charlescoverdale.github.io/fred/reference/fred_browse.md)
  pretty-prints the FRED category tree. With no arguments, shows the
  eight top-level categories from a static reference (no API call). Pass
  a `category_id` to drill into children.
- New
  [`fred_recession_dates()`](https://charlescoverdale.github.io/fred/reference/fred_recession_dates.md)
  returns NBER business-cycle reference dates (peak, trough, duration)
  since 1857. Pass a vector of dates to `flag` to get back
  per-observation in-recession indicators for use as a regression
  covariate.
- New
  [`fred_fomc_dates()`](https://charlescoverdale.github.io/fred/reference/fred_fomc_dates.md)
  returns FOMC scheduled meeting decision dates 2017 to 2025, including
  SEP-meeting flags. Selected unscheduled meetings during stress periods
  are included.
- `fred_tbl` now threads through
  [`fred_search()`](https://charlescoverdale.github.io/fred/reference/fred_search.md),
  [`fred_category()`](https://charlescoverdale.github.io/fred/reference/fred_category.md),
  [`fred_category_children()`](https://charlescoverdale.github.io/fred/reference/fred_category_children.md),
  [`fred_category_series()`](https://charlescoverdale.github.io/fred/reference/fred_category_series.md),
  [`fred_releases()`](https://charlescoverdale.github.io/fred/reference/fred_releases.md),
  [`fred_release_series()`](https://charlescoverdale.github.io/fred/reference/fred_release_series.md),
  [`fred_release_dates()`](https://charlescoverdale.github.io/fred/reference/fred_release_dates.md),
  [`fred_sources()`](https://charlescoverdale.github.io/fred/reference/fred_sources.md),
  [`fred_source_releases()`](https://charlescoverdale.github.io/fred/reference/fred_source_releases.md),
  [`fred_tags()`](https://charlescoverdale.github.io/fred/reference/fred_tags.md),
  [`fred_related_tags()`](https://charlescoverdale.github.io/fred/reference/fred_related_tags.md),
  and
  [`fred_updates()`](https://charlescoverdale.github.io/fred/reference/fred_updates.md).
  Their print headers now show the endpoint and search query (where
  applicable).
- New
  [`summary.fred_tbl()`](https://charlescoverdale.github.io/fred/reference/summary.fred_tbl.md)
  prints query metadata, dimensions, date range, and value range before
  the standard `summary.data.frame` output.
- New `[.fred_tbl()` preserves the `fred_tbl` class and `fred_query`
  attribute when subsetting.

### Workflow utilities and plotting

- New
  [`fred_event_window()`](https://charlescoverdale.github.io/fred/reference/fred_event_window.md)
  extracts data inside a `c(before, after)` day window around event
  dates. Works on both long and wide format. Handy for event studies
  around FOMC decisions, recession peaks, or release dates.
- New
  [`fred_aggregate()`](https://charlescoverdale.github.io/fred/reference/fred_aggregate.md)
  aggregates long or wide format data to a coarser calendar frequency
  (week / month / quarter / year) using `mean`, `sum`, `first`, `last`,
  `median`, `min`, or `max`. Complements server-side aggregation in
  `fred_series(frequency = ...)`.
- New
  [`fred_interpolate()`](https://charlescoverdale.github.io/fred/reference/fred_interpolate.md)
  fills `NA` values via last-observation-carry- forward (`"locf"`) or
  linear interpolation (`"linear"`). Useful for mixed-frequency
  analysis.
- New
  [`plot.fred_tbl()`](https://charlescoverdale.github.io/fred/reference/plot.fred_tbl.md)
  default plot method. Detects long or wide format, draws one line per
  series, and shades NBER recession periods. Uses base graphics: no
  `ggplot2` dependency.

### Reproducibility helpers

- New
  [`fred_cite_series()`](https://charlescoverdale.github.io/fred/reference/fred_cite_series.md)
  produces a citation for a FRED series in BibTeX, plain text, or
  `bibentry` form. Works offline (falls back to the series ID as the
  title); pass `fetch_metadata = TRUE` to use the official series title
  from
  [`fred_info()`](https://charlescoverdale.github.io/fred/reference/fred_info.md).
  Supports vintage-date pinning so cited data is reproducible even after
  revisions.
- New
  [`fred_manifest()`](https://charlescoverdale.github.io/fred/reference/fred_manifest.md)
  snapshots one or more `fred_tbl` objects as a YAML manifest with query
  metadata, dimensions, date range, and an MD5 hash of each object.
  Saving the manifest alongside paper code lets reviewers verify that
  the underlying data is unchanged.
- New
  [`fred_vintage_revisions()`](https://charlescoverdale.github.io/fred/reference/fred_vintage_revisions.md)
  returns per-observation revision summary statistics (n_vintages,
  first/final value, total revision, mean/SD of inter-vintage changes,
  days to final). Useful for choosing low-revision series for nowcasting
  and real-time analysis.

### Vignettes

- New vignette `multi-series-workflows`: fetch, transform, widen, plot.
- New vignette `nowcasting-with-fred`: pseudo-real-time GDP nowcasting
  using monthly indicators, with vintage-aware backtesting (pairs with
  the `nowcast` package).
- New vignette `inflation-revisions`: tracking core inflation revisions
  using
  [`fred_real_time_panel()`](https://charlescoverdale.github.io/fred/reference/fred_real_time_panel.md)
  aligned to FOMC SEP meeting dates.

### Documentation

- CITATION updated to v0.3.0 (was outdated against 0.1.0).
- New `CITATION.cff` file at the repository root for the GitHub citation
  widget and Zenodo deposit workflow.

## fred 0.2.0

CRAN release: 2026-04-11

### New features

- [`fred_series()`](https://charlescoverdale.github.io/fred/reference/fred_series.md)
  gains a `format` argument. Pass `format = "wide"` to get one row per
  date with a column per series, instead of the default long layout.
- [`fred_series()`](https://charlescoverdale.github.io/fred/reference/fred_series.md)
  gains a `transform` argument with readable aliases for the FRED
  `units` codes: `"level"`, `"diff"`, `"yoy_diff"`, `"qoq_pct"`,
  `"yoy_pct"`, `"annualised"`, `"log"`, `"log_diff"`, and more. The raw
  `units` codes still work; `transform` and `units` are mutually
  exclusive.
- New real-time and vintage helpers built on the ALFRED endpoint:
  - [`fred_as_of()`](https://charlescoverdale.github.io/fred/reference/fred_as_of.md)
    returns a series as it appeared on a chosen vintage date.
  - [`fred_first_release()`](https://charlescoverdale.github.io/fred/reference/fred_first_release.md)
    returns only the initial release of each observation, with no
    subsequent revisions.
  - [`fred_all_vintages()`](https://charlescoverdale.github.io/fred/reference/fred_all_vintages.md)
    returns the full revision history.
  - [`fred_real_time_panel()`](https://charlescoverdale.github.io/fred/reference/fred_real_time_panel.md)
    returns the values that were available on each of a chosen set of
    vintage dates.
- New
  [`fred_cache_info()`](https://charlescoverdale.github.io/fred/reference/fred_cache_info.md)
  reports the cache directory, file count, total size, and per-file
  metadata. Useful for debugging stale results.
- All observation results are now returned as `fred_tbl`, a thin
  `data.frame` subclass with a one-line provenance header showing the
  query (series count, observation count, units, transform, frequency,
  vintage). The header is informational; downstream code can keep
  treating the result as a plain data frame.

### Internals

- The cache key format is unchanged for default arguments, so caches
  built under 0.1.x are still picked up after upgrade. Realtime,
  output-type, and vintage requests are cached under distinct keys.

## fred 0.1.2

CRAN release: 2026-03-19

- Removed non-existent pkgdown URL from DESCRIPTION.

## fred 0.1.1

- Examples now use `\donttest` with
  [`tempdir()`](https://rdrr.io/r/base/tempfile.html) cache instead of
  `\dontrun`, fixing CRAN policy compliance.
- Cache directory is now configurable via
  `options(fred.cache_dir = ...)`.

## fred 0.1.0

- Initial CRAN release.
- Core function
  [`fred_series()`](https://charlescoverdale.github.io/fred/reference/fred_series.md)
  for fetching one or more FRED time series.
- Server-side unit transformations and frequency aggregation.
- Local caching of downloaded data.
- Search, category, release, source, tag, and vintage endpoints.
