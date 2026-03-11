test_that("fred_releases returns expected structure", {
  skip_if(Sys.getenv("FRED_API_KEY") == "", "FRED_API_KEY not set")

  df <- fred_releases()
  expect_s3_class(df, "data.frame")
  expect_true(nrow(df) > 0)
  expect_true("id" %in% names(df))
  expect_true("name" %in% names(df))
})

test_that("fred_release_series returns expected structure", {
  skip_if(Sys.getenv("FRED_API_KEY") == "", "FRED_API_KEY not set")

  df <- fred_release_series(53)
  expect_s3_class(df, "data.frame")
  expect_true("id" %in% names(df))
})

test_that("fred_release_dates returns expected structure", {
  skip_if(Sys.getenv("FRED_API_KEY") == "", "FRED_API_KEY not set")

  df <- fred_release_dates(53)
  expect_s3_class(df, "data.frame")
  expect_true(nrow(df) > 0)
})
