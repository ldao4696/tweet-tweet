library(streamR)
library(ROAuth)
library(jsonlite)
library(twitteR)
library(dismo)

load("scripts/my_oauth.Rdata")

source("scripts/manageData.R")

# Start the twitter stream and return a dataframe of the given search term.
startStream <- function(keyword) {
  if (keyword == "") {
    keyword <- "everything"
  }
  path <- paste0("data/",keyword, "Tweets.json")
  filterStream(file.name = path, 
               track = c(keyword), 
               language = "en",
               timeout = 10, # can change later
               locations = c(-125, 25, -66, 50),
               oauth = my_oauth)  
  tweets.df <- parseTweets(path, verbose = FALSE)
  tweets.df <- flatten(tweets.df)
  return (tweets.df)
}

# Get the top trends in the US
getTweetTrends <- function() {
  trends <- getTrends(23424977)
  trends <- trends[1:10,]
  return (trends)
}

# Get the location of the user using bing geocoding service
getUserLocation <- function(dataFrame) {
  location.df <- data.frame(address = dataFrame$location)
  data <- geocode(location.df, service = "bing")
  data <- subset(data, data$lat != "")
  return (data)
}

# List of the locations twitter uses 
name <- availableTrendLocations()
# List of cities in the US
name <- name[grep('United States', name$country), ]

# Return a dataframe of information for the input city
TrendFreq <- function(city) {
  list <- availableTrendLocations() 
  city.info <- filter(list, name %in% c(city))
  
  woeid <- city.info %>% dplyr::select(woeid)
  trend <- getTrends(woeid) %>% dplyr::select(name)
  trend <- head(trend, n = 20)
  
  
  trend.data <- as.character(as.vector(trend[,1]))
  
  total.retweet = c()
  
  for(i in 1:length(trend.data)) {
    search.trend <- searchTwitter(trend.data[i], n = 25, lang = 'en')
    trend.df <- twListToDF(search.trend)
    total.retweet[i] <- trend.df %>% dplyr::select(retweetCount) %>% summarise(retweet_count = sum(retweetCount))
  }
  
  retweet.data <- as.data.frame(total.retweet) 
  vector.retweet <- as.numeric(as.vector(retweet.data[1,]))
  result <- data.frame(Main_Trend = trend.data, Number_of_Retweet = vector.retweet)
  
  return(result)
}
