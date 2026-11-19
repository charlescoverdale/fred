# Internal HTTP helpers for fred

fred_base_url <- "https://api.stlouisfed.org/fred/"

#' Make a raw request to the FRED API
#'
#' Low-level function that sends a request to any FRED API endpoint and
#' returns the parsed JSON as a list. Most users should use the higher-level
#' functions such as [fred_series()] or [fred_search()].
#'
#' @param endpoint Character. The API endpoint path (e.g.
#'   `"series/observations"`).
#' @param ... Named parameters passed as query string arguments to the API.
#'
#' @return A list parsed from the JSON response.
#'
#' @family configuration
#' @export
#' @examples
#' \donttest{
#' op <- options(fred.cache_dir = tempdir())
#' try({
#'   fred_request("series", series_id = "GDP")
#' })
#' options(op)
#' }
fred_request <- function(endpoint, ...) {
  key <- fred_get_key()
  url <- paste0(fred_base_url, endpoint)

  params <- list(api_key = key, file_type = "json", ...)

  req <- httr2::request(url)
  req <- httr2::req_url_query(req, !!!params)
  req <- httr2::req_throttle(req, rate = 120 / 60)
  req <- httr2::req_retry(
    req,
    max_tries = 3L,
    is_transient = function(resp) httr2::resp_status(resp) == 429L,
    backoff = ~ 5
  )
  req <- httr2::req_user_agent(req, "fred R package (https://github.com/charlescoverdale/fred)")
  # Abort a connection that takes over 20 seconds to open, or a transfer
  # that stalls below 1 byte/s for 60 seconds. httr2 sets no timeout of its
  # own, so a stalled FRED server hung the session indefinitely. A stall
  # raises a curl error, reported by the handler below.
  req <- httr2::req_options(
    req,
    connecttimeout = 20L,
    low_speed_limit = 1L,
    low_speed_time = 60L
  )
  # Return HTTP errors as responses. Without this, req_perform() raised on
  # every 4xx, the handler below reported them all as a connection failure
  # (a mistyped series ID or a bad key read "check your internet
  # connection"), and the status checks after it were unreachable.
  req <- httr2::req_error(req, is_error = function(resp) FALSE)

  resp <- tryCatch(
    httr2::req_perform(req),
    error = function(e) {
      # Only transport failures reach here: no DNS, no route, a timeout.
      cli::cli_abort(c(
        "Failed to connect to the FRED API.",
        "i" = "Check your internet connection or try again later.",
        "i" = "Original error: {conditionMessage(e)}"
      ))
    }
  )

  status <- httr2::resp_status(resp)
  if (status == 400L) {
    # FRED explains a 400 in the body, e.g. "The series does not exist." or
    # "The value for variable api_key is not registered."
    detail <- tryCatch(
      httr2::resp_body_json(resp)[["error_message"]],
      error = function(e) NULL
    )
    if (!is.null(detail)) detail <- gsub("\\s+", " ", detail)
    cli::cli_abort(c(
      "FRED API returned a bad request (HTTP 400).",
      "x" = if (!is.null(detail)) "{detail}",
      "i" = "Check your API key and parameters are valid."
    ))
  }
  if (status == 404L) {
    cli::cli_abort("No data found for this request (HTTP 404).")
  }
  if (status == 429L) {
    cli::cli_abort(c(
      "FRED API rate limit exceeded.",
      "i" = "The limit is 120 requests per minute. Wait and retry."
    ))
  }
  if (status >= 400L) {
    cli::cli_abort("FRED API returned HTTP {status}.")
  }

  httr2::resp_body_json(resp)
}


#' Fetch all pages from a paginated FRED endpoint
#'
#' @param endpoint Character. The API endpoint path.
#' @param result_key Character. The JSON key containing the results list.
#' @param page_limit Integer. Max results per page (API default varies).
#' @param ... Additional query parameters.
#' @return A list of result elements combined across all pages.
#' @noRd
fred_fetch_all <- function(endpoint, result_key, page_limit = 1000L, ...) {
  all_results <- list()
  offset <- 0L

  repeat {
    resp <- fred_request(endpoint, limit = page_limit, offset = offset, ...)
    items <- resp[[result_key]]
    if (is.null(items) || length(items) == 0L) break
    all_results <- c(all_results, items)
    count <- resp[["count"]]
    offset <- offset + page_limit
    if (is.null(count) || offset >= count) break
  }

  all_results
}


#' Convert a list of FRED JSON records to a data frame
#'
#' @param items A list of named lists (parsed JSON records).
#' @return A data frame.
#' @noRd
list_to_df <- function(items) {
  if (length(items) == 0L) {
    return(data.frame())
  }
  # Each item is a named list; rbind them
  cols <- unique(unlist(lapply(items, names)))
  rows <- lapply(items, function(item) {
    vals <- lapply(cols, function(col) {
      v <- item[[col]]
      if (is.null(v)) NA_character_ else as.character(v)
    })
    names(vals) <- cols
    as.data.frame(vals, stringsAsFactors = FALSE)
  })
  do.call(rbind, rows)
}
