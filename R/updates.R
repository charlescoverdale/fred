# Recently updated series

#' List recently updated FRED series
#'
#' Returns series that have been recently updated or revised.
#'
#' @param limit Integer. Maximum number of results. Default 100, maximum 100.
#'
#' @return A data frame of recently updated series.
#'
#' @export
#' @examples
#' \dontrun{
#' fred_updates()
#' }
fred_updates <- function(limit = 100L) {
  resp <- fred_request("series/updates", limit = min(as.integer(limit), 100L))
  serieses <- resp[["seriess"]]
  if (is.null(serieses) || length(serieses) == 0L) {
    return(data.frame())
  }
  list_to_df(serieses)
}
