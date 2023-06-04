skip_if_offline("apps.apple.com")

test_that("Simple ID search returns data.frame", {
  res <- tryCatch(
    lookup_apple(909253),
    error = function(e) NULL
  )

  skip_if(
    is.null(res),
    "Artist may no longer be available in iTunes"
  )

  expect_s3_class(res, "data.frame")
  expect_identical(nrow(res), 1L)
  expect_identical(res$artistName, "Jack Johnson")
})

test_that("Non-Apple ID search provides results", {
  res <- tryCatch(
    lookup_apple(468749, id_type = "amgArtistId"),
    error = function(e) NULL
  )

  skip_if(
    is.null(res),
    "Artist may no longer be available in iTunes"
  )

  expect_is(res, "data.frame")
  expect_identical(nrow(res), 1L)
  expect_identical(res$artistName, "Jack Johnson")
})

test_that("ISBN ID search provides results", {
  res <- tryCatch(
    lookup_apple(9780316069359, id_type = "isbn"),
    error = function(e) NULL
  )

  skip_if(
    is.null(res),
    "Artist may no longer be available in iTunes"
  )

  expect_s3_class(res, "data.frame")
  expect_identical(nrow(res), 1L)
  expect_identical(res$artistName, "Michael Connelly")
})

test_that("Pulling the top 5 albums for 2 artists returns data.frame", {
  res <- tryCatch(
    lookup_apple(c(468749, 5723), country = "gb", entity = "album", limit = 5, id_type = "amgArtistId"),
    error = function(e) NULL
  )

  skip_if(
    is.null(res),
    "Artists may no longer be available in iTunes"
  )

  expect_s3_class(res, "data.frame")
  expect_true(any(res$artistName == "Jack Johnson", na.rm = TRUE))
})

test_that("Non-existent ID returns `NULL`", {
  res <- lookup_apple(1)

  expect_null(res)
})
