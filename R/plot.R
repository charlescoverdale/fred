# Default plot method for fred_tbl.

#' Plot a fred_tbl
#'
#' Time-series plot for a `fred_tbl`. Detects long or wide format, draws one
#' line per series, and optionally shades NBER recession periods. Uses base
#' graphics so no extra dependencies are pulled in.
#'
#' For long-format input (`date`, `series_id`, `value`), one line per
#' `series_id`. For wide-format input (`date` plus one numeric column per
#' series), one line per numeric column.
#'
#' @param x A `fred_tbl`.
#' @param recessions Logical. If `TRUE` (default), shade NBER recession
#'   periods that overlap the plotted date range.
#' @param legend Logical. If `TRUE` (default) and there are multiple series,
#'   add a top-left legend.
#' @param col Character. Optional vector of colours, one per series. Default
#'   uses a fixed six-colour qualitative palette, or HCL colours for >6 series.
#' @param type Character. Plot type, passed to [graphics::lines()]. Default
#'   `"l"` (line).
#' @param main,xlab,ylab Plot labels. Sensible defaults are inferred.
#' @param ... Other arguments passed to the initial [graphics::plot()] call.
#'
#' @return `x`, invisibly.
#'
#' @family fred_tbl methods
#' @export
#' @examples
#' \donttest{
#' op <- options(fred.cache_dir = tempdir())
#' \dontrun{
#'   gdp <- fred_series("GDPC1", from = "2000-01-01")
#'   plot(gdp)
#'
#'   panel <- fred_series(c("UNRATE", "CIVPART"), from = "2000-01-01",
#'                        format = "wide")
#'   plot(panel)
#' }
#' options(op)
#' }
plot.fred_tbl <- function(x, recessions = TRUE, legend = TRUE,
                          col = NULL, type = "l",
                          main = NULL, xlab = "", ylab = "value", ...) {
  if (!"date" %in% names(x)) {
    cli::cli_abort("{.fn plot.fred_tbl} needs a {.code date} column.")
  }
  if (nrow(x) == 0L) {
    cli::cli_abort("Cannot plot an empty {.cls fred_tbl}.")
  }

  d <- x$date
  if (!inherits(d, "Date")) d <- as.Date(d)

  if ("series_id" %in% names(x) && "value" %in% names(x)) {
    series_names <- unique(x$series_id)
    series_data <- lapply(series_names, function(sid) {
      g <- x[x$series_id == sid, c("date", "value"), drop = FALSE]
      g[order(g$date), , drop = FALSE]
    })
    names(series_data) <- series_names
  } else {
    other <- setdiff(names(x), "date")
    is_num <- vapply(x[other], is.numeric, logical(1L))
    series_names <- other[is_num]
    if (length(series_names) == 0L) {
      cli::cli_abort("No numeric columns found to plot.")
    }
    series_data <- lapply(series_names, function(col_name) {
      data.frame(date = d, value = x[[col_name]])
    })
    names(series_data) <- series_names
  }

  n_series <- length(series_names)
  if (is.null(col)) {
    palette6 <- c("#1F77B4", "#FF7F0E", "#2CA02C",
                  "#D62728", "#9467BD", "#8C564B")
    col <- if (n_series <= length(palette6)) {
      palette6[seq_len(n_series)]
    } else {
      grDevices::hcl.colors(n_series, palette = "Dark 3")
    }
  }
  if (length(col) < n_series) col <- rep(col, length.out = n_series)

  xrng <- range(unlist(lapply(series_data, function(s) s$date)),
                na.rm = TRUE)
  yrng <- range(unlist(lapply(series_data, function(s) s$value)),
                na.rm = TRUE, finite = TRUE)
  if (any(!is.finite(yrng))) {
    cli::cli_abort("All values are non-finite; nothing to plot.")
  }

  if (is.null(main)) {
    q <- attr(x, "fred_query")
    if (!is.null(q$series_id)) {
      main <- if (length(q$series_id) <= 3L) {
        paste(q$series_id, collapse = ", ")
      } else {
        sprintf("%s + %d more", q$series_id[1L], length(q$series_id) - 1L)
      }
      if (!is.null(q$transform) && nzchar(q$transform)) {
        main <- sprintf("%s (%s)", main, q$transform)
      }
    } else {
      main <- ""
    }
  }

  graphics::plot(
    NA, NA,
    xlim = as.Date(xrng),
    ylim = yrng,
    xaxt = "n",
    main = main, xlab = xlab, ylab = ylab,
    ...
  )
  graphics::axis.Date(1, at = pretty(xrng))

  if (isTRUE(recessions)) {
    rec <- .fred_nber_recessions()
    rec <- rec[rec$trough >= xrng[1L] & rec$peak <= xrng[2L], , drop = FALSE]
    if (nrow(rec) > 0L) {
      shade <- grDevices::adjustcolor("grey50", alpha.f = 0.2)
      pad <- (yrng[2L] - yrng[1L]) * 0.1 + 1
      for (i in seq_len(nrow(rec))) {
        graphics::rect(rec$peak[i], yrng[1L] - pad,
                       rec$trough[i], yrng[2L] + pad,
                       col = shade, border = NA)
      }
    }
  }

  for (i in seq_along(series_data)) {
    sd <- series_data[[i]]
    graphics::lines(sd$date, sd$value, col = col[i], type = type)
  }

  if (isTRUE(legend) && n_series > 1L) {
    graphics::legend("topleft", legend = series_names, col = col,
                     lty = 1, bty = "n", cex = 0.8)
  }

  invisible(x)
}
