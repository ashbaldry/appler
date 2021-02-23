testthat::context("get_apple_reviews")

testthat::test_that("Simple reviews search returns data.frame", {
  res <- get_apple_reviews(979274575, "gb")

  testthat::expect_is(res, "data.frame")
  testthat::expect_equal(nrow(res), 50)
})

testthat::test_that("Multi page reviews search returns data.frame", {
  res <- get_apple_reviews(979274575, "gb", all_results = TRUE)

  testthat::expect_is(res, "data.frame")
  testthat::expect_equal(nrow(res), 500)
})

testthat::test_that("Non-existent ID returns `NULL`", {
  res <- get_apple_reviews(1, "gb")

  testthat::expect_null(res)
})

testthat::test_that("Non-existent country returns error", {
  testthat::expect_error(get_apple_reviews(1, "gbsdsds"))
})
