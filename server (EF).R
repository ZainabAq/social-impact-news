library(shiny)

shinyServer(
  function(input,output){
    
    output$contents <- reactive({
      output$contents <- renderTable({
        if(is.null(input$file1))
          return(NULL) 
        
      req(input$datafile)
      df <- read.csv(input$file$datapath,
                     header=input$header,
                     sep-input$sep)
    })
    
    if(input$disp == "head") {
      return(head(df))
    }
    else{
      return(df)
    }
    
  })
})

#Resources:
#https://shiny.rstudio.com/articles/upload.html