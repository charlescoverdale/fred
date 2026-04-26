# Multi-series macro panels: fetch, transform, widen, plot

This vignette walks through the most common starting workflow with
`fred`: fetching several series in one call, applying a server-side
transformation, pivoting to wide format for cross-series analysis, and
producing a default plot with recession shading.

The chunks below require an API key (set via
[`fred_set_key()`](https://charlescoverdale.github.io/fred/reference/fred_set_key.md)
or the `FRED_API_KEY` environment variable). If no key is set, code is
shown but not executed.

## Setup

``` r
library(fred)
```

## A core macro panel

A typical first move is to grab GDP, unemployment, and headline CPI
together, on a long format that is easy to iterate over.

``` r
panel <- fred_series(
  c("GDPC1", "UNRATE", "CPIAUCSL"),
  from = "2000-01-01"
)
panel
```

The print header tells you immediately what you are looking at: three
series, how many rows, which transformation was applied, the frequency,
and any vintage information. Underneath, `panel` is a plain data frame.

## Transformations

For inflation and growth analyses, raw levels are usually less useful
than year-on-year percent change. Pass a readable `transform` rather
than the raw FRED `units` code:

``` r
growth_panel <- fred_series(
  c("GDPC1", "CPIAUCSL"),
  from = "2010-01-01",
  transform = "yoy_pct"
)
growth_panel
```

`transform` and `units` are mutually exclusive. The full list of
readable aliases lives in
[`?fred_series`](https://charlescoverdale.github.io/fred/reference/fred_series.md).
Server-side transforms avoid a manual `diff(log(x))` step and ensure the
result matches what FRED itself shows.

## Wide format for cross-series work

For correlation matrices, scatter plots, or regression input, wide is
more convenient than long.

``` r
wide <- fred_series(
  c("UNRATE", "CIVPART", "EMRATIO"),
  from = "2000-01-01",
  format = "wide"
)
head(wide)
```

## Default plot

The default
[`plot.fred_tbl()`](https://charlescoverdale.github.io/fred/reference/plot.fred_tbl.md)
method handles long and wide format automatically and shades NBER
recessions when the date range overlaps one.

``` r
plot(growth_panel, ylab = "% YoY")
```

``` r
plot(wide, ylab = "%", main = "US labour market")
```

Pass `recessions = FALSE` to switch off shading. Pass a `col =` vector
of length equal to the number of series to override the default palette.

## A starting catalogue

If you cannot remember a series ID,
[`fred_catalogue()`](https://charlescoverdale.github.io/fred/reference/fred_catalogue.md)
ships a curated offline reference of around 50 widely used series:

``` r
fred_catalogue(category = "Inflation")
#> # FRED: catalogue · 6 rows
#>         id                                                     title frequency
#> 1 CPIAUCSL                    CPI for All Urban Consumers: All Items         M
#> 2 CPILFESL         CPI for All Urban Consumers: Less Food and Energy         M
#> 3    PCEPI Personal Consumption Expenditures: Chain-type Price Index         M
#> 4 PCEPILFE     PCE Excluding Food and Energy: Chain-type Price Index         M
#> 5   PPIACO        Producer Price Index by Commodity: All Commodities         M
#> 6   T10YIE                          10-Year Breakeven Inflation Rate         D
#>               units  category                               description
#> 1 Index 1982-84=100 Inflation     BLS headline CPI, seasonally adjusted
#> 2 Index 1982-84=100 Inflation                              BLS core CPI
#> 3    Index 2017=100 Inflation                 BEA headline PCE deflator
#> 4    Index 2017=100 Inflation        BEA core PCE deflator (Fed target)
#> 5    Index 1982=100 Inflation                   BLS PPI all commodities
#> 6           Percent Inflation Market-implied 10y inflation expectations
```

Filtering with `query =` does a case-insensitive substring match against
the ID, title, and description:

``` r
fred_catalogue(query = "mortgage")
#> # FRED: catalogue · 1 row
#>             id                               title frequency   units
#> 1 MORTGAGE30US 30-Year Fixed Rate Mortgage Average         W Percent
#>         category                        description
#> 1 Interest Rates Freddie Mac PMMS 30y mortgage rate
```

For the FRED category tree, use
[`fred_browse()`](https://charlescoverdale.github.io/fred/reference/fred_browse.md).
With no arguments it shows the eight top-level categories from a static
reference (no API call):

``` r
fred_browse()
#> FRED top-level categories
#> -------------------------
#>    32991  Money, Banking, & Finance
#>       10  Population, Employment, & Labor Markets
#>    32992  National Accounts
#>        1  Production & Business Activity
#>    32455  Prices
#>    32263  International Data
#>     3008  U.S. Regional Data
#>    33060  Academic Data
#> 
#> Use fred_browse(id) to drill into a category.
```

Pass a category ID to drill into its children (this hits the API and is
cached).

## Where to next

- **Real-time and vintages:** see
  [`vignette("nowcasting-with-fred")`](https://charlescoverdale.github.io/fred/articles/nowcasting-with-fred.md)
  for a pseudo-real-time GDP nowcasting backtest.
- **Inflation revisions:** see
  [`vignette("inflation-revisions")`](https://charlescoverdale.github.io/fred/articles/inflation-revisions.md)
  for tracking how core inflation estimates change with revisions.
- **Reproducibility:** combine
  [`fred_cite_series()`](https://charlescoverdale.github.io/fred/reference/fred_cite_series.md)
  and
  [`fred_manifest()`](https://charlescoverdale.github.io/fred/reference/fred_manifest.md)
  to pin every series your analysis depends on.
