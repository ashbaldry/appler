media_types <- c(
  "movie", "podcast", "music", "musicVideo", "audiobook", "shortFilm", "tvShow",
  "software", "ebook", "all"
)

entities <- list(
  movie = c("movieArtist", "movie"),
  podcast = c("podcastAuthor", "podcast"),
  music = c("musicArtist", "musicTrack", "album", "musicVideo", "mix", "song"),
  musicVideo = c("musicArtist", "musicVideo"),
  audiobook = c("audiobookAuthor", "audiobook"),
  shortFilm = c("shortFilmArtist", "shortFilm"),
  tvShow = c("tvEpisode", "tvSeason"),
  software = c("software", "iPadSoftware", "macSoftware"),
  ebook = "ebook",
  all = c(
    "movie", "album", "allArtist", "podcast", "musicVideo",
    "mix", "audiobook", "tvSeason", "allTrack"
  )
)

attributes <- list(
  movie = c(
    "actorTerm", "genreIndex", "artistTerm", "shortFilmTerm", "producerTerm",
    "ratingTerm", "directorTerm", "releaseYearTerm", "featureFilmTerm",
    "movieArtistTerm", "movieTerm", "ratingIndex", "descriptionTerm"
  ),
  podcast = c(
    "titleTerm", "languageTerm", "authorTerm", "genreIndex", "artistTerm",
    "ratingIndex", "keywordsTerm", "descriptionTerm"
  ),
  music = c(
    "mixTerm", "genreIndex", "artistTerm", "composerTerm", "albumTerm",
    "ratingIndex", "songTerm"
  ),
  musicVideo = c(
    "genreIndex", "artistTerm", "albumTerm", "ratingIndex", "songTerm"
  ),
  audiobook = c("titleTerm", "authorTerm", "genreIndex", "ratingIndex"),
  shortFilm = c(
    "genreIndex", "artistTerm", "shortFilmTerm", "ratingIndex",
    "descriptionTerm"
  ),
  tvShow = c(
    "genreIndex", "tvEpisodeTerm", "showTerm", "tvSeasonTerm", "ratingIndex",
    "descriptionTerm"
  ),
  software = "softwareDeveloper",
  ebook = NULL,
  all = c(
    "actorTerm", "languageTerm", "allArtistTerm", "tvEpisodeTerm", "shortFilmTerm",
    "directorTerm", "releaseYearTerm", "titleTerm", "featureFilmTerm",
    "ratingIndex", "keywordsTerm", "descriptionTerm", "authorTerm", "genreIndex",
    "mixTerm", "allTrackTerm", "artistTerm", "composerTerm", "tvSeasonTerm",
    "producerTerm", "ratingTerm", "songTerm", "movieArtistTerm", "showTerm",
    "movieTerm", "albumTerm"
  )
)
