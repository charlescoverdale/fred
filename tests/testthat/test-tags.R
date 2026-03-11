test_that("fred_related_tags validates inputs", {
  expect_error(fred_related_tags(123), "single character string")
  expect_error(fred_related_tags(c("a", "b")), "single character string")
})

test_that("fred_tags returns expected structure", {
  skip_if(Sys.getenv("FRED_API_KEY") == "", "FRED_API_KEY not set")

  df <- fred_tags("inflation")
  expect_s3_class(df, "data.frame")
  expect_true(nrow(df) > 0)
  expect_true("name" %in% names(df))
})

test_that("fred_related_tags returns expected structure", {
  skip_if(Sys.getenv("FRED_API_KEY") == "", "FRED_API_KEY not set")

  df <- fred_related_tags("gdp")
  expect_s3_class(df, "data.frame")
  expect_true(nrow(df) > 0)
})
