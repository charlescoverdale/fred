# NBER US business-cycle reference dates

Returns the NBER Business Cycle Dating Committee's reference dates for
US business-cycle peaks and troughs since 1857. With `flag = NULL`
(default), returns one row per recession (peak, trough, duration). Pass
a vector of observation dates as `flag` to get back a data frame
indicating whether each observation falls within a recession.

## Usage

``` r
fred_recession_dates(from = NULL, to = NULL, flag = NULL)
```

## Arguments

- from:

  Optional character or Date. Filter to recessions whose peak is on or
  after this date.

- to:

  Optional character or Date. Filter to recessions whose trough is on or
  before this date.

- flag:

  Optional Date vector. If supplied, returns a data frame
  `data.frame(date, in_recession)` indicating whether each date falls
  within an NBER recession. Useful as a regression covariate or for
  plotting.

## Value

A `fred_tbl`. Default columns: `peak`, `trough`, `duration_months`. With
`flag`: `date`, `in_recession`.

## Details

Source: NBER Business Cycle Dating Committee
(<https://www.nber.org/research/data/us-business-cycle-expansions-and-contractions>).
Dates are ISO month-start (peak = first month of recession, trough =
last month of recession).

## See also

Other dates:
[`fred_fomc_dates()`](https://charlescoverdale.github.io/fred/reference/fred_fomc_dates.md)

## Examples

``` r
# All recessions since 1857
fred_recession_dates()
#> # FRED: recession_dates · 34 rows
#>          peak     trough duration_months
#> 1  1857-06-01 1858-12-01              19
#> 2  1860-10-01 1861-06-01               9
#> 3  1865-04-01 1867-12-01              33
#> 4  1869-06-01 1870-12-01              19
#> 5  1873-10-01 1879-03-01              66
#> 6  1882-03-01 1885-05-01              39
#> 7  1887-03-01 1888-04-01              14
#> 8  1890-07-01 1891-05-01              11
#> 9  1893-01-01 1894-06-01              18
#> 10 1895-12-01 1897-06-01              19
#> 11 1899-06-01 1900-12-01              19
#> 12 1902-09-01 1904-08-01              24
#> 13 1907-05-01 1908-06-01              14
#> 14 1910-01-01 1912-01-01              25
#> 15 1913-01-01 1914-12-01              24
#> 16 1918-08-01 1919-03-01               8
#> 17 1920-01-01 1921-07-01              19
#> 18 1923-05-01 1924-07-01              15
#> 19 1926-10-01 1927-11-01              14
#> 20 1929-08-01 1933-03-01              44
#> 21 1937-05-01 1938-06-01              14
#> 22 1945-02-01 1945-10-01               9
#> 23 1948-11-01 1949-10-01              12
#> 24 1953-07-01 1954-05-01              11
#> 25 1957-08-01 1958-04-01               9
#> 26 1960-04-01 1961-02-01              11
#> 27 1969-12-01 1970-11-01              12
#> 28 1973-11-01 1975-03-01              17
#> 29 1980-01-01 1980-07-01               7
#> 30 1981-07-01 1982-11-01              17
#> 31 1990-07-01 1991-03-01               9
#> 32 2001-03-01 2001-11-01               9
#> 33 2007-12-01 2009-06-01              19
#> 34 2020-02-01 2020-04-01               3

# Modern era only
fred_recession_dates(from = "1948-01-01")
#> # FRED: recession_dates · 12 rows
#>          peak     trough duration_months
#> 1  1948-11-01 1949-10-01              12
#> 2  1953-07-01 1954-05-01              11
#> 3  1957-08-01 1958-04-01               9
#> 4  1960-04-01 1961-02-01              11
#> 5  1969-12-01 1970-11-01              12
#> 6  1973-11-01 1975-03-01              17
#> 7  1980-01-01 1980-07-01               7
#> 8  1981-07-01 1982-11-01              17
#> 9  1990-07-01 1991-03-01               9
#> 10 2001-03-01 2001-11-01               9
#> 11 2007-12-01 2009-06-01              19
#> 12 2020-02-01 2020-04-01               3

# Flag a vector of dates
fred_recession_dates(flag = seq(as.Date("2007-01-01"), as.Date("2010-12-01"),
                                by = "month"))
#> # FRED: recession_dates · 48 rows
#>          date in_recession
#> 1  2007-01-01        FALSE
#> 2  2007-02-01        FALSE
#> 3  2007-03-01        FALSE
#> 4  2007-04-01        FALSE
#> 5  2007-05-01        FALSE
#> 6  2007-06-01        FALSE
#> 7  2007-07-01        FALSE
#> 8  2007-08-01        FALSE
#> 9  2007-09-01        FALSE
#> 10 2007-10-01        FALSE
#> 11 2007-11-01        FALSE
#> 12 2007-12-01         TRUE
#> 13 2008-01-01         TRUE
#> 14 2008-02-01         TRUE
#> 15 2008-03-01         TRUE
#> 16 2008-04-01         TRUE
#> 17 2008-05-01         TRUE
#> 18 2008-06-01         TRUE
#> 19 2008-07-01         TRUE
#> 20 2008-08-01         TRUE
#> 21 2008-09-01         TRUE
#> 22 2008-10-01         TRUE
#> 23 2008-11-01         TRUE
#> 24 2008-12-01         TRUE
#> 25 2009-01-01         TRUE
#> 26 2009-02-01         TRUE
#> 27 2009-03-01         TRUE
#> 28 2009-04-01         TRUE
#> 29 2009-05-01         TRUE
#> 30 2009-06-01         TRUE
#> 31 2009-07-01        FALSE
#> 32 2009-08-01        FALSE
#> 33 2009-09-01        FALSE
#> 34 2009-10-01        FALSE
#> 35 2009-11-01        FALSE
#> 36 2009-12-01        FALSE
#> 37 2010-01-01        FALSE
#> 38 2010-02-01        FALSE
#> 39 2010-03-01        FALSE
#> 40 2010-04-01        FALSE
#> 41 2010-05-01        FALSE
#> 42 2010-06-01        FALSE
#> 43 2010-07-01        FALSE
#> 44 2010-08-01        FALSE
#> 45 2010-09-01        FALSE
#> 46 2010-10-01        FALSE
#> 47 2010-11-01        FALSE
#> 48 2010-12-01        FALSE
```
