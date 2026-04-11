# S3 class for FRED query results.

#' Construct a fred_tbl
#'
#' @param df A data frame.
#' @param query A list of query metadata.
#' @return A `fred_tbl` (subclass of data.frame).
#' @noRd
new_fred_tbl <- function(df, query = list()) {
  if (!is.data.frame(df)) {
    df <- as.data.frame(df, stringsAsFactors = FALSE)
  }
  attr(df, "fred_query") <- query
  class(df) <- c("fred_tbl", "data.frame")
  df
}


#' Print method for fred_tbl
#'
#' Adds a one-line provenance header above the data frame body. The
#' header summarises the query: number of series, observation count,
#' transformation in effect, and any vintage information.
#'
#' @param x A `fred_tbl`.
#' @param ... Passed to the underlying `print.data.frame` method.
#' @return `x`, invisibly.
#' @export
print.fred_tbl <- function(x, ...) {
  q <- attr(x, "fred_query")
  parts <- character(0L)

  n_series <- if (!is.null(q$series_id)) length(q$series_id) else NA_integer_
  if (!is.na(n_series)) {
    parts <- c(parts, sprintf("%d series", n_series))
  }
  parts <- c(parts, sprintf("%d obs", nrow(x)))

  if (!is.null(q$units) && nzchar(q$units) && q$units != "lin") {
    parts <- c(parts, paste0("units=", q$units))
  }
  if (!is.null(q$transform) && nzchar(q$transform)) {
    parts <- c(parts, paste0("transform=", q$transform))
  }
  if (!is.null(q$frequency) && nzchar(q$frequency)) {
    parts <- c(parts, paste0("freq=", q$frequency))
  }
  if (!is.null(q$vintage) && nzchar(q$vintage)) {
    parts <- c(parts, paste0("as_of=", q$vintage))
  }
  if (!is.null(q$output_type)) {
    label <- switch(as.character(q$output_type),
                    "2" = "all vintages",
                    "4" = "first release",
                    paste0("output_type=", q$output_type))
    parts <- c(parts, label)
  }

  cat(sprintf("# FRED: %s\n", paste(parts, collapse = " \u00b7 ")))
  NextMethod()
}
