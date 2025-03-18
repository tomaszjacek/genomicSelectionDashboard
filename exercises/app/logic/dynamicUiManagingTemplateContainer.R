source("app/view/cassandra/cassandra_column_R6.R", local = TRUE)
source("app/logic/tools.R", local = TRUE)


dynamicUiManagerTemplateUI = R6Class(
  "dynamicUiManagerTemplateUI",
  public = list(
    dynamicUiManagerTemplateUI_UI= function (prefixe){
      ns<-NS(prefixe)
      tagList(
        renderText("dynamicUiManagerTemplateUI$dynamicUiManagerTemplateUI_UI"),
        uiOutput(ns("dynamicUiManagerTemplateUI_UI"))
      )
    }
  )
)

dynamicUiManagerTemplate <- R6Class(
  "dynamicUiManagerTemplate",
  public = list(
      id = NULL,
      ns =NULL,
      initialize = function(input,output, session,id){
        self$id = id
        self$ns = NS(session$ns(id))
        callModule(private$dynamicUiManagerTemplateSERVER, self$id)
        private$server(input, output, session)
    },

    dynamicUiManagerTemplate_renderUI= function(){
      fluidPage(
        uiOutput(self$ns("dynamic_ui")),
        actionButton(self$ns("new"), NULL, icon=icon("plus"), width="100%"),
        textOutput(self$ns("text_out")),
        renderText("aloha")
      )
    }
  ),
  private = list(
    #id = NULL,
    dynamicUiManagerTemplateSERVER = function(input, output, session) {
      output$dynamicUiManagerTemplateUI_UI<- renderUI(self$dynamicUiManagerTemplate_renderUI( ))
    },
    uiElementsList = list(),
    
 #   scatter_ui_objects <- function(){
 #     for (n in 1:length(self$uiElementsList))
  #  },
    
    server = function(input, output, session){
      print("dynamicUiManagerTemplateContainerServer Start")
      #ns <- session$ns
      #output$text_out <- renderText({
      #  input$text_in
      #})
      
    }
    
    
  )
)