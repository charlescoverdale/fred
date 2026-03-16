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
