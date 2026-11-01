test_that("clear_cache runs without error", {
  expect_no_error(clear_cache())
})

test_that("fred_cache_info returns expected shape on empty cache", {
  withr::with_options(list(fred.cache_dir = tempfile("fred_cache_")), {
    info <- fred_cache_info()
    expect_type(info, "list")
    expect_true(all(c("dir", "n_files", "size_bytes",
                      "size_human", "files") %in% names(info)))
    expect_equal(info$n_files, 0L)
    expect_equal(info$size_bytes, 0)
    expect_s3_class(info$files, "data.frame")
  })
})

test_that("fred_cache_info reflects cached files", {
  withr::with_options(list(fred.cache_dir = tempfile("fred_cache_")), {
    dir.create(getOption("fred.cache_dir"), recursive = TRUE,
               showWarnings = FALSE)
    saveRDS(data.frame(x = 1:10),
            file.path(getOption("fred.cache_dir"), "obs_TEST_lin_avg.rds"))
    info <- fred_cache_info()
    expect_equal(info$n_files, 1L)
    expect_gt(info$size_bytes, 0)
    expect_true(grepl("B|KB|MB", info$size_human))
    expect_true("obs_TEST_lin_avg.rds" %in% info$files$name)
  })
})

test_that("fred_cache_ttl() defaults to 24 hours and rejects bad values", {
  withr::local_options(fred.cache_ttl = NULL)
  expect_equal(fred_cache_ttl(), 24)
  withr::local_options(fred.cache_ttl = -1)
  expect_error(fred_cache_ttl(), "non-negative")
  withr::local_options(fred.cache_ttl = "1 day")
  expect_error(fred_cache_ttl(), "non-negative")
})

test_that("a fresh cached series is served without the API", {
  withr::local_options(fred.cache_dir = withr::local_tempdir(),
                       fred.cache_ttl = 24)
  withr::local_envvar(FRED_API_KEY = "")
  cached <- data.frame(date = as.Date("2026-01-01"), series_id = "TEST",
                       value = 1)
  saveRDS(cached, file.path(fred_cache_dir(), "obs_TEST_lin_avg.rds"))
  expect_equal(fred_obs_one("TEST"), cached)
})

test_that("an expired cached series is fetched again", {
  withr::local_options(fred.cache_dir = withr::local_tempdir(),
                       fred.cache_ttl = 0)
  withr::local_envvar(FRED_API_KEY = "")
  saveRDS(data.frame(date = as.Date("2026-01-01"), series_id = "TEST",
                     value = 1),
          file.path(fred_cache_dir(), "obs_TEST_lin_avg.rds"))
  # With no API key, reaching the API is an error: the stale copy was not
  # returned.
  expect_error(fred_obs_one("TEST"))
})
