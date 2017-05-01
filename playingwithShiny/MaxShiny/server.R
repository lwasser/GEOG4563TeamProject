library(shiny)
library(leaflet)
library(rgdal)
setwd("~/GitHub/GEOG4563TeamProject/playingwithShiny/MaxShiny")


r_colors <- rgb(t(col2rgb(colors()) / 255))
names(r_colors) <- colors()

function(input, output, session) {
  
  points <- eventReactive(input$recalc, {
    cbind(rnorm(40) * 2 + 13, rnorm(40) + 48)
  }, ignoreNULL = FALSE)
  
  output$mymap <- renderLeaflet({
    leaflet() %>%
      addProviderTiles(providers$Stamen.TonerLite,
                       options = providerTileOptions(noWrap = TRUE)
      ) %>%
      addMarkers(data = points())
  })

  output$CaliCensus <- renderLeaflet({
    leaflet(readOGR("CaliCensus/Cal_Cnty_RacePop.shp")) %>% addProviderTiles(providers$OpenMapSurfer.Roads) %>%
      addAwesomeMarkers( clusterOptions = markerClusterOptions()
    ,twitter_data_10min, lat=twitter_data_10min$lat, lng=twitter_data_10min$lon,
    popup=~twitter_data_10min$Text) %>% addPolygons(color = "#444444", weight = 1,
    smoothFactor = 0.5,opacity = 1.0, fillOpacity = 0.5, fillColor = ~colorQuantile("YlOrRd",
   CalCen$Total)(CalCen$Total), popup=paste0("<b>Total County Population: </b>", CalCen$Total)
                                                                                                                                                                                                                            ,highlightOptions = highlightOptions(color = "white", weight = 2, bringToFront = TRUE))
  })
 }

