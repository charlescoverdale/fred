# Workflow utilities: event windows, frequency aggregation, interpolation.


#' Extract data windows around event dates
#'
#' Given a `fred_tbl` (or any data frame with a `date` column) and a vector of
#' event dates, returns one row per (event, observation) pair where the
#' observation falls inside the requested window. Useful for event studies
#' around FOMC decisions, recession peaks, or release dates.
#'
#' Long-format input with `series_id`/`value` is supported, as is wide-format
#' input from `fred_series(..., format = "wide")`. The window is in calendar
#' days; for monthly or quarterly data, choose a window large enough to
#' capture at least one observation.
#'
#' @param data A `fred_tbl` or `data.frame` with a `date` column.
#' @param events A character or Date vector of event dates.
#' @param window Integer length-2. Days before (negative or zero) and after
#'   (positive or zero) each event date. Default `c(-30L, 90L)`.
#'
#' @return A `fred_tbl` with the original columns plus `event_date` and
#'   `days_from_event`.
#'
#' @family utilities
#' @export
#' @examples
#' # Synthetic example — works offline
#' d <- seq(as.Date("2024-01-01"), as.Date("2024-12-31"), by = "month")
#' df <- data.frame(date = d, value = seq_along(d))
#' events <- as.Date(c("2024-03-15", "2024-09-15"))
#' fred_event_window(df, events = events, window = c(-30L, 60L))
#'
#' \donttest{
#' op <- options(fred.cache_dir = tempdir())
#' # With live FRED data: UNRATE around 2024 SEP meetings (needs API key)
#' \dontrun{
#'   ur <- fred_series("UNRATE", from = "2023-01-01")
#'   sep <- fred_fomc_dates(year = 2024, sep_only = TRUE)
#'   fred_event_window(ur, events = sep$date, window = c(-60L, 60L))
#' }
#' options(op)
#' }
fred_event_window <- function(data, events, window = c(-30L, 90L)) {
  if (!is.data.frame(data)) {
    cli::cli_abort("{.arg data} must be a data frame.")
  }
  if (!"date" %in% names(data)) {
    cli::cli_abort("{.arg data} must have a {.code date} column.")
  }
  if (length(events) == 0L) {
    cli::cli_abort("{.arg events} must contain at least one date.")
  }
  if (length(window) != 2L) {
    cli::cli_abort("{.arg window} must be a length-2 integer vector.")
  }
  events <- as.Date(events)
  window <- as.integer(window)
  if (any(is.na(events))) {
    cli::cli_abort("{.arg events} contains values that cannot be coerced to Date.")
  }
  if (window[1L] > window[2L]) {
    cli::cli_abort("{.arg window}: first element must be <= second element.")
  }

  date_col <- data$date
  if (!inherits(date_col, "Date")) {
    date_col <- as.Date(date_col)
  }

  pieces <- lapply(events, function(ev) {
    in_win <- !is.na(date_col) &
              date_col >= (ev + window[1L]) &
              date_col <= (ev + window[2L])
    if (!any(in_win)) return(NULL)
    sub <- data[in_win, , drop = FALSE]
    sub$event_date <- ev
    sub$days_from_event <- as.integer(date_col[in_win] - ev)
    sub
  })

  pieces <- pieces[!vapply(pieces, is.null, logical(1L))]
  if (length(pieces) == 0L) {
    out <- data[0L, , drop = FALSE]
    out$event_date <- as.Date(character(0L))
    out$days_from_event <- integer(0L)
  } else {
    out <- do.call(rbind, pieces)
    rownames(out) <- NULL
  }

  q <- attr(data, "fred_query") %||% list()
  q$event_window <- list(window = window, n_events = length(events))
  new_fred_tbl(out, query = q)
}


#' Aggregate FRED observations to a coarser frequency
#'
#' Aggregates a long-format `fred_tbl` (with `date`, `series_id`, `value`) or
#' a wide-format `fred_tbl` (date plus one column per series) to a coarser
#' calendar frequency. For long format, aggregation is performed per
#' `series_id`; for wide format, per numeric column.
#'
#' Use this when you have, say, daily Treasury yields and need a monthly
#' average, or weekly initial claims aggregated to monthly totals. For
#' server-side aggregation that mirrors FRED's own interpolation conventions,
#' pass `frequency = "m"` to [fred_series()] instead.
#'
#' @param data A `fred_tbl` or `data.frame` with a `date` column.
#' @param fun Character. Aggregation function. One of `"mean"`, `"sum"`,
#'   `"first"`, `"last"`, `"median"`, `"min"`, `"max"`. Default `"mean"`.
#' @param by Character. Target frequency. One of `"week"`, `"month"`,
#'   `"quarter"`, `"year"`. Default `"month"`.
#'
#' @return A `fred_tbl` with the same columns as the input, with `date`
#'   collapsed to period start.
#'
#' @family utilities
#' @export
#' @examples
#' # Synthetic example: aggregate daily synthetic data to monthly means
#' d <- seq(as.Date("2024-01-01"), as.Date("2024-06-30"), by = "day")
#' daily <- data.frame(date = d, series_id = "X", value = rnorm(length(d)))
#' fred_aggregate(daily, fun = "mean", by = "month")
#'
#' # Wide-format input also works
#' wide <- data.frame(date = d, A = rnorm(length(d)), B = rnorm(length(d)))
#' fred_aggregate(wide, fun = "sum", by = "quarter")
#'
#' \donttest{
#' op <- options(fred.cache_dir = tempdir())
#' \dontrun{
#'   daily_yields <- fred_series("DGS10", from = "2023-01-01")
#'   monthly_yields <- fred_aggregate(daily_yields, fun = "mean", by = "month")
#' }
#' options(op)
#' }
fred_aggregate <- function(data, fun = "mean", by = "month") {
  if (!is.data.frame(data)) {
    cli::cli_abort("{.arg data} must be a data frame.")
  }
  if (!"date" %in% names(data)) {
    cli::cli_abort("{.arg data} must have a {.code date} column.")
  }
  valid_fun <- c("mean", "sum", "first", "last", "median", "min", "max")
  if (!fun %in% valid_fun) {
    cli::cli_abort("{.arg fun} must be one of {.val {valid_fun}}.")
  }
  valid_by <- c("week", "month", "quarter", "year")
  if (!by %in% valid_by) {
    cli::cli_abort("{.arg by} must be one of {.val {valid_by}}.")
  }

  fun_call <- switch(fun,
    mean   = function(x) mean(x, na.rm = TRUE),
    sum    = function(x) sum(x, na.rm = TRUE),
    first  = function(x) { x <- x[!is.na(x)]; if (length(x)) x[1L] else NA_real_ },
    last   = function(x) { x <- x[!is.na(x)]; if (length(x)) x[length(x)] else NA_real_ },
    median = function(x) stats::median(x, na.rm = TRUE),
    min    = function(x) suppressWarnings(min(x, na.rm = TRUE)),
    max    = function(x) suppressWarnings(max(x, na.rm = TRUE))
  )

  d <- data$date
  if (!inherits(d, "Date")) d <- as.Date(d)
  period <- .period_floor(d, by)

  if ("series_id" %in% names(data) && "value" %in% names(data)) {
    keys <- paste(format(period), data$series_id, sep = "@@")
    splits <- split(data$value, keys)
    agg <- vapply(splits, fun_call, numeric(1L))
    parts <- strsplit(names(agg), "@@", fixed = TRUE)
    out <- data.frame(
      date = as.Date(vapply(parts, `[`, character(1L), 1L)),
      series_id = vapply(parts, `[`, character(1L), 2L),
      value = as.numeric(agg),
      stringsAsFactors = FALSE
    )
    out <- out[order(out$series_id, out$date), , drop = FALSE]
  } else {
    other <- setdiff(names(data), "date")
    is_num <- vapply(data[other], is.numeric, logical(1L))
    num_cols <- other[is_num]
    if (length(num_cols) == 0L) {
      cli::cli_abort("{.arg data} has no numeric columns to aggregate.")
    }
    grouped <- split(data, period)
    out <- do.call(rbind, lapply(names(grouped), function(p) {
      g <- grouped[[p]]
      vals <- vapply(num_cols, function(col) fun_call(g[[col]]), numeric(1L))
      out_row <- as.data.frame(c(list(date = as.Date(p)), as.list(vals)),
                               stringsAsFactors = FALSE)
      names(out_row) <- c("date", num_cols)
      out_row
    }))
    out <- out[order(out$date), , drop = FALSE]
  }

  rownames(out) <- NULL
  q <- attr(data, "fred_query") %||% list()
  q$aggregation <- list(by = by, fun = fun)
  new_fred_tbl(out, query = q)
}


#' Fill missing values in a FRED series
#'
#' Fills `NA` values in the `value` column (long format) or in numeric columns
#' (wide format). Two methods are supported: last-observation-carry-forward
#' (`"locf"`) and linear interpolation between adjacent observed values
#' (`"linear"`). Use this for mixed-frequency analysis where a low-frequency
#' series needs to be interpolated to a higher frequency.
#'
#' Boundary behaviour: with `method = "locf"`, leading `NA`s remain `NA`
#' because there is no prior observation to carry forward. With
#' `method = "linear"`, neither leading nor trailing `NA`s are filled
#' because `stats::approx()` is called with `rule = 1` (no extrapolation).
#' If you need extrapolation, post-process the result.
#'
#' @param data A `fred_tbl` or `data.frame` with a `date` column.
#' @param method Character. `"locf"` (default) carries the last observed
#'   value forward. `"linear"` does linear interpolation between adjacent
#'   non-`NA` values.
#'
#' @return A `fred_tbl` with interior `NA`s filled (see boundary note above).
#'
#' @family utilities
#' @export
#' @examples
#' # Synthetic example: fill interior NAs
#' d <- seq(as.Date("2024-01-01"), by = "month", length.out = 6L)
#' df <- data.frame(date = d, series_id = "X",
#'                  value = c(NA, 2, NA, NA, 5, NA))
#' fred_interpolate(df, method = "locf")
#' fred_interpolate(df, method = "linear")
#'
#' \donttest{
#' op <- options(fred.cache_dir = tempdir())
#' \dontrun{
#'   gdp <- fred_series("GDPC1", from = "2020-01-01")
#'   gdp_monthly <- fred_interpolate(gdp, method = "linear")
#' }
#' options(op)
#' }
fred_interpolate <- function(data, method = c("locf", "linear")) {
  if (!is.data.frame(data)) {
    cli::cli_abort("{.arg data} must be a data frame.")
  }
  if (!"date" %in% names(data)) {
    cli::cli_abort("{.arg data} must have a {.code date} column.")
  }
  method <- match.arg(method)

  fill_one <- function(x) {
    if (length(x) == 0L) return(x)
    if (method == "locf") {
      for (i in seq_along(x)) {
        if (is.na(x[i]) && i > 1L) x[i] <- x[i - 1L]
      }
      x
    } else {
      ok <- !is.na(x)
      if (sum(ok) < 2L) return(x)
      pos <- seq_along(x)
      stats::approx(pos[ok], x[ok], xout = pos, rule = 1)$y
    }
  }

  if ("series_id" %in% names(data) && "value" %in% names(data)) {
    parts <- split(data, data$series_id)
    out <- do.call(rbind, lapply(parts, function(g) {
      g <- g[order(g$date), , drop = FALSE]
      g$value <- fill_one(g$value)
      g
    }))
  } else {
    out <- data[order(data$date), , drop = FALSE]
    other <- setdiff(names(out), "date")
    is_num <- vapply(out[other], is.numeric, logical(1L))
    for (col in other[is_num]) {
      out[[col]] <- fill_one(out[[col]])
    }
  }

  rownames(out) <- NULL
  q <- attr(data, "fred_query") %||% list()
  q$interpolation <- method
  new_fred_tbl(out, query = q)
}


#' Floor a Date vector to the start of week, month, quarter, or year.
#' @noRd
.period_floor <- function(d, by) {
  switch(by,
    week    = as.Date(format(d, "%Y")) + (as.integer(format(d, "%j")) - 1L) -
              ((as.integer(format(d, "%w")) - 1L) %% 7L),
    month   = as.Date(format(d, "%Y-%m-01")),
    quarter = {
      m <- as.integer(format(d, "%m"))
      q_first <- ((m - 1L) %/% 3L) * 3L + 1L
      as.Date(sprintf("%s-%02d-01", format(d, "%Y"), q_first))
    },
    year    = as.Date(paste0(format(d, "%Y"), "-01-01"))
  )
}
