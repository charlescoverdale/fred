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
#' Adds a one-line provenance header above the data frame body. The header
#' summarises the query: number of series, observation count, transformation
#' in effect, vintage information, or for non-observation queries, the
#' endpoint and result count.
#'
#' @param x A `fred_tbl`.
#' @param ... Passed to the underlying `print.data.frame` method.
#' @return `x`, invisibly.
#' @export
print.fred_tbl <- function(x, ...) {
  cat(sprintf("# FRED: %s\n", .fred_tbl_header(x)))
  NextMethod()
}


#' Summary method for fred_tbl
#'
#' Prints query metadata, dimensions, date range (when present), and value
#' range (when present), then dispatches to the standard `summary.data.frame`.
#'
#' @param object A `fred_tbl`.
#' @param ... Passed to the underlying `summary.data.frame` method.
#' @return Invisibly returns the standard data frame summary.
#' @export
summary.fred_tbl <- function(object, ...) {
  q <- attr(object, "fred_query")
  cat(sprintf("FRED query summary: %s\n", .fred_tbl_header(object)))
  cat(sprintf("  rows: %d  cols: %d\n", nrow(object), ncol(object)))
  if (!is.null(q$series_id)) {
    cat(sprintf("  series: %s\n", paste(q$series_id, collapse = ", ")))
  }
  if (!is.null(q$transform) && nzchar(q$transform)) {
    cat(sprintf("  transform: %s\n", q$transform))
  }
  if ("date" %in% names(object) && nrow(object) > 0L) {
    d <- object$date
    if (inherits(d, "Date")) {
      cat(sprintf("  date range: %s to %s\n",
                  format(min(d, na.rm = TRUE)),
                  format(max(d, na.rm = TRUE))))
    }
  }
  if ("value" %in% names(object) && nrow(object) > 0L && is.numeric(object$value)) {
    rng <- range(object$value, na.rm = TRUE)
    if (all(is.finite(rng))) {
      cat(sprintf("  value range: %.4g to %.4g\n", rng[1L], rng[2L]))
    }
  }
  cat("\n")
  invisible(NextMethod())
}


#' Subset method for fred_tbl
#'
#' Preserves the `fred_tbl` class and `fred_query` attribute when subsetting
#' rows or columns. Falls back to a plain vector when `drop = TRUE` reduces
#' the result to a single column (matching `data.frame` behaviour).
#'
#' @param x A `fred_tbl`.
#' @param i Row selector.
#' @param j Column selector.
#' @param ... Other arguments passed to `[.data.frame`.
#' @param drop Logical. As in `[.data.frame`.
#' @return A `fred_tbl` (or a vector if `drop` collapses the result).
#' @export
`[.fred_tbl` <- function(x, i, j, ..., drop = TRUE) {
  q <- attr(x, "fred_query")
  out <- NextMethod()
  if (is.data.frame(out)) {
    attr(out, "fred_query") <- q
    class(out) <- c("fred_tbl", "data.frame")
  }
  out
}


#' Build the one-line header for a fred_tbl
#'
#' Detects the query type from the metadata and assembles a compact header
#' string. Used by both `print.fred_tbl()` and `summary.fred_tbl()`.
#' @noRd
.fred_tbl_header <- function(x) {
  q <- attr(x, "fred_query")
  parts <- character(0L)

  if (!is.null(q$series_id)) {
    parts <- c(parts, sprintf("%d series", length(q$series_id)))
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
  } else if (!is.null(q$endpoint)) {
    parts <- c(parts, q$endpoint)
    if (!is.null(q$search_query)) {
      parts <- c(parts, sprintf("query='%s'", q$search_query))
    }
    if (!is.null(q$category_id)) {
      parts <- c(parts, sprintf("category=%d", as.integer(q$category_id)))
    }
    if (!is.null(q$release_id)) {
      parts <- c(parts, sprintf("release=%d", as.integer(q$release_id)))
    }
    if (!is.null(q$source_id)) {
      parts <- c(parts, sprintf("source=%d", as.integer(q$source_id)))
    }
    parts <- c(parts, sprintf("%d row%s", nrow(x), if (nrow(x) == 1L) "" else "s"))
  } else {
    parts <- c(parts, sprintf("%d row%s", nrow(x), if (nrow(x) == 1L) "" else "s"))
  }

  paste(parts, collapse = " \u00b7 ")
}
