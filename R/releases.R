# Release functions

#' List all FRED releases
#'
#' Returns all data releases available on FRED. A release is a collection of
#' related series published together (e.g. "Employment Situation", "GDP").
#'
#' @return A data frame of releases with columns including `id`, `name`,
#'   `press_release`, and `link`.
#'
#' @family releases
#' @export
#' @examples
#' \donttest{
#' op <- options(fred.cache_dir = tempdir())
#' fred_releases()
#' options(op)
#' }
fred_releases <- function() {
  items <- fred_fetch_all("releases", result_key = "releases",
                          page_limit = 1000L)
  list_to_df(items)
}


#' List series in a release
#'
#' Returns all series belonging to a given release.
#'
#' @param release_id Integer. The release ID.
#'
#' @return A data frame of series metadata.
#'
#' @family releases
#' @export
#' @examples
#' \donttest{
#' op <- options(fred.cache_dir = tempdir())
#' # GDP release
#' fred_release_series(53)
#' options(op)
#' }
fred_release_series <- function(release_id) {
  items <- fred_fetch_all(
    "release/series",
    result_key = "seriess",
    page_limit = 1000L,
    release_id = as.integer(release_id)
  )
  list_to_df(items)
}


#' Get release dates
#'
#' Returns the dates on which data for a release were published. Useful for
#' understanding the data calendar and when revisions occurred.
#'
#' @param release_id Integer. The release ID.
#'
#' @return A data frame with columns `release_id` and `date`.
#'
#' @family releases
#' @export
#' @examples
#' \donttest{
#' op <- options(fred.cache_dir = tempdir())
#' fred_release_dates(53)
#' options(op)
#' }
fred_release_dates <- function(release_id) {
  items <- fred_fetch_all(
    "release/dates",
    result_key = "release_dates",
    page_limit = 1000L,
    release_id = as.integer(release_id)
  )
  list_to_df(items)
}
