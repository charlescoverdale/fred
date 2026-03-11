test_that("fred_updates returns expected structure", {
  skip_if(Sys.getenv("FRED_API_KEY") == "", "FRED_API_KEY not set")

  df <- fred_updates(limit = 5)
  expect_s3_class(df, "data.frame")
  expect_true(nrow(df) > 0)
})
