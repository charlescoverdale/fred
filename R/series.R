# Series observation and metadata functions

#' Fetch observations for one or more FRED series
#'
#' The main function in the package. Downloads time series observations from
#' FRED and returns a tidy data frame. Multiple series can be fetched in a
#' single call.
#'
#' FRED supports server-side unit transformations via the `units` argument.
#' This avoids the need to compute growth rates or log transforms locally.
#' Supported values:
#' \itemize{
#'   \item `"lin"` — levels (no transformation, the default)
#'   \item `"chg"` — change from previous period
#'   \item `"ch1"` — change from one year ago
#'   \item `"pch"` — percent change from previous period
#'   \item `"pc1"` — percent change from one year ago
#'   \item `"pca"` — compounded annual rate of change
#'   \item `"cch"` — continuously compounded rate of change
#'   \item `"cca"` — continuously compounded annual rate of change
#'   \item `"log"` — natural log
#' }
#'
#' @param series_id Character. One or more FRED series IDs (e.g. `"GDP"`,
#'   `c("GDP", "UNRATE", "CPIAUCSL")`).
#' @param from Optional start date. Character (`"YYYY-MM-DD"`) or Date.
#' @param to Optional end date. Character (`"YYYY-MM-DD"`) or Date.
#' @param units Character. Unit transformation to apply. Default `"lin"`
#'   (levels). See Details.
#' @param frequency Character. Frequency aggregation. One of `"d"` (daily),
#'   `"w"` (weekly), `"bw"` (biweekly), `"m"` (monthly), `"q"` (quarterly),
#'   `"sa"` (semiannual), `"a"` (annual), or `NULL` (native frequency,
#'   the default).
#' @param aggregation Character. Aggregation method when `frequency` is
#'   specified. One of `"avg"` (default), `"sum"`, or `"eop"` (end of period).
#'
#' @return A data frame with columns:
#' \describe{
#'   \item{date}{Date. The observation date.}
#'   \item{series_id}{Character. The FRED series identifier.}
#'   \item{value}{Numeric. The observation value.}
#' }
#'
#' @export
#' @examples
#' \dontrun{
#' # Single series
#' gdp <- fred_series("GDP")
#'
#' # Multiple series
#' macro <- fred_series(c("GDP", "UNRATE", "CPIAUCSL"))
#'
#' # With transformation: year-on-year percent change
#' gdp_growth <- fred_series("GDP", units = "pc1")
#'
#' # Aggregate daily to monthly
#' rates <- fred_series("DGS10", frequency = "m")
#' }
fred_series <- function(series_id, from = NULL, to = NULL,
                        units = "lin", frequency = NULL,
                        aggregation = "avg") {
  if (!is.character(series_id) || length(series_id) == 0L) {
    cli::cli_abort("{.arg series_id} must be a non-empty character vector.")
  }

  valid_units <- c("lin", "chg", "ch1", "pch", "pc1", "pca", "cch", "cca", "log")
  if (!units %in% valid_units) {
    cli::cli_abort("{.arg units} must be one of {.val {valid_units}}.")
  }

  valid_agg <- c("avg", "sum", "eop")
  if (!aggregation %in% valid_agg) {
    cli::cli_abort("{.arg aggregation} must be one of {.val {valid_agg}}.")
  }

  if (!is.null(from)) from <- as.character(from)
  if (!is.null(to))   to   <- as.character(to)

  # Check cache
  cache_dir <- tools::R_user_dir("fred", "cache")
  results <- list()

  for (sid in series_id) {
    cache_key <- paste0("obs_", sid, "_", units,
                        if (!is.null(frequency)) paste0("_", frequency),
                        if (!is.null(from)) paste0("_from_", from),
                        if (!is.null(to))   paste0("_to_", to))
    cache_file <- file.path(cache_dir, paste0(cache_key, ".rds"))

    if (file.exists(cache_file)) {
      results[[sid]] <- readRDS(cache_file)
      next
    }

    params <- list(
      series_id = sid,
      units = units,
      aggregation_method = aggregation
    )
    if (!is.null(from)) params$observation_start <- from
    if (!is.null(to))   params$observation_end   <- to
    if (!is.null(frequency)) params$frequency     <- frequency

    resp <- do.call(fred_request, c(list(endpoint = "series/observations"), params))
    obs <- resp[["observations"]]

    if (is.null(obs) || length(obs) == 0L) {
      cli::cli_warn("No observations found for series {.val {sid}}.")
      next
    }

    df <- data.frame(
      date = as.Date(vapply(obs, `[[`, character(1L), "date")),
      series_id = sid,
      value = as.numeric(vapply(obs, function(o) {
        v <- o[["value"]]
        if (is.null(v) || v == ".") NA_character_ else v
      }, character(1L))),
      stringsAsFactors = FALSE
    )

    # Cache
    dir.create(cache_dir, recursive = TRUE, showWarnings = FALSE)
    saveRDS(df, cache_file)

    results[[sid]] <- df
  }

  if (length(results) == 0L) {
    return(data.frame(date = as.Date(character(0L)),
                      series_id = character(0L),
                      value = numeric(0L),
                      stringsAsFactors = FALSE))
  }

  do.call(rbind, results)
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
#' @export
#' @examples
#' \dontrun{
#' fred_info("GDP")
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
#' @export
#' @examples
#' \dontrun{
#' fred_vintages("GDP")
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
