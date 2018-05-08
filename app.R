# install.packages("shiny")
#install.packages("rPython")
library(shiny)
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
library(pROC)
library(formattable)
library(skimr)
library(sparkline)
source("findstats.R")

#data for graph 
politics_s3_graph <- politics_s3 %>%
  select(total_words,  Views, Tw_interactions, pos2, neg1, Fb_refs, New_vis., Mobile_views)


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
fluidRow(
  column(8,
         plotOutput("plot")
  ),
  column(4,
         tabsetPanel(type = "tabs",
                     tabPanel("Summary Stats",
                              br(),
                              # sparklineOutput("sparkline")
                              # tableOutput("sumstats1"),
                              # br(),
                              # tableOutput("sumstats2"),
                              # br(),
                              # tableOutput("sumstats3"),
                              h5("Total Words:"),
                              textOutput("var1"),
                              h5("Views:"),
                              textOutput("var2"),
                              h5("Twitter Interactions:"),
                              textOutput("var3"),
                              h5("Negative1:"),
                              textOutput("var4"),
                              h5("Positive2:"),
                              textOutput("var5"),
                              h5("Total Sentences:"),
                              textOutput("var6"),
                              h5("Facebook References:"),
                              textOutput("var7")
                     ),
                     tabPanel("Choose Variable",
                              br(),
                              selectInput("variable", "Variable:", 
                                          choices= colnames(politics_s3_graph), width = "100%"),
                              br(),
                              br(),
                              # tableOutput("var1")),
                              h4("For this article:", align = "center"),
                              h4(textOutput("var"), align = "center")),
                     tabPanel("Distribution of Variable",
                              br(),
                              plotOutput("plot2"))
                     )
  )
),
  
  hr(),
  h4("Probabilities of Social Impact"),
  
  fluidRow(
    column(3,
           h5("Optimized Boosting Model:"),
           strong(span(textOutput("boosting"), style="color:red")),
           br(),
           tags$ul(
             tags$li("Total Words"), 
             tags$li("Views"), 
             tags$li("Twitter Interactions")
           )
    ),
    column(3,
           h5("Logistic Model:"),
           strong(span(textOutput("log"), style="color:blue")),
           br(),
           tags$ul(
             tags$li("Total Words"), 
             tags$li("Negative1"), 
             tags$li("Positive2")
           )
    ),
    column(3,
           h5("SVM Classification:"),
           strong(span(textOutput("svm"), style='color:green')),
           br(),
           tags$ul(
             tags$li("Facebook References"), 
             tags$li("New visitors"), 
             tags$li("Mobile Views")
           )
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
    findvar(input$URL1, "Title")
  })
  
  output$boosting <- renderText({
    findvar(input$URL1, "predboosting")
  })
  
  #Huffstat output
  # output$huff <- renderText({
  #   findhuff(input$URL1)
  # })  
  
  #log output
  output$log <- renderText({
    findvar(input$URL1, "predlog")
  })
  
  #SVM output
  output$svm <- renderText({
    findvar(input$URL1, "predsvm")
  })
  
  #Our impact output
  output$ours <- renderText({
    findvar(input$URL1, "impact")
  })
  
  #############Summary Statistics
  output$var <- renderText({
  end <- findvar(input$URL1, input$variable)
  paste("•", end)
  })
  
  # output$var1 <- renderText({
  #   findtable(input$URL1, input$variable)
  # })
  
  #list of summary stats
  output$var1 <- renderText({
  end <- findvar(input$URL1, "total_words")
  paste("•", end)
  })

  output$var2 <- renderText({
    end <- findvar(input$URL1, "Views")
    paste("•", end)
  })

  output$var3 <- renderText({
    end <- findvar(input$URL1, "Tw_interactions")
    end2 <- sparkline(politics_s3_graph$Tw_interactions, type = "bar")
    paste("Twitter interactions:","•", end, end2)
  })

  output$var4 <- renderText({
    end <- findvar(input$URL1, "neg1")
    paste("•", end)
  })

  output$var5 <- renderText({
    end <- findvar(input$URL1, "pos2")
    paste("•", end)
  })

  output$var6 <- renderText({
    end <- findvar(input$URL1, "total_sentences")
    paste("•", end)
  })

  output$var7 <- renderText({
    end <- findvar(input$URL1, "Fb_refs")
    paste("•", end)
  })
  
  output$sumstats1 <- renderTable({
    findtable1(input$URL1)
  })
  
  output$sumstats2 <- renderTable({
    findtable2(input$URL1)
  })
  
  output$sumstats3 <- renderTable({
    findtable3(input$URL1)
  })
  
  output$skimtable <- renderText({
    skim(politics_s3_graph, total_words)
  })
  
  output$sparkline <- renderSparkline({
    sparkline(politics_s3_graph$total_words, type = "bar")
  })
  
  # output$sumstats1 <- renderTable({
  #   findtable(input$URL1, "total_words")
  # })
  # output$sumstats2 <- renderTable({
  #   findtable(input$URL1, "Views")
  # })
  
  #############Plot
  load(file = "huffplot.rda")
  
  #boosting2 int
  xint_boost <- reactive({
    findvar(input$URL1, "predboosting")
  })
  
  #log int
  xint_log <- reactive({
    findvar(input$URL1, "predlog")
  })
  
  #svm int 
  xint_svm <- reactive({
    findvar(input$URL1, "predsvm") 
  })
  
  
  output$plot <- renderPlot({
    plot + 
      geom_vline(xintercept = xint_boost(), color = "red", size = 1.5) +
      geom_vline(xintercept = xint_log(), color = "blue", size = 1.5) +
      geom_vline(xintercept = xint_svm(), color = "green", size = 1.5)
  })
  
  ###Summary stat plot
  
  variableInput <- reactive({
    switch(input$variable,
           "total_words" = politics_s3$total_words,
           "Tw_interactions" = politics_s3$Tw_interactions,
           "neg1" = politics_s3$neg1,
           "pos2" = politics_s3$pos2,
           "Views" = politics_s3$Views,
           "Fb_refs" = politics_s3$Fb_refs,
           "New_vis." = politics_s3$New_vis.,
           "Mobile_views" = politics_s3$Mobile_views)
  })
  
  #Xint 
  xint_var <- reactive({
    findvar(input$URL1, input$variable) 
  }) 
  
  output$plot2 <- renderPlot({
    
    # Render a barplot
    ggplot(data = politics_s3_graph, aes(variableInput())) +
      geom_density() +
      theme(axis.title.y = element_blank(), axis.text = element_text(size = 10),
            panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
            panel.background = element_blank(), axis.ticks.y = element_blank(), axis.text.y = element_blank())+
      geom_vline(xintercept = xint_var(), size = 1) +
      labs(x = input$variable)
    
  })
  
}

# Run the app ----
shinyApp(ui = ui, server = server)
