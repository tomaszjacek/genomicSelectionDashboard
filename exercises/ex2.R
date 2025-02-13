library(shiny)

ui<-fluidPage(
  sidebarLayout(
    sidebarPanel(
      h3("table generator"),
      numericInput(inputId = "nrow", label = "Number of rows", value=50,min=1,max=150,step=10),
      div(id = "variables"),
      div(
        id = "define-vars",
        textInput("name", "Column name"),
        actionButton("new", NULL, icon=icon("plus"),width = "100%")
      ),
      actionButton("run", "generate",width = "100%"),
      width = 2
    ),
    mainPanel(
      div("in the main panel"),
      "im here as well",
      width = 10
    )
  )
)


server <-function(input,output,session){
  observeEvent(input$new,{
    print("buttonClicked_new")
    print(input$name)
    print(input[["nrow"]])
  })
  observeEvent(input$run,{
    print("buttonClicked_run")
    print(input$name)
    print(input[["nrow"]])
  })
}


shinyApp(ui, server)