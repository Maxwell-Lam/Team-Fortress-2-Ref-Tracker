library(shiny)
library(shinydashboard)
library(dplyr)
library(stringr)
library(readxl)
library(tidyr)
library(writexl)
library(openxlsx)
library(shinyWidgets)

dashboardPage(
  dashboardHeader(title = "Team Fortress 2 Ref Tracker"),
  
  dashboardSidebar(sidebarMenu(
    menuItem(text = "Welcome Page", tabName = "welcomePage"),
    menuItem(text = "Backpack.tf", tabName = "backpackTF"),
    menuItem(text = "Trading Services", tabName = 'tradingServicesPage')
  )),
  
  dashboardBody(tabItems(
    tabItem(tabName = "welcomePage", fluidPage(box(status = "success"))),
    
    tabItem(
      tabName = "backpackTF",
      
      box(
        id = "uploadBackpackBox1",
        width = "100%",
        
        fileInput(inputId = "refExcelInput", label = "Browse backpack.tf Ref Template:")
      ),
      
      uiOutput("addOrderSector")
      

      

      
    ),
    
    tabItem(tabName = "tradingServicesPage")
  ))
)