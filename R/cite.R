# Citation helpers: produce machine-readable citations for FRED series.

#' Generate a citation for a FRED series
#'
#' Produces a citation string for a single FRED series in BibTeX, plain text,
#' or `bibentry` form. Works offline by default: the citation falls back to
#' the series ID as the title. Pass `fetch_metadata = TRUE` to call
#' [fred_info()] and use the official series title (requires an API key).
#'
#' Cite a specific vintage by passing `vintage_date`. This is essential for
#' reproducible research: a 2023 GDP figure published in October 2023 may
#' differ materially from the same observation as it appears today.
#'
#' @param series_id Character. A single FRED series ID.
#' @param vintage_date Optional character or Date. Vintage date the data was
#'   accessed as of. Defaults to today's date (the "accessed" date).
#' @param format Character. One of `"bibtex"` (default), `"text"`, or
#'   `"bibentry"` (an R `utils::bibentry` object).
#' @param fetch_metadata Logical. If `TRUE`, call [fred_info()] to fetch the
#'   official series title. Requires an API key. Default `FALSE`.
#'
#' @return A character string (`"bibtex"`, `"text"`) or a `bibentry` object.
#'
#' @family reproducibility
#' @export
#' @examples
#' # BibTeX without an API call
#' fred_cite_series("GDPC1")
#'
#' # Plain-text citation pinned to a vintage date
#' fred_cite_series("UNRATE", vintage_date = "2024-06-01", format = "text")
#'
#' \dontrun{
#'   # Use the official title (requires an API key)
#'   fred_cite_series("GDPC1", fetch_metadata = TRUE)
#' }
fred_cite_series <- function(series_id, vintage_date = NULL,
                             format = c("bibtex", "text", "bibentry"),
                             fetch_metadata = FALSE) {
  if (!is.character(series_id) || length(series_id) != 1L || !nzchar(series_id)) {
    cli::cli_abort("{.arg series_id} must be a single non-empty character string.")
  }
  format <- match.arg(format)

  title <- series_id
  if (isTRUE(fetch_metadata)) {
    info <- tryCatch(fred_info(series_id), error = function(e) NULL)
    if (!is.null(info) && !is.null(info$title) && nzchar(info$title[1L])) {
      title <- info$title[1L]
    }
  }

  publisher <- "Federal Reserve Bank of St. Louis"
  url <- sprintf("https://fred.stlouisfed.org/series/%s", series_id)
  accessed <- if (!is.null(vintage_date)) as.Date(vintage_date) else Sys.Date()
  year <- as.integer(format(accessed, "%Y"))

  switch(
    format,
    bibtex = {
      key <- sprintf("FRED_%s_%d", series_id, year)
      sprintf(
        paste(
          "@misc{%s,",
          "  title        = {%s [%s]},",
          "  author       = {{%s}},",
          "  publisher    = {%s},",
          "  year         = {%d},",
          "  url          = {%s},",
          "  urldate      = {%s},",
          "  note         = {FRED, Federal Reserve Bank of St. Louis}",
          "}", sep = "\n"),
        key, title, series_id, publisher, publisher, year, url,
        format(accessed, "%Y-%m-%d")
      )
    },
    text = {
      sprintf(
        "%s. (%d). %s [%s]. FRED, Federal Reserve Bank of St. Louis. %s. Accessed %s.",
        publisher, year, title, series_id, url, format(accessed, "%d %B %Y")
      )
    },
    bibentry = {
      utils::bibentry(
        bibtype  = "Misc",
        key      = sprintf("FRED_%s_%d", series_id, year),
        title    = sprintf("%s [%s]", title, series_id),
        author   = utils::person(family = publisher),
        year     = as.character(year),
        url      = url,
        note     = sprintf("FRED, Federal Reserve Bank of St. Louis. Accessed %s.",
                           format(accessed, "%d %B %Y"))
      )
    }
  )
}
