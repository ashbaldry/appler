#' Apple Store Search
#'
#' @description
#' Using Apple's iTunes API, will extract the information about a selected
#'
#' @param term The URL-encoded text string you want to search for. For example: \code{jack+johnson}.
#' If using a vector it will search for all terms in one search.
#' @param country The two-letter country code for the store you want to search.
#' For a list of country codes see \url{http://en.wikipedia.org/wiki/\%20ISO_3166-1_alpha-2}
#' @param media \code{Optional} The media type you want to search for. For example: movie. The default is all.
#' @param entity \code{Optional} The type of results you want returned, relative to the specified media type.
#' @param attribute \code{Optional}	The attribute you want to search for in the stores, relative to the specified
#' media type. For example, if you want to search for an artist by name specify
#' \code{entity=allArtist&attribute=allArtistTerm}. In this example, if you search for term=maroon, iTunes
#' returns "Maroon 5" in the search results, instead of all artists who have ever recorded a song with the
#' word "maroon" in the title.
#' @param limit \code{Optional} The number of search results you want the iTunes Store to return between 1 and 200.
#' The default is 50.
#' @param lang \code{Optional} The language, English or Japanese, you want to use when returning search results.
#' @param explicit \code{Optional} A flag indicating whether or not you want to include explicit content
#' in your search results.
#'
#' @return
#' A \code{data.frame} of any results that match the iTunes database.
#'
#' If there were no successful results then it will return \code{NULL}.
#'
#' @examples
#' # Search for all Jack Johnson audio and video content
#' search_apple(term = "jack johnson")
#'
#' # To search for all Jack Johnson audio and video content and return only the first 25 items
#' search_apple(term = "jack johnson", limit = 25)
#'
#' @seealso \url{https://affiliate.itunes.apple.com/resources/documentation/itunes-store-web-service-search-api/}
#'
#' @export
search_apple <- function(term, country = NULL, media = NULL, entity = NULL, attribute = NULL,
                         limit = NULL, lang = c("en_us", "ja_jp"), explicit = c("Yes", "No")) {
  if (!is.null(limit) && !limit %in% seq(200)) stop("Limit must be between 1 and 200")
  if (!is.null(media) && !media %in% media_types) {
    stop(
      "Media (", media, ") is not in list, available options:\n",
      paste(media_types, collapse = ", ")
    )
  }
  if (!is.null(entity)) {
    if (is.null(media)) media <- "all"
    if (!all(entity %in% entities[[media]]))
    stop(
      "Not all entities available for ", media, ", available options:\n",
      paste(entities[[media]], collapse = ", ")
    )
  }
  if (!is.null(attribute)) {
    if (is.null(media)) media <- "all"
    if (!all(attribute %in% attributes[[media]]))
      stop(
        "Not all attributes available for ", media, ", available options:\n",
        paste(attributes[[media]], collapse = ", ")
      )
  }

  lang <- match.arg(lang)
  explicit = match.arg(explicit)

  query <- list(
    term = gsub(" ", "+", paste(term, collapse = "+")),
    country = country,
    media = media,
    entity = paste(entity, collapse = ","),
    attribute = paste(attribute, collapse = ","),
    limit = limit,
    lang = lang,
    explicit = explicit
  )

  req <- httr::GET("https://itunes.apple.com/search", query = query)
  httr::stop_for_status(req)

  res <- jsonlite::fromJSON(httr::content(req))
  if (res$resultCount == 0) NULL else res$results
}

#' Apple Store Lookup
#'
#' @description
#' You can create a lookup request to search for content in the stores based on iTunes IDs, UPCs/EANs,
#' and All Music Guide (AMG) IDs. ID-based lookups are faster and contain fewer false-positive results.
#'
#' @param id The ID of the iTunes entity
#' @param country The two-letter country code for the store you want to search.
#' For a list of country codes see \url{http://en.wikipedia.org/wiki/\%20ISO_3166-1_alpha-2}
#' @param entity \code{Optional} The type of results you want returned, relative to the specified media type.
#' @param limit \code{Optional} The number of search results you want the iTunes Store to return between 1 and 200.
#' The default is 50.
#' @param sort \code{Optional} The order the results are returned, for most recent first select \code{recent}.
#' @param id_type The ID type to lookup, options are:
#' \describe{
#' \item{\code{id}}{The default iTunes ID}
#' \item{\code{amgArtistId}}{AMG Artist ID}
#' \item{\code{amgAlbumId}}{AMG Album ID}
#' \item{\code{upc}}{UPC Album or Video ID}
#' \item{\code{isbn}}{ISB Book ID}
#' }
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
#' lookup_apple(468749, id_type = "amgArtistId")
#'
#' @seealso \url{https://affiliate.itunes.apple.com/resources/documentation/itunes-store-web-service-search-api/}
#'
#' @export
lookup_apple <- function(id, country = NULL, entity = NULL, limit = NULL, sort = NULL, id_type = "id") {
  if (!is.null(limit) && !limit %in% seq(200)) stop("Limit must be between 1 and 200")
  if (!is.null(entity)) {
    if (!all(entity %in% entities[["all"]]))
      stop(
        "Entity is not available, available options:\n",
        paste(entities[["all"]], collapse = ", ")
      )
  }

  query <- list(
    id = paste(id, collapse = ","),
    country = country,
    entity = entity,
    limit = limit,
    sort = sort
  )
  names(query)[1] <- id_type

  req <- httr::GET("https://itunes.apple.com/lookup", query = query)
  httr::stop_for_status(req)

  res <- jsonlite::fromJSON(httr::content(req))
  if (res$resultCount == 0) NULL else res$results
}
