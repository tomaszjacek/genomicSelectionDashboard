library(shiny)

ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(
      h3("sidebarTitle"),
      "sidebar",
      width = 2
    ),
    mainPanel(
      div("in the main panel"),
      "im here as well",
      width = 10
    )
  )
  
)

server <- function(input, output, session) {
  
}

shinyApp(ui, server)