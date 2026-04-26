test_that("fred_cite_series returns BibTeX by default", {
  out <- fred_cite_series("GDPC1")
  expect_type(out, "character")
  expect_match(out, "@misc\\{FRED_GDPC1_")
  expect_match(out, "Federal Reserve Bank of St\\. Louis")
  expect_match(out, "https://fred\\.stlouisfed\\.org/series/GDPC1")
})

test_that("fred_cite_series respects vintage_date", {
  out <- fred_cite_series("UNRATE", vintage_date = "2024-06-01",
                          format = "text")
  expect_match(out, "Accessed 01 June 2024")
  expect_match(out, "UNRATE")
})

test_that("fred_cite_series text format is human readable", {
  out <- fred_cite_series("CPIAUCSL", format = "text")
  expect_match(out, "FRED, Federal Reserve Bank of St\\. Louis")
  expect_match(out, "CPIAUCSL")
})

test_that("fred_cite_series bibentry format returns bibentry object", {
  out <- fred_cite_series("PCEPI", format = "bibentry")
  expect_s3_class(out, "bibentry")
})

test_that("fred_cite_series rejects bad inputs", {
  expect_error(fred_cite_series(123), "single non-empty character")
  expect_error(fred_cite_series(""), "single non-empty character")
  expect_error(fred_cite_series(c("A", "B")), "single non-empty character")
})

test_that("fred_cite_series falls back to series ID without metadata fetch", {
  out <- fred_cite_series("XYZ_NONEXISTENT", format = "text")
  expect_match(out, "XYZ_NONEXISTENT")
})

test_that("fred_cite_series fetch_metadata gracefully ignores API failure", {
  # With no API key set this should fall back to series ID, not error
  withr::with_envvar(c(FRED_API_KEY = ""), {
    out <- fred_cite_series("GDPC1", fetch_metadata = TRUE, format = "text")
    expect_match(out, "GDPC1")
  })
})
