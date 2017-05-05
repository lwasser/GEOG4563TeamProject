library(rsconnect)
library(shiny)
library(leaflet)
# load in twitter data to be read by the tab panels
twitter_data_10min <- read.csv("twitter_data_10min.csv")
# Create entire page structure
fluidPage(h1("Napa Valley Earthquake", id = "navBar"),
          
          # Create a tab bar for the individual pages
          tabsetPanel(id = "mainPanels",

                      # Binned progression tab for twitter data
                      tabPanel("10 Minute Range", 
                                 fluidPage(
                                   h1("Time Range"),
                                   leafletOutput("tenminrange", width = "100%", height = 800),
                                 absolutePanel(draggable = TRUE, top = 250, left = "auto", right = 20, bottom = "auto",
                                               width = 400, height = "auto",
                                               sliderInput("range", "Time", min=0, max=10,
                                                           value = c(0,1), step = .1,
                                                           animate=animationOptions(interval=300, loop=T)
                                               ) 

                                 )
                              )
                               ),
                      # Acumulative 10 minute twitter data 
                      tabPanel("10 Minute Progression", 
                               fluidPage(
                                 h1("Time Progression"),
                                 leafletOutput("tenmintime", width = "100%", height = 800),
                                 absolutePanel(draggable = TRUE, top = 250, left = "auto", right = 20, bottom = "auto",
                                               width = 400, height = "auto",
                                               sliderInput("progression", "Time", min=0, max=10,
                                                           value = c(0,0), step = .1,
                                                           animate=animationOptions(interval=150, loop=T)
                                               ) 

                                 )
                               )),
                      # Califonia census and tweet exploration
                      tabPanel("California Census",
                               fluidPage(
                                 leafletOutput("CaliCensus", width = "100%", height = 800),
                                 p()
                               )),
                      # Plot and data fram exploration
                      tabPanel("Data Exploration", 
                               pageWithSidebar(
                                 headerPanel('Twitter Data Clustering'),
                                 sidebarPanel(
                                  selectInput('xcol', 'X Variable', names(twitter_data_10min)),
                                   selectInput('ycol', 'Y Variable', names(twitter_data_10min),
                                               selected=names(twitter_data_10min)[[2]]),
                                   numericInput('clusters', 'Cluster count', 3,
                                                min = 1, max = 9) 

                                   ), 
                                # Organize the data exploration page
                                 mainPanel(
                                   plotOutput('twitplot'),
                                   dataTableOutput("dataspread")
                                 ))
                      
                      
                      
                      )

))
