library(shiny)
library(shinyGizmo)
library(glue)
library(magrittr)
ui <- fluidPage(
  
  numericInput("numeric", "value", value = 0),
  actionButton("button","submit"),
  textOutput("text"),
  modalDialogUI(
    "modal",
    textInput("name", "Name",value = 'name'),
    textInput("namee", "Name",value = 'deupa'),
    footer = actionButton("confirm", "Confirm", `data-dismiss`="modal")
  )
)

server <- function(input, output, session) {
  
  output$text <- renderText({
    input$numeric^2
    
  }) |> bindEvent(input$button)
  
}

shinyApp(ui, server)