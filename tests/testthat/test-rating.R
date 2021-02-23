testthat::context("get_apple_rating_split")

testthat::test_that("Simple ratings search returns data.frame", {
  res <- get_apple_rating_split(979274575, "gb")

  testthat::expect_is(res, "data.frame")
  testthat::expect_equal(nrow(res), 5)
})

testthat::test_that("Non-existent ID returns error", {
  testthat::expect_error(get_apple_rating_split(1, "gb"))
})

testthat::test_that("Non-existent country returns error", {
  testthat::expect_error(get_apple_rating_split(1, "gbsdsds"))
})
