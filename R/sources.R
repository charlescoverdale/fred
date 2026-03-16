# Source functions

#' List all FRED data sources
#'
#' Returns all data sources that contribute series to FRED. Sources include
#' the Bureau of Labor Statistics, Bureau of Economic Analysis, Federal
#' Reserve Board, U.S. Census Bureau, and over 100 others.
#'
#' @return A data frame of sources with columns including `id`, `name`,
#'   and `link`.
#'
#' @family sources
#' @export
#' @examples
#' \donttest{
#' op <- options(fred.cache_dir = tempdir())
#' fred_sources()
#' options(op)
#' }
fred_sources <- function() {
  items <- fred_fetch_all("sources", result_key = "sources",
                          page_limit = 1000L)
  list_to_df(items)
}


#' List releases from a source
#'
#' Returns all releases published by a given data source.
#'
#' @param source_id Integer. The source ID.
#'
#' @return A data frame of releases.
#'
#' @family sources
#' @export
#' @examples
#' \donttest{
#' op <- options(fred.cache_dir = tempdir())
#' # Bureau of Labor Statistics
#' fred_source_releases(22)
#' options(op)
#' }
fred_source_releases <- function(source_id) {
  items <- fred_fetch_all(
    "source/releases",
    result_key = "releases",
    page_limit = 1000L,
    source_id = as.integer(source_id)
  )
  list_to_df(items)
}
