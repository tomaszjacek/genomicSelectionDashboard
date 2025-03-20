library(purrr)
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
      nestedUiTrigger = NULL,
      uiElementsList = NULL,
      initialize = function(input,output, session,id){
        self$uiElementsList = list()
        self$nestedUiTrigger = counter$new(reactive = TRUE)
        self$id = id
        #self$ns = NS(session$ns(id))
        self$ns = NS(session$ns(id))
        callModule(self$dynamicUiManagerTemplateSERVER, self$id)
        self$server(input, output, session)
    },

    dynamicUiManagerTemplate_renderUI= function(){
      fluidPage(
        uiOutput("dynamic_ui"),
        actionButton("new", NULL, icon=icon("plus"), width="100%"),
        #renderText("dynamicUiManagerTemplateUI$dynamicUiManagerTemplateUI_UI"),
        textOutput("gen_by"),
        #renderText("aloha")
      )
    },
  #),
  #self = list(
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
      #print(paste0("names in uiElementsList", objNames))
      content <- vector()
      for (n in 1:length(objNames)){
        name <- objNames[n]
        #print(paste0("scatter_ui_object",name))
        content <- append(content,self$uiElementsList[[name]][["ui"]]( ))
        #self$uiElementsList[[name]][["ui"]]
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
      
      observeEvent(input$new,{
        print("button new pressed")
        print(paste0("prefixtest0 ",self$ns("test")))
        uid <- genid()
        print(paste0("typeof ",typeof(uid)))
        newUiElementObject <- cassandraColumn$new(input, output, session, uid, self$nestedUiTrigger)
        self$uiElementsList[[uid]] <- newUiElementObject

        output$dynamic_ui <- renderUI({
          #newUiElementObject$ui()
          self$scatter_ui_objects( )
        })
        
        self$nestedUiTrigger$setIncrement( )
      })
      
      
    }
    
    
  )
)