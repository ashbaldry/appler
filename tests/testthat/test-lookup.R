testthat::context("lookup_apple_info")

testthat::test_that("Simple ID Search Return data.frame", {
  res <- lookup_apple(909253)

  testthat::expect_is(res, "data.frame")
  testthat::expect_equal(nrow(res), 1)
})

testthat::test_that("Simple ID Search Return data.frame", {
  res <- lookup_apple(1)

  testthat::expect_null(res)
})
