# fred
[![CRAN status](https://www.r-pkg.org/badges/version/fred)](https://CRAN.R-project.org/package=fred) [![CRAN downloads](https://cranlogs.r-pkg.org/badges/fred)](https://CRAN.R-project.org/package=fred) [![Total Downloads](https://cranlogs.r-pkg.org/badges/grand-total/fred)](https://CRAN.R-project.org/package=fred) [![Lifecycle: stable](https://img.shields.io/badge/lifecycle-stable-brightgreen.svg)](https://lifecycle.r-lib.org/articles/stages.html#stable) [![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)

**fred** provides clean, tidy access to economic data from the [Federal Reserve Economic Data (FRED)](https://fred.stlouisfed.org/) API directly from R.

## What is FRED?

The Federal Reserve Economic Data (FRED) database is maintained by the [Federal Reserve Bank of St. Louis](https://www.stlouisfed.org/) - one of twelve regional Reserve Banks in the US Federal Reserve System. While the Fed's Board of Governors in Washington sets monetary policy, the regional banks each developed their own research specialisms. St. Louis carved out a reputation for applied economic research and data dissemination, and FRED launched in 1991 as a dial-up bulletin board before moving to the web in the mid-1990s. It has since grown into arguably the single most important free data platform for macroeconomic research, now hosting over 800,000 time series covering GDP, employment, inflation, interest rates, trade, financial markets, and more.

What makes FRED unusual is its role as an aggregator. The database doesn't just publish the St. Louis Fed's own data - it pulls in series from 118 different sources, including the Bureau of Labor Statistics, Bureau of Economic Analysis, Census Bureau, Treasury Department, World Bank, and dozens of other US and international agencies. Rather than visiting each agency's website individually and navigating their different data formats, FRED gives you a single, consistent interface to all of them. It's the closest thing economics has to a universal data catalogue.

## The FRED API

FRED provides a [free REST API](https://fred.stlouisfed.org/docs/api/fred/) that gives programmatic access to the full database. The API supports searching for series, fetching observations, browsing the category tree, tracking data releases and revisions, and applying server-side transformations like percent change or frequency aggregation - all without needing to visit the website. Anyone can register for a free API key.

This package wraps the FRED API so you can pull data directly into R with a single function call. Rather than constructing API URLs by hand, `fred_series("GDP")` fetches the data, parses the response, and returns a tidy data frame. You can fetch multiple series at once, apply transformations, search by keyword, browse categories, and track revisions - all from R. Results are cached locally so repeated calls are instant.

## How is this different from fredr?

There is an existing R package called [fredr](https://cran.r-project.org/package=fredr), written by Sam Boysel and Davis Vaughan and published on CRAN in 2021. It's a solid package, but it hasn't been updated since August 2021.

**What's better for users:**

- **Multiple series in one call** - fredr can only fetch one series at a time, so pulling GDP, unemployment, and CPI means three separate requests and manually binding the results. With **fred**, `fred_series(c("GDP", "UNRATE", "CPIAUCSL"))` returns everything in one tidy data frame.
- **Local caching** - fredr downloads data fresh every time you run your script. If you're knitting a Quarto report and tweaking a chart title, it re-downloads everything from scratch on every render. **fred** caches results locally after the first download, so subsequent calls are instant and don't touch the API.
- **Automatic pagination** - FRED's API returns results in pages of 1,000. If a category has 2,500 series, fredr gives you the first 1,000 and stops - most users won't realise they're getting incomplete data. **fred** automatically fetches all pages and stitches them together.

**What's better under the hood:**

- **Modern HTTP stack** - fredr depends on `httr`, which has been superseded by `httr2`. **fred** uses `httr2` with built-in rate-limit retries and graceful error handling when the API is unreachable.
- **Fewer dependencies** - **fred** depends on 3 packages (`httr2`, `cli`, `tools`). fredr pulls in `httr`, `jsonlite`, `rlang`, `tibble`, and `purrr`.
- **Actively maintained** - fredr has had no updates since August 2021.

## Installation

```r
# install.packages("devtools")
devtools::install_github("charlescoverdale/fred")
```

## API key (required)

**You need a free API key to use this package.** The FRED API requires authentication so the St. Louis Fed can manage server load - but the key is completely free and takes about two minutes to set up. You only need to do this once.

### Step 1: Create a FRED account

1. Go to <https://fredaccount.stlouisfed.org/login/secure/>
2. Click **Create New Account**
3. Fill in your name, email, and a password, then click **Create Account**
4. Check your email and click the verification link

### Step 2: Request an API key

1. Once logged in, go to <https://fredaccount.stlouisfed.org/apikeys>
2. Click **Request API Key**
3. Enter a short description (e.g. "R data analysis") and agree to the terms
4. Your API key will appear on screen - it's a string of letters and numbers like `abcdef1234567890abcdef1234567890`
5. Copy it

### Step 3: Save the key so R can find it

The best approach is to store your key in a file called `.Renviron`, which R reads automatically every time it starts. This means you only set it once and never have to think about it again.

**Option A: From RStudio**

1. Open RStudio
2. In the console, type `file.edit("~/.Renviron")` and press Enter - this opens (or creates) the file
3. Add this line, replacing the placeholder with your actual key:
   ```
   FRED_API_KEY=abcdef1234567890abcdef1234567890
   ```
4. Save the file and close it
5. Restart R (Session → Restart R, or press Ctrl+Shift+F10 / Cmd+Shift+F10)

**Option B: From the terminal**

1. Open Terminal (Mac/Linux) or Command Prompt (Windows)
2. Run this command, replacing the placeholder with your actual key:
   ```bash
   echo 'FRED_API_KEY=abcdef1234567890abcdef1234567890' >> ~/.Renviron
   ```
3. Restart R

**Option C: Set it for the current session only**

If you just want to try things out without editing any files, you can set the key temporarily:

```r
library(fred)
fred_set_key("abcdef1234567890abcdef1234567890")
```

This only lasts until you close R - you'll need to run it again next session.

### Verify it works

After restarting R, check that the key is picked up:

```r
library(fred)
fred_get_key()
#> [1] "abcdef1234567890abcdef1234567890"
```

If that prints your key, you're good to go.

## How do I find the series I need?

Every dataset in FRED has a short series ID. For example, `GDP` is US quarterly GDP, `UNRATE` is the US unemployment rate, and `CPIAUCSL` is the Consumer Price Index. You need to know the series ID to pull data.

There are two ways to find it:

**1. Search from R** using `fred_search()`:

```r
fred_search("consumer price index")
#>            id                                          title frequency
#>      CPIAUCSL   Consumer Price Index for All Urban Consumers   Monthly
#>    CPILFESL     CPI Less Food and Energy (Core CPI)          Monthly
#>    CPIENGSL     CPI: Energy                                  Monthly
#>    ...
```

**2. Browse the FRED website** at [fred.stlouisfed.org](https://fred.stlouisfed.org). Search or browse by category, and the series ID is shown at the top of every data page. This is often the easiest way to explore what's available if you're not sure what you're looking for.

Once you have a series ID, pass it to `fred_series()`.

## Examples

### Fetch a single series

```r
library(fred)

# US quarterly GDP
gdp <- fred_series("GDP")
tail(gdp)
#>          date series_id    value
#>   2023-04-01       GDP 27063.01
#>   2023-07-01       GDP 27610.55
#>   ...
```

### Fetch multiple series in one call

```r
# GDP, unemployment, and CPI together
macro <- fred_series(c("GDP", "UNRATE", "CPIAUCSL"))

# Returns a single data frame with a series_id column
table(macro$series_id)
#>  CPIAUCSL       GDP    UNRATE
#>       977       310       953
```

### Growth rates and transformations

FRED can compute transformations server-side, so you don't have to calculate them yourself.

```r
# Year-on-year percent change in GDP
gdp_growth <- fred_series("GDP", units = "pc1")
tail(gdp_growth, 4)
#>          date series_id value
#>   2023-01-01       GDP  3.57
#>   2023-04-01       GDP  4.49
#>   2023-07-01       GDP  5.36
#>   2023-10-01       GDP  5.78

# Other options: "pch" (period-on-period %), "chg" (level change),
# "log" (natural log), "pca" (annualised rate)
```

### Filter by date

```r
# CPI since 2020 only
cpi <- fred_series("CPIAUCSL", from = "2020-01-01")
head(cpi, 4)
#>          date series_id   value
#>   2020-01-01  CPIAUCSL  257.971
#>   2020-02-01  CPIAUCSL  258.678
#>   2020-03-01  CPIAUCSL  258.115
#>   2020-04-01  CPIAUCSL  256.389
```

### Aggregate daily data to a lower frequency

```r
# The 10-year Treasury yield is published daily.
# Aggregate to monthly averages:
rates <- fred_series("DGS10", frequency = "m")
tail(rates, 4)
#>          date series_id value
#>   2024-09-01     DGS10  3.73
#>   2024-10-01     DGS10  4.10
#>   2024-11-01     DGS10  4.34
#>   2024-12-01     DGS10  4.39

# Or get end-of-period values instead of averages:
rates_eop <- fred_series("DGS10", frequency = "m", aggregation = "eop")
```

### Look up what a series actually measures

```r
fred_info("UNRATE")
#>       id                                title frequency units  seasonal_adjustment
#>   UNRATE   Unemployment Rate                   Monthly     %   Seasonally Adjusted
```

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
| [readnoaa](https://github.com/charlescoverdale/readnoaa) | NOAA climate and weather data | On GitHub |
| [inflateR](https://github.com/charlescoverdale/inflateR) | Inflation adjustment | On CRAN |

## Attribution

This product uses the FRED® API but is not endorsed or certified by the Federal Reserve Bank of St. Louis.

## Keywords

FRED, Federal Reserve, economic data, macroeconomic data, time series, US economy, interest rates, inflation, GDP, unemployment, monetary policy, St. Louis Fed, API, R package
