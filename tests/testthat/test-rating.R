skip_if_offline("apps.apple.com")
# Reference: App ID 979274575 is Apollo for Reddit

test_that("Simple ratings search returns data.frame", {
  res <- tryCatch(
    get_apple_rating_split(979274575, "gb"),
    error = function(e) NULL
  )

  skip_if(
    is.null(res),
    "App may no longer be available in the App Store"
  )

  expect_s3_class(res, "data.frame")
  expect_identical(nrow(res), 5L)
})

test_that("Non-existent ID returns error", {
  expect_error(get_apple_rating_split(1, "gb"))
})

test_that("Non-existent country returns error", {
  expect_error(get_apple_rating_split(1, "gbsdsds"))
})
