#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(leaflet)
library(shiny)


# Define UI for application that draws a histogram
ui <-  bootstrapPage(
  tags$style(type = "text/css", "html, body {width:100%;height:100%}"),
  leafletOutput("map", width = "100%", height = "100%"),
  absolutePanel(top = 10, right = 10,
                sliderInput("range", "Time", 
                            min=0, max=10,
                            value = .5, step = .1
                )
  )
)

# Define server logic
server <- function(input, output, session) {
  
  # Reactive expression for the data subsetted to what the user selected
  filteredData <- reactive({
    twitter_data_10min[twitter_data_10min$minutes >= input$range[1] & twitter_data_10min$minutes <= input$range[2],]
  })
  
  
  output$map <- renderLeaflet({
    # Use leaflet() here, and only include aspects of the map that
    # won't need to change dynamically (at least, not unless the
    # entire map is being torn down and recreated).
    leaflet(twitter_data_10min) %>% addProviderTiles("OpenStreetMap.BlackAndWhite") %>%
      fitBounds(~(-123.56), ~(37.38), ~(-121.06), ~(39.04))
  })
  
}
# Run the application 
shinyApp(ui = ui, server = server)

