# library(shiny)
# library(shinyGizmo)
# library(glue)
# library(magrittr)
# source("tools.R")
box::use(
  shinydashboard[dashboardHeader,dashboardSidebar,dashboardBody,dashboardPage,sidebarMenuOutput,tabItems,tabItem, renderMenu, menuItem,sidebarMenu],
  shiny[bootstrapPage,reactiveVal, observeEvent,div, moduleServer, NS, renderUI, tags, insertUI,wellPanel,selectInput,renderText,validate,need,fluidPage,removeUI,
        uiOutput,sidebarLayout,sidebarPanel,h3,numericInput,textOutput,textInput,conditionalPanel,actionButton,icon,mainPanel],
  shinyGizmo[modalDialogUI],
  glue[...]
)
box::use(

  app/logic/tools
)



#' @export
server <- function(id){ #,input,output,session){
  moduleServer(id, function(input,output,session){
  ns<-session$ns
  ID<-ns("id")
  #ns <- NS(id)
  #id<-ns('')    
  print(paste0("column_server started ",ID," | "))
  observeEvent(input[["delete"]], {
    print(paste0("pressed delete", glue("#{ID}")))
    removeUI(selector = glue("#{ID}"))
  })
  
  observeEvent(input[["confirm"]],{
    print("modal closed")
  })
  observeEvent(input[["type"]],{
    print("column type ")
  })
  observeEvent(input,{
    print(input)
  })
  output[["outname"]] <- renderText({
    input[["name"]]
  })
  })
}


serveri <- function(id){ #,input,output,session){
  moduleServer(id, function(input,output,session){
  print(paste0("column_server started", id," | ",input))

  observeEvent(input[["delete"]], {
    print("delete pressed")
    removeUI(selector = glue("#{id}"))
  })
  
  observeEvent(input[["confirm"]],{
    print("modal closed")
  })
  
  output[["outname"]] <- renderText({
    input[["name"]]
  })
  })
}

