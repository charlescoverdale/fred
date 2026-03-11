test_that("fred_series validates inputs", {
  expect_error(fred_series(123), "non-empty character")
  expect_error(fred_series(character(0L)), "non-empty character")
  expect_error(fred_series("GDP", units = "bad"), "must be one of")
  expect_error(fred_series("GDP", aggregation = "bad"), "must be one of")
})

test_that("fred_info validates inputs", {
  expect_error(fred_info(c("GDP", "UNRATE")), "single character string")
  expect_error(fred_info(123), "single character string")
})

test_that("fred_vintages validates inputs", {
  expect_error(fred_vintages(c("GDP", "UNRATE")), "single character string")
})

test_that("fred_series returns expected structure", {
  skip_if(Sys.getenv("FRED_API_KEY") == "", "FRED_API_KEY not set")

  df <- fred_series("GDP", from = "2020-01-01", to = "2021-01-01")
  expect_s3_class(df, "data.frame")
  expect_true(all(c("date", "series_id", "value") %in% names(df)))
  expect_true(all(df$series_id == "GDP"))
  expect_s3_class(df$date, "Date")
  expect_type(df$value, "double")
})

test_that("fred_series handles multiple series", {
  skip_if(Sys.getenv("FRED_API_KEY") == "", "FRED_API_KEY not set")

  df <- fred_series(c("GDP", "UNRATE"), from = "2020-01-01", to = "2021-01-01")
  expect_s3_class(df, "data.frame")
  expect_true(all(c("GDP", "UNRATE") %in% df$series_id))
})

test_that("fred_series supports unit transformations", {
  skip_if(Sys.getenv("FRED_API_KEY") == "", "FRED_API_KEY not set")

  df <- fred_series("GDP", from = "2020-01-01", to = "2021-01-01", units = "pch")
  expect_s3_class(df, "data.frame")
  expect_true(all(c("date", "series_id", "value") %in% names(df)))
})

test_that("fred_series supports frequency aggregation", {
  skip_if(Sys.getenv("FRED_API_KEY") == "", "FRED_API_KEY not set")

  df <- fred_series("DGS10", from = "2020-01-01", to = "2020-06-01",
                    frequency = "m")
  expect_s3_class(df, "data.frame")
})

test_that("fred_info returns expected structure", {
  skip_if(Sys.getenv("FRED_API_KEY") == "", "FRED_API_KEY not set")

  df <- fred_info("GDP")
  expect_s3_class(df, "data.frame")
  expect_true("id" %in% names(df))
  expect_true("title" %in% names(df))
})

test_that("fred_vintages returns expected structure", {
  skip_if(Sys.getenv("FRED_API_KEY") == "", "FRED_API_KEY not set")

  df <- fred_vintages("GDP")
  expect_s3_class(df, "data.frame")
  expect_true(all(c("series_id", "vintage_date") %in% names(df)))
  expect_s3_class(df$vintage_date, "Date")
})
