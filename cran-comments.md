# CRAN submission comments — fred 0.2.0

## Summary of changes

This is a feature release. Changes since 0.1.2 (see NEWS.md for full list):

* New real-time / vintage helpers built on the ALFRED endpoint:
  `fred_as_of()`, `fred_first_release()`, `fred_all_vintages()`, and
  `fred_real_time_panel()`. These return a series as it appeared on a
  chosen date, the first release of each observation, the full revision
  history, or a panel of selected vintage snapshots.
* `fred_series()` gains `format = "wide"` and a `transform =` argument
  with readable aliases (`yoy_pct`, `log_diff`, `qoq_annualised`, etc.).
  The raw `units` codes still work; the two arguments are mutually
  exclusive.
* New `fred_cache_info()` reports cache directory, file count, total
  size, and per-file metadata for debugging stale results.
* All observation results are now returned as `fred_tbl`, a thin
  `data.frame` subclass with a one-line provenance header. Downstream
  code can keep treating the result as a plain data frame.
* Bug fix: the `fred_set_key()` example previously called
  `fred_set_key("your_api_key_here")` inside `\donttest{}`, which
  overwrote the real key for every alphabetically-later donttest
  example. The example is now wrapped in `\dontrun{}`.

The cache key format is unchanged for default arguments, so caches
built under 0.1.x are still picked up after upgrade. Realtime,
output-type, and vintage requests are cached under distinct keys.

## R CMD check results

0 errors | 0 warnings | 0 notes

## Test environments

* macOS Sequoia 15.6.1, R 4.5.2 (aarch64-apple-darwin20) — local
  `devtools::check(cran = TRUE)` with `--run-donttest`

## Notes for CRAN reviewers

* All functions that make network requests are wrapped in `\donttest{}`
  in examples (and require `FRED_API_KEY` to be set in the environment),
  and use `skip_if(Sys.getenv("FRED_API_KEY") == "")` in tests.
* Data is fetched from the FRED API at `https://api.stlouisfed.org/fred/`.
  A free API key is required (set via `fred_set_key()` or the
  `FRED_API_KEY` environment variable).
* Local caching uses `tools::R_user_dir("fred", "cache")` (base R, no
  additional dependencies). In examples, caching is redirected to
  `tempdir()` so that no files are written to the user's home filespace.
* No new dependencies were added in 0.2.0. The package still imports
  only `cli`, `httr2`, and `tools`.

## Downstream dependencies

There are currently no downstream dependencies for this package.
