test_that("fred_search validates inputs", {
  expect_error(fred_search(123), "non-empty character")
  expect_error(fred_search(""), "non-empty character")
  expect_error(fred_search("gdp", type = "bad"), "must be one of")
})

test_that("fred_search returns expected structure", {
  skip_if(Sys.getenv("FRED_API_KEY") == "", "FRED_API_KEY not set")

  df <- fred_search("gross domestic product", limit = 5)
  expect_s3_class(df, "data.frame")
  expect_true(nrow(df) > 0)
  expect_true("id" %in% names(df))
  expect_true("title" %in% names(df))
})

test_that("fred_search respects limit", {
  skip_if(Sys.getenv("FRED_API_KEY") == "", "FRED_API_KEY not set")

  df <- fred_search("unemployment", limit = 3)
  expect_true(nrow(df) <= 3)
})
