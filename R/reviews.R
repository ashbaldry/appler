#' Apple App Store Reviews
#'
#' @description
#' Using Apple's RSS feed, extract the most recent or helpful reviews for a specific application.
#'
#' @details
#' There is a limitation in Apple's RSS feed that means only the 500 most recent/helpful reviews
#' can be pulled. There are 10 pages of results from the RSS feed, each one containing 50 reviews.
#' It is recommended to periodically store reviews in a database or other storage system to track
#' the older reviews.
#'
#' @param id The ID of the App on the Apple App Store. Either found by using \code{\link{search_apple}},
#' or available in the URL of the app to pull reviews from. For example, GitHub's App ID is \code{1477376903},
#' as seen in its URL: \url{https://apps.apple.com/gb/app/id1477376905}
#' @param country The two-letter country code for the store you want to search.
#' For a list of country codes see \url{https://en.wikipedia.org/wiki/ISO_3166-1_alpha-2}
#' @param all_results Logical, would you like all possible reviews to be pulled? By default set to
#' \code{FALSE}
#' @param page_no If \code{page_no = FALSE} then the page of reviews to pull. Defaults to most recent.
#' @param sort_by Which order should the reviews be pulled? There are currently two possible options:
#' \describe{
#' \item{\code{"mostrecent"}}{Sorts by the time reviews are posted and pulls the most recently posted reviews}
#' \item{\code{"mosthelpful"}}{Sorts the reviews by usefulness and returns the most useful posts. For larger
#' apps, the top 500 may not match the top 500 most recent}
#' }
#'
#' @return
#' A \code{data.frame} of the extracted reviews, containing:
#' \itemize{
#' \item{\code{id}}{The reveiw ID}
#' \item{\code{review_time}}{The time the review was posted on the App Store}
#' \item{\code{author}}{The username of the reviewer}
#' \item{\code{app_version}}{The version of the application that was installed when reviewing the application}
#' \item{\code{title}}{Title summary of the review}
#' \item{\code{rating}}{The rating (out of 5) given to the application}
#' \item{\code{review}}{The text of the review}
#' }
#'
#' If there were no reviews then it will return \code{NULL}.
#'
#' @examplesIf interactive()
#' # Search for GitHub in App Store in UK
#' country_id <- "gb"
#' github_search_results <- search_apple(
#'   term = "GitHub",
#'   country = country_id,
#'   media = "software"
#' )
#'
#' # Look up reviews for GitHub
#' # (id found in github_search_results)
#' get_apple_reviews(1477376905, country_id)
#'
#' @export
get_apple_reviews <- function(id, country = "us", all_results = FALSE, page_no = 1,
                              sort_by = c("mostrecent", "mosthelpful")) {
  if (nchar(country) != 2) stop("Country must be a 2 digit ISO code")
  if (!is.numeric(page_no) || page_no < 1 || page_no > 10) stop("Page number must be between 1 and 10")
  sort_by <- match.arg(sort_by)

  url <- sprintf(
    "https://itunes.apple.com/%s/rss/customerreviews/page=%s/id=%s/sortby=%s/json",
    country,
    page_no,
    id,
    sort_by
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
