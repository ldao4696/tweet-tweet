library(twitteR)
library(dplyr)
library(RJSONIO)


setwd("~/Desktop/Info201/tweet-tweet/scripts/")

name <- availableTrendLocations()
name <- name[grep('United States', name$country), ]

TrendFreq <- function(city) {
  list <- availableTrendLocations() 
  city.info <- filter(list, name %in% c(city))
  
  woeid <- city.info %>% dplyr::select(woeid)
  trend <- getTrends(woeid) %>% dplyr::select(name)
  trend <- head(trend, n = 10)
  
  
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
