# CRAN submission comments: fred 0.3.2

Bug-fix release. `fred_series()` returned a locally cached copy of each
request indefinitely, so repeated calls never saw new observations or
revisions. Cached copies now expire after 24 hours (configurable with an
option). Separately, every HTTP error from the API (a mistyped series ID,
an unregistered key) was reported as a connection failure; errors now
carry the status and FRED's own message.

## Test environments

* local macOS (aarch64-apple-darwin), R 4.5.x: `R CMD check --as-cran
  --run-donttest`

## R CMD check results

0 errors | 0 warnings | 0 notes

The check machine could not reach the time server, so "checking for
future file timestamps" reported "unable to verify current time"; that is
not a package issue.

## Internet resources

Every example and test that calls the FRED API needs an API key; examples
are wrapped in `try()` inside `\donttest{}` and tests are skipped on CRAN
and when no key is set, so the package fails gracefully when the API is
unreachable.
