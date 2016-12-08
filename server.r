library(leaflet)
library(twitteR)
library(ROAuth)
library(shinydashboard)

# setwd("~/Desktop/Info201/tweet-tweet/")
source("./scripts/buildMap.R")
source("./scripts/setUpAuth.R")
source("./scripts/streamData.R")
setUpAuth()

shinyServer(function(input, output, session) {
  # autoInvalidate <- reactiveTimer(5000, session)
  updateSelectInput(session, "city", choices = name$name)
  trends <- getTweetTrends()
  updateSelectInput(session, "trend2", choices = trends$name)
  
  # Creates links between tabs  
  observeEvent(input$link_restdata, {
    newvalue <- "Rest Data"
    updateTabItems(session, 'nav', newvalue)
  })
  observeEvent(input$link_livedata, {
    newvalue <- "Live Data"
    updateTabItems(session, 'nav', newvalue)
  })
  observeEvent(input$link_comparedata, {
    newvalue <- "Compare Tweets"
    updateTabItems(session, 'nav', newvalue)
  })
  observeEvent(input$link_trenddata, {
    newvalue <- "Get Trends"
    updateTabItems(session, 'nav', newvalue)
  })
  observeEvent(input$link_about, {
    newvalue <- "About"
    updateTabItems(session, 'nav', newvalue)
  })
  
  
  
  output$restMap <- renderLeaflet({
    data <- read.csv(paste0("data/",input$trend1,".csv"))
    if (input$nTweets == 10000) {
      data <- data[1:nrow(data),]
    } else {
      data <- data[1:input$nTweets,]
    }
   
    buildMap(data)
  })
  
  search <- eventReactive(input$btnStart, {
    input$text2
  })
  
  observe({
    print(search())
    data <- startStream(search())
    data <- trimData(data)
    data <- getEmbedHTML(data)
    output$liveMap <- renderLeaflet({
     buildMap(data)
    })  
  })
 
  searchTerm <- reactive({
   input$compareTerm 
  })
  
  numTweets <- reactive({
    input$num3
  })
  
  dateStart <- reactive({
    input$dates[1]
  })
  
  dateEnd <- reactive({
    input$dates[2]
  })
  
  updateCompare <- eventReactive(input$updateCompare,{
    tweets <- searchTwitter(searchTerm(), since=as.character(dateStart()), until=as.character(dateEnd()), n = numTweets(), resultType = "popular", lang = "en" )
    tweet.df <- twListToDF(tweets)
    tweet.df$createdDate <- format(tweet.df$created, "%m/%d/%y")
    dataframe <- tweet.df %>%  arrange_(paste0("desc(", input$radio, ")"))
    return(dataframe)
  })
  
  observeEvent(input$updateCompare, {
    output$summary <- renderUI({
      data <- updateCompare()
      data <- getEmbedHTMLnoURL(data)
      HTML(paste0(data[,21]))
    })
    
    output$tableTweet <- renderTable({
      dataframe <- updateCompare()
      dataframe <- dplyr::select(dataframe, text, favoriteCount, retweetCount, screenName, createdDate) %>% arrange_(paste0("desc(", input$radio, ")"))
      names(dataframe)[1] <- "Tweet Content"
      names(dataframe)[2] <- "Number of Favorites"
      names(dataframe)[3] <- "Number of Retweets "
      names(dataframe)[4] <- "User ID"
      names(dataframe)[5] <- "Created"
      return(dataframe)
    })
    
  })
  
  datasetInput <- reactive({
    TrendFreq(input$city)
  })
  
  
  output$table <- renderDataTable({
    datasetInput()
    }, options = list(id = "nEntry", lengthMenu = c(5, 10, 20), pageLength = 10)) 
  
  output$bar <- renderPlotly({
    data <- datasetInput()
    
    x <- as.vector(data$Main_Trend)
    y <- as.vector(data$Number_of_Retweet)
    
    plot_ly(data,
            x = ~x,
            y = ~y,
            name = 'total retweet number for trends',
            type = "bar",
            color = 'rgb(0, 172, 237)')
  })  
  
  
  
})