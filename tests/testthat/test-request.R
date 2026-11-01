test_that("an HTTP 400 is reported with FRED's own explanation", {
  skip_if_not(utils::packageVersion("httr2") >= "1.1.0")
  withr::local_envvar(FRED_API_KEY = "abcdef1234567890abcdef1234567890")
  httr2::local_mocked_responses(function(req) {
    httr2::response(
      status_code = 400L,
      headers = list(`Content-Type` = "application/json"),
      body = charToRaw(paste0(
        '{"error_code":400,',
        '"error_message":"Bad Request.  The series does not exist."}'
      ))
    )
  })
  expect_error(fred_request("series", series_id = "NOTASERIES"),
               "The series does not exist")
})

test_that("an HTTP error is not reported as a connection failure", {
  skip_if_not(utils::packageVersion("httr2") >= "1.1.0")
  withr::local_envvar(FRED_API_KEY = "abcdef1234567890abcdef1234567890")
  httr2::local_mocked_responses(function(req) {
    httr2::response(status_code = 404L)
  })
  err <- tryCatch(fred_request("series", series_id = "GDP"),
                  error = function(e) conditionMessage(e))
  expect_match(err, "HTTP 404")
  expect_no_match(err, "Failed to connect")
})
