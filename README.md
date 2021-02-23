## `appler`

The goal of `appler` is to be able to pull information from the Apple iTunes and App Stores.

### Installation

```{r}
devtools::install_github("ashbaldry/appler")
```

### Functionality

#### `search_apple` 

A simple search tool that returns Apple items that are related to the search term.

```{r}
search_apple("GitHub", "gb")
```

#### `lookup_apple`

Using the ID of an Apple item (found in the URL) returns basic information about the selected item.

```{r}
lookup_apple(1477376905, "gb")
```

#### `get_apple_rating_split`

The API only extracts the average review, so this scrapes the webpage for the split of 1 :star: to 5 :star: ratings.

```{r}
get_apple_rating_split(1477376905, "gb")
```

#### `get_apple_reviews`

Pulls the most recent reviews for a selected app.

```{r}
get_apple_reviews(1477376905, "gb")
```

__NB__ All ratings and reviews are country specific.
