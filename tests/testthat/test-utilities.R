make_long <- function(n = 30L) {
  d <- seq(as.Date("2020-01-01"), by = "month", length.out = n)
  rbind(
    data.frame(date = d, series_id = "A", value = seq_len(n) + 0.0),
    data.frame(date = d, series_id = "B", value = seq_len(n) * 2 + 0.0)
  )
}

make_wide <- function(n = 30L) {
  d <- seq(as.Date("2020-01-01"), by = "month", length.out = n)
  data.frame(date = d, A = seq_len(n) + 0.0, B = seq_len(n) * 2 + 0.0)
}

# ---- fred_event_window -----------------------------------------------------

test_that("fred_event_window adds event_date and days_from_event", {
  long <- make_long()
  ev <- as.Date(c("2020-06-01", "2021-01-01"))
  out <- fred_event_window(long, events = ev, window = c(-30L, 60L))
  expect_s3_class(out, "fred_tbl")
  expect_true(all(c("event_date", "days_from_event") %in% names(out)))
  expect_true(all(out$event_date %in% ev))
  expect_true(all(out$days_from_event >= -30L & out$days_from_event <= 60L))
})

test_that("fred_event_window works with wide format", {
  wide <- make_wide()
  ev <- as.Date("2020-06-01")
  out <- fred_event_window(wide, events = ev, window = c(0L, 90L))
  expect_s3_class(out, "fred_tbl")
  expect_true("A" %in% names(out))
  expect_true("event_date" %in% names(out))
})

test_that("fred_event_window returns empty when no observations match", {
  long <- make_long()
  out <- fred_event_window(long, events = as.Date("1900-01-01"),
                            window = c(-1L, 1L))
  expect_s3_class(out, "fred_tbl")
  expect_equal(nrow(out), 0L)
})

test_that("fred_event_window validates inputs", {
  long <- make_long()
  expect_error(fred_event_window(list()), "data frame")
  expect_error(fred_event_window(long, events = as.Date("2020-01-01"),
                                  window = c(10L)), "length-2")
  expect_error(fred_event_window(long, events = as.Date("2020-01-01"),
                                  window = c(10L, -10L)), "first element")
  expect_error(fred_event_window(long, events = character(0L)),
               "at least one date")
})

# ---- fred_aggregate --------------------------------------------------------

test_that("fred_aggregate aggregates long format to quarterly", {
  d <- seq(as.Date("2020-01-01"), as.Date("2022-12-31"), by = "month")
  long <- data.frame(date = d, series_id = "X", value = seq_along(d) + 0.0)
  out <- fred_aggregate(long, fun = "mean", by = "quarter")
  expect_s3_class(out, "fred_tbl")
  expect_equal(length(unique(out$date)), 12L)  # 3 years * 4 quarters
})

test_that("fred_aggregate aggregates wide format to year", {
  d <- seq(as.Date("2020-01-01"), as.Date("2021-12-31"), by = "month")
  wide <- data.frame(date = d, A = seq_along(d) + 0.0)
  out <- fred_aggregate(wide, fun = "sum", by = "year")
  expect_s3_class(out, "fred_tbl")
  expect_equal(nrow(out), 2L)
  expect_true("A" %in% names(out))
})

test_that("fred_aggregate validates fun and by", {
  long <- make_long()
  expect_error(fred_aggregate(long, fun = "bogus"), "must be one of")
  expect_error(fred_aggregate(long, by = "epoch"), "must be one of")
})

test_that("fred_aggregate first/last return correct values", {
  d <- seq(as.Date("2020-01-01"), as.Date("2020-12-31"), by = "day")
  long <- data.frame(date = d, series_id = "X", value = seq_along(d) + 0.0)
  first_q <- fred_aggregate(long, fun = "first", by = "quarter")
  last_q  <- fred_aggregate(long, fun = "last", by = "quarter")
  expect_lt(first_q$value[1L], last_q$value[1L])
})

# ---- fred_interpolate ------------------------------------------------------

test_that("fred_interpolate locf fills forward in long format", {
  d <- seq(as.Date("2020-01-01"), by = "day", length.out = 5L)
  long <- data.frame(date = d, series_id = "X",
                     value = c(1, NA, NA, 4, NA))
  out <- fred_interpolate(long, method = "locf")
  expect_equal(out$value, c(1, 1, 1, 4, 4))
})

test_that("fred_interpolate linear fills between observed points", {
  d <- seq(as.Date("2020-01-01"), by = "day", length.out = 5L)
  long <- data.frame(date = d, series_id = "X",
                     value = c(1, NA, NA, 4, NA))
  out <- fred_interpolate(long, method = "linear")
  expect_equal(out$value[1L], 1)
  expect_equal(out$value[4L], 4)
  expect_equal(out$value[2L], 2)  # halfway interpolation 1 -> 4
  expect_equal(out$value[3L], 3)
})

test_that("fred_interpolate works on wide format", {
  d <- seq(as.Date("2020-01-01"), by = "day", length.out = 4L)
  wide <- data.frame(date = d, A = c(1, NA, 3, NA), B = c(2, NA, NA, 8))
  out <- fred_interpolate(wide, method = "locf")
  expect_equal(out$A, c(1, 1, 3, 3))
  expect_equal(out$B, c(2, 2, 2, 8))
})

test_that("fred_interpolate validates method", {
  expect_error(fred_interpolate(make_long(), method = "magic"),
               "should be one of")
})
