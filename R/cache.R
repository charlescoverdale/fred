#' Clear the fred cache
#'
#' Deletes all locally cached FRED data files. The next call to any data
#' function will re-download from the FRED API.
#'
#' @return Invisible `NULL`.
#'
#' @family configuration
#' @export
#' @examples
#' \donttest{
#' op <- options(fred.cache_dir = tempdir())
#' clear_cache()
#' options(op)
#' }
clear_cache <- function() {
  cache_dir <- fred_cache_dir()
  if (dir.exists(cache_dir)) {
    unlink(cache_dir, recursive = TRUE)
    cli::cli_inform("Cache cleared.")
  } else {
    cli::cli_inform("No cache to clear.")
  }
  invisible(NULL)
}


#' Inspect the local fred cache
#'
#' Returns information about the local cache: where it lives, how many
#' files it contains, and how much disk space they take. Useful when
#' debugging stale results or deciding whether to call [clear_cache()].
#'
#' @return A list with elements `dir`, `n_files`, `size_bytes`,
#'   `size_human`, and `files` (a data frame with `name`, `size_bytes`,
#'   and `modified` columns). Returns the same shape with zero counts
#'   if the cache directory does not yet exist.
#'
#' @family configuration
#' @export
#' @examples
#' \donttest{
#' op <- options(fred.cache_dir = tempdir())
#' fred_cache_info()
#' options(op)
#' }
fred_cache_info <- function() {
  cache_dir <- fred_cache_dir()
  empty_files <- data.frame(
    name = character(0L),
    size_bytes = numeric(0L),
    modified = as.POSIXct(character(0L)),
    stringsAsFactors = FALSE
  )
  if (!dir.exists(cache_dir)) {
    return(list(
      dir = cache_dir,
      n_files = 0L,
      size_bytes = 0,
      size_human = "0 B",
      files = empty_files
    ))
  }
  paths <- list.files(cache_dir, full.names = TRUE)
  if (length(paths) == 0L) {
    return(list(
      dir = cache_dir,
      n_files = 0L,
      size_bytes = 0,
      size_human = "0 B",
      files = empty_files
    ))
  }
  info <- file.info(paths)
  files <- data.frame(
    name = basename(paths),
    size_bytes = info$size,
    modified = info$mtime,
    stringsAsFactors = FALSE
  )
  files <- files[order(-files$size_bytes), , drop = FALSE]
  rownames(files) <- NULL
  total <- sum(files$size_bytes)
  list(
    dir = cache_dir,
    n_files = nrow(files),
    size_bytes = total,
    size_human = format_bytes(total),
    files = files
  )
}


#' @noRd
format_bytes <- function(x) {
  if (is.na(x) || x < 1024) return(paste0(x, " B"))
  units <- c("KB", "MB", "GB", "TB")
  i <- 1L
  while (x >= 1024 && i < length(units)) {
    x <- x / 1024
    i <- i + 1L
  }
  sprintf("%.1f %s", x, units[i])
}
