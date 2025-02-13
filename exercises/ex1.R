library(shiny)


ui<-fluidPage(
  sliderInput(
    inputId = "my_slider_one", label="select number here",value =1, min=1,max=10,step=1
  ),
actionButton(inputId="my_button", label= "Click")
)

server <- function(input,output,session){
  
  observeEvent(input$my_slider_one,{
    print("sliderBarchanged")
    print(input[["my_slider_one"]])
  })
  
  observeEvent(input$my_button,{
    updateSliderInput(session, "my_slider_one", value = sample(1:10,1))
  })
}
  
shinyApp(ui, server)