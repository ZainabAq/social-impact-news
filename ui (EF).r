library(shiny)

shinyUI(fluidPage(
  
  #App title
  titlePanel("Social Impact Rating Generator"),
  
  #Sidebar
  sidebarLayout(
    
    
    sidebarPanel(("Enter Data Set"),
                 given <- fileInput("datafile","Choose CSV file",
                           accept=c(
                             "text/csv",
                             "text/comma-separated-values,text/plain",
                             ".csv"
                             )
                           ),
                 
                
    
                 checkboxInput("header","Header",TRUE),
                 
                 radioButtons("sep", "Separator",
                              choices = c(Comma = ",",
                                          Semicolon = ";",
                                          Tab = "\t"),
                              selected = ","
                              )
    ),
                 
                 
                 mainPanel(
                   tableOutput("contents")
                   #plotOutput("plot")
                 )
    )
)
)