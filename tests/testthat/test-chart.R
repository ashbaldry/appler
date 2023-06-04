skip_if_offline("apps.apple.com")
# Reference: App ID 979274575 is Apollo for Reddit

test_that("Simple app check returns list", {
  res <- tryCatch(
    get_apple_chart_postion(979274575, "gb"),
    error = function(e) NULL
  )

  skip_if(
    is.null(res),
    "App may no longer be available in the App Store"
  )

  expect_type(res, "list")
  expect_named(res, c("position", "category"))
  expect_type(res$position, "double")
  expect_type(res$category, "character")
})

test_that("Non-existent ID returns error", {
  expect_error(get_apple_chart_postion(1, "gb"))
})

test_that("Non-existent country returns error", {
  expect_error(get_apple_chart_postion(1, "gbsdsds"))
})
