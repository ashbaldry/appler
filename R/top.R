#' Check App Chart
#'
#' @description
#' \code{get_apple_chart_postion} searches for whether an App is within the top 100 for any category (generally found
#'  on the App page).
#'
#' @param id The ID of the App on the Apple App Store
#' @param country The two-letter country code for the store you want to search.
#' For a list of country codes see \url{http://en.wikipedia.org/wiki/\%20ISO_3166-1_alpha-2}
#'
#' @return A list of two, containing the position and the category of the App if available. Otherwise both will be \code{NA}
#'
#' @examples
#' # Look up ratings split for Apollo in the UK
#' get_apple_chart_postion(979274575, "gb")
#'
#' @export
get_apple_chart_postion <- function(id, country) {
  if (nchar(country) != 2) stop("Country must be a 2 digit ISO code")

  req <- httr::GET(glue::glue("https://apps.apple.com/{country}/app/id{id}"))
  httr::stop_for_status(req)

  res <- httr::content(req)

  position_parent <- rvest::html_node(res, ".app-header__list")
  if (length(rvest::html_children(position_parent)) < 2) {
    return(list(position = NA_real_, category = NA_character_))
  }

  position_text <- rvest::html_text(rvest::html_children(position_parent)[1])

  list(
    position = as.numeric(gsub("[^0-9]+", "\\1", position_text)),
    category = gsub(".*\\d+ [a-zA-Z]+ (\\w+(| \\w+)+)\n.*", "\\1", position_text)
  )
}
