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
#' @examples
#' # Look up reviews for Apollo in the UK
#' \dontrun{
#' get_apple_reviews(979274575, "gb")
#' }
#'
#' @export
get_apple_reviews <- function(id, country = "us", all_results = FALSE, page_no = 1) {
  if (nchar(country) != 2) stop("Country must be a 2 digit ISO code")

  url <- glue::glue(
    "https://itunes.apple.com/{country}/rss/customerreviews/page={page_no}/id={id}/sortby=mostrecent/xml"
  )
  req <- httr::GET(url)
  httr::stop_for_status(req)

  res <- httr::content(req, encoding = "UTF-8")
  res <- xml2::xml_children(res)
  entries <- res[xml2::xml_name(res) == "entry"]

  reviews <- lapply(entries, extract_review)

  if (isTRUE(all_results)) {
    while ("next" %in% xml2::xml_attr(res, "rel")) {
      url <- xml2::xml_attr(res[which(xml2::xml_attr(res, "rel") == "next")], "href")

      req <- httr::GET(url)

      res <- httr::content(req, encoding = "UTF-8")
      res <- xml2::xml_children(res)
      entries <- res[xml2::xml_name(res) == "entry"]

      reviews <- append(reviews, lapply(entries, extract_review))

      new_url <- xml2::xml_attr(res[which(xml2::xml_attr(res, "rel") == "next")], "href")
      if (sub("\\?.*", "", url) == sub("\\?.*", "", new_url)) break()
    }
  }

  do.call(rbind, reviews)
}

extract_review <- function(entry) {
  entry_child <- xml2::xml_children(entry)
  child_names <- xml2::xml_name(entry_child)

  data.frame(
    id = as.numeric(xml2::xml_text(entry_child[child_names == "id"])),
    review_time = extract_review_time(xml2::xml_text(entry_child[child_names == "updated"])),
    author = xml2::xml_text(xml2::xml_children(entry_child[child_names == "author"])[1]),
    app_version = xml2::xml_text(entry_child[child_names == "version"]),
    title = xml2::xml_text(entry_child[child_names == "title"]),
    rating = as.numeric(xml2::xml_text(entry_child[child_names == "rating"])),
    review = xml2::xml_text(entry_child[child_names == "content"][1])
  )
}

extract_review_time <- function(x) {
  as.POSIXlt(sub(":(\\d+)$", "\\1", x), tz = "UTC", format = "%Y-%m-%dT%H:%M:%S%z")
}
