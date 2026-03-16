# CRAN submission comments — fred 0.1.1

## Resubmission

This is a resubmission of fred 0.1.0. Changes since 0.1.0:

* Examples now use `\donttest` with `tempdir()` cache instead of `\dontrun`,
  fixing CRAN policy compliance.
* Cache directory is now configurable via `options(fred.cache_dir = ...)`.

## R CMD check results

0 errors | 0 warnings | 1 note

* New submission.

## Test environments

* macOS Sequoia 15.6.1, R 4.5.2 (aarch64-apple-darwin20) — local

## Notes for CRAN reviewers

* All functions that make network requests are wrapped in `\donttest{}` in
  examples and `skip_on_cran()` + `skip_if_offline()` in tests.
* Data is fetched from the FRED API at `https://api.stlouisfed.org/fred/`.
  A free API key is required (set via `fred_set_key()`).
* Local caching uses `tools::R_user_dir("fred", "cache")` (base R, no
  additional dependencies). In examples, caching is redirected to `tempdir()`
  so that no files are written to the user's home filespace.

## Downstream dependencies

There are currently no downstream dependencies for this package.
