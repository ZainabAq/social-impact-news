# install.packages("shiny")
#install.packages("rPython")
library(shiny)
library(rPython)
library(dplyr)
library(mosaic)
library(randomForest)
library(ParetoPosStable)
library(tree)
library(gbm)
library(adabag)
library(EnvStats)
library(caret)
source("plot_1.R")
source("findstats.R")


# Define UI ----
ui <- fluidPage(
  
  titlePanel("Social Impact News"),
  
  sidebarLayout(
    
    sidebarPanel(
      textInput("URL1", label = "Enter URL of Article")
    ),
    
    mainPanel(
      
      h3("Probability of Social Impact: 78%"),
      plotOutput("plot_1"),
      tableOutput("table1"))
  )
)



# Define server logic ----
server <- function(input, output) {
  
  output$plot_1 <- renderPlot({
    plot_1()
  })
  output$table1 <- renderTable({
    findstats(input$URL1)
  })
  
}

# Run the app ----
shinyApp(ui = ui, server = server)
