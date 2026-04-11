# API key management for fred

# Package-level environment to store the API key
fred_env <- new.env(parent = emptyenv())

#' Set the FRED API key
#'
#' Sets the API key used to authenticate requests to the FRED API. The key
#' persists for the current R session. Alternatively, set the
#' `FRED_API_KEY` environment variable in your `.Renviron` file.
#'
#' Register for a free API key at
#' \url{https://fredaccount.stlouisfed.org/apikeys}.
#'
#' @param key Character. A 32-character FRED API key.
#'
#' @return Invisible `NULL`.
#'
#' @family configuration
#' @export
#' @examples
#' \dontrun{
#' fred_set_key("your_api_key_here")
#' }
fred_set_key <- function(key) {
  if (!is.character(key) || length(key) != 1L || nchar(key) == 0L) {
    cli::cli_abort("{.arg key} must be a non-empty character string.")
  }
  fred_env$api_key <- key
  invisible(NULL)
}

#' Get the current FRED API key
#'
#' Returns the API key set via [fred_set_key()] or the `FRED_API_KEY`
#' environment variable. Raises an error if no key is found.
#'
#' @return Character. The API key.
#'
#' @family configuration
#' @export
#' @examples
#' \donttest{
#' op <- options(fred.cache_dir = tempdir())
#' fred_get_key()
#' options(op)
#' }
fred_get_key <- function() {
  key <- fred_env$api_key %||% Sys.getenv("FRED_API_KEY", unset = "")
  if (nchar(key) == 0L) {
    cli::cli_abort(c(
      "No FRED API key found.",
      "i" = "Set one with {.fn fred_set_key} or the {.envvar FRED_API_KEY} environment variable.",
      "i" = "Register for a free key at {.url https://fredaccount.stlouisfed.org/apikeys}."
    ))
  }
  key
}
