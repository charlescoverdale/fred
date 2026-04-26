# Reproducibility helpers: session manifests and vintage revision summaries.


#' Snapshot a session's FRED downloads as a YAML manifest
#'
#' Produces a YAML manifest describing one or more `fred_tbl` objects, with
#' query metadata, dimensions, date ranges, and an MD5 hash of each object.
#' Intended to be saved alongside paper code for reproducibility checks: if
#' the manifest still hashes to the same values, the data underlying the
#' analysis has not changed.
#'
#' Pass `fred_tbl` objects positionally, named, or as a list. If passed a
#' bare list, names from the list are used; otherwise objects are labelled
#' `obj_1`, `obj_2`, ...
#'
#' @param ... `fred_tbl` objects (positional or named) or a single list of
#'   `fred_tbl` objects.
#' @param file Optional path to write the YAML manifest. If `NULL` (default),
#'   the manifest is returned as a `fred_manifest` object (printable).
#'
#' @return A `fred_manifest` object (a character string with an attached
#'   print method). If `file` is supplied, written to disk and returned
#'   invisibly.
#'
#' @family reproducibility
#' @export
#' @examples
#' \donttest{
#' op <- options(fred.cache_dir = tempdir())
#' \dontrun{
#'   gdp <- fred_series("GDPC1", from = "2020-01-01")
#'   un  <- fred_series("UNRATE", from = "2020-01-01")
#'   m <- fred_manifest(gdp = gdp, unrate = un)
#'   print(m)
#'   fred_manifest(gdp = gdp, file = file.path(tempdir(), "manifest.yml"))
#' }
#' options(op)
#' }
fred_manifest <- function(..., file = NULL) {
  args <- list(...)
  if (length(args) == 1L && is.list(args[[1L]]) && !is.data.frame(args[[1L]])) {
    args <- args[[1L]]
  }
  if (length(args) == 0L) {
    cli::cli_abort("{.fn fred_manifest} requires at least one object.")
  }
  ok <- vapply(args, is.data.frame, logical(1L))
  if (!all(ok)) {
    cli::cli_abort("All objects passed to {.fn fred_manifest} must be data frames.")
  }

  obj_names <- names(args)
  if (is.null(obj_names)) obj_names <- rep("", length(args))
  obj_names <- ifelse(nzchar(obj_names), obj_names,
                      sprintf("obj_%d", seq_along(args)))

  lines <- c(
    "# FRED manifest",
    sprintf("created: %s", format(Sys.time(), "%Y-%m-%dT%H:%M:%S%z")),
    sprintf("r_version: %s", as.character(getRversion())),
    sprintf("fred_version: %s", as.character(utils::packageVersion("fred"))),
    sprintf("n_objects: %d", length(args)),
    "objects:"
  )

  for (i in seq_along(args)) {
    obj <- args[[i]]
    nm  <- obj_names[i]
    q   <- attr(obj, "fred_query") %||% list()
    h   <- .fred_hash_object(obj)

    lines <- c(lines,
      sprintf("  - name: %s", nm),
      sprintf("    rows: %d", nrow(obj)),
      sprintf("    cols: %d", ncol(obj)),
      sprintf("    md5: %s", h))

    if (!is.null(q$series_id)) {
      lines <- c(lines,
        sprintf("    series_id: [%s]", paste(q$series_id, collapse = ", ")))
    }
    if (!is.null(q$units) && nzchar(q$units)) {
      lines <- c(lines, sprintf("    units: %s", q$units))
    }
    if (!is.null(q$transform) && nzchar(q$transform)) {
      lines <- c(lines, sprintf("    transform: %s", q$transform))
    }
    if (!is.null(q$frequency) && nzchar(q$frequency)) {
      lines <- c(lines, sprintf("    frequency: %s", q$frequency))
    }
    if (!is.null(q$vintage) && nzchar(q$vintage)) {
      lines <- c(lines, sprintf("    vintage: %s", q$vintage))
    }
    if (!is.null(q$endpoint)) {
      lines <- c(lines, sprintf("    endpoint: %s", q$endpoint))
    }
    if ("date" %in% names(obj) && nrow(obj) > 0L &&
        inherits(obj$date, "Date")) {
      d <- obj$date
      lines <- c(lines, sprintf("    date_range: [%s, %s]",
                                format(min(d, na.rm = TRUE)),
                                format(max(d, na.rm = TRUE))))
    }
  }

  text <- paste(lines, collapse = "\n")
  class(text) <- c("fred_manifest", "character")

  if (!is.null(file)) {
    writeLines(unclass(text), file)
    cli::cli_inform("Wrote manifest to {.file {file}}.")
    return(invisible(text))
  }
  text
}


#' Print method for fred_manifest
#' @param x A `fred_manifest` object.
#' @param ... Ignored.
#' @return `x`, invisibly.
#' @export
print.fred_manifest <- function(x, ...) {
  cat(unclass(x), sep = "\n")
  cat("\n")
  invisible(x)
}


#' Summarise revision behaviour for a FRED series
#'
#' For each observation date in a series' vintage history, computes summary
#' statistics on how the value has been revised: number of vintages, first
#' and final value, total revision (final minus first), mean and SD of
#' inter-vintage changes, and elapsed days from first publication to final.
#' Useful for choosing series for real-time analysis (low-revision series are
#' more reliable for nowcasting).
#'
#' Internally fetches `fred_all_vintages(series_id, ...)` and reduces. For
#' long-running indicators, narrow the window with `from`/`to` to keep the
#' API call manageable.
#'
#' @param series_id Character. A single FRED series ID.
#' @param from,to Optional observation date range.
#' @param cache Logical. Cache the underlying vintage download. Default `TRUE`.
#'
#' @return A `fred_tbl` with columns `series_id`, `date`, `n_vintages`,
#'   `first_value`, `final_value`, `revision_total`, `revision_total_pct`,
#'   `revision_mean`, `revision_sd`, `days_to_final`.
#'
#' @family reproducibility
#' @export
#' @examples
#' \donttest{
#' op <- options(fred.cache_dir = tempdir())
#' \dontrun{
#'   rev <- fred_vintage_revisions("GDPC1", from = "2018-01-01")
#'   summary(rev$revision_total_pct)
#' }
#' options(op)
#' }
fred_vintage_revisions <- function(series_id, from = NULL, to = NULL,
                                   cache = TRUE) {
  if (!is.character(series_id) || length(series_id) != 1L) {
    cli::cli_abort("{.arg series_id} must be a single character string.")
  }

  v <- fred_all_vintages(series_id, from = from, to = to, cache = cache)
  if (nrow(v) == 0L) {
    cli::cli_abort("No vintages returned for series {.val {series_id}}.")
  }

  parts <- split(v, v$date)
  rows <- lapply(parts, function(g) {
    g <- g[order(g$realtime_start), , drop = FALSE]
    n_vint <- nrow(g)
    fv <- g$value[1L]
    lv <- g$value[n_vint]
    rev_total <- lv - fv
    rev_pct <- if (!is.na(fv) && fv != 0) rev_total / fv * 100 else NA_real_
    revs <- diff(g$value)
    rev_mean <- if (length(revs)) mean(revs, na.rm = TRUE) else NA_real_
    rev_sd   <- if (length(revs) > 1L) stats::sd(revs, na.rm = TRUE) else NA_real_
    days <- as.integer(g$realtime_start[n_vint] - g$realtime_start[1L])
    data.frame(
      series_id          = series_id,
      date               = g$date[1L],
      n_vintages         = n_vint,
      first_value        = fv,
      final_value        = lv,
      revision_total     = rev_total,
      revision_total_pct = rev_pct,
      revision_mean      = rev_mean,
      revision_sd        = rev_sd,
      days_to_final      = days,
      stringsAsFactors   = FALSE
    )
  })

  out <- do.call(rbind, rows)
  out <- out[order(out$date), , drop = FALSE]
  rownames(out) <- NULL
  new_fred_tbl(out, query = list(
    series_id = series_id,
    endpoint = "vintage_revisions"
  ))
}


#' Hash a fred_tbl object via temp-file MD5
#'
#' Serialises the object to a temp file and uses `tools::md5sum()`. Avoids
#' adding a `digest` dependency. The hash is stable across sessions for the
#' same data plus identical `fred_query` attributes.
#' @noRd
.fred_hash_object <- function(x) {
  tf <- tempfile()
  on.exit(unlink(tf), add = TRUE)
  saveRDS(x, tf, ascii = TRUE)
  unname(tools::md5sum(tf))
}
