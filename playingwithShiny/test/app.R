#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(RColorBrewer)
library(dplyr)

colors <- brewer.pal(4, "Set3")

# Define UI for application that draws a histogram
ui <- fluidPage(
   
   titlePanel("Interactive"),
   
   # Sidebar with a slider input for  
   sidebarLayout(
      sidebarPanel(
         sliderInput(
           inputId = "distance",
           label = "Select distance",
           min = 0,
           max = 500,
           value = c(0,500)),
         checkboxGroupInput(
           inputID = "minutes",
           label = "Minutes",
           choices = c(""),
           selected = c("")),
         textInput(
           inputID = "title",
           label = "Title")),
      
      # Show a plot of the generated distribution
      mainPanel(
         plotOutput(
           outputId ="plot"
         )
      )
   )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
   
   output$plot <- renderPlot({
     subset <- movies %>%
       filter (Year >= input$year[1]) %>%
       filter (Year <= input$year[2]) %>%
       filter (Rating %in% input$rating) %>%
       filter(grepl(input$title, Title)) %>%
       as.data.frame()
     plot(
       x=subset$Critic.score,
       y= subset$Box.Office,
       col = colors[as.integer(suset$Rating)])
     legend(
       x="topleft",
       as.character(levels(movies$Rating)),
       col = colors [1:4],
       cex = 1.5 )
     })
}

# Run the application 
shinyApp(ui = ui, server = server)

