library(rsconnect)
library(shiny)
library(leaflet)
twitter_data_10min <- read.csv("twitter_data_10min.csv")

fluidPage(h1("Napa Valley Earthquake", id = "navBar"),
          
          
          tabsetPanel(id = "mainPanels",

                      
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
                                               
                                              # ,
                                              #  selectInput("colors", "Color Scheme",
                                              #             rownames(subset(brewer.pal.info, category %in% c("seq", "div")))
                                              #  ),
                                              #  checkboxInput("legend", "Show legend", TRUE)
                                 )
                              )
                               ),
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
                                               
                                               # ,
                                               #  selectInput("colors", "Color Scheme",
                                               #             rownames(subset(brewer.pal.info, category %in% c("seq", "div")))
                                               #  ),
                                               #  checkboxInput("legend", "Show legend", TRUE)
                                 )
                               )),
                      tabPanel("California Census",
                               fluidPage(
                                 leafletOutput("CaliCensus", width = "100%", height = 800),
                                 p()
                               )),
                      tabPanel("Data Exploration", 
                               pageWithSidebar(
                                 headerPanel('Twitter Data Clustering'),
                                 sidebarPanel(
                                  selectInput('xcol', 'X Variable', names(twitter_data_10min)),
                                   selectInput('ycol', 'Y Variable', names(twitter_data_10min),
                                               selected=names(twitter_data_10min)[[2]]),
                                   numericInput('clusters', 'Cluster count', 3,
                                                min = 1, max = 9) 
                                  # sliderInput("timerange", "Time Range", 
                                  #              min = min(twitter_data_10min$minutes), max=max(twitter_data_10min$minutes),
                                  #              value = c(0,1))
                                   ), 
                     
                                 mainPanel(
                                   plotOutput('twitplot'),
                                   dataTableOutput("dataspread")
                                 ))
                      
                      
                      
                      )

))
