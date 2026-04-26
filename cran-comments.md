# CRAN submission comments — fred 0.3.0

## Summary of changes

This is a feature release. Highlights since 0.2.0 (full list in NEWS.md):

* **Discoverability and reference data:**
  * `fred_catalogue()`: an offline curated catalogue of around 50
    widely used FRED series, filterable by category or free-text. No
    API call.
  * `fred_browse()`: pretty-prints the FRED category tree. The
    eight top-level categories are offline; deeper levels hit the API.
  * `fred_recession_dates()`: NBER business-cycle peaks and troughs
    since 1857, with an optional vector-flag mode.
  * `fred_fomc_dates()`: FOMC scheduled meeting decision dates 2017-2025
    with SEP flags.
  * `fred_tbl` now threads through every search/browse return value
    (search, categories, releases, sources, tags, updates) with an
    endpoint-aware print header.
  * New `summary.fred_tbl()` and `[.fred_tbl()` S3 methods.

* **Workflow utilities and plotting:**
  * `fred_event_window()`, `fred_aggregate()`, `fred_interpolate()`.
  * `plot.fred_tbl()` default plot method with NBER recession shading
    via base graphics (no `ggplot2` dependency).

* **Reproducibility helpers:**
  * `fred_cite_series()`: BibTeX, plain-text, or `bibentry` citation,
    with vintage-date pinning. BibTeX escapes special characters in
    titles.
  * `fred_manifest()`: YAML snapshot of one or more `fred_tbl` objects
    with query metadata, dimensions, date range, and an MD5 hash per
    object.
  * `fred_vintage_revisions()`: per-observation revision summary
    statistics (n_vintages, first/final value, total revision, mean/SD
    of inter-vintage changes, days to final).

* **Vignettes (new):**
  * `multi-series-workflows`: fetch, transform, widen, plot.
  * `nowcasting-with-fred`: pseudo-real-time GDP nowcasting with monthly
    indicators (pairs with the `nowcast` package).
  * `inflation-revisions`: tracking core inflation revisions across FOMC
    SEP meeting vintages.

* **Other:**
  * CITATION updated to v0.3.0 (was outdated against 0.1.0).
  * New `CITATION.cff` at the repository root for GitHub citation widget
    and Zenodo deposit.

## Dependencies

`Imports`: `cli`, `httr2`, `tools`, plus the base R recommended
packages `graphics`, `grDevices`, `stats`, and `utils` used by the new
plot, citation, and statistics helpers.

`Suggests`: `knitr`, `nowcast`, `rmarkdown`, `testthat`, `withr`.
`nowcast` is used in one vignette and is on CRAN.

No third-party dependency added in this release.

## R CMD check results

0 errors | 0 warnings | 0 notes

Local check: macOS Sequoia 15.6.1, R 4.5.2 (aarch64-apple-darwin20),
`devtools::check(cran = TRUE)`.

## Test environments

* macOS Sequoia 15.6.1, R 4.5.2 (aarch64-apple-darwin20) — local
  `devtools::check(cran = TRUE)`.
* win-builder devel and release (queued via `devtools::check_win_devel()`
  / `check_win_release()` ahead of submission).

## Notes for CRAN reviewers

* All functions that make network requests are wrapped in `\donttest{}`
  in examples and require `FRED_API_KEY` to be set in the environment.
  Tests that hit the live API use `skip_if(Sys.getenv("FRED_API_KEY") == "")`.
* All offline functions (`fred_catalogue()`, `fred_browse()` at root,
  `fred_recession_dates()`, `fred_fomc_dates()`, `fred_cite_series()` at
  default `fetch_metadata = FALSE`, `fred_manifest()`, the S3 methods,
  and the workflow utilities on synthetic data) have un-wrapped examples
  that run during R CMD check.
* Local caching uses `tools::R_user_dir("fred", "cache")` (base R, no
  additional dependency). In examples, caching is redirected to
  `tempdir()` so no files are written outside the session.
* The embedded NBER recession dataset (1857-2020) is from the NBER
  Business Cycle Dating Committee
  <https://www.nber.org/research/data/us-business-cycle-expansions-and-contractions>.
  The embedded FOMC scheduled-meeting dataset (2017-2025) is from the
  Federal Reserve Board's `fomccalendars.htm` page. Both are static
  reference frames and will be refreshed in future releases.
* CITATION.cff at the repository root is `.Rbuildignore`'d so it does
  not appear in the package tarball; it is purely for GitHub's
  citation widget and Zenodo discoverability.

## Downstream dependencies

`fred` has no reverse dependencies on CRAN at present.
