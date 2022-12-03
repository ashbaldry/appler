#' iTunes Artists
#'
#' @description
#' A small dataset containing current artists available on iTunes with
#' a corresponding ID that can be used in {appler} functions.
#'
#' To see more information about the artist online, you can add the following
#' URL in your browser: music.apple.com/artist/<id> where <id> is the `artist_id`
#' column
#'
#' @format
#' A data frame with 2 columns and 10 rows
#' \describe{
#' \item{artist}{Artist name}
#' \item{artist_id}{Apple ID of the artist}
#' }
#'
#' @examplesIf interactive()
#' # Get information about Microsoft Teams
#' lizzo <- itunes_artists[itunes_artists$artist == "Lizzo", ]
#' lizzo_id <- lizzo$artist_id
#' lizzo_name <- lizzo$artist
#'
#' # Search for artist by name, can find the ID from this query
#' search_apple(term = lizzo_name, country = "ca", lang = "en")
#'
#' # Get information about the artist
#' lookup_apple(id = lizzo_id, country = "ca", sort = "recent")
#'
#' @source <https://music.apple.com>
"itunes_artists"

#' Apple App Store Applications
#'
#' @description
#' A dataset containing a selection of apps available on the Apple App Store
#' with a corresponding ID that can be used in {appler} functions.
#'
#' To see more information about the application online, you can add the following
#' URL in your browser: apps.apple.com/app/id<id> where <id> is the `app_id`
#' column
#'
#' @details
#' All of the applications in this table are available in Canada (`country_id = "ca"`)
#' at the time of writing (2022-12-03), however they might not be available in all countries,
#' or have a different application name.
#'
#' @format
#' A data frame with 2 columns and 202 rows
#' \describe{
#' \item{app_name}{Application name}
#' \item{app_id}{Apple ID of the application}
#' }
#'
#' @examplesIf interactive()
#' # Get information about Microsoft Teams
#' teams <- apple_apps[apple_apps$app_name == "Microsoft Teams", "app_id"]
#'
#' # Search for any other apps
#' search_apple(term = "Microsoft Teams", country = "ca", media = "software")
#'
#' # General application information including average rating
#' lookup_apple(teams, country = "ca")
#'
#' # Latest application reviews
#' get_apple_reviews(teams, country = "ca")
#'
#' # Current position on App store
#' get_apple_chart_postion(teams, country = "ca")
#'
#' @source <https://apps.apple.com>
"apple_apps"
