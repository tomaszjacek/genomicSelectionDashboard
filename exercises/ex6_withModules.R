library(shiny)
library(shinyGizmo)
library(glue)
library(magrittr)
source("tools.R")

column_ui <- function(id,name){
  ns<-NS(id)
  wellPanel(
    id = id,
    modalDialogUI(
      ns("modal"),
      textInput(ns("name"), "Name",value = name),
      textInput(ns("namee"), "Name",value = 'deupa'),
      footer = actionButton(ns("confirm"), "Confirm", `data-dismiss`="modal")
    ),
    
    actionButton(ns("delete"),NULL,icon("trash-alt")),
    textOutput(ns("outname"), inline =TRUE)
  )
  
}

column_server <- function(id){
  
  moduleServer(id, function(input, output, session) {
    showModalUI("modal")
    
    observeEvent(input[["delete"]], {
      removeUI(selector = glue("#{id}"))
    })
  
    observeEvent(input[["confirm"]],{
      print(reactiveValuesToList(input))
      print("modal closed")
      #updateTextInput(session,"name",value="")
      tmp<- session$userData$modal_closed()
      session$userData$modal_closed(tmp+1)
    })
  
    output[["outname"]] <- renderText({
      input[["name"]]
    })
  })
}

ui<-fluidPage(
  sidebarLayout(
    sidebarPanel(
      h3("generator"),
      numericInput(inputId = "nrow", "Number of rows", value=50, min=1, max = 1000,step = 1),
      textOutput("number_facts"),
      div(id="variables"),
      textInput("name", "Column name"),
      conditionalPanel(
        "input.name != ''",
        actionButton("new",NULL,icon=icon("plus"),width="100%")
      ),
      conditionalPanel(
        "input.nrow>0 & $(#variables >div).length > 0",
        actionButton("run","Generate",width="100%")
      ),
      width = 2
    ),
    mainPanel(
      DT::dataTableOutput("table"),
      width = 10
    )
  )
)

server <-function(input,output,session){
  my_table<-reactiveVal(NULL)
  session$userData$modal_closed <- reactiveVal(1)
  
  observeEvent(input$new,{
    id<-genid()
    insertUI(
      "#variables",
      where = "beforeEnd",
      ui = column_ui(id,input$name),
      immediate=TRUE
    )
    column_server(id)
  })
  
   observeEvent(session$userData$modal_closed(),{
     updateTextInput(session,inputId="name",value="")
   })
  
  observeEvent(input$run, {
    if(identical(input$nrow>0,TRUE)){
      my_table(iris[1:input$nrow,])
    }else{
      my_table(NULL)
    }
  }
  )
  output$table <- DT::renderDataTable({
    validate(need(!is.null(my_table()),message = "novaliddata"))
    DT::datatable(
      my_table(),
      options=list(paging=TRUE,pageLength=10,searching=FALSE)
    )
  })
  
}


shinyApp(ui, server)
