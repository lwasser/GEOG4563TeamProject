

source("load.R", local = TRUE)

function(input, output, session) {



  output$CaliCensus <- renderLeaflet({
    leaflet(CaliCen) %>% addProviderTiles(providers$OpenMapSurfer.Roads) %>%
    #   addAwesomeMarkers( clusterOptions = markerClusterOptions()
    # ,twitter_data_10min, lat=twitter_data_10min$lat, lng=twitter_data_10min$lon,
    # popup=~twitter_data_10min$Text) %>% 
      addPolygons(color = "#444444", weight = 1,
    smoothFactor = 0.5,opacity = 1.0, fillOpacity = 0.5, fillColor = ~colorQuantile("YlOrRd",
   CaliCen$Total)(CaliCen$Total), popup=paste0("<b>Total County Population: </b>", CaliCen$Total)
                                                                                                                                                                                                                            ,highlightOptions = highlightOptions(color = "white", weight = 2, bringToFront = TRUE))
  })
 }

