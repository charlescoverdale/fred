# Recently updated series

#' List recently updated FRED series
#'
#' Returns series that have been recently updated or revised.
#'
#' @param limit Integer. Maximum number of results. Default 100, maximum 100.
#'
#' @return A data frame of recently updated series.
#'
#' @family series
#' @export
#' @examples
#' \donttest{
#' op <- options(fred.cache_dir = tempdir())
#' fred_updates()
#' options(op)
#' }
fred_updates <- function(limit = 100L) {
  resp <- fred_request("series/updates", limit = min(as.integer(limit), 100L))
  serieses <- resp[["seriess"]]
  if (is.null(serieses) || length(serieses) == 0L) {
    return(new_fred_tbl(data.frame(), query = list(endpoint = "series/updates")))
  }
  new_fred_tbl(list_to_df(serieses), query = list(endpoint = "series/updates"))
}
