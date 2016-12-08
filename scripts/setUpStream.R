library(streamR)
library(RCurl)
library(RJSONIO)
library(stringr)
library(ROAuth)

setwd("~/Desktop/Info201/instafeed/scripts/")
requestURL <- "https://api.twitter.com/oauth/request_token"
accessURL <- "https://api.twitter.com/oauth/access_token"
authURL <- "https://api.twitter.com/oauth/authorize"
consumerKey <- "HmyVMCHby0N2v82jGm5iK7f4s" # From dev.twitter.com
consumerSecret <- "6CvfbYjKO9xJkocr49GOlYD5XqcVwc40S4doTTk9LfQFabIdKO" # From dev.twitter.com

my_oauth <- OAuthFactory$new(consumerKey = consumerKey,
                             consumerSecret = consumerSecret,
                             requestURL = requestURL,
                             accessURL = accessURL,
                             authURL = authURL)

my_oauth$handshake(cainfo = system.file("CurlSSL", "cacert.pem", package = "RCurl"))

save(my_oauth, file = "my_oauth.Rdata")