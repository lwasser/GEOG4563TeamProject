



function(input, output, session) {

  output$CaliCensus <- renderLeaflet({
    leaflet(CaliCen) %>% addProviderTiles(providers$OpenMapSurfer.Roads) %>%
      addAwesomeMarkers(group="Twitter", clusterOptions = markerClusterOptions()
    ,twitter_data_10min, lat=twitter_data_10min$lat, lng=twitter_data_10min$lon,
    popup=~twitter_data_10min$Text) %>%
      addPolygons(group = "Census", color = "#444444", weight = 1,
    smoothFactor = 0.5,opacity = 1.0, fillOpacity = 0.5, fillColor = ~colorQuantile("YlOrRd",
   CaliCen$Total)(CaliCen$Total), popup=paste0("<b>Total County Population: </b>", CaliCen$Total)
  ,highlightOptions = highlightOptions(color = "white", weight = 2, bringToFront = TRUE)) %>% 
  fitBounds(-123.56, 37.38, -121.06, 39.04) %>%
  addLayersControl(
        #baseGroups = c("OSM (default)", "Toner", "Toner Lite"),
        overlayGroups = c("Twitter", "Census"),
        options = layersControlOptions(collapsed = FALSE)
      )
  })
  
  # Reactive expression for the data subsetted to what the user selected
  filteredData <- reactive({
    twitter_data_10min[twitter_data_10min$minutes >= input$range[1] & 
                         twitter_data_10min$minutes <= input$range[2],]
  })
  
  # This reactive expression represents the palette function,
  # which changes as the user makes selections in UI.
  # colorpal <- reactive({
  #  colorNumeric(input$colors, twitter_data_10min$minutes)
  # })
  
  #pal1 <- (brewer.pal(n = 10, name = "Spectral"))
  pal2 <- colorNumeric(rev(brewer.pal(n = 9, name = "Spectral")), values(shake_raster))
  
  output$tenmin <- renderLeaflet({
    # Use leaflet() here, and only include aspects of the map that
    # won't need to change dynamically (at least, not unless the
    # entire map is being torn down and recreated).
    leaflet(twitter_data_10min) %>% 
      addProviderTiles("OpenStreetMap.BlackAndWhite") %>%
      addRasterImage(shake_raster, colors = pal2, opacity = .5) %>%
      fitBounds(-123.56, 37.38, -121.06, 39.04) 
    # %>% 
    #addLegend(position = "bottomleft", colors = pal2, values = values(shake_raster), 
    #          title = "Shakemap")
  })
  
  # Incremental changes to the map (in this case, replacing the
  # circles when a new color is chosen) should be performed in
  # an observer. Each independent set of things that can change
  # should be managed in its own observer.
  observe({
    #   pal <- colorpal()
    
    leafletProxy("tenmin", data = filteredData()) %>%
      clearShapes() %>%
      addCircles(radius = ~500, weight = 1, color = "#777777",
                 fillColor = ~"red", fillOpacity = 0.7, popup = ~paste(minutes)
      )
  })
  
  # Use a separate observer to recreate the legend as needed.
  # observe({
  #   proxy <- leafletProxy("map", data = twitter_data_10min)
  
  # Remove any existing legend, and only if the legend is
  # enabled, create a new one.
  #  proxy %>% clearControls()
  #  if (input$legend) {
  #  pal <- colorpal()
  #    proxy %>% addLegend(position = "bottomright",
  #                       pal = pal, values = ~minutes
  #    )
  #  }
  
 }

