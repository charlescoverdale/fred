test_that("vintage helpers validate inputs", {
  expect_error(fred_as_of(123, "2020-01-01"), "non-empty character")
  expect_error(fred_as_of("GDP", c("2020-01-01", "2020-02-01")),
               "single date")
  expect_error(fred_first_release(123), "non-empty character")
  expect_error(fred_all_vintages(123), "non-empty character")
  expect_error(fred_real_time_panel(123, vintages = "2020-01-01"),
               "non-empty character")
  expect_error(fred_real_time_panel("GDP", vintages = character(0L)),
               "at least one date")
})

test_that("fred_cache_key is backwards compatible for default args", {
  k_old <- fred_cache_key("GDP", "lin", "avg", NULL, NULL, NULL)
  expect_equal(k_old, "obs_GDP_lin_avg")
})

test_that("fred_cache_key appends realtime suffix only when needed", {
  k_default <- fred_cache_key("GDP", "lin", "avg", NULL, NULL, NULL)
  k_rt <- fred_cache_key("GDP", "lin", "avg", NULL, NULL, NULL,
                         realtime_start = "2020-01-01",
                         realtime_end = "2020-01-01")
  expect_false(identical(k_default, k_rt))
  expect_match(k_rt, "_rt2020-01-01-2020-01-01")
})

test_that("fred_cache_key appends output_type suffix", {
  k <- fred_cache_key("GDP", "lin", "avg", NULL, NULL, NULL, output_type = 4)
  expect_match(k, "_ot4$")
})

test_that("fred_cache_key appends vintage_dates suffix", {
  k <- fred_cache_key("GDP", "lin", "avg", NULL, NULL, NULL,
                      vintage_dates = "2020-01-01,2020-04-01,2020-07-01")
  expect_match(k, "_vd3-2020-01-01-2020-07-01$")
})

test_that("fred_as_of returns expected structure (live)", {
  skip_if(Sys.getenv("FRED_API_KEY") == "", "FRED_API_KEY not set")

  df <- fred_as_of("GDP", date = "2020-03-01",
                   from = "2018-01-01", to = "2020-01-01")
  expect_s3_class(df, "fred_tbl")
  expect_true(all(c("date", "series_id", "value",
                    "realtime_start", "realtime_end") %in% names(df)))
})

test_that("fred_first_release returns expected structure (live)", {
  skip_if(Sys.getenv("FRED_API_KEY") == "", "FRED_API_KEY not set")

  df <- fred_first_release("GDP", from = "2018-01-01", to = "2020-01-01")
  expect_s3_class(df, "fred_tbl")
  expect_true(all(c("date", "series_id", "value",
                    "realtime_start", "realtime_end") %in% names(df)))
})

test_that("fred_real_time_panel returns expected structure (live)", {
  skip_if(Sys.getenv("FRED_API_KEY") == "", "FRED_API_KEY not set")

  df <- fred_real_time_panel(
    "GDP",
    vintages = c("2020-04-30", "2020-07-31"),
    from = "2018-01-01", to = "2020-04-01"
  )
  expect_s3_class(df, "fred_tbl")
  expect_true(all(c("date", "series_id", "value",
                    "realtime_start", "realtime_end") %in% names(df)))
})
