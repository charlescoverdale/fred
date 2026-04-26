make_tbl <- function(name = "GDPC1", n = 12L) {
  d <- seq(as.Date("2020-01-01"), by = "quarter", length.out = n)
  new_fred_tbl(
    data.frame(date = d, series_id = name, value = seq_len(n) + 0.0),
    query = list(series_id = name, units = "lin", frequency = "q")
  )
}

# ---- fred_manifest --------------------------------------------------------

test_that("fred_manifest returns a fred_manifest character object", {
  m <- fred_manifest(gdp = make_tbl("GDPC1"))
  expect_s3_class(m, "fred_manifest")
  expect_match(unclass(m)[1L], "FRED manifest")
  expect_match(unclass(m), "n_objects: 1", all = FALSE)
  expect_match(unclass(m), "name: gdp", all = FALSE)
  expect_match(unclass(m), "md5:", all = FALSE)
})

test_that("fred_manifest accepts multiple objects positionally", {
  m <- fred_manifest(make_tbl("A"), make_tbl("B"))
  expect_match(unclass(m), "n_objects: 2", all = FALSE)
  expect_match(unclass(m), "name: obj_1", all = FALSE)
  expect_match(unclass(m), "name: obj_2", all = FALSE)
})

test_that("fred_manifest accepts a list", {
  m <- fred_manifest(list(gdp = make_tbl("A"), un = make_tbl("B")))
  expect_match(unclass(m), "name: gdp", all = FALSE)
  expect_match(unclass(m), "name: un", all = FALSE)
})

test_that("fred_manifest writes to file when path given", {
  tf <- tempfile(fileext = ".yml")
  on.exit(unlink(tf), add = TRUE)
  res <- fred_manifest(x = make_tbl(), file = tf)
  expect_true(file.exists(tf))
  text <- readLines(tf)
  expect_match(paste(text, collapse = "\n"), "FRED manifest")
  expect_s3_class(res, "fred_manifest")
})

test_that("fred_manifest hash is deterministic for identical inputs", {
  a <- make_tbl("X")
  b <- make_tbl("X")
  ma <- unclass(fred_manifest(a))
  mb <- unclass(fred_manifest(b))
  # Extract the md5 line; created/timestamp will differ
  hash_a <- grep("md5:", strsplit(ma, "\n")[[1L]], value = TRUE)
  hash_b <- grep("md5:", strsplit(mb, "\n")[[1L]], value = TRUE)
  expect_equal(hash_a, hash_b)
})

test_that("fred_manifest hash changes for different inputs", {
  a <- make_tbl("X")
  b <- make_tbl("Y")
  ha <- grep("md5:", strsplit(unclass(fred_manifest(a)), "\n")[[1L]],
             value = TRUE)
  hb <- grep("md5:", strsplit(unclass(fred_manifest(b)), "\n")[[1L]],
             value = TRUE)
  expect_false(identical(ha, hb))
})

test_that("fred_manifest validates inputs", {
  expect_error(fred_manifest(), "at least one object")
  expect_error(fred_manifest("not_a_df"), "must be data frames")
})

test_that("fred_manifest print returns invisibly", {
  m <- fred_manifest(make_tbl())
  out <- capture.output(p <- print(m))
  expect_s3_class(p, "fred_manifest")
  expect_true(any(grepl("FRED manifest", out)))
})

# ---- fred_vintage_revisions -----------------------------------------------

test_that("fred_vintage_revisions validates inputs", {
  expect_error(fred_vintage_revisions(c("A", "B")), "single character")
  expect_error(fred_vintage_revisions(123), "single character")
})

test_that("fred_vintage_revisions returns expected structure (live)", {
  skip_if(Sys.getenv("FRED_API_KEY") == "", "FRED_API_KEY not set")
  withr::with_options(list(fred.cache_dir = tempdir()), {
    rev <- fred_vintage_revisions("GDPC1", from = "2020-01-01")
    expect_s3_class(rev, "fred_tbl")
    expect_true(all(c("series_id", "date", "n_vintages", "first_value",
                      "final_value", "revision_total", "revision_total_pct",
                      "revision_mean", "revision_sd", "days_to_final") %in%
                    names(rev)))
    expect_gt(nrow(rev), 0L)
  })
})
