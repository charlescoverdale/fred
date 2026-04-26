# Tag functions

#' List or search FRED tags
#'
#' Returns FRED tags, optionally filtered by a search query. Tags are
#' keywords used to categorise series (e.g. "gdp", "monthly", "usa",
#' "seasonally adjusted").
#'
#' @param query Character. Optional search string to filter tags.
#' @param limit Integer. Maximum number of results. Default 1000.
#'
#' @return A data frame of tags with columns including `name`,
#'   `group_id`, `notes`, `popularity`, and `series_count`.
#'
#' @family tags
#' @export
#' @examples
#' \donttest{
#' op <- options(fred.cache_dir = tempdir())
#' fred_tags()
#' fred_tags("inflation")
#' options(op)
#' }
fred_tags <- function(query = NULL, limit = 1000L) {
  params <- list()
  if (!is.null(query)) params$search_text <- query
  items <- do.call(
    fred_fetch_all,
    c(list(endpoint = "tags", result_key = "tags",
           page_limit = min(as.integer(limit), 1000L)),
      params)
  )
  new_fred_tbl(list_to_df(items), query = list(
    endpoint = "tags", search_query = query
  ))
}


#' Find tags related to a given tag
#'
#' Returns tags that are frequently used together with the specified tag.
#'
#' @param tag_names Character. One or more tag names, separated by semicolons
#'   (e.g. `"gdp"`, `"usa;quarterly"`).
#'
#' @return A data frame of related tags.
#'
#' @family tags
#' @export
#' @examples
#' \donttest{
#' op <- options(fred.cache_dir = tempdir())
#' fred_related_tags("gdp")
#' options(op)
#' }
fred_related_tags <- function(tag_names) {
  if (!is.character(tag_names) || length(tag_names) != 1L) {
    cli::cli_abort("{.arg tag_names} must be a single character string.")
  }
  items <- fred_fetch_all(
    "related_tags",
    result_key = "tags",
    page_limit = 1000L,
    tag_names = tag_names
  )
  new_fred_tbl(list_to_df(items), query = list(
    endpoint = "related_tags", search_query = tag_names
  ))
}
