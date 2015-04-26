library(fpp);library(forecast)
library(shiny)
options(shiny.maxRequestSize=3*1024^2)

shinyServer(function(input,output){
  #Exploratory Data Analysis
  
  dataInput <- reactive({
    inFile <- input$file
    if(is.null(inFile)){
      return(NULL)
    }else{
    read.csv(inFile$datapath)
    }
  })
  
  data1 <- reactive({
    data0 <- a10
    data0 <- if(input$select_data==1){
                a10
              }else if(input$select_data==2){
                cafe
              }else if(input$select_data==3){
                euretail
              }else if(input$select_data==4){
                usmelec
              }
    if(is.null(dataInput())){
      data0
    }else{
      ts(as.numeric(gsub(",","",as.character(dataInput()$x))),
      start=input$start,frequency=input$freq)
    }
  })
  output$table1 <- renderTable({
    data1()
  })
  
  output$plot <- renderPlot({
    if(input$graphic_radio==1){
      plot(data1())
    }else if(input$graphic_radio==2){
      seasonplot(data1(),frequency(data1()),year.labels=TRUE,
                 year.labels.left=TRUE,col=seq_len(end(data1())[1]-start(data1())[1]),
                 pch=19)
    }else if(input$graphic_radio==3){
      monthplot(data1())
    }else if(input$graphic_radio==4){
      lag.plot(data1(),lags=9,do.lines=FALSE)
    }else if(input$graphic_radio==5){
      Acf(data1())
    }
  })
  
  fit1 <- reactive({
    stl(data1(),s.window="periodic",robust=TRUE)
  })
  output$adj <- renderPlot({
    if(input$select_adj==1){
      plot(data1())
      lines(seasadj(fit1()),col="red")
    }else if(input$select_adj==2){
      plot(data1())
      lines(ma(data1(),order=input$order),col="red")
    }else if(input$select_adj==3){
      plot(fit1())
    }  
  })
  
  fit2 <- reactive({
    if(input$select_forc==1){
      auto.arima(data1())
    }else if(input$select_forc==2){
      HoltWinters(data1())
    }
  })
  output$forc <- renderPlot({
      plot(forecast(fit2(),h=input$horizon))
  })
    
})
