library(dplyr)
library(htmltools)
library(httr)
library(curl)

# Trim all data without a valid location to map
trimData <- function(data) {
  data <- subset(data, data$location != "")
  data <- subset(data, data$place_lon != "NaN")
  data <- subset(data, data$url != "")
  return(data)
}

# Request the data about the embedded tweets and returns a dataframe with the information attached.
getEmbedHTML <- function(data) {
  library(jsonlite)
  store.html <- c()
  for(i in 1:nrow(data)) {
    id <- data[i,5]
    url <- data[i,42]
    path <- paste0("https://api.twitter.com/1.1/statuses/oembed.json?align=left&id=",id,"&url=",url)
    request <- GET(path)
    if (request$status_code == 200) {
      html <- content(request)$html
      store.html[i] <- html
    } else {
      store.html[i] <- "Tweet Has Been Deleted By User"
    }
  }
  data <- data %>% mutate(store.html)
  return(data)
}

# Request the data about the embedded tweets and returns a dataframe with the information attached.
getEmbedHTMLnoURL <- function(data) {
  store.html <- c()
  for(i in 1:nrow(data)) {
    print(i)
    id <- data[i,8]
    path <- paste0("https://api.twitter.com/1.1/statuses/oembed.json?align=left&id=",id)
    request <- GET(path)
    if (request$status_code == 200) {
      html <- content(request)$html
      store.html[i] <- html
    } else {
      store.html[i] <- "Tweet Has Been Deleted By User"
    }
  }
  data <- data %>% mutate(store.html)
  return(data)
}
