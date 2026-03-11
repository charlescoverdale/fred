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
#' @export
#' @examples
#' \dontrun{
#' # Root category
#' fred_category()
#'
#' # National Accounts (category 32992)
#' fred_category(32992)
#' }
fred_category <- function(category_id = 0L) {
  resp <- fred_request("category", category_id = as.integer(category_id))
  list_to_df(resp[["categories"]])
}


#' List child categories
#'
#' Returns the child categories for a given parent category.
#'
#' @param category_id Integer. The parent category ID. Default `0` (root).
#'
#' @return A data frame of child categories.
#'
#' @export
#' @examples
#' \dontrun{
#' # Top-level categories
#' fred_category_children()
#' }
fred_category_children <- function(category_id = 0L) {
  resp <- fred_request("category/children", category_id = as.integer(category_id))
  list_to_df(resp[["categories"]])
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
#' @export
#' @examples
#' \dontrun{
#' fred_category_series(32992)
#' }
fred_category_series <- function(category_id, limit = 1000L) {
  items <- fred_fetch_all(
    "category/series",
    result_key = "seriess",
    page_limit = min(as.integer(limit), 1000L),
    category_id = as.integer(category_id)
  )
  list_to_df(items)
}
