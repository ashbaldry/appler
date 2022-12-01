
## appler

<!-- badges: start -->

[![R-CMD-check](https://github.com/ashbaldry/appler/workflows/R-CMD-check/badge.svg)](https://github.com/ashbaldry/appler/actions)
<!-- [![Codecov test coverage](https://codecov.io/gh/ashbaldry/appler/branch/main/graph/badge.svg)](https://codecov.io/gh/ashbaldry/appler?branch=main) -->

<!-- badges: end -->

<img src="./img/appler.png" height="200" align="right"/>

The goal of `appler` is to be able to pull information from the Apple
iTunes and App Stores.

### Installation

    devtools::install_github("ashbaldry/appler")

### Functionality

    library(appler)

#### `search_apple`

A simple search tool that returns Apple items that are related to the
search term.

    search_results <- search_apple("GitHub", "gb")
    dim(search_results)

    ## [1] 14 42

    names(search_results)

    ##  [1] "wrapperType"            "kind"                   "artistId"              
    ##  [4] "collectionId"           "trackId"                "artistName"            
    ##  [7] "collectionName"         "trackName"              "collectionCensoredName"
    ## [10] "trackCensoredName"      "artistViewUrl"          "collectionViewUrl"     
    ## [13] "trackViewUrl"           "previewUrl"             "artworkUrl30"          
    ## [16] "artworkUrl60"           "artworkUrl100"          "collectionPrice"       
    ## [19] "trackPrice"             "releaseDate"            "collectionExplicitness"
    ## [22] "trackExplicitness"      "discCount"              "discNumber"            
    ## [25] "trackCount"             "trackNumber"            "trackTimeMillis"       
    ## [28] "country"                "currency"               "primaryGenreName"      
    ## [31] "isStreamable"           "collectionArtistId"     "collectionArtistName"  
    ## [34] "feedUrl"                "trackRentalPrice"       "collectionHdPrice"     
    ## [37] "trackHdPrice"           "trackHdRentalPrice"     "contentAdvisoryRating" 
    ## [40] "artworkUrl600"          "genreIds"               "genres"

#### `lookup_apple`

Using the ID of an Apple item (found in the URL) returns basic
information about the selected item.

    lookup_results <- lookup_apple(1477376905, "gb")
    dim(lookup_results)

    ## [1]  1 44

    names(lookup_results)

    ##  [1] "ipadScreenshotUrls"                 "appletvScreenshotUrls"             
    ##  [3] "artworkUrl60"                       "artworkUrl512"                     
    ##  [5] "artworkUrl100"                      "artistViewUrl"                     
    ##  [7] "screenshotUrls"                     "supportedDevices"                  
    ##  [9] "advisories"                         "isGameCenterEnabled"               
    ## [11] "features"                           "kind"                              
    ## [13] "minimumOsVersion"                   "trackCensoredName"                 
    ## [15] "languageCodesISO2A"                 "fileSizeBytes"                     
    ## [17] "sellerUrl"                          "formattedPrice"                    
    ## [19] "contentAdvisoryRating"              "averageUserRatingForCurrentVersion"
    ## [21] "userRatingCountForCurrentVersion"   "averageUserRating"                 
    ## [23] "trackViewUrl"                       "trackContentRating"                
    ## [25] "releaseDate"                        "trackId"                           
    ## [27] "trackName"                          "currentVersionReleaseDate"         
    ## [29] "releaseNotes"                       "primaryGenreName"                  
    ## [31] "genreIds"                           "isVppDeviceBasedLicensingEnabled"  
    ## [33] "primaryGenreId"                     "sellerName"                        
    ## [35] "currency"                           "description"                       
    ## [37] "artistId"                           "artistName"                        
    ## [39] "genres"                             "price"                             
    ## [41] "bundleId"                           "version"                           
    ## [43] "wrapperType"                        "userRatingCount"

#### `get_apple_rating_split`

The API only extracts the average review, so this scrapes the app page
for the split of 1 :star: to 5 :star: ratings.

    ratings <- get_apple_rating_split(1477376905, "gb")
    ratings

    ##   rating percent
    ## 1      5    0.83
    ## 2      4    0.11
    ## 3      3    0.04
    ## 4      2    0.01
    ## 5      1    0.01

#### `get_apple_reviews`

Pulls the most recent reviews for a selected app.

    reviews <- get_apple_reviews(1477376905, "gb")
    head(reviews)

    ##           id         review_time         author app_version
    ## 2 6995723328 2021-02-15 03:10:28  Max Hitchings       1.4.2
    ## 3 6977862590 2021-02-10 14:35:30  Benthomas7777       1.4.2
    ## 4 6971291453 2021-02-08 23:05:47      amr rayed       1.4.2
    ## 5 6957031610 2021-02-05 12:38:08 superyellyfish       1.4.2
    ## 6 6900870415 2021-01-22 16:56:46        Kilthar         1.4
    ## 7 6835125060 2021-01-05 20:09:28    Omnibus-KEI       1.3.4
    ##                  title rating
    ## 2                 GOOD      5
    ## 3 Great Productive App      5
    ## 4              Amr8457      5
    ## 5      App works great      5
    ## 6            Great app      5
    ## 7             Good app      5
    ##                                                                review
    ## 2                                                                GOOD
    ## 3 Offers a nice way to do code reviews and deal with issues on the go
    ## 4      Please can you rate all message \nFrom this email and Facebook
    ## 5                                     Good app, an essential service.
    ## 6    Works as it says on the tin. Great in a pinch on a train or bus!
    ## 7                                       I think is good application:)

#### `get_apple_chart_postion`

Checks whether the app is within any category chart and returns the
position and category

    chart_pos <- get_apple_chart_postion(1477376905, "gb")
    chart_pos

    ## $position
    ## [1] 1
    ## 
    ## $category
    ## [1] "Developer Tools"

**NB** All ratings and reviews are country specific.
