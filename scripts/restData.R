library(jsonlite)
library(twitteR)
library(dplyr)
library(dismo)


getRestData <- function(searchTerm, nTweets) {
  num <- as.integer(nTweets)
  searchResults <- searchTwitter(searchTerm, n = num, resultType = "recent")
  searchResults <- twListToDF(searchResults)
  user.data <- getUserData(searchResults)
  user.location <- getUserLocation(user.data)
  while (nrow(user.location) < nTweets) {
    num <- as.integer(num * 5)
    searchResults <- searchTwitter(searchTerm, n = num) 
    searchResults <- twListToDF(searchResults)
    user.data <- getUserData(searchResults)
    user.location <- getUserLocation(user.data)
  }
  user.location <- user.location[1:nTweets,]
  return (user.location)
}

getUserData <- function(dataFrame) {
  userInfo <- lookupUsers(dataFrame$screenName)  
  userInfo <- twListToDF(userInfo) 
  dataFrame$location <- userInfo$location[match(dataFrame$screenName, userInfo$screenName)]
  dataFrame <- subset(dataFrame, dataFrame$location != "")
  return (dataFrame)
}

getUserLocation <- function(dataFrame) {
  location.df <- data.frame(address = dataFrame$location)
  data <- geocode(location.df, service = "bing")
  data <- subset(data, data$lat != "")
  return (data)
}

name <- availableTrendLocations()
name <- name[grep('United States', name$country), ]

TrendFreq <- function(city) {
  list <- availableTrendLocations() 
  city.info <- filter(list, name %in% c(city))
  
  woeid <- city.info %>% select(woeid)
  trend <- getTrends(woeid) %>% select(name)
  trend <- head(trend, n = 10)
  
  
  trend.data <- as.character(as.vector(trend[,1]))
  
  total.retweet = c()
  
  for(i in 1:length(trend.data)) {
    search.trend <- searchTwitter(trend.data[i], n = 25, lang = 'en')
    trend.df <- twListToDF(search.trend)
    total.retweet[i] <- trend.df %>% select(retweetCount) %>% summarise(retweet_count = sum(retweetCount))
  }
  
  retweet.data <- as.data.frame(total.retweet) 
  vector.retweet <- as.numeric(as.vector(retweet.data[1,]))
  result <- data.frame(Main_Trend = trend.data, Number_of_Retweet = vector.retweet)
  
  return(result)
}
