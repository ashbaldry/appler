testthat::context("lookup_apple")

testthat::test_that("Simple ID search returns data.frame", {
  res <- lookup_apple(909253)

  testthat::expect_is(res, "data.frame")
  testthat::expect_equal(nrow(res), 1)
  testthat::expect_equal(res$artistName, "Jack Johnson")
})

testthat::test_that("Simple ID search with specified country returns data.frame", {
  res <- lookup_apple(909253, "GB")

  testthat::expect_is(res, "data.frame")
  testthat::expect_equal(nrow(res), 1)
  testthat::expect_equal(res$artistName, "Jack Johnson")
})

testthat::test_that("Non-Apple ID search provides results", {
  res <- lookup_apple(468749, id_type = "amgArtistId")

  testthat::expect_is(res, "data.frame")
  testthat::expect_equal(nrow(res), 1)
  testthat::expect_equal(res$artistName, "Jack Johnson")
})

testthat::test_that("ISBN ID search provides results", {
  res <- lookup_apple(9780316069359, id_type = "isbn")

  testthat::expect_is(res, "data.frame")
  testthat::expect_equal(nrow(res), 1)
  testthat::expect_equal(res$artistName, "Michael Connelly")
})

testthat::test_that("Pulling the top 5 albums for 2 artists returns data.frame", {
  res <- lookup_apple(c(468749, 5723), entity = "album", limit = 5, id_type = "amgArtistId")

  testthat::expect_is(res, "data.frame")
  # 1 row for each artist, 5 albums per artist
  testthat::expect_equal(nrow(res), 12)
  testthat::expect_equal(res$artistName[1], "Jack Johnson")
})

testthat::test_that("Non-existent ID returns `NULL`", {
  res <- lookup_apple(1)

  testthat::expect_null(res)
})

