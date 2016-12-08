library(ROAuth)

# This script loads up the twitter and Bing oAuth.
setUpAuth <- function() {
  api_key <- "API Key from Twitter Dev Page"
  api_secret <- "API Secret from Twitter Dev Page" 
  token <- "API token from Twitter Dev Page" 
  token_secret <- "API token secret from Twitter Dev Page" 
  options(BingMapsKey='API Key from Bing Dev Page')
  setup_twitter_oauth(api_key, api_secret, token, token_secret)
}

setUpAuth() 
