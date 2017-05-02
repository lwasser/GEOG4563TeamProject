
source("load.R", local = TRUE)


function(input, output, session) {

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

  # This reactive expression represents the palette function,
  # which changes as the user makes selections in UI.
  # colorpal <- reactive({
  #  colorNumeric(input$colors, twitter_data_10min$minutes)
  # })
  
  #pal1 <- (brewer.pal(n = 10, name = "Spectral"))
  pal2 <- colorNumeric(rev(brewer.pal(n = 9, name = "Spectral")), values(shake_raster))
  
  output$tenminrange <- renderLeaflet({
    # Use leaflet() here, and only include aspects of the map that
    # won't need to change dynamically (at least, not unless the
    # entire map is being torn down and recreated).
    leaflet(twitter_data_10min) %>% 
      addProviderTiles("OpenStreetMap.BlackAndWhite") %>%
      addRasterImage(group = "Shakemap", shake_raster, colors = pal2, opacity = .5) %>%
      fitBounds(-123.56, 37.38, -121.06, 39.04) %>%
      addPolygons(data =CaliCen ,group = "Census", color = "#444444", weight = 1,
                  smoothFactor = 0.5,opacity = 1.0, fillOpacity = 0.5, fillColor = ~colorQuantile("YlOrRd",
                                                                                                  CaliCen$Total)(CaliCen$Total), popup=paste0("<b>County: </b>", CaliCen$NAMELSAD10,"<br><b>Total County Population: </b></br>", CaliCen$Total)
                  ,highlightOptions = highlightOptions(color = "white", weight = 2, bringToFront = TRUE)) %>% 

      addLayersControl(
        overlayGroups = c("Shakemap", "Census"),
        options = layersControlOptions(collapsed = FALSE))
    # %>% 
    #addLegend(position = "bottomleft", colors = pal2, values = values(shake_raster), 
    #          title = "Shakemap")
  })
  output$tenmintime <- renderLeaflet({
    # Use leaflet() here, and only include aspects of the map that
    # won't need to change dynamically (at least, not unless the
    # entire map is being torn down and recreated).
    leaflet(twitter_data_10min) %>% 
      addProviderTiles("OpenStreetMap.BlackAndWhite") %>%
      addRasterImage(shake_raster, colors = pal2, opacity = .5) %>%
      fitBounds(-123.56, 37.38, -121.06, 39.04) %>%
      addPolygons(data =CaliCen ,group = "Census", color = "#444444", weight = 1,
      smoothFactor = 0.5,opacity = 1.0, fillOpacity = 0.5, fillColor = ~colorQuantile("YlOrRd",
      CaliCen$Total)(CaliCen$Total), popup=paste0("<b>County: </b>", CaliCen$NAMELSAD10,"<br><b>Total County Population: </b></br>", CaliCen$Total)
       ,highlightOptions = highlightOptions(color = "white", weight = 2, bringToFront = TRUE)) %>% 
      addLayersControl(
        overlayGroups = c("Shakemap", "Census"),
        options = layersControlOptions(collapsed = FALSE))
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
    
    leafletProxy("tenminrange", data = filteredData()) %>%
      clearShapes() %>%
      addCircles(radius = ~500, weight = 1, color = "#777777",
                 fillColor = ~"red", fillOpacity = 0.7, popup = ~paste(minutes)
      )
  })
  observe({
    #   pal <- colorpal()
    
    leafletProxy("tenmintime", data = timeData()) %>%
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

    plot(selectedData(),
         col = clusters()$cluster,
         pch = 20, cex = 3)
    points(clusters()$centers, pch = 4, cex = 4, lwd = 4)
  })
  
  
  {
      output$dataspread <- renderDataTable(selectedData())
  }  
      
      
      ## Observe mouse clicks and add circles
      observeEvent(input$map_click, {

        click <- input$map_click
        clat <- click$lat
        clng <- click$lng
        address <- revgeocode(c(clng,clat))
        
        ## Add the circle to the map proxy
        ## so you dont need to re-render the whole thing
        ## I also give the circles a group, "circles", so you can
        ## then do something like hide all the circles with hideGroup('circles')
        leafletProxy('tenmin') %>% # use the proxy to save computation
          addCircles(lng=clng, lat=clat, group='circles',
                     weight=1, radius=100, color='black', fillColor='orange',
                     popup=address, fillOpacity=0.5, opacity=1)
      })    

  

  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
   
}







