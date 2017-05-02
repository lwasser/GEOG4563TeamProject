library(shiny)
library(leaflet)
library(rgdal)
library(dplyr)
source("load.R", local = TRUE)


fluidPage(h1("Napa Valley Earthquake", id = "navBar"),
          
          
          tabsetPanel(id = "mainPanels",

                      tabPanel("Cali Census",
                               fluidPage(
                                 leafletOutput("CaliCensus", width = "100%", height = 700),
                                 p()
                               )),
                      tabPanel("10 Minute Timescale", 
                                fluidPage(
                                 leafletOutput("tenmin", width = "100%", height = 700),
                                 absolutePanel(top = 10, right = 10,
                                               sliderInput("range", "Time", min=0, max=10,
                                                           value = range(twitter_data_10min$minutes), step = .1
                                               )
                                               # selectInput("colors", "Color Scheme",
                                               #            rownames(subset(brewer.pal.info, category %in% c("seq", "div")))
                                               #),
                                               #checkboxInput("legend", "Show legend", TRUE)
                                 )
                               )
                               ))

          )

