
library(shiny)
library(tidyverse)
library(shinyWidgets)
library(plotly)

load(file = "dashboard-data-whisky.RData")

# Frontend

ui <- fluidPage(

    # Application title
    titlePanel("Dashboard Posicionamiento Whisky"),

    sidebarLayout(
        sidebarPanel(
          
            pickerInput(inputId = "marca",
                        label = "Marca:",
                        choices = levels(factor(DF3$`¿Cuál es la marca que más compra?`)),
                        selected = levels(factor(DF3$`¿Cuál es la marca que más compra?`)),
                        multiple = T,
                        options = pickerOptions(actionsBox = T))
            
        ),

        mainPanel(
           
          fluidRow(
            
            column(width = 12,
                   plotlyOutput(outputId = "loyalty_chart"))
            
          )
          
        )
    )
)

# Backend

server <- function(input, output) {
  
  DF3_react <- reactive({
    
    DF3 %>% 
      
      filter(`¿Cuál es la marca que más compra?` %in% input$marca)
    
  })
  
  
  
  output$loyalty_chart <- renderPlotly({
    
    ggplotly(
      
      DF3_react() %>%
        
        count(`¿Cuál es la marca que más compra?`) %>% 
        
        ggplot(mapping = aes(x = `¿Cuál es la marca que más compra?`,
                             y = n)) +
        
        geom_col() +
        
        theme_minimal()
      
    )
    
  })
  
}

# Run the application 
shinyApp(ui = ui, server = server)
