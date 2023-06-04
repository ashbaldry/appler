library(appler)

# iTunes web --------------------------------------------------------------
# https://music.apple.com/ca/browse
# https://music.apple.com/ca/album/get-rollin/1642697894
# https://music.apple.com/ca/artist/nickelback/5280361
# https://music.apple.com/ca/artist/<artist-name>  fails

# Browse Categories > Hits
# https://music.apple.com/ca/curator/apple-music-hits/1526756058
# Hot Tracks        https://music.apple.com/room/1532292351
# New Releases      https://music.apple.com/room/1532292352
# Artist Playlist   https://music.apple.com/room/1532292353
# Hits of the 2010s https://music.apple.com/room/1532292355
# Hits of the '00s  https://music.apple.com/room/1532292356
# Hits of the 90s   https://music.apple.com/room/1532292357
# Essential Albums  https://music.apple.com/room/1532292578

# Browser Categories > Charts
# https://music.apple.com/ca/browse/top-charts
# Top Songs   https://music.apple.com/ca/browse/top-charts/songs/

# --- use the dataset to get artist id
lizzo <- itunes_artists[itunes_artists$artist == "Lizzo", ]
lizzo_id <- lizzo$artist_id
lizzo_name <- lizzo$artist

# --- use the artist name and id from the dataset for search
artist_by_name <- search_apple(term = lizzo_name, country = "ca", lang = "en")
artist_by_id <- lookup_apple(id = lizzo_id, country = "ca", sort = "recent")

# --- check the data
head(artist_by_name)
head(artist_by_id)

# Apple app store ---------------------------------------------------------

# Develop > Top Free Apps (iPhone)
# ---- the id is the same if iPad is chosen, just the order or app popularity changes

# https://apps.apple.com/ca/developer/github/id429758986
# https://apps.apple.com/ca/app/github/id1477376905

# id of app on Apple App store
# -- use the dataset apple_apps to get ids
head(apple_apps)
xcode <- apple_apps[apple_apps$app_name == "Xcode", ]

get_apple_chart_postion(id = xcode$app_id, "ca")

get_apple_rating_split(id = xcode$app_id, country = "ca")

app_reviews <- get_apple_reviews(xcode$app_id, "ca", all_results = TRUE)
head(app_reviews)
