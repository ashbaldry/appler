testthat::context("search_apple")

testthat::test_that("Simple term search returns data.frame", {
  res <- search_apple("Jack Johnson")

  testthat::expect_is(res, "data.frame")
  testthat::expect_equal(res$artistName[1], "Jack Johnson")
})

testthat::test_that("Simple term search with specified country returns data.frame", {
  res <- search_apple(c("Jack", "Johnson"), "GB")

  testthat::expect_is(res, "data.frame")
  testthat::expect_equal(res$artistName[1], "Jack Johnson")
})

testthat::test_that("Pulling the top 25 results from a search returns data.frame", {
  res <- search_apple("Jack Johnson", limit = 25)

  testthat::expect_is(res, "data.frame")
  testthat::expect_equal(nrow(res), 25)
  testthat::expect_equal(res$artistName[1], "Jack Johnson")
})

testthat::test_that("Non-existent term returns `NULL`", {
  res <- search_apple("fdjksdgjdsknjfkcdzsjdgnfkmsdnjfdksd")

  testthat::expect_null(res)
})

