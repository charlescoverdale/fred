# fred <img src="man/figures/logo.png" align="right" height="139" />

<!-- badges: start -->
[![R-CMD-check](https://github.com/charlescoverdale/fred/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/charlescoverdale/fred/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

**fred** provides clean, tidy access to economic data from the [Federal Reserve Economic Data (FRED)](https://fred.stlouisfed.org/) API. FRED is maintained by the Federal Reserve Bank of St. Louis and contains over 800,000 time series from 118 sources covering GDP, employment, inflation, interest rates, trade, and more.

## Installation

```r
# Install from CRAN (when available)
install.packages("fred")

# Or the development version from GitHub
# install.packages("pak")
pak::pak("charlescoverdale/fred")
```

## Setup

You need a free FRED API key. Register at <https://fredaccount.stlouisfed.org/apikeys>.

The recommended approach is to add your key to `.Renviron`:

```
FRED_API_KEY=your_key_here
```

Or set it for the current session:

```r
library(fred)
fred_set_key("your_key_here")
```

## Quick start

```r
library(fred)

# Fetch GDP
gdp <- fred_series("GDP")

# Multiple series in one call
macro <- fred_series(c("GDP", "UNRATE", "CPIAUCSL"))

# Year-on-year percent change (computed server-side)
gdp_growth <- fred_series("GDP", units = "pc1")

# Aggregate daily data to monthly
rates <- fred_series("DGS10", frequency = "m")

# Search for series
fred_search("consumer price index")

# Series metadata
fred_info("GDP")

# Browse the category tree
fred_category_children()
```

## Key features

- **Multiple series in one call** — `fred_series(c("GDP", "UNRATE"))` returns a single tidy data frame
- **Server-side transformations** — percent change, log, annualised rates via the `units` argument
- **Frequency aggregation** — aggregate daily/weekly data to monthly/quarterly/annual
- **Automatic pagination** — all list endpoints paginate transparently
- **Local caching** — data is cached on first download; use `clear_cache()` to reset
- **Graceful error handling** — informative messages when the API is unreachable or keys are invalid
- **Minimal dependencies** — only `httr2`, `cli`, and `tools`

## Functions

| Function | Description |
|---|---|
| `fred_series()` | Fetch observations for one or more series |
| `fred_search()` | Search for series by keyword or ID |
| `fred_info()` | Get series metadata |
| `fred_vintages()` | Get revision dates for a series |
| `fred_category()` | Get category information |
| `fred_category_children()` | List child categories |
| `fred_category_series()` | List series in a category |
| `fred_releases()` | List all data releases |
| `fred_release_series()` | List series in a release |
| `fred_release_dates()` | Get release publication dates |
| `fred_sources()` | List all data sources |
| `fred_source_releases()` | List releases from a source |
| `fred_tags()` | List or search tags |
| `fred_related_tags()` | Find related tags |
| `fred_updates()` | List recently updated series |
| `fred_request()` | Raw API request (power users) |
| `fred_set_key()` | Set API key for session |
| `fred_get_key()` | Get current API key |
| `clear_cache()` | Clear local cache |

## Related packages

The **fred** package is part of a suite of R packages for economic and financial data:

| Package | Source | Status |
|---|---|---|
| [ons](https://github.com/charlescoverdale/ons) | UK Office for National Statistics | On CRAN |
| [boe](https://github.com/charlescoverdale/boe) | Bank of England | On CRAN |
| [hmrc](https://github.com/charlescoverdale/hmrc) | HM Revenue & Customs | On CRAN |
| [obr](https://github.com/charlescoverdale/obr) | Office for Budget Responsibility | On CRAN |
| [readecb](https://github.com/charlescoverdale/readecb) | European Central Bank | On CRAN |
| [readoecd](https://github.com/charlescoverdale/readoecd) | OECD | On CRAN |
| [inflateR](https://github.com/charlescoverdale/inflateR) | UK inflation adjustment | On CRAN |

## Attribution

This product uses the FRED® API but is not endorsed or certified by the Federal Reserve Bank of St. Louis.
