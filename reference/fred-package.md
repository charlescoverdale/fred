# fred: Access 'Federal Reserve Economic Data'

Provides clean, tidy access to economic data from the 'Federal Reserve
Economic Data' ('FRED') API
<https://fred.stlouisfed.org/docs/api/fred/>. 'FRED' is maintained by
the 'Federal Reserve Bank of St. Louis' and contains over 800,000 time
series from 118 sources covering GDP, employment, inflation, interest
rates, trade, and more. Dedicated functions fetch series observations,
search for series, browse categories, releases, and tags, and retrieve
series metadata. Multiple series can be fetched in a single call, in
long or wide format. Server-side unit transformations (percent change,
log, etc.) and frequency aggregation are supported, with readable
transform aliases such as 'yoy_pct' and 'log_diff'. Real-time and
vintage helpers (built on 'ALFRED') return a series as it appeared on a
given date, the first-release version, every revision, or a panel of
selected vintages. Data is cached locally for subsequent calls. This
product uses the 'FRED' API but is not endorsed or certified by the
'Federal Reserve Bank of St. Louis'.

## See also

Useful links:

- <https://charlescoverdale.github.io/fred/>

- <https://github.com/charlescoverdale/fred>

- Report bugs at <https://github.com/charlescoverdale/fred/issues>

## Author

**Maintainer**: Charles Coverdale <charlesfcoverdale@gmail.com>
