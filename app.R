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
library(mdsr)
library(RMySQL)
source("findstats.R")


# Define UI ----
ui <- fluidPage(
  
titlePanel("Is This Article Socially Impactful?"),
  hr(),
  
  fluidRow(
    column(3,
           textInput("URL1", label = "URL of Article:")
    ),
    column(9,
           h5("Title:"),
           h4(tableOutput("title"))
    )
),
plotOutput("plot"),
  
  hr(),
  h4("Probabilities of Social Impact"),
  
  fluidRow(
    column(3,
           h5("Optimized Boosting Model:"),
           strong(span(textOutput("boosting2"), style="color:red"))
    ),
    column(3,
           h5("Logistic Model:"),
           strong(span(textOutput("log"), style="color:blue"))
    ),
    column(3,
           h5("SVM Classification:"),
           strong(span(textOutput("svm"), style='color:green'))
    ),
    column(3,
           h5("Our Classification:"),
           strong(span(textOutput("ours")))
    )
  )
) 


  # sidebarLayout(
  #   
  #   sidebarPanel(
  #     textInput("URL1", label = "Enter URL of Article")
  #     ),
  #   
  #   mainPanel(
  #     
  #     h5("Title of Article:"),
  #     tableOutput("title"),
  #     # h5("Probability of Social Impact based on Social Interactions:"),
  #     # textOutput("pred1"),
  #     # h5("Probaility of Social Impact based on SVM Model"),
  #     # textOutput("pred2")
  #     h5("Probability of Social Impact based on Optimized Boosting Model"),
  #     textOutput("boosting2"),
  #     # h5("Social Impact based on Boosting Model"),
  #     # textOutput("boosting"),
  #     h5("Probability of Social Impact based on HuffPost Model"),
  #     textOutput("huff")
  #     
  #   )
  #   
  # ))
  # 


# Define server logic ----
server <- function(input, output) {

  
  output$title <- renderText({
    findtitle(input$URL1)
  })
  
  # model1 <- lm(all1 ~ social_interactions, data = data)
  # load(file = 'simple_model.rda')
  # 
  # model1predict <- reactive({
  #   socialint<- findstats(input$URL1)
  #   socialInput <- socialint
  #   predict(my_model, newdata = data.frame(socialInput))
  # })
  # 
  # output$pred1 <- renderText({
  #   model1predict()
  # })
  
  # load(file = 'boosting.rda')
  # data <- read.csv("politics-data-for-model.csv")
  # 
  # modelboostpredict <- reactive({
  #   predict(bestmod, newdata = databoost)
  # })
  # 
  # output$pred2 <- renderText({
  #   modelboostpredict()
  # })
  
  output$boosting2 <- renderText({
    findboosting2(input$URL1)
  })
  
  # output$boosting <- renderText({
  #   findboosting(input$URL1)
  # })
  
  #Huffstat output
  output$huff <- renderText({
    findhuff(input$URL1)
  })  
  
  #log output
  output$log <- renderText({
    findlog(input$URL1)
  })
  
  #SVM output
  output$svm <- renderText({
    findsvm(input$URL1)
  })
  
  #Our impact output
  output$ours <- renderText({
    findours(input$URL1)
  })
  
  #Plot
  load(file = "huffplot.rda")
  
  #boosting2 int
  xint_boost <- reactive({
    findboosting2(input$URL1)
  })
  
  #huffpost int
  # xint_huff <- reactive({
  #   findhuff(input$URL1)
  # })
  
  #log int
  xint_log <- reactive({
    findlog(input$URL1)
  })
  
  #svm int 
  xint_svm <- reactive({
    findsvm(input$URL1) 
  })
  
  #our int
  # xint_ours <- reactive({
  #   findours(input$URL1)
  # })
  
  
  output$plot <- renderPlot({
    plot + 
      geom_vline(xintercept = xint_boost(), color = "red", size = 1.5) +
      geom_vline(xintercept = xint_log(), color = "blue", size = 1.5) +
      geom_vline(xintercept = xint_svm(), color = "green", size = 1.5)
  })
  
}

# Run the app ----
shinyApp(ui = ui, server = server)
