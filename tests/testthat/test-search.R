testthat::context("search_apple")

testthat::test_that("Simple term search returns data.frame", {
  res <- search_apple("Jack Johnson")

  testthat::expect_is(res, "data.frame")
  testthat::expect_equal(res$artistName[1], "Jack Johnson")
})

testthat::test_that("Pulling the top 25 results with specified country from a search returns data.frame", {
  res <- search_apple("Jack Johnson", "gb", limit = 25)

  testthat::expect_is(res, "data.frame")
  testthat::expect_equal(nrow(res), 25)
  testthat::expect_equal(res$artistName[1], "Jack Johnson")
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

