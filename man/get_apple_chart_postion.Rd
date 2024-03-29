% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/top.R
\name{get_apple_chart_postion}
\alias{get_apple_chart_postion}
\title{Apple App Store Chart Position}
\usage{
get_apple_chart_postion(id, country)
}
\arguments{
\item{id}{The ID of the App on the Apple App Store. Either found by using \code{\link{search_apple}},
or available in the URL of the app to pull reviews from. For example, GitHub's App ID is \code{1477376903},
as seen in its URL: \url{https://apps.apple.com/gb/app/id1477376905}}

\item{country}{The two-letter country code for the store you want to search.
For a list of country codes see \url{https://en.wikipedia.org/wiki/ISO_3166-1_alpha-2}}
}
\value{
A list of two, containing the `position` and the `category` of the app if available.

If the application is not in the charts then both fields will return as \code{NA}
}
\description{
Search for whether an application is currently in the top 100 apps of any category
on the Apple App Store.
}
\examples{
\dontshow{if (interactive()) (if (getRversion() >= "3.4") withAutoprint else force)(\{ # examplesIf}
# Search for GitHub in App Store in the UK
country_id <- "gb"
github_search_results <- search_apple(
  term = "GitHub",
  country = country_id,
  media = "software"
)

# Look up chart position for GitHub in the UK
# (App ID found in trackId column of github_search_results)
get_apple_chart_postion(1477376905, "gb")
\dontshow{\}) # examplesIf}
}
