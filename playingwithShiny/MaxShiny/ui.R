fluidPage("Ranch Drought", id = "navBar",
          
          
          tabsetPanel(id = "mainPanels",
                      
                      ## Instruction panel
                      # tabPanel("10 Minute Data",
                      #          fluidRow(
                      #            leafletOutput("mymap"),
                      #            p(),
                      #            actionButton("recalc", "New points")
                      #            
                      #          )), 
                      
                      tabPanel("Cali Census",
                               fluidRow(

                                 leafletOutput("CaliCensus"),
                                 p()
                                 
                                 
                               ))
          )
)
