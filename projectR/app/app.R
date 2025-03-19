library(shinydashboard)
library(shiny)
library(glue)
library(R6)
library(shinyGizmo)
setwd("/home/jach/work/github/genomicSelectionDashboard/projectR/")
source("app/logic/dynamicUiManagingTemplateContainer.R", local = TRUE)


BaseCassandraPanelUi<-dynamicUiManagerTemplateUI$new()

ui <- 
  dashboardPage(

    dashboardHeader(title = "Dynamic sidebar"),
    dashboardSidebar(#sidebarMenuOutput("menu")),
    sidebarMenu(id = "tabs",
                menuItem(
                  "cassandraPanel",
                  icon = icon("calendar"),
                  tabName = "tab_cassandra"
                ),
                menuItem(
                  "versionControl",
                  icon = icon("globe"),
                  tabName = "tab_git"
                )
    )),
    dashboardBody(

      tabItems(
        #tabItem(tabName = "tab_cassandra", cassandra_panel_Ui$ui(ns("cassandra_panel"))),
        #tabItem(tabName = "tab_cassandra",uiOutput("cassandra_panel"))# dynamicUiManagingTemplateContainer$dynamicUiManagerTemplateUI$dynamicUiManagerTemplateUI_UI("dynamicUiId")),
        #tabItem(tabName = "tab_git", git_panel_Ui$ui("git")
        tabItem(tabName = "tab_cassandra",BaseCassandraPanelUi$dynamicUiManagerTemplateUI_UI("dynamicUiId"))
      )

     )
     

  )
  #)



server <- function(input, output, session) {
  #moduleServer(id, function(input, output, session) {
    
    BaseCassandraPanelServer<-dynamicUiManagerTemplate$new(input, output, session,"dynamicUiId")



    #output$cassandra_panel <- renderUI(BaseCassandraPanelUi$dynamicUiManagerTemplateUI_UI("dynamicUiId"))

      #git_panel_Server$server(id = "git")

  
  

}#)
#}

shinyApp(ui, server)
