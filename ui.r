library(leaflet)
library(plotly)

shinyUI(navbarPage(title=div(img(src="logo.png"),' Tweet Tweet'), id = "nav", theme = "bootstrap.css", 
                   tabPanel('Home', id = "home", align = 'center',
                            titlePanel("Welcome to Tweet Tweet!"),
                            h1("INFO 201: Final Project"),
                            img(src='Twitter.png', width = 440, height = 300),
                            h3("Understand the best sources of market growth through real-time and historical Twitter Data"),
                            br(),
                            p("Approximately 310 million users actively use Twitter per month, 80% of them being millennials. With the vast amount of usage, Twitter has become one of the most powerful marketing tools for businesses. By analyzing behavioral metrics, companies are better able to develop profiles of target segments. However, even with that capability, effectively targeting high value sources of growth remains to be the largest problem in the marketing industry."),
                            p("With this in mind, we studied Twitter’s data to produce an interactive visualization of the origin of tweets based on keywords and trends to make the data easier to understand and utilize for identifying the best sources of growth for a brand, product, or service. We have leveraged this data to plot and interpret key geographical locations, and better streamline analyses of potential markets for businesses."),
                            br(),
                            h3("Click below to find out more!"),
                            h3(actionLink('link_restdata', img(src='Rest.png', width = 180, height = 180)), actionLink('link_livedata', img(src='Live.png', width = 200, height = 200)), actionLink('link_comparedata', img(src='Compare.png', width = 180, height = 180)), actionLink('link_trenddata', img(src='Trend.png', width = 180, height = 180))),
                            h2(actionLink('link_about', 'Contact Us')),
                            br()
                   ),
                   
                   tabPanel('Rest Data', id = "rest", 
                                      titlePanel('Twitter Rest Data'),
                                      
                                      sidebarLayout(
                                        
                                        sidebarPanel(
                                          selectInput("trend1", "Select Trend", c("#TuesdayMotivation", "Ariana", "#HairsprayLive", "#HolidayPickUpLines")) ,
                                          
                                          selectInput("nTweets", label = "Pick a number", 
                                                      choices = c(1, 10, 50, 100, 500, 1000, 2500, 5000, 7500, 10000), selected = 1000),
                                          
                                          p("Please wait patiently as the map loads.")
                                        ),
                                        
                                        mainPanel(leafletOutput('restMap', width = "100%", height = 400))
                                       )),
                   tabPanel('Live Data', id = "live", 
                            titlePanel('Twitter Live Data Stream'),

                            sidebarLayout(

                              sidebarPanel(
                                p("Search for any kind of tweet."),
                                p("ex. #Twitter or Twitter"),
                                p("Our map will stream live data relating to your search for 10 seconds."),
                                p("Please wait patiently as we gather tweets."),
                                textInput("text2", label = "Search Tweets", value = ""),
                                actionButton('btnStart', 'Update Map'),
                                br(),
                                br()
                                # selectInput("trend2", "Select Trend", "")

                              ),

                              mainPanel(leafletOutput("liveMap"))

                            )
                   ),

                   tabPanel('Compare Tweets', id = "compare", 
                            sidebarLayout(
                              sidebarPanel(
                                dateRangeInput("dates", label = h3("Date range"),
                                               min = as.character(Sys.Date() - 7),
                                               max = as.character(Sys.Date()),
                                               start = as.character(Sys.Date() - 1),
                                               end = as.character(Sys.Date()) ),
                                textInput("compareTerm", label = h3("Hashtag or Trend"), value = "cats"),
                                numericInput("num3", label = h3("Number of Tweets"), value = 1, min = 1),
                                radioButtons("radio", label = h3("Arrange by:"),
                                             choices = list("Favorites" = "favoriteCount", "Retweets" = "retweetCount"),
                                             selected = "favoriteCount"),
                                actionButton("updateCompare", "Apply Changes")
                              ),
                              mainPanel(
                                tabsetPanel(
                                  tabPanel("Actual Tweets", br(), htmlOutput("summary")),
                                  tabPanel("DataTable", br(), tableOutput("tableTweet"))
                              ))
                   )),

                   tabPanel("Get Trends", id = "trend",
                     sidebarLayout(
                     sidebarPanel(
                       helpText("Search the trends in specific city."),

                       selectInput("city", "choose a city", "",
                                   selectize = TRUE, selected = "Seattle"),
                       br()),

                       #Show a scatter plot
                       mainPanel(
                         tabsetPanel(
                           tabPanel("Table", br(), dataTableOutput('table')),
                           tabPanel("Plot", br(), h1("Below are the top 20 trends for the selected city."), plotlyOutput('bar'))
                         )
                       )
                     )),

                   tabPanel('About', id = "about",
                            titlePanel('Meet our Tweet Team!'),
                            p("INFO 201: Fall 2016"),
                            img(class = "twitterpics", src="Twitter-Daisy.png"),
                            img(class = "twitterpics",src="Twitter-Bao.png"),
                            img(class = "twitterpics",src="Twitter-Jenny.png"),
                            img(class = "twitterpics",src="Twitter-Leah.png")
                   )

                   
))
