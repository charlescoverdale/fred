# FOMC scheduled meeting dates and decisions

Returns scheduled regular FOMC meeting decision dates from 2017 to 2025,
plus selected unscheduled meetings during stress periods (e.g. March
2020). Each row carries the decision date, meeting type, and a flag for
whether a Summary of Economic Projections (SEP) was released. Useful as
a left table for event-study windows around monetary-policy decisions.

## Usage

``` r
fred_fomc_dates(from = NULL, to = NULL, year = NULL, sep_only = FALSE)
```

## Arguments

- from:

  Optional character or Date. Filter to meetings on or after this date.

- to:

  Optional character or Date. Filter to meetings on or before this date.

- year:

  Optional integer vector. Filter to specific calendar years.

- sep_only:

  Logical. If `TRUE`, return only meetings that released an SEP
  (typically four per year). Default `FALSE`.

## Value

A `fred_tbl` with columns `date`, `type`, `sep`.

## Details

Source: Federal Reserve Board press release calendars
(<https://www.federalreserve.gov/monetarypolicy/fomccalendars.htm>).
Curated and embedded; not auto-synced.

## See also

Other dates:
[`fred_recession_dates()`](https://charlescoverdale.github.io/fred/reference/fred_recession_dates.md)

## Examples

``` r
# All meetings since 2017
fred_fomc_dates()
#> # FRED: fomc_dates · 73 rows
#>          date        type   sep
#> 1  2017-02-01     regular FALSE
#> 2  2017-03-15     regular  TRUE
#> 3  2017-05-03     regular FALSE
#> 4  2017-06-14     regular  TRUE
#> 5  2017-07-26     regular FALSE
#> 6  2017-09-20     regular  TRUE
#> 7  2017-11-01     regular FALSE
#> 8  2017-12-13     regular  TRUE
#> 9  2018-01-31     regular FALSE
#> 10 2018-03-21     regular  TRUE
#> 11 2018-05-02     regular FALSE
#> 12 2018-06-13     regular  TRUE
#> 13 2018-08-01     regular FALSE
#> 14 2018-09-26     regular  TRUE
#> 15 2018-11-08     regular FALSE
#> 16 2018-12-19     regular  TRUE
#> 17 2019-01-30     regular FALSE
#> 18 2019-03-20     regular  TRUE
#> 19 2019-05-01     regular FALSE
#> 20 2019-06-19     regular  TRUE
#> 21 2019-07-31     regular FALSE
#> 22 2019-09-18     regular  TRUE
#> 23 2019-10-30     regular FALSE
#> 24 2019-12-11     regular  TRUE
#> 25 2020-01-29     regular FALSE
#> 26 2020-03-03 unscheduled FALSE
#> 27 2020-03-15 unscheduled FALSE
#> 28 2020-04-29     regular FALSE
#> 29 2020-06-10     regular  TRUE
#> 30 2020-07-29     regular FALSE
#> 31 2020-09-16     regular  TRUE
#> 32 2020-11-05     regular FALSE
#> 33 2020-12-16     regular  TRUE
#> 34 2021-01-27     regular FALSE
#> 35 2021-03-17     regular  TRUE
#> 36 2021-04-28     regular FALSE
#> 37 2021-06-16     regular  TRUE
#> 38 2021-07-28     regular FALSE
#> 39 2021-09-22     regular  TRUE
#> 40 2021-11-03     regular FALSE
#> 41 2021-12-15     regular  TRUE
#> 42 2022-01-26     regular FALSE
#> 43 2022-03-16     regular  TRUE
#> 44 2022-05-04     regular FALSE
#> 45 2022-06-15     regular  TRUE
#> 46 2022-07-27     regular FALSE
#> 47 2022-09-21     regular  TRUE
#> 48 2022-11-02     regular FALSE
#> 49 2022-12-14     regular  TRUE
#> 50 2023-02-01     regular FALSE
#> 51 2023-03-22     regular  TRUE
#> 52 2023-05-03     regular FALSE
#> 53 2023-06-14     regular  TRUE
#> 54 2023-07-26     regular FALSE
#> 55 2023-09-20     regular  TRUE
#> 56 2023-11-01     regular FALSE
#> 57 2023-12-13     regular  TRUE
#> 58 2024-01-31     regular FALSE
#> 59 2024-03-20     regular  TRUE
#> 60 2024-05-01     regular FALSE
#> 61 2024-06-12     regular  TRUE
#> 62 2024-07-31     regular FALSE
#> 63 2024-09-18     regular  TRUE
#> 64 2024-11-07     regular FALSE
#> 65 2024-12-18     regular  TRUE
#> 66 2025-01-29     regular FALSE
#> 67 2025-03-19     regular  TRUE
#> 68 2025-05-07     regular FALSE
#> 69 2025-06-18     regular  TRUE
#> 70 2025-07-30     regular FALSE
#> 71 2025-09-17     regular  TRUE
#> 72 2025-10-29     regular FALSE
#> 73 2025-12-10     regular  TRUE

# 2022 hiking cycle
fred_fomc_dates(year = 2022)
#> # FRED: fomc_dates · 8 rows
#>         date    type   sep
#> 1 2022-01-26 regular FALSE
#> 2 2022-03-16 regular  TRUE
#> 3 2022-05-04 regular FALSE
#> 4 2022-06-15 regular  TRUE
#> 5 2022-07-27 regular FALSE
#> 6 2022-09-21 regular  TRUE
#> 7 2022-11-02 regular FALSE
#> 8 2022-12-14 regular  TRUE

# SEP meetings only (Mar/Jun/Sep/Dec)
fred_fomc_dates(year = 2024, sep_only = TRUE)
#> # FRED: fomc_dates · 4 rows
#>         date    type  sep
#> 1 2024-03-20 regular TRUE
#> 2 2024-06-12 regular TRUE
#> 3 2024-09-18 regular TRUE
#> 4 2024-12-18 regular TRUE
```
