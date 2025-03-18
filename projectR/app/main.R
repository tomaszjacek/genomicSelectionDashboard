box::use(
  shinydashboard[dashboardHeader,dashboardSidebar,dashboardBody,dashboardPage,sidebarMenuOutput,tabItems,tabItem, renderMenu, menuItem,sidebarMenu],
  shiny[bootstrapPage,reactiveVal, observeEvent,div, moduleServer, NS, renderUI, tags, renderText,
        uiOutput,sidebarLayout,sidebarPanel,h3,numericInput,textOutput,textInput,conditionalPanel,actionButton,icon,mainPanel],

)

box::use(
  #app/view/cassandra/cassandra_panel_Ui,
  #app/view/cassandra/cassandra_panel_Server,
  app/logic/dynamicUiManagingTemplateContainer,
  app/view/git/git_panel_Ui,
  app/view/git/git_panel_Server
)

#' @export
ui <- function(id) {
  ns<-NS(id)
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
        tabItem(tabName = "tab_cassandra",uiOutput(ns("dynamicUiManagerTemplateUI_UI"))),# dynamicUiManagingTemplateContainer$dynamicUiManagerTemplateUI$dynamicUiManagerTemplateUI_UI("dynamicUiId")),
        tabItem(tabName = "tab_git", git_panel_Ui$ui("git")
      )

     )
     

  )
  )
}


#' @export
server <- function(id) {
  moduleServer(id, function(input, output, session) {
    
    #ns <- session$ns
    
  # Function to load settings from file
  #active_modules <- reactiveVal(value = NULL)
  
  #globalData <- callModule(globalVariablesModule, "globals")
  
  globalData<-NULL
  
  #observeEvent(input$tabs,{
    #if(input$tabs=="tab_cassandra"){
      #cassandra_panel_Server$server(id = "cassandra_panel")
      #active_modules(c("cassandra_panel", active_modules()))
    #}
  #}, ignoreNULL = TRUE, ignoreInit = TRUE)

  output$cassandra <- renderUI(dynamicUiManagingTemplateContainer$dynamicUiManagerTemplate$new(input, output, session,"dynamicUiId"))
  
  
  #observeEvent(input$tabs,{
  #  if(input$tabs=="tab_git"){
      git_panel_Server$server(id = "git")
      #active_modules(c("git", active_modules()))
   # }
  #}, ignoreNULL = TRUE, ignoreInit = TRUE)

  
  
  # output$menu <- renderMenu({
  #   sidebarMenu(id = "tabs",
  #               menuItem(
  #                 "cassandraPanel",
  #                 icon = icon("calendar"),
  #                 tabName = "tab_cassandra"
  #               )
  #               # menuItem(
  #               #   "versionControl",
  #               #   icon = icon("globe"),
  #               #   tabName = "tab_git"
  #               # )
  #   )
  # })
})
}


