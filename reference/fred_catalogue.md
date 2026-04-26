# Browse a curated catalogue of popular FRED series

Returns a data frame of around 50 of the most widely used FRED series
organised by economic category. The catalogue is curated and embedded in
the package: no API call is made. Use it as a starting point for common
workflows or as a quick reference when you cannot remember a series ID.

## Usage

``` r
fred_catalogue(category = NULL, query = NULL)
```

## Arguments

- category:

  Character. Optional category filter. One of `"GDP & Output"`,
  `"Employment"`, `"Inflation"`, `"Interest Rates"`, `"Housing"`,
  `"Financial"`, `"Money & Credit"`, `"Trade & FX"`, `"Consumer"`,
  `"Government & Fiscal"`. Multiple categories may be passed.

- query:

  Character. Optional free-text filter (e.g. `"unemployment"`,
  `"mortgage"`).

## Value

A `fred_tbl` (a `data.frame` subclass) with columns `id`, `title`,
`frequency`, `units`, `category`, `description`.

## Details

Filter by category, by free-text query, or both. Free-text matches
against the series ID, title, and description (case-insensitive
substring match).

## See also

Other catalogue:
[`fred_browse()`](https://charlescoverdale.github.io/fred/reference/fred_browse.md)

## Examples

``` r
# Full catalogue
fred_catalogue()
#> # FRED: catalogue · 51 rows
#>               id                                                     title
#> 1            GDP                                    Gross Domestic Product
#> 2          GDPC1                               Real Gross Domestic Product
#> 3         GDPPOT                     Real Potential Gross Domestic Product
#> 4         GDPDEF                               GDP Implicit Price Deflator
#> 5         INDPRO                        Industrial Production: Total Index
#> 6         CUMFNS                       Capacity Utilization: Manufacturing
#> 7         UNRATE                                         Unemployment Rate
#> 8         PAYEMS                                    Total Nonfarm Payrolls
#> 9        CIVPART                            Labor Force Participation Rate
#> 10       EMRATIO                               Employment-Population Ratio
#> 11          ICSA                                            Initial Claims
#> 12        JTSJOL                               Job Openings: Total Nonfarm
#> 13        AHETPI             Average Hourly Earnings of Production Workers
#> 14      CPIAUCSL                    CPI for All Urban Consumers: All Items
#> 15      CPILFESL         CPI for All Urban Consumers: Less Food and Energy
#> 16         PCEPI Personal Consumption Expenditures: Chain-type Price Index
#> 17      PCEPILFE     PCE Excluding Food and Energy: Chain-type Price Index
#> 18        PPIACO        Producer Price Index by Commodity: All Commodities
#> 19        T10YIE                          10-Year Breakeven Inflation Rate
#> 20      FEDFUNDS                              Effective Federal Funds Rate
#> 21           DFF                              Federal Funds Effective Rate
#> 22          DGS2                           Market Yield on 2-Year Treasury
#> 23         DGS10                          Market Yield on 10-Year Treasury
#> 24         DGS30                          Market Yield on 30-Year Treasury
#> 25        T10Y2Y           10-Year Treasury Constant Maturity Minus 2-Year
#> 26  MORTGAGE30US                       30-Year Fixed Rate Mortgage Average
#> 27     CSUSHPISA      S&P CoreLogic Case-Shiller National Home Price Index
#> 28         HOUST                 Housing Starts: Total New Privately Owned
#> 29        PERMIT              New Privately Owned Housing Units Authorized
#> 30 EXHOSLUSM495S                                       Existing Home Sales
#> 31         SP500                                                   S&P 500
#> 32        VIXCLS                                CBOE Volatility Index: VIX
#> 33     NASDAQCOM                                    NASDAQ Composite Index
#> 34          NFCI           Chicago Fed National Financial Conditions Index
#> 35       STLFSI4                      St. Louis Fed Financial Stress Index
#> 36          M2SL                                                        M2
#> 37       TOTALSL               Total Consumer Credit Owned and Securitized
#> 38      BUSLOANS     Commercial and Industrial Loans, All Commercial Banks
#> 39       BOPGSTB                         Trade Balance: Goods and Services
#> 40       DEXUSEU                   U.S. Dollars to Euro Spot Exchange Rate
#> 41       DEXUSUK             U.S. Dollars to U.K. Pound Spot Exchange Rate
#> 42      DTWEXBGS                           Nominal Broad U.S. Dollar Index
#> 43    DCOILWTICO                 Crude Oil Prices: West Texas Intermediate
#> 44           PCE                         Personal Consumption Expenditures
#> 45         RSAFS            Advance Retail Sales: Retail and Food Services
#> 46       UMCSENT                University of Michigan: Consumer Sentiment
#> 47            PI                                           Personal Income
#> 48       GFDEBTN                           Federal Debt: Total Public Debt
#> 49   GFDEGDQ188S               Federal Debt: Total Public Debt as % of GDP
#> 50   FYFSGDA188S                    Federal Surplus or Deficit as % of GDP
#> 51        DGS3MO                   3-Month Treasury Constant Maturity Rate
#>    frequency              units            category
#> 1          Q          Bil. of $        GDP & Output
#> 2          Q     Bil. chained $        GDP & Output
#> 3          Q     Bil. chained $        GDP & Output
#> 4          Q     Index 2017=100        GDP & Output
#> 5          M     Index 2017=100        GDP & Output
#> 6          M            Percent        GDP & Output
#> 7          M            Percent          Employment
#> 8          M          Thousands          Employment
#> 9          M            Percent          Employment
#> 10         M            Percent          Employment
#> 11         W             Number          Employment
#> 12         M          Thousands          Employment
#> 13         M         Dollars/hr          Employment
#> 14         M  Index 1982-84=100           Inflation
#> 15         M  Index 1982-84=100           Inflation
#> 16         M     Index 2017=100           Inflation
#> 17         M     Index 2017=100           Inflation
#> 18         M     Index 1982=100           Inflation
#> 19         D            Percent           Inflation
#> 20         M            Percent      Interest Rates
#> 21         D            Percent      Interest Rates
#> 22         D            Percent      Interest Rates
#> 23         D            Percent      Interest Rates
#> 24         D            Percent      Interest Rates
#> 25         D            Percent      Interest Rates
#> 26         W            Percent      Interest Rates
#> 27         M Index Jan 2000=100             Housing
#> 28         M          Thousands             Housing
#> 29         M          Thousands             Housing
#> 30         M             Number             Housing
#> 31         D              Index           Financial
#> 32         D              Index           Financial
#> 33         D              Index           Financial
#> 34         W              Index           Financial
#> 35         W              Index           Financial
#> 36         M          Bil. of $      Money & Credit
#> 37         M          Bil. of $      Money & Credit
#> 38         M          Bil. of $      Money & Credit
#> 39         M          Mil. of $          Trade & FX
#> 40         D        USD per EUR          Trade & FX
#> 41         D        USD per GBP          Trade & FX
#> 42         D Index Jan 2006=100          Trade & FX
#> 43         D     USD per barrel          Trade & FX
#> 44         M          Bil. of $            Consumer
#> 45         M          Mil. of $            Consumer
#> 46         M     Index 1966=100            Consumer
#> 47         M          Bil. of $            Consumer
#> 48         Q          Mil. of $ Government & Fiscal
#> 49         Q            Percent Government & Fiscal
#> 50         A            Percent Government & Fiscal
#> 51         D            Percent      Interest Rates
#>                                       description
#> 1                  Headline nominal GDP, BEA NIPA
#> 2                  Real GDP, chained 2017 dollars
#> 3                CBO estimate of potential output
#> 4               Broad inflation measure from NIPA
#> 5           Federal Reserve industrial production
#> 6            Federal Reserve capacity utilisation
#> 7              BLS headline U-3 unemployment rate
#> 8                        BLS Establishment Survey
#> 9                  BLS labour force participation
#> 10             BLS employment to population ratio
#> 11   Weekly initial unemployment insurance claims
#> 12                             JOLTS job openings
#> 13        BLS production and nonsupervisory wages
#> 14          BLS headline CPI, seasonally adjusted
#> 15                                   BLS core CPI
#> 16                      BEA headline PCE deflator
#> 17             BEA core PCE deflator (Fed target)
#> 18                        BLS PPI all commodities
#> 19      Market-implied 10y inflation expectations
#> 20       Monthly average effective fed funds rate
#> 21                 Daily effective fed funds rate
#> 22            Constant-maturity 2y Treasury yield
#> 23           Constant-maturity 10y Treasury yield
#> 24           Constant-maturity 30y Treasury yield
#> 25 Yield-curve slope, classic recession indicator
#> 26             Freddie Mac PMMS 30y mortgage rate
#> 27                     National house price index
#> 28                          Census housing starts
#> 29                        Census building permits
#> 30                        NAR existing home sales
#> 31                          S&P 500 closing price
#> 32          Implied volatility on S&P 500 options
#> 33                           NASDAQ closing price
#> 34          Broad financial conditions, zero-mean
#> 35          Composite financial stress, zero-mean
#> 36                              Broad money stock
#> 37                     G.19 consumer credit total
#> 38                               C&I bank lending
#> 39                      BEA monthly trade balance
#> 40                      Daily noon-buying USD/EUR
#> 41                      Daily noon-buying USD/GBP
#> 42       Federal Reserve broad trade-weighted USD
#> 43                                 WTI spot price
#> 44                           Headline nominal PCE
#> 45           Census retail sales advance estimate
#> 46           Michigan consumer sentiment headline
#> 47                            BEA personal income
#> 48         Treasury total public debt outstanding
#> 49                              Debt-to-GDP ratio
#> 50             Annual fiscal balance share of GDP
#> 51       Constant-maturity 3-month Treasury yield

# Inflation series only
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

# Free-text search
fred_catalogue(query = "mortgage")
#> # FRED: catalogue · 1 row
#>             id                               title frequency   units
#> 1 MORTGAGE30US 30-Year Fixed Rate Mortgage Average         W Percent
#>         category                        description
#> 1 Interest Rates Freddie Mac PMMS 30y mortgage rate

# Combined
fred_catalogue(category = "Interest Rates", query = "treasury")
#> # FRED: catalogue · 5 rows
#>       id                                           title frequency   units
#> 1   DGS2                 Market Yield on 2-Year Treasury         D Percent
#> 2  DGS10                Market Yield on 10-Year Treasury         D Percent
#> 3  DGS30                Market Yield on 30-Year Treasury         D Percent
#> 4 T10Y2Y 10-Year Treasury Constant Maturity Minus 2-Year         D Percent
#> 5 DGS3MO         3-Month Treasury Constant Maturity Rate         D Percent
#>         category                                    description
#> 1 Interest Rates            Constant-maturity 2y Treasury yield
#> 2 Interest Rates           Constant-maturity 10y Treasury yield
#> 3 Interest Rates           Constant-maturity 30y Treasury yield
#> 4 Interest Rates Yield-curve slope, classic recession indicator
#> 5 Interest Rates       Constant-maturity 3-month Treasury yield
```
