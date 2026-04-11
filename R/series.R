# Series observation and metadata functions

#' @noRd
fred_cache_dir <- function() {
  getOption("fred.cache_dir", default = tools::R_user_dir("fred", "cache"))
}


#' Build a cache key for one observation request
#'
#' Backwards compatible with v0.1.x: when realtime/output_type/vintage_dates
#' are not set, the key matches the old format so existing caches keep
#' working after upgrade.
#'
#' @noRd
fred_cache_key <- function(sid, units, aggregation, frequency, from, to,
                           realtime_start = NULL, realtime_end = NULL,
                           output_type = NULL, vintage_dates = NULL) {
  key <- paste0("obs_", sid, "_", units, "_", aggregation,
                if (!is.null(frequency)) paste0("_", frequency),
                if (!is.null(from)) paste0("_from_", from),
                if (!is.null(to))   paste0("_to_", to))
  if (!is.null(realtime_start) || !is.null(realtime_end)) {
    key <- paste0(key, "_rt", realtime_start %||% "", "-", realtime_end %||% "")
  }
  if (!is.null(output_type)) {
    key <- paste0(key, "_ot", output_type)
  }
  if (!is.null(vintage_dates)) {
    vd <- if (is.character(vintage_dates) && length(vintage_dates) == 1L) {
      strsplit(vintage_dates, ",", fixed = TRUE)[[1L]]
    } else {
      as.character(vintage_dates)
    }
    key <- paste0(key, "_vd", length(vd), "-", vd[1L], "-", vd[length(vd)])
  }
  key
}


#' Coalesce helper (avoids importing magrittr)
#' @noRd
`%||%` <- function(a, b) if (is.null(a)) b else a


#' Fetch observations for a single FRED series with caching.
#'
#' Internal worker shared by `fred_series()` and the vintage helpers.
#'
#' @noRd
fred_obs_one <- function(sid, units = "lin", aggregation = "avg",
                         frequency = NULL, from = NULL, to = NULL,
                         realtime_start = NULL, realtime_end = NULL,
                         output_type = NULL, vintage_dates = NULL,
                         cache = TRUE) {
  cache_dir <- fred_cache_dir()
  cache_key <- fred_cache_key(sid, units, aggregation, frequency, from, to,
                              realtime_start, realtime_end,
                              output_type, vintage_dates)
  cache_file <- file.path(cache_dir, paste0(cache_key, ".rds"))

  if (isTRUE(cache) && file.exists(cache_file)) {
    return(readRDS(cache_file))
  }

  params <- list(
    series_id = sid,
    units = units,
    aggregation_method = aggregation
  )
  if (!is.null(from))           params$observation_start <- from
  if (!is.null(to))             params$observation_end   <- to
  if (!is.null(frequency))      params$frequency         <- frequency
  if (!is.null(realtime_start)) params$realtime_start    <- realtime_start
  if (!is.null(realtime_end))   params$realtime_end      <- realtime_end
  if (!is.null(output_type))    params$output_type       <- output_type
  if (!is.null(vintage_dates))  params$vintage_dates     <- vintage_dates

  resp <- do.call(fred_request, c(list(endpoint = "series/observations"), params))
  obs <- resp[["observations"]]

  if (is.null(obs) || length(obs) == 0L) {
    cli::cli_warn("No observations found for series {.val {sid}}.")
    return(NULL)
  }

  has_rt <- !is.null(realtime_start) || !is.null(realtime_end) ||
            !is.null(output_type) || !is.null(vintage_dates)

  df <- data.frame(
    date = as.Date(vapply(obs, `[[`, character(1L), "date")),
    series_id = sid,
    value = as.numeric(vapply(obs, function(o) {
      v <- o[["value"]]
      if (is.null(v) || v == ".") NA_character_ else v
    }, character(1L))),
    stringsAsFactors = FALSE
  )

  if (has_rt) {
    df$realtime_start <- as.Date(vapply(obs, function(o) {
      v <- o[["realtime_start"]]; if (is.null(v)) NA_character_ else v
    }, character(1L)))
    df$realtime_end <- as.Date(vapply(obs, function(o) {
      v <- o[["realtime_end"]]; if (is.null(v)) NA_character_ else v
    }, character(1L)))
  }

  dir.create(cache_dir, recursive = TRUE, showWarnings = FALSE)
  saveRDS(df, cache_file)
  df
}


#' Fetch observations for one or more FRED series
#'
#' The main function in the package. Downloads time series observations from
#' FRED and returns a tidy data frame. Multiple series can be fetched in a
#' single call, in either long or wide format.
#'
#' FRED supports server-side unit transformations via the `units` argument.
#' This avoids the need to compute growth rates or log transforms locally.
#' For readability you can pass `transform` instead of `units`:
#' \itemize{
#'   \item `"level"`, `"raw"` -levels (the default)
#'   \item `"diff"`, `"change"` -change from previous period
#'   \item `"yoy_diff"` -change from one year ago
#'   \item `"qoq_pct"`, `"mom_pct"`, `"pop_pct"` -percent change from previous period
#'   \item `"yoy_pct"` -percent change from one year ago
#'   \item `"annualised"`, `"qoq_annualised"` -compounded annual rate of change
#'   \item `"log"` -natural log
#'   \item `"log_diff"` -continuously compounded rate of change
#'   \item `"log_diff_annualised"` -continuously compounded annual rate
#' }
#' Raw FRED `units` codes (`"lin"`, `"chg"`, `"ch1"`, `"pch"`, `"pc1"`,
#' `"pca"`, `"cch"`, `"cca"`, `"log"`) are also accepted.
#'
#' @param series_id Character. One or more FRED series IDs (e.g. `"GDP"`,
#'   `c("GDP", "UNRATE", "CPIAUCSL")`).
#' @param from Optional start date. Character (`"YYYY-MM-DD"`) or Date.
#' @param to Optional end date. Character (`"YYYY-MM-DD"`) or Date.
#' @param units Character. Raw FRED units code. Default `"lin"` (levels).
#'   Mutually exclusive with `transform`.
#' @param transform Character. Readable transformation name. See Details.
#' @param frequency Character. Frequency aggregation. One of `"d"` (daily),
#'   `"w"` (weekly), `"bw"` (biweekly), `"m"` (monthly), `"q"` (quarterly),
#'   `"sa"` (semiannual), `"a"` (annual), or `NULL` (native frequency,
#'   the default).
#' @param aggregation Character. Aggregation method when `frequency` is
#'   specified. One of `"avg"` (default), `"sum"`, or `"eop"` (end of period).
#' @param format Character. `"long"` (default) returns one row per
#'   `(series_id, date)`. `"wide"` returns one row per date with one column
#'   per series.
#' @param cache Logical. If `TRUE` (the default), results are cached locally
#'   and returned from the cache on subsequent calls. Set to `FALSE` to force
#'   a fresh download from the API.
#'
#' @return A `fred_tbl` (a `data.frame` subclass that prints with a
#'   one-line provenance header). In long format, columns are `date`,
#'   `series_id`, `value`. In wide format, columns are `date` plus one
#'   numeric column per series.
#'
#' @family series
#' @export
#' @examples
#' \donttest{
#' op <- options(fred.cache_dir = tempdir())
#' # Single series
#' gdp <- fred_series("GDP")
#'
#' # Multiple series, long format
#' macro <- fred_series(c("GDP", "UNRATE", "CPIAUCSL"))
#'
#' # Multiple series, wide format
#' macro_w <- fred_series(c("GDP", "UNRATE"), format = "wide")
#'
#' # Readable transformation: year-on-year percent change
#' gdp_growth <- fred_series("GDP", transform = "yoy_pct")
#'
#' # Aggregate daily to monthly
#' rates <- fred_series("DGS10", frequency = "m")
#' options(op)
#' }
fred_series <- function(series_id, from = NULL, to = NULL,
                        units = "lin", transform = NULL,
                        frequency = NULL, aggregation = "avg",
                        format = c("long", "wide"),
                        cache = TRUE) {
  if (!is.character(series_id) || length(series_id) == 0L) {
    cli::cli_abort("{.arg series_id} must be a non-empty character vector.")
  }

  format <- match.arg(format)

  if (!is.null(transform)) {
    if (!identical(units, "lin")) {
      cli::cli_abort(c(
        "{.arg units} and {.arg transform} are mutually exclusive.",
        "i" = "Pass one or the other, not both."
      ))
    }
    units <- transform_to_units(transform)
  }

  valid_units <- c("lin", "chg", "ch1", "pch", "pc1", "pca", "cch", "cca", "log")
  if (!units %in% valid_units) {
    cli::cli_abort("{.arg units} must be one of {.val {valid_units}}.")
  }

  valid_agg <- c("avg", "sum", "eop")
  if (!aggregation %in% valid_agg) {
    cli::cli_abort("{.arg aggregation} must be one of {.val {valid_agg}}.")
  }

  valid_freq <- c("d", "w", "bw", "m", "q", "sa", "a")
  if (!is.null(frequency) && !frequency %in% valid_freq) {
    cli::cli_abort("{.arg frequency} must be one of {.val {valid_freq}} or {.val NULL}.")
  }

  if (!is.null(from)) from <- as.character(from)
  if (!is.null(to))   to   <- as.character(to)

  results <- list()
  for (sid in series_id) {
    df <- fred_obs_one(sid, units = units, aggregation = aggregation,
                       frequency = frequency, from = from, to = to,
                       cache = cache)
    if (!is.null(df)) results[[sid]] <- df
  }

  if (length(results) == 0L) {
    empty <- data.frame(date = as.Date(character(0L)),
                        series_id = character(0L),
                        value = numeric(0L),
                        stringsAsFactors = FALSE)
    return(new_fred_tbl(empty, query = list(series_id = series_id, units = units,
                                            transform = transform,
                                            frequency = frequency)))
  }

  long <- do.call(rbind, results)
  rownames(long) <- NULL

  out <- if (format == "wide") pivot_to_wide(long) else long

  new_fred_tbl(out, query = list(
    series_id = series_id,
    units = units,
    transform = transform,
    frequency = frequency,
    format = format
  ))
}


#' Get metadata for a FRED series
#'
#' Returns descriptive information about a series, including its title, units,
#' frequency, seasonal adjustment, and notes.
#'
#' @param series_id Character. A single FRED series ID.
#'
#' @return A data frame with one row containing series metadata.
#'
#' @family series
#' @export
#' @examples
#' \donttest{
#' op <- options(fred.cache_dir = tempdir())
#' fred_info("GDP")
#' options(op)
#' }
fred_info <- function(series_id) {
  if (!is.character(series_id) || length(series_id) != 1L) {
    cli::cli_abort("{.arg series_id} must be a single character string.")
  }
  resp <- fred_request("series", series_id = series_id)
  serieses <- resp[["seriess"]]
  if (is.null(serieses) || length(serieses) == 0L) {
    cli::cli_abort("Series {.val {series_id}} not found.")
  }
  list_to_df(serieses)
}


#' Get vintage dates for a FRED series
#'
#' Returns the dates on which data for a series were revised. This is useful
#' for real-time analysis and understanding data revisions.
#'
#' @param series_id Character. A single FRED series ID.
#'
#' @return A data frame with columns `series_id` and `vintage_date`.
#'
#' @family series
#' @export
#' @examples
#' \donttest{
#' op <- options(fred.cache_dir = tempdir())
#' fred_vintages("GDP")
#' options(op)
#' }
fred_vintages <- function(series_id) {
  if (!is.character(series_id) || length(series_id) != 1L) {
    cli::cli_abort("{.arg series_id} must be a single character string.")
  }
  resp <- fred_request("series/vintagedates", series_id = series_id)
  dates <- resp[["vintage_dates"]]
  if (is.null(dates) || length(dates) == 0L) {
    return(data.frame(series_id = character(0L),
                      vintage_date = as.Date(character(0L)),
                      stringsAsFactors = FALSE))
  }
  data.frame(
    series_id = series_id,
    vintage_date = as.Date(unlist(dates)),
    stringsAsFactors = FALSE
  )
}
