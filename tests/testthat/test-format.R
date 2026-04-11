test_that("transform_to_units maps known names", {
  expect_equal(transform_to_units("level"), "lin")
  expect_equal(transform_to_units("raw"), "lin")
  expect_equal(transform_to_units("diff"), "chg")
  expect_equal(transform_to_units("change"), "chg")
  expect_equal(transform_to_units("yoy_diff"), "ch1")
  expect_equal(transform_to_units("qoq_pct"), "pch")
  expect_equal(transform_to_units("mom_pct"), "pch")
  expect_equal(transform_to_units("pop_pct"), "pch")
  expect_equal(transform_to_units("yoy_pct"), "pc1")
  expect_equal(transform_to_units("annualised"), "pca")
  expect_equal(transform_to_units("qoq_annualised"), "pca")
  expect_equal(transform_to_units("log"), "log")
  expect_equal(transform_to_units("log_diff"), "cch")
  expect_equal(transform_to_units("log_diff_annualised"), "cca")
})

test_that("transform_to_units rejects unknown names", {
  expect_error(transform_to_units("nonsense"), "not a recognised name")
  expect_error(transform_to_units(c("a", "b")), "single character string")
  expect_error(transform_to_units(123), "single character string")
})

test_that("transform_to_units returns NULL for NULL input", {
  expect_null(transform_to_units(NULL))
})

test_that("fred_series rejects units and transform together", {
  expect_error(
    fred_series("GDP", units = "pch", transform = "yoy_pct"),
    "mutually exclusive"
  )
})

test_that("pivot_to_wide handles empty input", {
  empty <- data.frame(date = as.Date(character(0L)),
                      series_id = character(0L),
                      value = numeric(0L),
                      stringsAsFactors = FALSE)
  out <- pivot_to_wide(empty)
  expect_s3_class(out, "data.frame")
  expect_equal(nrow(out), 0L)
  expect_true("date" %in% names(out))
})

test_that("pivot_to_wide reshapes long to wide", {
  long <- data.frame(
    date = as.Date(c("2020-01-01", "2020-02-01", "2020-01-01", "2020-02-01")),
    series_id = c("A", "A", "B", "B"),
    value = c(1, 2, 10, 20),
    stringsAsFactors = FALSE
  )
  wide <- pivot_to_wide(long)
  expect_equal(nrow(wide), 2L)
  expect_true(all(c("date", "A", "B") %in% names(wide)))
  expect_equal(wide$A, c(1, 2))
  expect_equal(wide$B, c(10, 20))
})

test_that("new_fred_tbl wraps a data frame", {
  df <- data.frame(date = as.Date("2020-01-01"), series_id = "GDP", value = 1)
  out <- new_fred_tbl(df, query = list(series_id = "GDP", units = "lin"))
  expect_s3_class(out, "fred_tbl")
  expect_s3_class(out, "data.frame")
  expect_equal(attr(out, "fred_query")$series_id, "GDP")
})

test_that("print.fred_tbl emits a header", {
  df <- new_fred_tbl(
    data.frame(date = as.Date("2020-01-01"), series_id = "GDP", value = 1),
    query = list(series_id = "GDP", units = "pch", frequency = "q")
  )
  expect_output(print(df), "FRED")
})

test_that("fred_series wide format works (live)", {
  skip_if(Sys.getenv("FRED_API_KEY") == "", "FRED_API_KEY not set")

  df <- fred_series(c("GDP", "UNRATE"),
                    from = "2020-01-01", to = "2020-12-31",
                    format = "wide")
  expect_s3_class(df, "fred_tbl")
  expect_true("date" %in% names(df))
  expect_true(all(c("GDP", "UNRATE") %in% names(df)))
})

test_that("fred_series transform aliases route to units (live)", {
  skip_if(Sys.getenv("FRED_API_KEY") == "", "FRED_API_KEY not set")

  df <- fred_series("GDP", from = "2020-01-01", to = "2021-12-31",
                    transform = "yoy_pct")
  expect_s3_class(df, "fred_tbl")
  expect_true(all(c("date", "series_id", "value") %in% names(df)))
})
