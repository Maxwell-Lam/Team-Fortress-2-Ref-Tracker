source('ui.R')

# Public Variables

buttonStyle = "color: #fff; background-color: #337ab7; border-color: #2e6da4"

backpackRValues <- reactiveValues(
  excelRecords = data.frame()
)

server = shinyServer(function(input, output, session) {
  #### backpackTF Page
  
  # Observe Excel File Input
  observeEvent(input$refExcelInput, {
    dataPath <- input$refExcelInput$datapath[1]
    df <- read.xlsx(dataPath)
    
    #Desired Template
    templateColNames <- c("Date", "Time", "Order.Type", "Id", "Ref.Amount")
    
    matchCheck = TRUE
    
    for (i in 1:length(templateColNames))
    {
      if (templateColNames[i] != colnames(df)[i])
      {
        matchCheck = FALSE
      }
    }
    
    # If Doesn't match template, then quit:
    if (!matchCheck)
    {
      return(FALSE)
    }
    
    # If does match template, continue:
    
    backpackRValues$excelRecords <- df
    
    # Shows "Add Order Record" UI
    output$addOrderSector <- renderUI({
      box(
        id = "addOrderBox",
        width = "100%",
        title  = "Add Order Record",
        
        # Order Type Selector
        selectInput(
          label = "Select Order Type: ",
          inputId = "selectOrderType",
          choices = list("Sell Order", "Buy Order"),
          selected = "Sell Order"
        ),
        
        # Order Inputs
        column(
          width = 4,
          textInput(
            inputId = "order1",
            label = "Order 1:",
            value = "0"
          ),
          
        ),
        column(
          width = 4,
          textInput(
            inputId = "order2",
            label = "Order 2:",
            value = "0"
          ),
          
        ),
        column(
          width = 4,
          textInput(
            inputId = "order3",
            label = "Order 3:",
            value = "0"
          )
        ),
        
        actionButton(
          inputId = "addRecordButton",
          label = "Add Record",
          width = "200px",
          style = buttonStyle
        )
      )
      
    })
    
  })
  
  # When Add Record Button is pressed. 
  observeEvent(input$addRecordButton, {
    if ((is.na(as.numeric(input$order1))) ||
        (is.na(as.numeric(input$order2))) ||
        (is.na(as.numeric(input$order3))))
    {
      showNotification("Invalid Order Value(s).")
      return(FALSE)
    }
    
    order1Ref <- as.numeric(input$order1)
    order2Ref <- as.numeric(input$order2)
    order3Ref <- as.numeric(input$order3)
    
    df <- backpackRValues$excelRecords
    # df$Date <- as.Date.POSIXct(df$Date)
    # df$Time <- as.POSIXct(df$Time)

    currentDate <- format(Sys.Date(), "%m/%d/%y")
    currentTime <- format(Sys.time(), "%H:%M:%S")
    
    order1Addition <- c(currentDate, currentTime, input$selectOrderType, 1, order1Ref)
    order2Addition <- c(currentDate, currentTime, input$selectOrderType, 2, order2Ref)
    order3Addition <- c(currentDate, currentTime, input$selectOrderType, 3, order3Ref)
    
    df <- rbind(df, order1Addition)
    df <- rbind(df, order2Addition)
    df <- rbind(df, order3Addition)
    
    colnames(df) <- c("Date", "Time", "Order Type", "Id", "Ref Amount")
    
    write_xlsx(df, "Ref Tracker Template.xlsx")
    backpackRValues$excelRecords <- df
    
    
  })
  
})