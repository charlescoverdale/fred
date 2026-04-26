# Static reference dates: NBER recessions and FOMC meetings.
#
# These return curated reference data without an API call. Useful for event
# studies, recession shading on plots, and aligning macro analysis to known
# policy dates.


#' NBER US business-cycle reference dates
#'
#' Returns the NBER Business Cycle Dating Committee's reference dates for US
#' business-cycle peaks and troughs since 1857. With `flag = NULL` (default),
#' returns one row per recession (peak, trough, duration). Pass a vector of
#' observation dates as `flag` to get back a data frame indicating whether
#' each observation falls within a recession.
#'
#' Source: NBER Business Cycle Dating Committee
#' (\url{https://www.nber.org/research/data/us-business-cycle-expansions-and-contractions}).
#' Dates are ISO month-start (peak = first month of recession, trough =
#' last month of recession).
#'
#' @param from Optional character or Date. Filter to recessions whose peak
#'   is on or after this date.
#' @param to Optional character or Date. Filter to recessions whose trough
#'   is on or before this date.
#' @param flag Optional Date vector. If supplied, returns a data frame
#'   `data.frame(date, in_recession)` indicating whether each date falls
#'   within an NBER recession. Useful as a regression covariate or for
#'   plotting.
#'
#' @return A `fred_tbl`. Default columns: `peak`, `trough`, `duration_months`.
#'   With `flag`: `date`, `in_recession`.
#'
#' @family dates
#' @export
#' @examples
#' # All recessions since 1857
#' fred_recession_dates()
#'
#' # Modern era only
#' fred_recession_dates(from = "1948-01-01")
#'
#' # Flag a vector of dates
#' fred_recession_dates(flag = seq(as.Date("2007-01-01"), as.Date("2010-12-01"),
#'                                 by = "month"))
fred_recession_dates <- function(from = NULL, to = NULL, flag = NULL) {
  rec <- .fred_nber_recessions()

  if (!is.null(from)) {
    from <- as.Date(from)
    rec <- rec[rec$peak >= from, , drop = FALSE]
  }
  if (!is.null(to)) {
    to <- as.Date(to)
    rec <- rec[rec$trough <= to, , drop = FALSE]
  }

  if (!is.null(flag)) {
    flag <- as.Date(flag)
    in_rec <- vapply(flag, function(d) {
      any(d >= rec$peak & d <= rec$trough)
    }, logical(1L))
    out <- data.frame(date = flag, in_recession = in_rec,
                      stringsAsFactors = FALSE)
    return(new_fred_tbl(out, query = list(
      endpoint = "recession_dates", flag = TRUE, n = nrow(out)
    )))
  }

  rec$duration_months <- as.integer(
    round(as.numeric(rec$trough - rec$peak) / 30.4375) + 1L
  )
  rownames(rec) <- NULL
  new_fred_tbl(rec, query = list(
    endpoint = "recession_dates", n = nrow(rec)
  ))
}


#' FOMC scheduled meeting dates and decisions
#'
#' Returns scheduled regular FOMC meeting decision dates from 2017 to 2025,
#' plus selected unscheduled meetings during stress periods (e.g. March 2020).
#' Each row carries the decision date, meeting type, and a flag for whether
#' a Summary of Economic Projections (SEP) was released. Useful as a left
#' table for event-study windows around monetary-policy decisions.
#'
#' Source: Federal Reserve Board press release calendars
#' (\url{https://www.federalreserve.gov/monetarypolicy/fomccalendars.htm}).
#' Curated and embedded; not auto-synced.
#'
#' @param from Optional character or Date. Filter to meetings on or after
#'   this date.
#' @param to Optional character or Date. Filter to meetings on or before
#'   this date.
#' @param year Optional integer vector. Filter to specific calendar years.
#' @param sep_only Logical. If `TRUE`, return only meetings that released
#'   an SEP (typically four per year). Default `FALSE`.
#'
#' @return A `fred_tbl` with columns `date`, `type`, `sep`.
#'
#' @family dates
#' @export
#' @examples
#' # All meetings since 2017
#' fred_fomc_dates()
#'
#' # 2022 hiking cycle
#' fred_fomc_dates(year = 2022)
#'
#' # SEP meetings only (Mar/Jun/Sep/Dec)
#' fred_fomc_dates(year = 2024, sep_only = TRUE)
fred_fomc_dates <- function(from = NULL, to = NULL, year = NULL,
                            sep_only = FALSE) {
  meetings <- .fred_fomc_meetings()

  if (!is.null(from)) {
    meetings <- meetings[meetings$date >= as.Date(from), , drop = FALSE]
  }
  if (!is.null(to)) {
    meetings <- meetings[meetings$date <= as.Date(to), , drop = FALSE]
  }
  if (!is.null(year)) {
    yr <- as.integer(format(meetings$date, "%Y"))
    meetings <- meetings[yr %in% as.integer(year), , drop = FALSE]
  }
  if (isTRUE(sep_only)) {
    meetings <- meetings[meetings$sep, , drop = FALSE]
  }

  rownames(meetings) <- NULL
  new_fred_tbl(meetings, query = list(
    endpoint = "fomc_dates", n = nrow(meetings)
  ))
}


#' NBER recession reference data
#'
#' US business-cycle peaks and troughs since 1857. Source: NBER Business
#' Cycle Dating Committee.
#' @noRd
.fred_nber_recessions <- function() {
  data.frame(
    peak = as.Date(c(
      "1857-06-01","1860-10-01","1865-04-01","1869-06-01","1873-10-01",
      "1882-03-01","1887-03-01","1890-07-01","1893-01-01","1895-12-01",
      "1899-06-01","1902-09-01","1907-05-01","1910-01-01","1913-01-01",
      "1918-08-01","1920-01-01","1923-05-01","1926-10-01","1929-08-01",
      "1937-05-01","1945-02-01","1948-11-01","1953-07-01","1957-08-01",
      "1960-04-01","1969-12-01","1973-11-01","1980-01-01","1981-07-01",
      "1990-07-01","2001-03-01","2007-12-01","2020-02-01"
    )),
    trough = as.Date(c(
      "1858-12-01","1861-06-01","1867-12-01","1870-12-01","1879-03-01",
      "1885-05-01","1888-04-01","1891-05-01","1894-06-01","1897-06-01",
      "1900-12-01","1904-08-01","1908-06-01","1912-01-01","1914-12-01",
      "1919-03-01","1921-07-01","1924-07-01","1927-11-01","1933-03-01",
      "1938-06-01","1945-10-01","1949-10-01","1954-05-01","1958-04-01",
      "1961-02-01","1970-11-01","1975-03-01","1980-07-01","1982-11-01",
      "1991-03-01","2001-11-01","2009-06-01","2020-04-01"
    )),
    stringsAsFactors = FALSE
  )
}


#' FOMC scheduled meeting reference data
#'
#' Decision dates for FOMC scheduled meetings, plus selected unscheduled
#' interventions during stress periods. `sep` flags meetings that released
#' a Summary of Economic Projections.
#' @noRd
.fred_fomc_meetings <- function() {
  raw <- list(
    # 2017
    list("2017-02-01", "regular", FALSE), list("2017-03-15", "regular", TRUE),
    list("2017-05-03", "regular", FALSE), list("2017-06-14", "regular", TRUE),
    list("2017-07-26", "regular", FALSE), list("2017-09-20", "regular", TRUE),
    list("2017-11-01", "regular", FALSE), list("2017-12-13", "regular", TRUE),
    # 2018
    list("2018-01-31", "regular", FALSE), list("2018-03-21", "regular", TRUE),
    list("2018-05-02", "regular", FALSE), list("2018-06-13", "regular", TRUE),
    list("2018-08-01", "regular", FALSE), list("2018-09-26", "regular", TRUE),
    list("2018-11-08", "regular", FALSE), list("2018-12-19", "regular", TRUE),
    # 2019
    list("2019-01-30", "regular", FALSE), list("2019-03-20", "regular", TRUE),
    list("2019-05-01", "regular", FALSE), list("2019-06-19", "regular", TRUE),
    list("2019-07-31", "regular", FALSE), list("2019-09-18", "regular", TRUE),
    list("2019-10-30", "regular", FALSE), list("2019-12-11", "regular", TRUE),
    # 2020
    list("2020-01-29", "regular", FALSE),
    list("2020-03-03", "unscheduled", FALSE),
    list("2020-03-15", "unscheduled", FALSE),
    list("2020-04-29", "regular", FALSE), list("2020-06-10", "regular", TRUE),
    list("2020-07-29", "regular", FALSE), list("2020-09-16", "regular", TRUE),
    list("2020-11-05", "regular", FALSE), list("2020-12-16", "regular", TRUE),
    # 2021
    list("2021-01-27", "regular", FALSE), list("2021-03-17", "regular", TRUE),
    list("2021-04-28", "regular", FALSE), list("2021-06-16", "regular", TRUE),
    list("2021-07-28", "regular", FALSE), list("2021-09-22", "regular", TRUE),
    list("2021-11-03", "regular", FALSE), list("2021-12-15", "regular", TRUE),
    # 2022
    list("2022-01-26", "regular", FALSE), list("2022-03-16", "regular", TRUE),
    list("2022-05-04", "regular", FALSE), list("2022-06-15", "regular", TRUE),
    list("2022-07-27", "regular", FALSE), list("2022-09-21", "regular", TRUE),
    list("2022-11-02", "regular", FALSE), list("2022-12-14", "regular", TRUE),
    # 2023
    list("2023-02-01", "regular", FALSE), list("2023-03-22", "regular", TRUE),
    list("2023-05-03", "regular", FALSE), list("2023-06-14", "regular", TRUE),
    list("2023-07-26", "regular", FALSE), list("2023-09-20", "regular", TRUE),
    list("2023-11-01", "regular", FALSE), list("2023-12-13", "regular", TRUE),
    # 2024
    list("2024-01-31", "regular", FALSE), list("2024-03-20", "regular", TRUE),
    list("2024-05-01", "regular", FALSE), list("2024-06-12", "regular", TRUE),
    list("2024-07-31", "regular", FALSE), list("2024-09-18", "regular", TRUE),
    list("2024-11-07", "regular", FALSE), list("2024-12-18", "regular", TRUE),
    # 2025
    list("2025-01-29", "regular", FALSE), list("2025-03-19", "regular", TRUE),
    list("2025-05-07", "regular", FALSE), list("2025-06-18", "regular", TRUE),
    list("2025-07-30", "regular", FALSE), list("2025-09-17", "regular", TRUE),
    list("2025-10-29", "regular", FALSE), list("2025-12-10", "regular", TRUE)
  )

  data.frame(
    date = as.Date(vapply(raw, `[[`, character(1L), 1L)),
    type = vapply(raw, `[[`, character(1L), 2L),
    sep  = vapply(raw, `[[`, logical(1L), 3L),
    stringsAsFactors = FALSE
  )
}
