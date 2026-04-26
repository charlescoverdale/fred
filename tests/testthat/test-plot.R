make_long <- function(n = 60L) {
  d <- seq(as.Date("2005-01-01"), by = "month", length.out = n)
  rbind(
    data.frame(date = d, series_id = "A", value = sin(seq_len(n) / 6)),
    data.frame(date = d, series_id = "B", value = cos(seq_len(n) / 6))
  )
}

make_wide <- function(n = 60L) {
  d <- seq(as.Date("2005-01-01"), by = "month", length.out = n)
  data.frame(date = d, A = sin(seq_len(n) / 6), B = cos(seq_len(n) / 6))
}

test_that("plot.fred_tbl runs without error on long format", {
  tbl <- new_fred_tbl(make_long(), query = list(series_id = c("A", "B")))
  pdf(NULL)
  on.exit(dev.off(), add = TRUE)
  expect_silent(plot(tbl))
})

test_that("plot.fred_tbl runs without error on wide format", {
  tbl <- new_fred_tbl(make_wide(), query = list(series_id = c("A", "B"),
                                                format = "wide"))
  pdf(NULL)
  on.exit(dev.off(), add = TRUE)
  expect_silent(plot(tbl))
})

test_that("plot.fred_tbl runs with recessions = FALSE", {
  tbl <- new_fred_tbl(make_wide(), query = list(series_id = "A"))
  pdf(NULL)
  on.exit(dev.off(), add = TRUE)
  expect_silent(plot(tbl, recessions = FALSE))
})

test_that("plot.fred_tbl errors on missing date column", {
  bad <- new_fred_tbl(data.frame(value = 1:3))
  expect_error(plot(bad), "date")
})

test_that("plot.fred_tbl errors on empty fred_tbl", {
  empty <- new_fred_tbl(data.frame(date = as.Date(character(0L)),
                                    value = numeric(0L)))
  expect_error(plot(empty), "empty")
})

test_that("plot.fred_tbl errors on no numeric columns", {
  d <- as.Date("2020-01-01")
  bad <- new_fred_tbl(data.frame(date = d, label = "a",
                                  stringsAsFactors = FALSE))
  expect_error(plot(bad), "numeric")
})

test_that("plot.fred_tbl uses recession shading correctly", {
  d <- seq(as.Date("2007-01-01"), as.Date("2010-12-01"), by = "month")
  tbl <- new_fred_tbl(data.frame(date = d, A = seq_along(d) + 0.0))
  pdf(NULL)
  on.exit(dev.off(), add = TRUE)
  expect_silent(plot(tbl, recessions = TRUE, legend = FALSE))
})
