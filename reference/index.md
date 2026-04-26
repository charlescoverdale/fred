# Package index

## Data Access

Fetch time series observations from FRED

- [`fred_series()`](https://charlescoverdale.github.io/fred/reference/fred_series.md)
  : Fetch observations for one or more FRED series
- [`fred_info()`](https://charlescoverdale.github.io/fred/reference/fred_info.md)
  : Get metadata for a FRED series
- [`fred_request()`](https://charlescoverdale.github.io/fred/reference/fred_request.md)
  : Make a raw request to the FRED API

## Vintage Data (ALFRED)

Real-time and vintage data via ALFRED

- [`fred_as_of()`](https://charlescoverdale.github.io/fred/reference/fred_as_of.md)
  : Fetch a series as it appeared on a given vintage date
- [`fred_first_release()`](https://charlescoverdale.github.io/fred/reference/fred_first_release.md)
  : Fetch the first-release ("real-time") version of a series
- [`fred_all_vintages()`](https://charlescoverdale.github.io/fred/reference/fred_all_vintages.md)
  : Fetch every vintage of a series
- [`fred_real_time_panel()`](https://charlescoverdale.github.io/fred/reference/fred_real_time_panel.md)
  : Fetch a real-time panel of a series across selected vintages
- [`fred_vintages()`](https://charlescoverdale.github.io/fred/reference/fred_vintages.md)
  : Get vintage dates for a FRED series
- [`fred_vintage_revisions()`](https://charlescoverdale.github.io/fred/reference/fred_vintage_revisions.md)
  : Summarise revision behaviour for a FRED series

## Discoverability

Find series and browse the FRED structure

- [`fred_catalogue()`](https://charlescoverdale.github.io/fred/reference/fred_catalogue.md)
  : Browse a curated catalogue of popular FRED series
- [`fred_browse()`](https://charlescoverdale.github.io/fred/reference/fred_browse.md)
  : Browse the FRED category tree
- [`fred_search()`](https://charlescoverdale.github.io/fred/reference/fred_search.md)
  : Search for FRED series
- [`fred_recession_dates()`](https://charlescoverdale.github.io/fred/reference/fred_recession_dates.md)
  : NBER US business-cycle reference dates
- [`fred_fomc_dates()`](https://charlescoverdale.github.io/fred/reference/fred_fomc_dates.md)
  : FOMC scheduled meeting dates and decisions

## Categories

Browse the FRED category tree

- [`fred_category()`](https://charlescoverdale.github.io/fred/reference/fred_category.md)
  : Get a FRED category
- [`fred_category_children()`](https://charlescoverdale.github.io/fred/reference/fred_category_children.md)
  : List child categories
- [`fred_category_series()`](https://charlescoverdale.github.io/fred/reference/fred_category_series.md)
  : List series in a category

## Releases & Sources

Explore data releases and their sources

- [`fred_releases()`](https://charlescoverdale.github.io/fred/reference/fred_releases.md)
  : List all FRED releases
- [`fred_release_series()`](https://charlescoverdale.github.io/fred/reference/fred_release_series.md)
  : List series in a release
- [`fred_release_dates()`](https://charlescoverdale.github.io/fred/reference/fred_release_dates.md)
  : Get release dates
- [`fred_sources()`](https://charlescoverdale.github.io/fred/reference/fred_sources.md)
  : List all FRED data sources
- [`fred_source_releases()`](https://charlescoverdale.github.io/fred/reference/fred_source_releases.md)
  : List releases from a source

## Tags

Search and explore FRED tags

- [`fred_tags()`](https://charlescoverdale.github.io/fred/reference/fred_tags.md)
  : List or search FRED tags
- [`fred_related_tags()`](https://charlescoverdale.github.io/fred/reference/fred_related_tags.md)
  : Find tags related to a given tag
- [`fred_updates()`](https://charlescoverdale.github.io/fred/reference/fred_updates.md)
  : List recently updated FRED series

## Workflow Utilities

Event windows, aggregation, interpolation

- [`fred_event_window()`](https://charlescoverdale.github.io/fred/reference/fred_event_window.md)
  : Extract data windows around event dates
- [`fred_aggregate()`](https://charlescoverdale.github.io/fred/reference/fred_aggregate.md)
  : Aggregate FRED observations to a coarser frequency
- [`fred_interpolate()`](https://charlescoverdale.github.io/fred/reference/fred_interpolate.md)
  : Fill missing values in a FRED series

## Reproducibility

Citations and manifests for paper-ready workflows

- [`fred_cite_series()`](https://charlescoverdale.github.io/fred/reference/fred_cite_series.md)
  : Generate a citation for a FRED series
- [`fred_manifest()`](https://charlescoverdale.github.io/fred/reference/fred_manifest.md)
  : Snapshot a session's FRED downloads as a YAML manifest

## S3 Methods

Methods for fred_tbl and fred_manifest

- [`print(`*`<fred_tbl>`*`)`](https://charlescoverdale.github.io/fred/reference/print.fred_tbl.md)
  : Print method for fred_tbl
- [`summary(`*`<fred_tbl>`*`)`](https://charlescoverdale.github.io/fred/reference/summary.fred_tbl.md)
  : Summary method for fred_tbl
- [`plot(`*`<fred_tbl>`*`)`](https://charlescoverdale.github.io/fred/reference/plot.fred_tbl.md)
  : Plot a fred_tbl
- [`` `[`( ``*`<fred_tbl>`*`)`](https://charlescoverdale.github.io/fred/reference/sub-.fred_tbl.md)
  : Subset method for fred_tbl
- [`print(`*`<fred_manifest>`*`)`](https://charlescoverdale.github.io/fred/reference/print.fred_manifest.md)
  : Print method for fred_manifest

## Configuration

API key and cache management

- [`fred_set_key()`](https://charlescoverdale.github.io/fred/reference/fred_set_key.md)
  : Set the FRED API key
- [`fred_get_key()`](https://charlescoverdale.github.io/fred/reference/fred_get_key.md)
  : Get the current FRED API key
- [`fred_cache_info()`](https://charlescoverdale.github.io/fred/reference/fred_cache_info.md)
  : Inspect the local fred cache
- [`clear_cache()`](https://charlescoverdale.github.io/fred/reference/clear_cache.md)
  : Clear the fred cache

## Package

- [`fred`](https://charlescoverdale.github.io/fred/reference/fred-package.md)
  [`fred-package`](https://charlescoverdale.github.io/fred/reference/fred-package.md)
  : fred: Access 'Federal Reserve Economic Data'
