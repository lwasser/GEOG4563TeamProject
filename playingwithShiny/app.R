#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(leaflet)
library(RColorBrewer)

ui <- bootstrapPage(
  tags$style(type = "text/css", "html, body {width:100%;height:100%}"),
  leafletOutput("map", width = "100%", height = "100%"),
  absolutePanel(top = 10, right = 10,
                sliderInput("range", "Time", min(0), max(10),
                            value = range(tidy_tweets$minutes), step = .1
                ),
                 selectInput("colors", "Color Scheme",
                            rownames(subset(brewer.pal.info, category %in% c("seq", "div")))
                ),
                checkboxInput("legend", "Show legend", TRUE)
  )
)

server <- function(input, output, session) {
  
  # Reactive expression for the data subsetted to what the user selected
  filteredData <- reactive({
    tidy_tweets[tidy_tweets$minutes >= input$range[1] & tidy_tweets$minutes <= input$range[2],]
  })
  
  # This reactive expression represents the palette function,
  # which changes as the user makes selections in UI.
   colorpal <- reactive({
    colorNumeric(input$colors, quakes$minutes)
   })
  
  output$map <- renderLeaflet({
    # Use leaflet() here, and only include aspects of the map that
    # won't need to change dynamically (at least, not unless the
    # entire map is being torn down and recreated).
    leaflet(tidy_tweets) %>% addTiles() %>%
      fitBounds(~(-123.56), ~(37.38), ~(-121.06), ~(39.04))
  })
  
  # Incremental changes to the map (in this case, replacing the
  # circles when a new color is chosen) should be performed in
  # an observer. Each independent set of things that can change
  # should be managed in its own observer.
   observe({
     pal <- colorpal()
     leafletProxy("map", data = filteredData()) %>%
       clearShapes() %>%
       addCircles(radius = ~300, weight = 1, color = "#777777",
                 fillColor = ~pal(minutes), fillOpacity = 0.7, popup = ~paste(minutes)
      )
   })
  
  # Use a separate observer to recreate the legend as needed.
   observe({
     proxy <- leafletProxy("map", data = tidy_tweets)
    
    # Remove any existing legend, and only if the legend is
    # enabled, create a new one.
    proxy %>% clearControls()
    if (input$legend) {
     pal <- colorpal()
      proxy %>% addLegend(position = "bottomright",
                         pal = pal, values = ~minutes
      )
    }
  })
}

shinyApp(ui, server)