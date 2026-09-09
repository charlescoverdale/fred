# CRAN submission comments: fred 0.3.1

## This is a resubmission

0.3.0 was rejected by the incoming checks on 2026-09-08 for two problems,
both fixed here.

**The donttest additional check errored.** `fred_all_vintages()` ran on a
machine with no `FRED_API_KEY` and aborted rather than failing gracefully.
0.3.0 wrapped 14 example blocks in `try()` but missed 14 more, including
every vintage helper and `fred_get_key()` itself. All are wrapped now. I
verified by extracting every generated example with
`tools::Rd2ex(commentDonttest = FALSE)` and running all 35 of them with the
API key unset: none errors.

**An invalid DOI.** `inst/CITATION` carried `10.5281/zenodo.fred`, a
placeholder never replaced with a real deposit. It 404s on both CrossRef and
DataCite. There is no Zenodo record for this package, so the field is
removed rather than corrected.

The remaining NOTE flags FOMC, NBER and "discoverability" as possibly
misspelled. All three are correct.

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
  The embedded FOMC scheduled-meeting dataset (2017-2026) is from the
  Federal Reserve Board's `fomccalendars.htm` page. Both are static
  reference frames and will be refreshed in future releases.
* CITATION.cff at the repository root is `.Rbuildignore`'d so it does
  not appear in the package tarball; it is purely for GitHub's
  citation widget and Zenodo discoverability.

## Downstream dependencies

`fred` has no reverse dependencies on CRAN at present.
