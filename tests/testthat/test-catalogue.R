test_that("fred_catalogue returns a fred_tbl with expected columns", {
  cat <- fred_catalogue()
  expect_s3_class(cat, "fred_tbl")
  expect_s3_class(cat, "data.frame")
  expect_true(all(c("id", "title", "frequency", "units", "category",
                    "description") %in% names(cat)))
  expect_gt(nrow(cat), 40L)
})

test_that("fred_catalogue filters by category", {
  inf <- fred_catalogue(category = "Inflation")
  expect_true(all(inf$category == "Inflation"))
  expect_gt(nrow(inf), 0L)
})

test_that("fred_catalogue filters by multiple categories", {
  pair <- fred_catalogue(category = c("Inflation", "Employment"))
  expect_true(all(pair$category %in% c("Inflation", "Employment")))
  expect_gt(nrow(pair), 5L)
})

test_that("fred_catalogue free-text query is case-insensitive", {
  upper <- fred_catalogue(query = "MORTGAGE")
  lower <- fred_catalogue(query = "mortgage")
  expect_equal(nrow(upper), nrow(lower))
  expect_gt(nrow(upper), 0L)
})

test_that("fred_catalogue rejects unknown categories", {
  expect_error(fred_catalogue(category = "Unknown"), "Unknown")
})

test_that("fred_catalogue rejects non-character query", {
  expect_error(fred_catalogue(query = 42), "single character")
})

test_that("fred_catalogue empty filter returns empty fred_tbl", {
  empty <- fred_catalogue(query = "qqxxz_no_match")
  expect_s3_class(empty, "fred_tbl")
  expect_equal(nrow(empty), 0L)
})

test_that("fred_browse with no args prints top-level categories", {
  out <- capture.output(res <- fred_browse())
  expect_s3_class(res, "fred_tbl")
  expect_true(any(grepl("Money", out)))
  expect_true(any(grepl("National Accounts", out)))
})

test_that("fred_browse top-level data has the correct shape", {
  out <- fred:::.fred_top_categories()
  expect_s3_class(out, "data.frame")
  expect_equal(nrow(out), 8L)
  expect_true(all(c("id", "name") %in% names(out)))
})

test_that("fred_browse rejects bad arguments", {
  expect_error(fred_browse(category_id = NA), "single integer")
  expect_error(fred_browse(category_id = 1L, depth = 0L), "positive integer")
})
