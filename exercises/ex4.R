library(shiny)
library(glue)
library(DT)

ui<-fluidPage(
  sidebarLayout(
    sidebarPanel(
      h3("Table generator"),
      
      numericInput(inputId = "nrow", label = "Maximum row in table", value=10, min=1, max = 50,step = 4),
      div(id = "variables"),

        div(
          id = "define-vars",
          textInput("name", "Column name"),
          conditionalPanel(
            "input.name!=''",
            actionButton("new", NULL, icon=icon("plus"),width = "100%")
          )
      ),
      conditionalPanel(
        "input.nrow>0",
        actionButton("run", "generate",width = "100%")
      ),
      width = 2
    ),
    mainPanel(
      dataTableOutput("table"),
      width = 10
    )
  )
)


server <-function(input,output,session){
  
  iris_data  <-reactiveVal(NULL)
  n_row  <-reactiveVal(NULL)
  
  observeEvent(input$run, {
    if(identical(input$nrow>0,TRUE)){
      iris_data(iris[1:input$nrow,])
      n_row(input$nrow)
    }else{
      iris_data(NULL)
      n_row(NULL)
    }
  }
  )
  
  # output$table <- renderDataTable({
  #   validate(need(!is.null(iris_data()),message = "novaliddata"))
  #     iris_data()
  #     },
  #     options=list(paging=TRUE,pageLength=10,searching=FALSE))
  # }

  
  output$table <- renderDataTable({
    validate(need(!is.null(iris_data()),message = "novaliddata"))
    DT::datatable(
      iris_data(),
      options=list(paging=TRUE,pageLength=10,searching=FALSE)
    )
  })

  
  
  observeEvent(input$new,{
    print("buttonNEWClicked")
    print(input$name)
  })
  
}


shinyApp(ui, server)

