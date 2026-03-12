# Series search functions

#' Search for FRED series
#'
#' Searches the FRED database by keywords or series ID substring. Returns
#' matching series with their metadata, ordered by relevance.
#'
#' @param query Character. Search terms (e.g. `"GDP"`, `"unemployment rate"`).
#' @param type Character. Either `"full_text"` (default) for keyword search
#'   or `"series_id"` for series ID substring matching (supports `*`
#'   wildcards).
#' @param limit Integer. Maximum number of results to return. Default 100,
#'   maximum 1000.
#' @param order_by Character. How to order results. One of `"search_rank"`
#'   (default), `"series_id"`, `"title"`, `"units"`, `"frequency"`,
#'   `"seasonal_adjustment"`, `"last_updated"`, `"popularity"`,
#'   `"group_popularity"`.
#' @param filter_variable Character. Optional variable to filter by. One of
#'   `"frequency"`, `"units"`, or `"seasonal_adjustment"`.
#' @param filter_value Character. The value to filter on (e.g. `"Monthly"`,
#'   `"Quarterly"`). Required if `filter_variable` is specified.
#' @param tag_names Character. Optional comma-separated tag names to filter
#'   results (e.g. `"gdp"`, `"usa;quarterly"`).
#'
#' @return A data frame of matching series with columns including `id`,
#'   `title`, `frequency`, `units`, `seasonal_adjustment`, `last_updated`,
#'   `popularity`, and `notes`.
#'
#' @export
#' @examples
#' \dontrun{
#' # Keyword search
#' fred_search("unemployment rate")
#'
#' # Filter to monthly series only
#' fred_search("consumer price index", filter_variable = "frequency",
#'             filter_value = "Monthly")
#'
#' # Search by series ID pattern
#' fred_search("GDP*", type = "series_id")
#' }
fred_search <- function(query, type = "full_text", limit = 100L,
                        order_by = "search_rank",
                        filter_variable = NULL, filter_value = NULL,
                        tag_names = NULL) {
  if (!is.character(query) || length(query) != 1L || nchar(query) == 0L) {
    cli::cli_abort("{.arg query} must be a non-empty character string.")
  }

  valid_types <- c("full_text", "series_id")
  if (!type %in% valid_types) {
    cli::cli_abort("{.arg type} must be one of {.val {valid_types}}.")
  }

  valid_order <- c("search_rank", "series_id", "title", "units", "frequency",
                    "seasonal_adjustment", "last_updated", "popularity",
                    "group_popularity")
  if (!order_by %in% valid_order) {
    cli::cli_abort("{.arg order_by} must be one of {.val {valid_order}}.")
  }

  limit <- min(as.integer(limit), 1000L)

  params <- list(
    search_text = query,
    search_type = type,
    limit = limit,
    order_by = order_by
  )
  if (!is.null(filter_variable)) params$filter_variable <- filter_variable
  if (!is.null(filter_value))    params$filter_value    <- filter_value
  if (!is.null(tag_names))       params$tag_names       <- tag_names

  resp <- do.call(fred_request, c(list(endpoint = "series/search"), params))
  serieses <- resp[["seriess"]]

  if (is.null(serieses) || length(serieses) == 0L) {
    cli::cli_inform("No series found for query {.val {query}}.")
    return(data.frame())
  }

  list_to_df(serieses)
}
