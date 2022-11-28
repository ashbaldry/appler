#' Apple App Store Reviews
#'
#' @description
#' Using Apple's RSS feed, will extract the reviews from a specific country for the desired application.
#'
#' @param id The ID of the App on the Apple App Store
#' @param country The two-letter country code for the store you want to search.
#' For a list of country codes see \url{https://en.wikipedia.org/wiki/ISO_3166-1_alpha-2}
#' @param all_results Logical, would you like all possible reviews to be pulled?
#' @param page_no If \code{page_no = FALSE} then the page of reviews to pull. Defaults to most recent.
#'
#' @return
#' A \code{data.frame} of the extracted reviews.
#'
#' If there were no reviews then it will return \code{NULL}.
#'
#' @details
#' There is a maximum of 500 reviews that can be pulled.
#'
#' @examplesIf interactive()
#' # Search for the app
#' github_app <- search_apple("GitHub", "gb", media = "software")
#'
#' # Look up reviews for GitHub in the UK
#' get_apple_reviews(1477376905, "gb")
#'
#' @export
get_apple_reviews <- function(id, country = "us", all_results = FALSE, page_no = 1) {
  if (nchar(country) != 2) stop("Country must be a 2 digit ISO code")

  url <- sprintf(
    "https://itunes.apple.com/%s/rss/customerreviews/page=%s/id=%s/sortby=mostrecent/json",
    country,
    page_no,
    id
  )
  req <- httr::GET(url)
  httr::stop_for_status(req)

  res <- httr::content(req, encoding = "UTF-8")
  res <- jsonlite::fromJSON(res, simplifyDataFrame = FALSE)
  reviews <- lapply(res$feed$entry, extract_review)

  if (isTRUE(all_results)) {
    links <- res$feed$link
    link_types <- vapply(links, function(x) x$attributes$rel, character(1))

    while ("next" %in% link_types) {
      url <- links[[which(link_types == "next")]]$attributes$href
      url <- sub("xml?", "json?", url, fixed = TRUE)

      req <- httr::GET(url)

      res <- httr::content(req, encoding = "UTF-8")
      res <- jsonlite::fromJSON(res, simplifyDataFrame = FALSE)
      reviews <- append(reviews, lapply(res$feed$entry, extract_review))

      links <- res$feed$link
      link_types <- vapply(links, function(x) x$attributes$rel, character(1))

      new_url <- links[[which(link_types == "next")]]$attributes$href
      if (sub("\\w+\\?.*", "", url) == sub("\\w+\\?.*", "", new_url)) break()
    }
  }

  do.call(rbind, reviews)
}

extract_review <- function(entry) {
  data.frame(
    id = as.numeric(entry$id$label),
    review_time = extract_review_time(entry$updated$label),
    author = entry$author$name$label,
    app_version = entry[["im:version"]]$label,
    title = entry$title$label,
    rating = as.numeric(entry[["im:rating"]]$label),
    review = entry$content$label
  )
}

extract_review_time <- function(x) {
  as.POSIXlt(sub(":(\\d+)$", "\\1", x), tz = "UTC", format = "%Y-%m-%dT%H:%M:%S%z")
}
