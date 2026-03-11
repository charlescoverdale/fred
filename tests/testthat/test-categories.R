test_that("fred_category returns expected structure", {
  skip_if(Sys.getenv("FRED_API_KEY") == "", "FRED_API_KEY not set")

  df <- fred_category()
  expect_s3_class(df, "data.frame")
  expect_true("id" %in% names(df))
  expect_true("name" %in% names(df))
})

test_that("fred_category_children returns expected structure", {
  skip_if(Sys.getenv("FRED_API_KEY") == "", "FRED_API_KEY not set")

  df <- fred_category_children()
  expect_s3_class(df, "data.frame")
  expect_true(nrow(df) > 0)
  expect_true("id" %in% names(df))
})

test_that("fred_category_series returns expected structure", {
  skip_if(Sys.getenv("FRED_API_KEY") == "", "FRED_API_KEY not set")

  df <- fred_category_series(32992)
  expect_s3_class(df, "data.frame")
  expect_true("id" %in% names(df))
})
