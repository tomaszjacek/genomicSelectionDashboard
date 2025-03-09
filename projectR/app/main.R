box::use(
  shinydashboard[dashboardHeader,dashboardSidebar,dashboardBody,dashboardPage,sidebarMenuOutput,tabItems,tabItem],
  shiny[bootstrapPage, div, moduleServer, NS, renderUI, tags, 
        
        uiOutput,sidebarLayout,sidebarPanel,h3,numericInput,textOutput,textInput,conditionalPanel,actionButton,icon,mainPanel],
)

box::use(
  #app/view/cassandra/cassandra_panel_Ui,
  #app/view/cassandra/cassandra_panel_Server,
  app/view/git/git_panel_Ui,
  app/view/git/git_panel_Server
)

#' @export
ui <- function(id) {
  ns <- NS(id)
  dashboardPage(
  dashboardHeader(title = "Dynamic sidebar"),
  dashboardSidebar(sidebarMenuOutput("menu")),
  dashboardBody(tabItems(
    #tabItem(tabName = "tab_cassandra", cassandra_panel_Ui$ui("cassandra_panel")),
    tabItem(tabName = "tab_git", git_panel_Ui$ui("git"))
    
  ))
)
}
#' @export
server <- function(input, output) {
  # Function to load settings from file
  active_modules <- reactiveVal(value = NULL)
  
  #globalData <- callModule(globalVariablesModule, "globals")
  
  globalData<-NULL
  
  # observeEvent(input$tabs,{
  #   if(input$tabs=="tab_cassandra"){
  #     cassandra_panel_Server$server(id = "cassandra_panel")
  #     active_modules(c("cassandra_panel", active_modules()))
  #   }
  # }, ignoreNULL = TRUE, ignoreInit = TRUE)
  # 
  
  
  
  observeEvent(input$tabs,{
    if(input$tabs=="tab_git"){
      git_panel_Server$server(id = "git",globalData)
      active_modules(c("git", active_modules()))
    }
  }, ignoreNULL = TRUE, ignoreInit = TRUE)

  
  
  output$menu <- renderMenu({
    sidebarMenu(id = "tabs",
                # menuItem(
                #   "cassandraPanel",
                #   icon = icon("calendar"),
                #   tabName = "tab_cassandra"
                # )
                menuItem(
                  "versionControl",
                  icon = icon("globe"),
                  tabName = "tab_git"
                )
    )
  })
}


