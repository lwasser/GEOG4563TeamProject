library(rsconnect)
library(shiny)
library(leaflet)
library(rgdal)
library(dplyr)
#source("load.R", local = TRUE)


fluidPage(h1("Napa Valley Earthquake", id = "navBar"),
          
          
          tabsetPanel(id = "mainPanels",

                      tabPanel("California Census",
                               fluidPage(
                                 leafletOutput("CaliCensus", width = "100%", height = 700),
                                 p()
                               )),
                      tabPanel("10 Minute Timescale", 
                               fluidPage(
                                 fluidPage(
                                   leafletOutput("tenmin", width = "100%", height = 700)),
                                 absolutePanel(draggable = TRUE, top = 140, left = "auto", right = 20, bottom = "auto",
                                               width = 400, height = "auto",
                                               sliderInput("range", "Time", min=0, max=10,
                                                           value = range(twitter_data_10min$minutes), step = .1,
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
                      tabPanel("Data Exploration", 
                               pageWithSidebar(
                                 headerPanel('Iris k-means clustering'),
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
