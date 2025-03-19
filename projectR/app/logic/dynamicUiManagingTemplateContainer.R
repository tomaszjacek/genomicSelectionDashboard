source("app/view/cassandra/cassandra_column_R6.R", local = TRUE)
source("app/logic/tools.R", local = TRUE)


dynamicUiManagerTemplateUI = R6Class(
  "dynamicUiManagerTemplateUI",
  public = list(
    dynamicUiManagerTemplateUI_UI= function (prefixe){
      ns<-NS(prefixe)
      fluidPage(
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
      uiElementsList = NULL,
      initialize = function(input,output, session,id){
        self$uiElementsList = list()
        self$id = id
        self$ns = NS(session$ns(id))
        callModule(private$dynamicUiManagerTemplateSERVER, self$id)
        private$server(input, output, session)
    },

    dynamicUiManagerTemplate_renderUI= function(){
      fluidPage(
        uiOutput("dynamic_ui"),
        actionButton("new", NULL, icon=icon("plus"), width="100%"),
        #renderText("dynamicUiManagerTemplateUI$dynamicUiManagerTemplateUI_UI"),
        textOutput("gen_by"),
        #renderText("aloha")
      )
    }
  ),
  private = list(
    #id = NULL,
    dynamicUiManagerTemplateSERVER = function(input, output, session) {
      print(paste0("ns in object ",self$ns("a")))
      output$dynamicUiManagerTemplateUI_UI<- renderUI(self$dynamicUiManagerTemplate_renderUI( ))
    },
    
    get_obj_names = function() {
      
      if(!is_empty(names(self$uiElementsList))){
        return(names(self$uiElementsList))
      }else{
        return(NULL)
        
      }
    },    
    scatter_ui_objects = function(){
      objNames <- self$get_obj_names()
      content <-NULL
      for (n in 1:length(objNames)){
        name <- objNames[n]
        content <- content + self$uiElementsList[[name]][["ui"]]()
      }
      return(content)
    },

    
    server = function(input, output, session){
      print("dynamicUiManagerTemplateContainerServer Start")
      #ns <- session$ns
      print(paste0("ns in server ",self$ns("a")))
      #output$text_out <- renderText({
      #  input$text_in
      #})
      output$gen_by <- renderText("hello")
      
      output$dynamic_ui <- renderUI({
        print("button new pressed")
        uid <- shiny:::createUniqueId()
        print(paste0("typeof ",typeof(uid)))
        newUiElementObject <- cassandraColumn$new(input, output, session, uid)
        self$uiElementsList[[uid]] <- newUiElementObject
        self$scatter_ui_objects()
      }) |> bindEvent(input$new)
      
      
    }
    
    
  )
)