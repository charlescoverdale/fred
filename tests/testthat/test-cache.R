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
