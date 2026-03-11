test_that("fred_sources returns expected structure", {
  skip_if(Sys.getenv("FRED_API_KEY") == "", "FRED_API_KEY not set")

  df <- fred_sources()
  expect_s3_class(df, "data.frame")
  expect_true(nrow(df) > 0)
  expect_true("id" %in% names(df))
  expect_true("name" %in% names(df))
})

test_that("fred_source_releases returns expected structure", {
  skip_if(Sys.getenv("FRED_API_KEY") == "", "FRED_API_KEY not set")

  df <- fred_source_releases(22)
  expect_s3_class(df, "data.frame")
  expect_true(nrow(df) > 0)
})
