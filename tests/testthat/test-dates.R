test_that("fred_recession_dates returns NBER reference frame", {
  rec <- fred_recession_dates()
  expect_s3_class(rec, "fred_tbl")
  expect_true(all(c("peak", "trough", "duration_months") %in% names(rec)))
  expect_s3_class(rec$peak, "Date")
  expect_s3_class(rec$trough, "Date")
  expect_gt(nrow(rec), 30L)
  expect_true(all(rec$trough >= rec$peak))
})

test_that("fred_recession_dates filters by from/to", {
  modern <- fred_recession_dates(from = "1948-01-01")
  expect_true(all(modern$peak >= as.Date("1948-01-01")))
  expect_lt(nrow(modern), nrow(fred_recession_dates()))

  pre <- fred_recession_dates(to = "1900-01-01")
  expect_true(all(pre$trough <= as.Date("1900-01-01")))
})

test_that("fred_recession_dates flag mode flags GFC", {
  dates <- seq(as.Date("2007-01-01"), as.Date("2010-12-01"), by = "month")
  flagged <- fred_recession_dates(flag = dates)
  expect_true(all(c("date", "in_recession") %in% names(flagged)))
  expect_equal(nrow(flagged), length(dates))
  # 2008 should be in recession
  expect_true(flagged$in_recession[flagged$date == as.Date("2008-06-01")])
  # 2007-01 should not
  expect_false(flagged$in_recession[flagged$date == as.Date("2007-01-01")])
})

test_that("fred_recession_dates flag mode flags COVID month", {
  flagged <- fred_recession_dates(flag = as.Date("2020-03-01"))
  expect_true(flagged$in_recession)
})

test_that("fred_fomc_dates returns expected shape", {
  m <- fred_fomc_dates()
  expect_s3_class(m, "fred_tbl")
  expect_true(all(c("date", "type", "sep") %in% names(m)))
  expect_s3_class(m$date, "Date")
  expect_type(m$sep, "logical")
  expect_gt(nrow(m), 50L)
})

test_that("fred_fomc_dates filters by year", {
  yr <- fred_fomc_dates(year = 2022)
  expect_true(all(format(yr$date, "%Y") == "2022"))
  expect_equal(nrow(yr), 8L)  # 2022 had 8 scheduled meetings, no unscheduled
})

test_that("fred_fomc_dates sep_only returns SEP meetings only", {
  sep <- fred_fomc_dates(year = 2024, sep_only = TRUE)
  expect_true(all(sep$sep))
  expect_equal(nrow(sep), 4L)  # SEP meetings happen Mar/Jun/Sep/Dec
})

test_that("fred_fomc_dates filters by from/to", {
  win <- fred_fomc_dates(from = "2020-03-01", to = "2020-03-31")
  # March 2020: regular meeting cancelled, two unscheduled emergencies
  expect_gte(nrow(win), 2L)
  expect_true(any(win$type == "unscheduled"))
})

test_that("fred_fomc_dates handles empty filter", {
  empty <- fred_fomc_dates(year = 2099L)
  expect_equal(nrow(empty), 0L)
})
