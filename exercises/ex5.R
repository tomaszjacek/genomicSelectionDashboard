library(shiny)

ui<-fluidPage(
  actionButton(inputId="add", "Add"),
  actionButton(inputId="add2", "Add2"),
  numericInput("which", "Which to remove?", value =1),
  selectInput(
    inputId="removeType",
    label="removeType",
    choices=c('add','add2')

  ),
  actionButton("remove", "Remove"),
  div(id="variables"),
  hr(),
  div(id="variables2")
)

server <-function(input,output,session){
  observeEvent(input$add,{
    print(glue("|#add_{input$add}|"))
    insertUI(
      selector = "#variables",
      where = "beforeEnd",
      ui = wellPanel(id=glue("add_{input$add}"),glue("add_{input$add}")),
      immediate=TRUE
    )
  })
  observeEvent(input$add2,{
    print(glue("|#add2_{input$add2}|"))
    insertUI(
      selector = "#variables2",
      where = "beforeEnd",
      ui = wellPanel(id=glue("add2_{input$add2}"),glue("add2_{input$add2}")),
      immediate=TRUE
    )
  })
  observeEvent(input$remove,{
    print(glue("|#{input$removeType}_{input$which}|"))
    removeUI(
      selector = glue("#{input$removeType}_{input$which}")
      
    )
  })
}



shinyApp(ui, server)