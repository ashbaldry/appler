testthat::context("search_apple")

testthat::skip_if_offline("apps.apple.com")

testthat::test_that("Simple term search returns data.frame", {
  res <- tryCatch(
    search_apple("Jack Johnson"),
    error = function(e) NULL
  )

  testthat::skip_if(
    is.null(res),
    "iTunes search function has changed/is no longer available"
  )

  testthat::expect_is(res, "data.frame")
  testthat::expect_true(any(res$artistName == "Jack Johnson", na.rm = TRUE))
})

testthat::test_that("Pulling the top 25 results with specified country from a search returns data.frame", {
  res <- tryCatch(
    search_apple("Jack Johnson", "gb", limit = 25),
    error = function(e) NULL
  )

  testthat::skip_if(
    is.null(res),
    "iTunes search function has changed/is no longer available"
  )

  testthat::expect_is(res, "data.frame")
  testthat::expect_equal(nrow(res), 25)
  testthat::expect_true(any(res$artistName == "Jack Johnson", na.rm = TRUE))
})

testthat::test_that("Invalid limit returns error", {
  testthat::expect_error(search_apple("Jack Johnson", limit = 500))
})

testthat::test_that("Invalid media returns error", {
  testthat::expect_error(search_apple("Jack Johnson", media = "fdhjkfd"))
})

testthat::test_that("Invalid attribute returns error", {
  testthat::expect_error(search_apple("Jack Johnson", attribute = "fdhjkfd"))
})

testthat::test_that("Non-existent term returns `NULL`", {
  testthat::expect_null(search_apple("fdjksdgjdsknjfkcdzsjdgnfkmsdnjfdksd"))
})

