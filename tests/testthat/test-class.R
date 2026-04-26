test_that("new_fred_tbl wraps a data frame and attaches query", {
  df <- data.frame(date = as.Date("2020-01-01"), value = 1)
  out <- new_fred_tbl(df, query = list(series_id = "X"))
  expect_s3_class(out, "fred_tbl")
  expect_s3_class(out, "data.frame")
  expect_equal(attr(out, "fred_query"), list(series_id = "X"))
})

test_that("print.fred_tbl shows series query header", {
  tbl <- new_fred_tbl(
    data.frame(date = as.Date("2020-01-01"), series_id = "A", value = 1),
    query = list(series_id = "A", units = "pc1", transform = "yoy_pct")
  )
  out <- capture.output(print(tbl))
  expect_match(out[1L], "^# FRED:")
  expect_match(out[1L], "1 series")
  expect_match(out[1L], "transform=yoy_pct")
})

test_that("print.fred_tbl shows endpoint header for non-series queries", {
  tbl <- new_fred_tbl(
    data.frame(id = c("a", "b"), name = c("x", "y")),
    query = list(endpoint = "search", search_query = "gdp")
  )
  out <- capture.output(print(tbl))
  expect_match(out[1L], "search")
  expect_match(out[1L], "query='gdp'")
  expect_match(out[1L], "2 rows")
})

test_that("print.fred_tbl handles empty fred_tbl", {
  tbl <- new_fred_tbl(data.frame(), query = list(endpoint = "search"))
  out <- capture.output(print(tbl))
  expect_match(out[1L], "search")
  expect_match(out[1L], "0 rows")
})

test_that("summary.fred_tbl prints query metadata", {
  d <- seq(as.Date("2020-01-01"), by = "month", length.out = 12L)
  tbl <- new_fred_tbl(
    data.frame(date = d, series_id = "GDPC1", value = seq_along(d) + 0.0),
    query = list(series_id = "GDPC1", transform = "yoy_pct")
  )
  out <- capture.output(summary(tbl))
  expect_true(any(grepl("FRED query summary", out)))
  expect_true(any(grepl("series: GDPC1", out)))
  expect_true(any(grepl("transform: yoy_pct", out)))
  expect_true(any(grepl("date range:", out)))
  expect_true(any(grepl("value range:", out)))
})

test_that("[.fred_tbl preserves class and query attribute", {
  d <- seq(as.Date("2020-01-01"), by = "month", length.out = 5L)
  tbl <- new_fred_tbl(
    data.frame(date = d, series_id = "A", value = seq_len(5L) + 0.0),
    query = list(series_id = "A", units = "lin")
  )
  sub <- tbl[1:3, ]
  expect_s3_class(sub, "fred_tbl")
  expect_equal(attr(sub, "fred_query"), attr(tbl, "fred_query"))
  expect_equal(nrow(sub), 3L)

  cols <- tbl[, c("date", "value")]
  expect_s3_class(cols, "fred_tbl")
  expect_equal(attr(cols, "fred_query"), attr(tbl, "fred_query"))
})

test_that("[.fred_tbl with drop = TRUE collapses to vector for single col", {
  tbl <- new_fred_tbl(
    data.frame(date = as.Date("2020-01-01"), value = 1.5),
    query = list(series_id = "A")
  )
  v <- tbl[, "value"]
  expect_type(v, "double")
  expect_equal(v, 1.5)
})
