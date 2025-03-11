box::use(
  shiny[bootstrapPage,reactiveVal, div, moduleServer, NS, renderUI, tags, uiOutput,fluidPage,sidebarLayout,sidebarPanel,h3,numericInput,textOutput,textInput,conditionalPanel,actionButton,icon,mainPanel],
)

columnTypes <- c('ascii','bigint','blob','boolean','counter','date','decimal','double','duration','float','inet','int','smallint','text','time','timestamp','timeuuid','tinyint','uuid','varchar','varint')


ui <- function(id) {
  ns <- NS(id)
  fluidPage(
    sidebarLayout(
      sidebarPanel(
        h3("generator"),
        numericInput(inputId = ns("nrow"), "Number of rows", value=50, min=1, max = 1000,step = 1),
        textOutput("number_facts"),
        div(id="variables"),
        div(
          id= "define-vars",
          textInput(ns("name"), "Column name"),
          conditionalPanel(
            "input.name != ''",
            actionButton(ns("new"), NULL, icon=icon("plus"), width="100%")
          )
        ),
        conditionalPanel(
          "input.nrow>0 & $(#variables >div).length > 0",
          actionButton(ns("run"),"Generate",width="100%")
        ),
        width = 2
      ),
      mainPanel(
        DT::dataTableOutput(ns("table")),
        width = 10
      )
    )
  )
}
