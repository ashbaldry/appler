skip_if_offline("apps.apple.com")

test_that("Simple term search returns data.frame", {
  res <- tryCatch(
    search_apple("Jack Johnson"),
    error = function(e) NULL
  )

  skip_if(
    is.null(res),
    "iTunes search function has changed/is no longer available"
  )

  expect_s3_class(res, "data.frame")
  expect_true(any(res$artistName == "Jack Johnson", na.rm = TRUE))
})

test_that("Pulling the top 25 results with specified country from a search returns data.frame", {
  res <- tryCatch(
    search_apple("Jack Johnson", "gb", limit = 25),
    error = function(e) NULL
  )

  skip_if(
    is.null(res),
    "iTunes search function has changed/is no longer available"
  )

  expect_s3_class(res, "data.frame")
  expect_identical(nrow(res), 25L)
  expect_true(any(res == "Jack Johnson", na.rm = TRUE))
})

test_that("Invalid limit returns error", {
  expect_error(search_apple("Jack Johnson", limit = 500))
})

test_that("Invalid media returns error", {
  expect_error(search_apple("Jack Johnson", media = "fdhjkfd"))
})

test_that("Invalid attribute returns error", {
  expect_error(search_apple("Jack Johnson", attribute = "fdhjkfd"))
})

test_that("Non-existent term returns `NULL`", {
  expect_null(search_apple("fdjksdgjdsknjfkcdzsjdgnfkmsdnjfdksd"))
})
