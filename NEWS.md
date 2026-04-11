# fred 0.2.0

## New features

* `fred_series()` gains a `format` argument. Pass `format = "wide"` to get
  one row per date with a column per series, instead of the default long
  layout.
* `fred_series()` gains a `transform` argument with readable aliases for
  the FRED `units` codes: `"level"`, `"diff"`, `"yoy_diff"`, `"qoq_pct"`,
  `"yoy_pct"`, `"annualised"`, `"log"`, `"log_diff"`, and more. The raw
  `units` codes still work; `transform` and `units` are mutually exclusive.
* New real-time and vintage helpers built on the ALFRED endpoint:
  * `fred_as_of()` returns a series as it appeared on a chosen vintage date.
  * `fred_first_release()` returns only the initial release of each
    observation, with no subsequent revisions.
  * `fred_all_vintages()` returns the full revision history.
  * `fred_real_time_panel()` returns the values that were available on
    each of a chosen set of vintage dates.
* New `fred_cache_info()` reports the cache directory, file count, total
  size, and per-file metadata. Useful for debugging stale results.
* All observation results are now returned as `fred_tbl`, a thin
  `data.frame` subclass with a one-line provenance header showing the
  query (series count, observation count, units, transform, frequency,
  vintage). The header is informational; downstream code can keep
  treating the result as a plain data frame.

## Internals

* The cache key format is unchanged for default arguments, so caches
  built under 0.1.x are still picked up after upgrade. Realtime,
  output-type, and vintage requests are cached under distinct keys.

# fred 0.1.2

* Removed non-existent pkgdown URL from DESCRIPTION.

# fred 0.1.1

* Examples now use `\donttest` with `tempdir()` cache instead of `\dontrun`,
  fixing CRAN policy compliance.
* Cache directory is now configurable via `options(fred.cache_dir = ...)`.

# fred 0.1.0

* Initial CRAN release.
* Core function `fred_series()` for fetching one or more FRED time series.
* Server-side unit transformations and frequency aggregation.
* Local caching of downloaded data.
* Search, category, release, source, tag, and vintage endpoints.
