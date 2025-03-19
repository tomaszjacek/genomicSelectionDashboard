box::use(
  shinydashboard[dashboardHeader,dashboardSidebar,dashboardBody,dashboardPage,sidebarMenuOutput,tabItems,tabItem, renderMenu, menuItem,sidebarMenu],
  shiny[bootstrapPage,reactiveVal, observeEvent,div, moduleServer, NS, renderUI, tags, insertUI,wellPanel,selectInput,renderText,validate,need,fluidPage,removeUI,
        uiOutput,sidebarLayout,sidebarPanel,h3,numericInput,textOutput,textInput,conditionalPanel,actionButton,icon,mainPanel,
        verbatimTextOutput],
  shinyGizmo[modalDialogUI],
  glue[...]
)
box::use(
  app/logic/tools
)

#' @export
ui <- function(id,name){
  ns <- NS(id)
  ID<-ns("id")
  wellPanel(
    id = ID,
    modalDialogUI(
      ns("modal"),
      textInput(ns("name"), "Name",value = name),
      selectInput(
        ns("type"),
        label="removeType",
        choices=tools$cassandraColumnTypes
      ),
      footer = actionButton(ns("confirm"), "Confirm", `data-dismiss`="modal")
    ),
    
    actionButton(ns("delete"),NULL,icon("trash-alt")),
    textOutput(ns("outname"), inline =TRUE),
    renderText(ID),
    renderText(ns(ID)),
    renderText(glue("{id}_type")),
    renderText(ns("type"))
    #udzxt
    #udzxt_outname
    #udzxt-udzxt_outname
  )
}

#' @export
uii <- function(id,name){
  ns <- NS(id)
  wellPanel(
    id = id,
    modalDialogUI(
      glue("{id}_modal"),
      textInput(glue("{id}_name"), "Name",value = name),
      selectInput(
        glue("{id}_type"),
        label="removeType",
        choices=tools$cassandraColumnTypes
      ),
      footer = actionButton(glue("{id}_confirm"), "Confirm", `data-dismiss`="modal")
    ),
    
    actionButton(glue("{id}_delete"),NULL,icon("trash-alt")),
    textOutput(glue("{id}_outname"), inline =TRUE),
    renderText(glue("{id}")),
    renderText(glue("{id}_outname")),
    renderText(ns(glue("{id}_outname"))),
    #udzxt
    #udzxt_outname
    #udzxt-udzxt_outname
  )
}



#' @export
uix <- function(id,name){
  ns<-NS(id)
  fluidPage(
    wellPanel(
      id = id,
    #modalDialogUI(
      #ns("_modal"),
      textInput(ns("name"), "Name",value = name),
      selectInput(
        ns("type"),
        label="columnType",
        choices=tools$cassandraColumnTypes
      ),
     # footer = actionButton(ns("_confirm"), "Confirm", `data-dismiss`="modal")
    ),
    
    actionButton(ns("delete"),NULL,icon("trash-alt")),
    textOutput(ns("outname"), inline =TRUE),
    renderText(ns(id)),
    renderText(glue("{id}_outname")),
    renderText(ns("outname"))
    #)
  )
}