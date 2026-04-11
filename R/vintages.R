# Real-time and vintage data helpers.
#
# These functions expose ALFRED-style vintage capabilities by passing
# realtime_start, realtime_end, output_type, and vintage_dates parameters
# through the existing observations endpoint. The shared worker
# `fred_obs_one()` handles caching and adds realtime columns when needed.


#' Fetch a series as it appeared on a given vintage date
#'
#' Returns the values that were available in FRED on `date`, before any
#' subsequent revisions. This is the standard real-time data access pattern:
#' set `realtime_start = realtime_end = date`. Useful for backtesting
#' forecasting models against the data that was actually available at the
#' time, not the revised series we see today.
#'
#' Underneath, this calls the `series/observations` endpoint with the
#' realtime parameters set. Results are cached separately from the
#' default (latest-vintage) cache, so calling `fred_series("GDP")` and
#' `fred_as_of("GDP", "2020-01-15")` keep distinct cache entries.
#'
#' @param series_id Character. One or more FRED series IDs.
#' @param date Character or Date. The vintage date (`"YYYY-MM-DD"`).
#' @param from,to Optional observation date range.
#' @param units Character. Raw FRED units code. Default `"lin"`.
#' @param frequency,aggregation Optional frequency aggregation arguments
#'   (see [fred_series()]).
#' @param cache Logical. Cache results locally. Default `TRUE`.
#'
#' @return A `fred_tbl` with columns `date`, `series_id`, `value`,
#'   `realtime_start`, `realtime_end`.
#'
#' @family vintages
#' @export
#' @examples
#' \donttest{
#' op <- options(fred.cache_dir = tempdir())
#' # GDP as it looked on 1 March 2020
#' gdp_2020 <- fred_as_of("GDP", "2020-03-01")
#' options(op)
#' }
fred_as_of <- function(series_id, date, from = NULL, to = NULL,
                       units = "lin", frequency = NULL, aggregation = "avg",
                       cache = TRUE) {
  if (!is.character(series_id) || length(series_id) == 0L) {
    cli::cli_abort("{.arg series_id} must be a non-empty character vector.")
  }
  if (length(date) != 1L) {
    cli::cli_abort("{.arg date} must be a single date.")
  }
  date <- as.character(date)
  if (!is.null(from)) from <- as.character(from)
  if (!is.null(to))   to   <- as.character(to)

  results <- list()
  for (sid in series_id) {
    df <- fred_obs_one(sid, units = units, aggregation = aggregation,
                       frequency = frequency, from = from, to = to,
                       realtime_start = date, realtime_end = date,
                       cache = cache)
    if (!is.null(df)) results[[sid]] <- df
  }

  if (length(results) == 0L) {
    empty <- data.frame(date = as.Date(character(0L)),
                        series_id = character(0L),
                        value = numeric(0L),
                        realtime_start = as.Date(character(0L)),
                        realtime_end = as.Date(character(0L)),
                        stringsAsFactors = FALSE)
    return(new_fred_tbl(empty, query = list(series_id = series_id,
                                            units = units,
                                            vintage = date)))
  }

  long <- do.call(rbind, results)
  rownames(long) <- NULL
  new_fred_tbl(long, query = list(
    series_id = series_id,
    units = units,
    frequency = frequency,
    vintage = date
  ))
}


#' Fetch the first-release ("real-time") version of a series
#'
#' Returns only the value that was published when each observation first
#' appeared in FRED, with no subsequent revisions. Internally this fetches
#' the full revision history and keeps the earliest `realtime_start` row
#' for each observation date. Useful when you want a clean comparison
#' between what policymakers saw at the time versus what the data look
#' like after revisions.
#'
#' @inheritParams fred_as_of
#'
#' @return A `fred_tbl` with columns `date`, `series_id`, `value`,
#'   `realtime_start`, `realtime_end`.
#'
#' @family vintages
#' @export
#' @examples
#' \donttest{
#' op <- options(fred.cache_dir = tempdir())
#' # Initial-release GDP, never revised
#' gdp_first <- fred_first_release("GDP", from = "2018-01-01")
#' options(op)
#' }
fred_first_release <- function(series_id, from = NULL, to = NULL,
                               units = "lin", frequency = NULL,
                               aggregation = "avg", cache = TRUE) {
  if (!is.character(series_id) || length(series_id) == 0L) {
    cli::cli_abort("{.arg series_id} must be a non-empty character vector.")
  }
  if (!is.null(from)) from <- as.character(from)
  if (!is.null(to))   to   <- as.character(to)

  results <- list()
  for (sid in series_id) {
    all_vint <- fred_obs_one(sid, units = units, aggregation = aggregation,
                             frequency = frequency, from = from, to = to,
                             output_type = 2, cache = cache)
    if (is.null(all_vint) || nrow(all_vint) == 0L) next
    # Keep the earliest realtime_start row per observation date.
    ord <- order(all_vint$date, all_vint$realtime_start)
    all_vint <- all_vint[ord, , drop = FALSE]
    keep <- !duplicated(all_vint$date)
    results[[sid]] <- all_vint[keep, , drop = FALSE]
  }

  if (length(results) == 0L) {
    empty <- data.frame(date = as.Date(character(0L)),
                        series_id = character(0L),
                        value = numeric(0L),
                        realtime_start = as.Date(character(0L)),
                        realtime_end = as.Date(character(0L)),
                        stringsAsFactors = FALSE)
    return(new_fred_tbl(empty, query = list(series_id = series_id,
                                            units = units,
                                            vintage = "first_release")))
  }

  long <- do.call(rbind, results)
  rownames(long) <- NULL
  new_fred_tbl(long, query = list(
    series_id = series_id,
    units = units,
    frequency = frequency,
    vintage = "first_release"
  ))
}


#' Fetch every vintage of a series
#'
#' Returns the full revision history: one row per (observation date,
#' realtime range) combination. This is the FRED API's `output_type = 2`
#' mode. The result can be reshaped into a vintage matrix or used to
#' compute revision statistics.
#'
#' Be aware that some series have hundreds of thousands of vintage rows,
#' so consider narrowing the date range with `from`/`to` for long-running
#' indicators like GDP.
#'
#' @inheritParams fred_as_of
#'
#' @return A `fred_tbl` with columns `date`, `series_id`, `value`,
#'   `realtime_start`, `realtime_end`. The `realtime_start` and
#'   `realtime_end` columns identify the vintage window for each row.
#'
#' @family vintages
#' @export
#' @examples
#' \donttest{
#' op <- options(fred.cache_dir = tempdir())
#' # All vintages of recent GDP releases
#' gdp_vint <- fred_all_vintages("GDP", from = "2020-01-01")
#' options(op)
#' }
fred_all_vintages <- function(series_id, from = NULL, to = NULL,
                              units = "lin", frequency = NULL,
                              aggregation = "avg", cache = TRUE) {
  if (!is.character(series_id) || length(series_id) == 0L) {
    cli::cli_abort("{.arg series_id} must be a non-empty character vector.")
  }
  if (!is.null(from)) from <- as.character(from)
  if (!is.null(to))   to   <- as.character(to)

  results <- list()
  for (sid in series_id) {
    df <- fred_obs_one(sid, units = units, aggregation = aggregation,
                       frequency = frequency, from = from, to = to,
                       output_type = 2, cache = cache)
    if (!is.null(df)) results[[sid]] <- df
  }

  if (length(results) == 0L) {
    empty <- data.frame(date = as.Date(character(0L)),
                        series_id = character(0L),
                        value = numeric(0L),
                        realtime_start = as.Date(character(0L)),
                        realtime_end = as.Date(character(0L)),
                        stringsAsFactors = FALSE)
    return(new_fred_tbl(empty, query = list(series_id = series_id,
                                            units = units,
                                            output_type = 2)))
  }

  long <- do.call(rbind, results)
  rownames(long) <- NULL
  new_fred_tbl(long, query = list(
    series_id = series_id,
    units = units,
    frequency = frequency,
    output_type = 2
  ))
}


#' Fetch a real-time panel of a series across selected vintages
#'
#' Returns the values that were available on each of a chosen set of
#' vintage dates. This is the FRED API's `vintage_dates` parameter:
#' instead of asking for every revision (potentially huge), you ask for
#' only the snapshots you care about, e.g. quarterly vintages aligned to
#' GDP release dates.
#'
#' @param series_id Character. One or more FRED series IDs.
#' @param vintages Character or Date vector. Vintage dates to fetch.
#' @param from,to Optional observation date range.
#' @param units Character. Raw FRED units code. Default `"lin"`.
#' @param frequency,aggregation Optional frequency aggregation arguments
#'   (see [fred_series()]).
#' @param cache Logical. Cache results locally. Default `TRUE`.
#'
#' @return A `fred_tbl` with columns `date`, `series_id`, `value`,
#'   `realtime_start`, `realtime_end`.
#'
#' @family vintages
#' @export
#' @examples
#' \donttest{
#' op <- options(fred.cache_dir = tempdir())
#' # GDP as published at three quarterly snapshots
#' gdp_panel <- fred_real_time_panel(
#'   "GDP",
#'   vintages = c("2023-04-30", "2023-07-31", "2023-10-31")
#' )
#' options(op)
#' }
fred_real_time_panel <- function(series_id, vintages, from = NULL, to = NULL,
                                 units = "lin", frequency = NULL,
                                 aggregation = "avg", cache = TRUE) {
  if (!is.character(series_id) || length(series_id) == 0L) {
    cli::cli_abort("{.arg series_id} must be a non-empty character vector.")
  }
  if (length(vintages) == 0L) {
    cli::cli_abort("{.arg vintages} must contain at least one date.")
  }
  vintages <- sort(unique(as.character(vintages)))
  vintage_str <- paste(vintages, collapse = ",")
  if (!is.null(from)) from <- as.character(from)
  if (!is.null(to))   to   <- as.character(to)

  results <- list()
  for (sid in series_id) {
    df <- fred_obs_one(sid, units = units, aggregation = aggregation,
                       frequency = frequency, from = from, to = to,
                       vintage_dates = vintage_str, cache = cache)
    if (!is.null(df)) results[[sid]] <- df
  }

  if (length(results) == 0L) {
    empty <- data.frame(date = as.Date(character(0L)),
                        series_id = character(0L),
                        value = numeric(0L),
                        realtime_start = as.Date(character(0L)),
                        realtime_end = as.Date(character(0L)),
                        stringsAsFactors = FALSE)
    return(new_fred_tbl(empty, query = list(series_id = series_id,
                                            units = units,
                                            vintage = vintage_str)))
  }

  long <- do.call(rbind, results)
  rownames(long) <- NULL
  new_fred_tbl(long, query = list(
    series_id = series_id,
    units = units,
    frequency = frequency,
    vintage = vintage_str
  ))
}
