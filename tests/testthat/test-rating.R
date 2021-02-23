testthat::context("get_apple_rating_split")

testthat::test_that("Simple ratings search returns data.frame", {
  res <- get_apple_rating_split(979274575, "gb")

  testthat::expect_is(res, "data.frame")
  testthat::expect_equal(nrow(res), 5)
})

testthat::test_that("Non-existent ID returns `NULL`", {
  res <- lookup_apple(1, "gb")

  testthat::expect_null(res)
})

testthat::test_that("Non-existent country returns error", {
  testthat::expect_error(lookup_apple(1, "gbsdsds"))
})
