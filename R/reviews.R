#' Apple Store Reviews
#'
#' @description
#' Using Apple's iTunes API, will extract the information about a selected
#'
#' @param id The ID of the iTunes entity
#' @param country The two-letter country code for the store you want to search.
#' For a list of country codes see \url{http://en.wikipedia.org/wiki/\%20ISO_3166-1_alpha-2}
#'
#' @return
#' A \code{data.frame} of any results that match the iTunes database.
#'
#' If there were no successful results then it will return \code{NULL}.
#'
#' @examples
#' # Look up Jack Johnson by iTunes artist ID
#' lookup_apple(909253)
#'
#' # Look up Jack Johnson by AMG artist ID
#' lookup_apple(468749, "amgArtistId")
#'
#' @seealso \url{https://affiliate.itunes.apple.com/resources/documentation/itunes-store-web-service-search-api/}
#'
#' @export
get_apple_reviews <- function(id, country = "us") {
}
