# fred <img src="man/figures/logo.png" align="right" height="139" />

<!-- badges: start -->
[![R-CMD-check](https://github.com/charlescoverdale/fred/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/charlescoverdale/fred/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

**fred** provides clean, tidy access to economic data from the [Federal Reserve Economic Data (FRED)](https://fred.stlouisfed.org/) API directly from R.

## What is FRED?

The Federal Reserve Economic Data (FRED) database is maintained by the [Federal Reserve Bank of St. Louis](https://www.stlouisfed.org/) — one of twelve regional Reserve Banks in the US Federal Reserve System. While the Fed's Board of Governors in Washington sets monetary policy, the regional banks each developed their own research specialisms. St. Louis carved out a reputation for applied economic research and data dissemination, and FRED launched in 1991 as a dial-up bulletin board before moving to the web in the mid-1990s. It has since grown into arguably the single most important free data platform for macroeconomic research, now hosting over 800,000 time series covering GDP, employment, inflation, interest rates, trade, financial markets, and more.

What makes FRED unusual is its role as an aggregator. The database doesn't just publish the St. Louis Fed's own data — it pulls in series from 118 different sources, including the Bureau of Labor Statistics, Bureau of Economic Analysis, Census Bureau, Treasury Department, World Bank, and dozens of other US and international agencies. Rather than visiting each agency's website individually and navigating their different data formats, FRED gives you a single, consistent interface to all of them. It's the closest thing economics has to a universal data catalogue.

## The FRED API

FRED provides a [free REST API](https://fred.stlouisfed.org/docs/api/fred/) that gives programmatic access to the full database. The API supports searching for series, fetching observations, browsing the category tree, tracking data releases and revisions, and applying server-side transformations like percent change or frequency aggregation — all without needing to visit the website. Anyone can register for a free API key.

This package wraps the FRED API so you can pull data directly into R with a single function call. Rather than constructing API URLs by hand, `fred_series("GDP")` fetches the data, parses the response, and returns a tidy data frame. You can fetch multiple series at once, apply transformations, search by keyword, browse categories, and track revisions — all from R. Results are cached locally so repeated calls are instant.

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
