testthat::context("get_apple_chart_postion")

testthat::test_that("Simple app check returns list", {
  res <- get_apple_chart_postion(979274575, "gb")

  testthat::expect_is(res, "list")
  testthat::expect_is(res$position, "numeric")
  testthat::expect_is(res$category, "character")
  testthat::expect_equal(length(res), 2)
})

testthat::test_that("Check top app gets valid information", {
  res <- get_apple_chart_postion(333903271, "gb")

  testthat::expect_false(is.na(res$position))
  testthat::expect_false(is.na(res$category))
})

testthat::test_that("Non-existent ID returns error", {
  testthat::expect_error(get_apple_chart_postion(1, "gb"))
})

testthat::test_that("Non-existent country returns error", {
  testthat::expect_error(get_apple_chart_postion(1, "gbsdsds"))
})
