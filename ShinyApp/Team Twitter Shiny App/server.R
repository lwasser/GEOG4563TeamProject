# This function runs the support script in order to load in data and run processing. 
source("load.R", local = TRUE)


function(input, output, session) {

    # Leaflet output for the tweets and census map
  output$CaliCensus <- renderLeaflet({
    leaflet(CaliCen) %>% addProviderTiles(providers$OpenMapSurfer.Roads) %>%
      addAwesomeMarkers(group="Twitter", clusterOptions = markerClusterOptions()
    ,twitter_data_10min, lat=twitter_data_10min$lat, lng=twitter_data_10min$lon,
    popup=paste0("<b>Tweet: </b>",twitter_data_10min$Text, "<br><b>Time: </b></br>", twitter_data_10min$Timestamp)) %>%
      addPolygons(group = "Census", color = "#444444", weight = 1,
    smoothFactor = 0.5,opacity = 1.0, fillOpacity = 0.5, fillColor = ~colorQuantile("YlOrRd",
   CaliCen$Total)(CaliCen$Total), popup=paste0("<b>County: </b>", CaliCen$NAMELSAD10,"<br><b>Total County Population: </b></br>", CaliCen$Total)
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
  timeData <- reactive({
    twitter_data_10min[ 
                         twitter_data_10min$minutes <= input$progression[2],]
  })

  # Color scheme for shakemap data
  pal2 <- colorNumeric(rev(brewer.pal(n = 9, name = "Spectral")), values(shake_raster))
  
  output$tenminrange <- renderLeaflet({
    # Use leaflet() here, and only include aspects of the map that
    # won't need to change dynamically (at least, not unless the
    # entire map is being torn down and recreated).
    leaflet(twitter_data_10min) %>% 
      addProviderTiles(providers$OpenMapSurfer.Roads) %>%
      addRasterImage(group = "Shakemap", shake_raster, colors = pal2, opacity = .5) %>%
      fitBounds(-123.56, 37.38, -121.06, 39.04) %>%
      addPolygons(data =CaliCen ,group = "Census", color = "#444444", weight = 1,
                  smoothFactor = 0.5,opacity = 1.0, fillOpacity = 0.5, fillColor = ~colorQuantile("YlOrRd",
                                                                                                  CaliCen$Total)(CaliCen$Total), popup=paste0("<b>County: </b>", CaliCen$NAMELSAD10,"<br><b>Total County Population: </b></br>", CaliCen$Total)
                  ,highlightOptions = highlightOptions(color = "white", weight = 2, bringToFront = TRUE)) %>% 

      addLayersControl(
        overlayGroups = c("Shakemap", "Census"),
        options = layersControlOptions(collapsed = FALSE))

  })
  output$tenmintime <- renderLeaflet({
    # Use leaflet() here, and only include aspects of the map that
    # won't need to change dynamically (at least, not unless the
    # entire map is being torn down and recreated).
    leaflet(twitter_data_10min) %>% 
      addProviderTiles(providers$OpenMapSurfer.Roads) %>%
      addRasterImage(shake_raster, colors = pal2, opacity = .5) %>%
      fitBounds(-123.56, 37.38, -121.06, 39.04) %>%
      addPolygons(data =CaliCen ,group = "Census", color = "#444444", weight = 1,
      smoothFactor = 0.5,opacity = 1.0, fillOpacity = 0.5, fillColor = ~colorQuantile("YlOrRd",
      CaliCen$Total)(CaliCen$Total), popup=paste0("<b>County: </b>", CaliCen$NAMELSAD10,"<br><b>Total County Population: </b></br>", CaliCen$Total)
       ,highlightOptions = highlightOptions(color = "white", weight = 2, bringToFront = TRUE)) %>% 
      addLayersControl(
        overlayGroups = c("Shakemap", "Census"),
        options = layersControlOptions(collapsed = FALSE))

  })
  
  # Incremental changes to the map (in this case, replacing the
  # circles when a new color is chosen) should be performed in
  # an observer. Each independent set of things that can change
  # should be managed in its own observer.
  observe({
    
    leafletProxy("tenminrange", data = filteredData()) %>%
      clearShapes() %>%
      addCircles(radius = ~500, weight = 1, color = "#777777",
                 fillColor = ~"red", fillOpacity = 0.7, popup = ~paste(minutes)
      )
  })
  observe({

    
    leafletProxy("tenmintime", data = timeData()) %>%
      clearShapes() %>%
      addCircles(radius = ~500, weight = 1, color = "#777777",
                 fillColor = ~"red", fillOpacity = 0.7, popup = ~paste(minutes)
      )
  })
  

 
  
  # Link data from data exploration tab to dataframe data
  selectedData <- reactive({
    twitter_data_10min[, c(
     input$xcol, 
      input$ycol

      )]
  })
  
  clusters <- reactive({
    kmeans(selectedData(), input$clusters)
  })
  
  output$twitplot <- renderPlot({
    palette(c("#E41A1C", "#377EB8", "#4DAF4A", "#984EA3",
              "#FF7F00", "#FFFF33", "#A65628", "#F781BF", "#999999"))
  # Plot the data selected in drop downs
    plot(selectedData(),
         col = clusters()$cluster,
         pch = 20, cex = 3)
    points(clusters()$centers, pch = 4, cex = 4, lwd = 4)
  })
  
  
  {
    # Render dataframe output for data exploration tab
      output$dataspread <- renderDataTable(selectedData())
  }  
      
   

  

  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
   
}







