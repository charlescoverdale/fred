test_that("fred_set_key stores and fred_get_key retrieves", {
  env <- getFromNamespace("fred_env", "fred")
  old <- env$api_key
  on.exit(env$api_key <- old)

  fred_set_key("test_key_123")
  expect_equal(fred_get_key(), "test_key_123")
})

test_that("fred_set_key rejects bad input", {
  expect_error(fred_set_key(123))
  expect_error(fred_set_key(""))
  expect_error(fred_set_key(c("a", "b")))
})

test_that("fred_get_key errors when no key set", {
  env <- getFromNamespace("fred_env", "fred")
  old <- env$api_key
  on.exit(env$api_key <- old)

  env$api_key <- NULL
  withr::with_envvar(c(FRED_API_KEY = ""), {
    expect_error(fred_get_key(), "No FRED API key found")
  })
})

test_that("fred_get_key reads FRED_API_KEY env var", {
  env <- getFromNamespace("fred_env", "fred")
  old <- env$api_key
  on.exit(env$api_key <- old)

  env$api_key <- NULL
  withr::with_envvar(c(FRED_API_KEY = "env_key_456"), {
    expect_equal(fred_get_key(), "env_key_456")
  })
})
