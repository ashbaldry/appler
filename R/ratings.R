#' Apple App Store Ratings
#'
#' @description
#' Scrapes the App store page and retrieves the split of the ratings between 1 and 5 stars
#'
#' @param id The ID of the App on the Apple App Store
#' @param country The two-letter country code for the store you want to search.
#' For a list of country codes see \url{https://en.wikipedia.org/wiki/ISO_3166-1_alpha-2}
#'
#' @details
#' For overall rating and count, use \code{\link{lookup_apple}}
#'
#' @return A 5 row data.frame with the split of 1-5 stars given rounded to the nearest percent
#'
#' @examplesIf interactive()
#' # Search for GitHub in App Store in the UK
#' country_id <- "gb"
#' github_search_results <- search_apple(
#'   term = "GitHub",
#'   country = country_id,
#'   media = "software"
#' )
#'
#' # Look up app store rating split for GitHub in the UK
#' # (App ID found in trackId column of github_search_results)
#' get_apple_rating_split(1477376905, country_id)
#'
#' @export
get_apple_rating_split <- function(id, country = "us") {
  if (nchar(country) != 2) stop("Country must be a 2 digit ISO code")

  url <- sprintf("https://apps.apple.com/%s/app/id%s", country, id)
  req <- httr::GET(url)
  httr::stop_for_status(req)

  res <- httr::content(req)

  ovr_parent <- rvest::html_node(res, ".we-customer-ratings__averages__display")
  ovr_rating <- as.numeric(sub(",", ".", rvest::html_text(ovr_parent)))

  rating_bars <- rvest::html_nodes(res, ".we-star-bar-graph__row")
  rating_vals <- lapply(rating_bars, function(x) {
    rating <- rvest::html_attr(rvest::html_children(x)[1], "class")
    rating <- as.numeric(substr(rating, nchar(rating), nchar(rating)))
    if (is.na(rating)) rating <- 1

    perc <- rvest::html_node(x, ".we-star-bar-graph__bar__foreground-bar")
    perc <- as.numeric(gsub(".*?(\\d+).*", "\\1", rvest::html_attr(perc, "style"))) / 100

    data.frame(rating = rating, percent = perc)
  })

  do.call(rbind, rating_vals)
}
