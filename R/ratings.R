#' Apple App Store Ratings
#'
#' @description
#' Scrapes the app page to get the number of ratings, the average rating and the split between
#' 1 and 5 stars
#'
#' @param id The ID of the App on the Apple Store
#' @param country The two-letter country code for the store you want to search.
#' For a list of country codes see \url{http://en.wikipedia.org/wiki/\%20ISO_3166-1_alpha-2}
#'
#' @return A list containing:
#' \describe{
#' \item{\code{ovr_rating}}{The overall rating of the App}
#' \item{\code{n_ratings}}{The number of ratings for the App}
#' \item{\code{proportion}}{The percentage split of ratings}
#' }
#'
#' @export
get_apple_ratings <- function(id, country) {
  req <- httr::GET(paste0("https://apps.apple.com/", country, "/app/id", id))
  httr::http_error(req)

  res <- httr::content(req)

  ovr_parent <- rvest::html_node(res, ".we-customer-ratings__averages__display")
  ovr_rating <- as.numeric(sub(",", ".", rvest::html_text(ovr_parent)))

  rate_parent <- rvest::html_node(res, ".we-customer-ratings__count")
  n_ratings <- sub(" .*", "", rvest::html_text(rate_parent))
  if (grepl("M$", n_ratings)) {
    n_ratings <- as.numeric(sub("M", "", sub("\\.|,", "", n_ratings))) * 1000000
  } else if (grepl("K$", n_ratings)) {
    n_ratings <- as.numeric(sub("K", "", sub("\\.|,", "", n_ratings))) * 1000
  } else {
    n_ratings <- as.numeric(sub("\\.|,", "", n_ratings))
  }

  rating_bars <- rvest::html_nodes(res, ".we-star-bar-graph__row")
  rating_vals <- lapply(rating_bars, function(x) {
    rating <- rvest::html_attr(rvest::html_children(x)[1], "class")
    rating <- as.numeric(substr(rating, nchar(rating), nchar(rating)))
    if (is.na(rating)) rating <- 1

    perc <- rvest::html_node(x, ".we-star-bar-graph__bar__foreground-bar")
    perc <- as.numeric(gsub(".*?(\\d+).*", "\\1", rvest::html_attr(perc, "style"))) / 100

    data.frame(rating = rating, percent = perc)
  })

  ratings <- list(
    ovr_rating = ovr_rating,
    n_ratings = n_ratings,
    proportion = do.call(rbind, rating_vals)
  )
}
