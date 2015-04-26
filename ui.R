library(shiny)

shinyUI(
  navbarPage("Forecasting Tool",
             tabPanel("Data",
                      sidebarLayout(
                        sidebarPanel(
                          selectInput("select_data",label=strong("Pick a dataset "),
                                       choices=list("Monthly anti-diabetic drug sales in Australia from 1992 to 2008"=1,
                                                    "Quarterly expenditure on eating out in Australia"=2,
                                                    "Quarterly retail trade: Euro area"=3,
                                                    "USA Electricity monthly total net generation"=4
                                       ),
                                       selected=1
                          ),
                          p("Alternatively, if you want to use your own dataset:"),
                          br(),
                          fileInput('file',strong('Choose file to upload (Max file size = 3 MB)'),
                                    accept = c(
                                      'text/csv',
                                      'text/comma-separated-values',
                                      'text/tab-separated-values',
                                      'text/plain',
                                      '.csv',
                                      '.tsv'
                                    )
                          ),
                          helpText("Please only upload csv file with one column of time-series values (a vector),
                                   and specify the details below:"),
                          numericInput('start','Start year',2000),
                          numericInput('freq','Frequency per year',12),
                          helpText("For example, monthly dataset has frequency of 12 per year,
                                   quarterly dataset has frequency of 4 per year.")
                        ),
                        mainPanel(
                          tableOutput('table1')
                        )
                      )
             ),
             tabPanel("Exploratory Data Analysis",
                      sidebarLayout(
                        sidebarPanel(
                          radioButtons("graphic_radio",label=h3("Pick a plot to explore the data"),
                                       choices=list("Time plot"=1,
                                                    "Seasonal plot"=2,
                                                    "Seasonal subseries plot"=3,
                                                    "Autocorrelation lag plot"=4,
                                                    "Autocorrelation function (ACF)"=5
                                                   ),
                                       selected=1
                                      )
                        ),  
                        mainPanel(
                          plotOutput("plot")
                        )
                      )
              ),
             tabPanel("Decomposition",
                      sidebarLayout(
                        sidebarPanel(
                          radioButtons("select_adj",label=h4("Select a smoothing/adjustment"),
                                       choices=list("Seasonal adjustment"=1,
                                                    "Moving average"=2,
                                                    "STL decomposition"=3
                                       ),
                                       selected=1
                          ),
                          helpText("Only for Moving Average:"),
                          numericInput('order','Specify the order of moving average',3)
                        ),  
                        mainPanel(
                          plotOutput("adj")
                        )
                      )
             ),
             tabPanel("Forecasting",
                      sidebarLayout(
                        sidebarPanel(
                          radioButtons("select_forc",label=h4("Select a forecasting method"),
                                       choices=list("ARIMA"=1,
                                                    "ETS (Holt-Winters)"=2
                                       ),
                                       selected=1
                          ),
                          helpText("For demo and simplification purpose, the parameters for the above forecasting
                                   method are automatically chosen."),
                          numericInput('horizon','Specify the forecast horizon (no of periods)',10)
                        ),  
                        mainPanel(
                          plotOutput("forc")
                        )
                      )
             )
                       
  )
)           
             
             