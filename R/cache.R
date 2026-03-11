#' Clear the fred cache
#'
#' Deletes all locally cached FRED data files. The next call to any data
#' function will re-download from the FRED API.
#'
#' @return Invisible `NULL`.
#'
#' @export
#' @examples
#' \dontrun{
#' clear_cache()
#' }
clear_cache <- function() {
  cache_dir <- tools::R_user_dir("fred", "cache")
  if (dir.exists(cache_dir)) {
    unlink(cache_dir, recursive = TRUE)
    cli::cli_alert_success("Cache cleared.")
  } else {
    cli::cli_alert_info("No cache to clear.")
  }
  invisible(NULL)
}
