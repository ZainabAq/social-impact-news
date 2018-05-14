library(shiny)
library(dplyr)
library(ggplot2)
library(RMySQL)
library(pROC)
library(formattable)

source("findstats.R")

#data for graph 
politics_s3_graph <- politics_s3 %>%
  select(total_words,  Views, Tw_interactions, pos2, neg1, Fb_refs, New_vis., Mobile_views)

#data for sum stats
politics_s3_find <- politics_s3 %>%
  select(-Title, -URL, -impact, -Impact)

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
    column(7,
           plotOutput("plot")
    ),
    column(5,
           h6("Summary Statistics", align = "Center"),
           br(),
           tableOutput("sumtable"))
    
    #To add panels:
    
    # tabsetPanel(type = "tabs",
    #             tabPanel("Summary Statistics",
    #                      br(),
    #                      # tableOutput("sumstats1"),
    #                      # br(),
    #                      # tableOutput("sumstats2"),
    #                      # br(),
    #                      # tableOutput("sumstats3"),
    #                      
    #             )
    # tabPanel("Choose Variable",
    #          br(),
    #          selectInput("variable", "Variable:",
    #                      choices= colnames(politics_s3_find), width = "100%"),
    #          br(),
    # #          # tableOutput("var1")),
    # #          plotOutput("plot2")
    #          h4("For this article:", align = "center"),
    #          h4(textOutput("var"), align = "center"))
    # # tabPanel("Distribution of Variable",
    # #          br(),
    # #          plotOutput("plot2"))
    # )
    
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
             tags$li("Other Interactions")
           )
    ),
    column(3,
           h5("Logistic Model:"),
           strong(span(textOutput("log"), style="color:blue")),
           br(),
           tags$ul(
             tags$li("Average Views: Returning Visitors"), 
             tags$li("Mobile Views"), 
             tags$li("Smog Index")
           )
    ),
    column(3,
           h5("SVM Classification:"),
           strong(span(textOutput("svm"), style='color:green')),
           br(),
           tags$ul(
             tags$li("Total Words"), 
             tags$li("Average Views: Returning Visitors"), 
             tags$li("Internal Referrals")
           )
    ),
    column(3,
           h5("Our Classification:"),
           strong(span(textOutput("ours")))
    )
  )
) 


# Define server logic ----
server <- function(input, output) {
  
  # db <- src_mysql(dbname = "social_impact", host="scidb.smith.edu", port=3306, user = "capstone18", password="xxx")
  # # 
  # the_article <- db %>%
  #   tbl("FINAL_POLITICS") %>%
  #   filter(URL == input$URL1) %>%
  #   collect(n = Inf)
  
  output$title <- renderText({
    findvar(input$URL1, "Title")
  })
  
  output$boosting <- renderText({
    findvar(input$URL1, "predboosting")
  })
  
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
  
  ##### trying to create a table
  
  output$sumtable <- renderTable({  
    Variable <- c('Total Words', 'Views', 'Other Interactions', 'Avg Views: Returning Vis', 'Mobile Views','Smog Index', 'Internal Referrals')
    Value <- c(findvar(input$URL1, "total_words"), findvar(input$URL1, "Views"), findvar(input$URL1, "Other_int"), 
               findvar(input$URL1, "Avg._views_ret._vis."), findvar(input$URL1, "Mobile_views"), findvar(input$URL1, "smog_index"),
               findvar(input$URL1, "Internal_refs"))
    Median <- c(median(politics_s3$total_words), median(politics_s3$Views), median(politics_s3$Other_int), 
                median(politics_s3$Avg._views_ret._vis.), median(politics_s3$Mobile_views), median(politics_s3$smog_index), median(politics_s3$Internal_refs))
    Q1 <- c(quantile(politics_s3$total_words, 0.25), quantile(politics_s3$Views, 0.25), quantile(politics_s3$Other_int, 0.25),
            quantile(politics_s3$Avg._views_ret._vis., 0.25), quantile(politics_s3$Mobile_views, 0.25), quantile(politics_s3$smog_index, 0.25), quantile(politics_s3$Internal_refs, 0.25))
    Q2 <- c(quantile(politics_s3$total_words, 0.75), quantile(politics_s3$Views, 0.75), quantile(politics_s3$Other_int, 0.75),
            quantile(politics_s3$Avg._views_ret._vis., 0.75), quantile(politics_s3$Mobile_views, 0.75), quantile(politics_s3$smog_index, 0.27), quantile(politics_s3$Internal_refs, 0.75))
    
    # row_names <- c('Total words', 'Views', 'Twitter interactions', 'Negative1', 'Positive2', 'New visitors', 'Mobile views')
    table1 <- data.frame(Variable, Value, Median, Q1, Q2, row.names = NULL)
    
    formattable(table1, digits = 0)
  })
  
  #summary table
  # output$sumstats1 <- renderTable({
  #   findtable1(input$URL1)
  # })
  # 
  # output$sumstats2 <- renderTable({
  #   findtable2(input$URL1)
  # })
  # 
  # output$sumstats3 <- renderTable({
  #   findtable3(input$URL1)
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
}

# Run the app ----
shinyApp(ui = ui, server = server)
