#' Check App Chart
#'
#' @description
#' Search for whether an application is currently in the top 100 applications of any category
#' on the Apple App Store
#'
#' @inheritParams get_apple_chart_postion
#'
#' @return
#' A list of two, containing the position and the category of the App if available.
#'
#' If the application is not in the charts then both fields will return as \code{NA}
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
#' # Look up chart position for GitHub in the UK
#' # (App ID found in trackId column of github_search_results)
#' get_apple_chart_postion(1477376905, "gb")
#'
#' @export
get_apple_chart_postion <- function(id, country) {
  if (nchar(country) != 2) stop("Country must be a 2 digit ISO code")

  url <- sprintf("https://apps.apple.com/%s/app/id%s", country, id)
  req <- httr::GET(url)
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
