library(shiny)
library(leaflet)
library(rgdal)
library(dplyr)



fluidPage("Ranch Drought", id = "navBar",
          
          
          tabsetPanel(id = "mainPanels",
                    
                      tabPanel("Cali Census",
                               fluidPage(

                                 leafletOutput("CaliCensus"),
                                 p()
                               ))

          )
)
