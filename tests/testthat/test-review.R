skip_if_offline("apps.apple.com")
# Reference: App ID 979274575 is Apollo for Reddit

test_that("Simple reviews search returns data.frame", {
  res <- tryCatch(
    get_apple_reviews(979274575, "gb"),
    error = function(e) NULL
  )

  skip_if(
    is.null(res),
    "App may no longer be available in the App Store"
  )

  expect_s3_class(res, "data.frame")
})

test_that("Reviews can pull by most helpful", {
  res_recent <- tryCatch(
    get_apple_reviews(979274575, "gb"),
    error = function(e) NULL
  )

  res_helpful <- tryCatch(
    get_apple_reviews(979274575, "gb", sort_by = "mosthelpful"),
    error = function(e) NULL
  )

  skip_if(
    is.null(res_helpful),
    "App may no longer be available in the App Store"
  )

  expect_is(res_helpful, "data.frame")
  expect_false(identical(res_recent, res_helpful))
  expect_lte(min(res_helpful$review_time), min(res_recent$review_time))
})

test_that("Multi page reviews search returns data.frame", {
  res <- tryCatch(
    get_apple_reviews(979274575, "gb", all_results = TRUE),
    error = function(e) NULL
  )

  skip_if(
    is.null(res),
    "App may no longer be available in the App Store"
  )

  expect_is(res, "data.frame")
  expect_identical(nrow(res), 500L)
})

test_that("Non-existent ID returns `NULL`", {
  res <- get_apple_reviews(1, "gb")
  expect_null(res)
})

test_that("Non-existent country returns error", {
  expect_error(get_apple_reviews(1, "gbsdsds"))
})
