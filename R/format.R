# Internal helpers for transformations and reshaping.

#' Map a readable transform name to a FRED units code
#'
#' @param transform Character. Readable transform name.
#' @return Character. FRED units code.
#' @noRd
transform_to_units <- function(transform) {
  if (is.null(transform)) return(NULL)
  if (!is.character(transform) || length(transform) != 1L) {
    cli::cli_abort("{.arg transform} must be a single character string.")
  }
  mapping <- c(
    level                = "lin",
    raw                  = "lin",
    diff                 = "chg",
    change               = "chg",
    yoy_diff             = "ch1",
    qoq_pct              = "pch",
    mom_pct              = "pch",
    pop_pct              = "pch",
    yoy_pct              = "pc1",
    annualised           = "pca",
    qoq_annualised       = "pca",
    log                  = "log",
    log_diff             = "cch",
    log_diff_annualised  = "cca"
  )
  if (!transform %in% names(mapping)) {
    cli::cli_abort(c(
      "{.arg transform} {.val {transform}} is not a recognised name.",
      "i" = "Valid names: {.val {names(mapping)}}.",
      "i" = "Or pass a raw FRED units code via {.arg units}."
    ))
  }
  unname(mapping[transform])
}


#' Pivot a long-format observations data frame to wide
#'
#' Base R reshape, no tidyr dependency.
#'
#' @param df Long data frame with columns date, series_id, value.
#' @return Wide data frame keyed on date with one column per series_id.
#' @noRd
pivot_to_wide <- function(df) {
  if (nrow(df) == 0L) {
    return(data.frame(date = as.Date(character(0L)),
                      stringsAsFactors = FALSE))
  }
  wide <- stats::reshape(
    df[, c("date", "series_id", "value")],
    idvar = "date",
    timevar = "series_id",
    direction = "wide"
  )
  names(wide) <- sub("^value\\.", "", names(wide))
  rownames(wide) <- NULL
  wide <- wide[order(wide$date), , drop = FALSE]
  wide
}
