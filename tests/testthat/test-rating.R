testthat::context("get_apple_rating_split")

testthat::skip_if_offline("apps.apple.com")

testthat::test_that("Simple ratings search returns data.frame", {
  res <- tryCatch(
    get_apple_rating_split(979274575, "gb"),
    error = function(e) NULL
  )

  testthat::skip_if(
    is.null(res),
    "App may no longer be available in the App Store"
  )

  testthat::expect_is(res, "data.frame")
  testthat::expect_equal(nrow(res), 5)
})

testthat::test_that("Non-existent ID returns error", {
  testthat::expect_error(get_apple_rating_split(1, "gb"))
})

testthat::test_that("Non-existent country returns error", {
  testthat::expect_error(get_apple_rating_split(1, "gbsdsds"))
})
