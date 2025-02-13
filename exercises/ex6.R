library(shiny)
library(shinyGizmo)
library(glue)
#source("tools.R")

column_ui <- function(id,name){
  wellPanel(
    id = id,
    modalDialogUI(
      glue("{id}_modal"),
      testInput(glue("{id}_name", "Name",value = name)),
                footer = actionButton(glue("{id}_confirm"), "Confirm", 'data-dismiss'="modal")
      ),
      
      actionButton(glue("{id}_delete"),NULL,icon("trash-alt")),
      textOutput(glue("{id}_outname"), inline =TRUE)
    )
}

column_server <- function(id,input,output,session){
  observeEvent(input[[glue("{id}_delete")]], {
    
  })
  
  observerEvent(input[[glue("{id}_confirm")]],{
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
      numericInput(inputId = "nrow", label = "Number of rows", value=50, min=1, max = 1000,step = 1),
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
        "input.nrow>0",
        actionButton("run","Generate",width="100%")
      ),
      width = 2
    ),
    mainPanel(
      DT::dataTableOutput("plot_table"),
      width = 10
    )
  )
)

server <-function(input,output,session){
  my_table<-reactiveVal(NULL)
  observeEvent(input$new,{
    id<-genid()
    insertUI(
      selector = "#variables",
      where = "beforeEnd",
      ui = column_ui(id,input$name),
      immediate=TRUE
    )
    column_server(id,input,output,session)
  })
  
  observeEvent(input$remove,{
    removeUI(
      selector = glue("#{input$which}"),
    )
  })
}


shinyApp(ui, server)
