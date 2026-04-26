# Category browsing functions

#' Get a FRED category
#'
#' Returns information about a single category. The FRED category tree starts
#' at category 0 (the root) and branches into 8 top-level categories:
#' Money, Banking & Finance; Population, Employment & Labor Markets; National
#' Accounts; Production & Business Activity; Prices; International Data; U.S.
#' Regional Data; and Academic Data.
#'
#' @param category_id Integer. The category ID. Default `0` (root).
#'
#' @return A data frame with category metadata.
#'
#' @family categories
#' @export
#' @examples
#' \donttest{
#' op <- options(fred.cache_dir = tempdir())
#' # Root category
#' fred_category()
#'
#' # National Accounts (category 32992)
#' fred_category(32992)
#' options(op)
#' }
fred_category <- function(category_id = 0L) {
  resp <- fred_request("category", category_id = as.integer(category_id))
  new_fred_tbl(list_to_df(resp[["categories"]]), query = list(
    endpoint = "category", category_id = as.integer(category_id)
  ))
}


#' List child categories
#'
#' Returns the child categories for a given parent category.
#'
#' @param category_id Integer. The parent category ID. Default `0` (root).
#'
#' @return A data frame of child categories.
#'
#' @family categories
#' @export
#' @examples
#' \donttest{
#' op <- options(fred.cache_dir = tempdir())
#' # Top-level categories
#' fred_category_children()
#' options(op)
#' }
fred_category_children <- function(category_id = 0L) {
  resp <- fred_request("category/children", category_id = as.integer(category_id))
  new_fred_tbl(list_to_df(resp[["categories"]]), query = list(
    endpoint = "category/children", category_id = as.integer(category_id)
  ))
}


#' List series in a category
#'
#' Returns all series belonging to a given category. Automatically paginates
#' through all results.
#'
#' @param category_id Integer. The category ID.
#' @param limit Integer. Maximum number of results to return. Default 1000.
#'
#' @return A data frame of series metadata.
#'
#' @family categories
#' @export
#' @examples
#' \donttest{
#' op <- options(fred.cache_dir = tempdir())
#' fred_category_series(32992)
#' options(op)
#' }
fred_category_series <- function(category_id, limit = 1000L) {
  items <- fred_fetch_all(
    "category/series",
    result_key = "seriess",
    page_limit = min(as.integer(limit), 1000L),
    category_id = as.integer(category_id)
  )
  new_fred_tbl(list_to_df(items), query = list(
    endpoint = "category/series", category_id = as.integer(category_id)
  ))
}
