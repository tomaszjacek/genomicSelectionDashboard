library(shiny)
library(shinyGizmo)
library(glue)
library(magrittr)
source("tools.R")

columnTypes <- c('ascii','bigint','blob','boolean','counter','date','decimal','double','duration','float','inet','int','smallint','text','time','timestamp','timeuuid','tinyint','uuid','varchar','varint')

column_ui <- function(id,name){

  wellPanel(
    id = glue("{id}"),
    modalDialogUI(
      glue("{id}_modal"),
      textInput(glue("{id}_name"), "Name",value = name),
      selectInput(
        glue("{id}_type"),
        label="removeType",
        choices=columnTypes
        
      ),
      footer = actionButton(glue("{id}_confirm"), "Confirm", `data-dismiss`="modal")
      ),
      
      actionButton(glue("{id}_delete"),NULL,icon("trash-alt")),
      textOutput(glue("{id}_outname"), inline =TRUE)
    )

}

column_server <- function(id,input,output,session){
  observeEvent(input[[glue("{id}_delete")]], {
    removeUI(selector = glue("#{id}"))
  })
  
  observeEvent(input[[glue("{id}_confirm")]],{
    print("modal closed")
  })
  
  output[[glue("{id}_outname")]] <- renderText({
    input[[glue("{id}_name")]]
  })
  
}

ui<-fluidPage(
  sidebarLayout(
    sidebarPanel(
      h3("generator"),
      numericInput(inputId = "nrow", "Number of rows", value=50, min=1, max = 1000,step = 1),
      textOutput("number_facts"),
      div(id="variables"),
      div(
        id= "define-vars",
        textInput("name", "Column name"),
        conditionalPanel(
          "input.name != ''",
          actionButton("new",NULL,icon=icon("plus"),width="100%")
        )
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

  observeEvent(input$new,{
    id<-genid()
    insertUI(
      "#variables",
      where = "beforeEnd",
      column_ui(id,input$name),
      immediate=TRUE
    )
    column_server(id,input,output,session)
  })
  
  # observeEvent(input$remove,{
  #   removeUI(
  #     selector = glue("#{input$which}"),
  #   )
  # })
  
  observeEvent(input$run, {
    if(identical(input$nrow>0,TRUE)){
      my_table(iris[1:input$nrow,])
    }else{
      my_table(NULL)
      n_row(NULL)
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
