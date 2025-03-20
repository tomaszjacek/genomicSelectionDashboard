source("app/logic/tools.R", local = TRUE)


# cassandraColumnUI = R6Class(
#   "cassandraColumnUI",
#   public = list(
#     cassandraColumnUI_UI= function (prefixe){
#       ns<-NS(prefixe)
#       tagList(
#         uiOutput(ns("cassandraColumnUI_UI"))
#       )
#     }
#   )
# )

cassandraColumn <- R6Class(
  "cassandraColumn",
  public = list(
    id = NULL,
    ns =NULL,
    parameterValues = NULL,
    uiReloadTrigger = NULL,
    
    initialize = function(input,output, session,id, t){
      self$parameterValues=list()
      self$id = id
      self$ns = NS(session$ns(id))
      self$parameterValues[["cassandraTableColumnType"]]<-NULL
      self$parameterValues[["cassandraTableColumnName"]]<-NULL
      self$uiReloadTrigger <- t
      callModule(self$cassandraColumnSERVER, self$id)
      callModule(self$server, self$id)
    },
    ui = function (){
      tagList(
        uiOutput(self$ns("cassandraColumnUI_UI"))
      )
    },
    getParametersValues = function(){
      returnList<-self$parameterValues
    },
#    bind = function(){
#      callModule(private$module_server, private$id)
#    },

    cassandraColumn_renderUI= function(){
      fluidPage(
        textInput(self$ns("cassandraTableColumnName"), "Column Name",value = ""),
        selectInput(
          self$ns("cassandraTableColumnType"),
          label="Column Type",
          choices=cassandraColumnTypes
        ),
        textOutput(self$ns("outname"), inline =TRUE),
        textOutput(self$ns("outtype"), inline =TRUE),
        renderText(paste0("prefixtest1 ",self$ns("test")," | ",self$ns(self$id)))
      )
    },
  #),
  #private = list(
    
    #id = NULL,
    

    
    cassandraColumnSERVER = function(input, output, session) {
      output$cassandraColumnUI_UI<- renderUI(self$cassandraColumn_renderUI(  ))
    },

    server = function(input, output, session){
      #ns<-session$ns
      #nss<-session$ns
      print("cassandra column server start")
      print(paste0("prefixtest2 self$ns(test) ",self$ns("test")))
      print(paste0("prefixtest2 self$id ",self$id))
            
      output$outname <- renderText({
        input$cassandraTableColumnName
      })  
      
      output$outtype <- renderText({
        input$cassandraTableColumnType
      })  
      output$nsid <- renderText({
        renderText(paste0("prefixtest2 ",self$ns("test")))
      })  
      
      observeEvent(input[["cassandraTableColumnType"]],{
        print(paste0("column type ",input[["cassandraTableColumnType"]]))
        self$parameterValues[["cassandraTableColumnType"]]<-input[["cassandraTableColumnType"]]
      })


      observeEvent(input[["cassandraTableColumnName"]],{
        print(paste0("column type ",input[["cassandraTableColumnName"]]))
        self$parameterValues[["cassandraTableColumnName"]]<-input[["cassandraTableColumnName"]]
      })
      
      # observeEvent(self$uiReloadTrigger,{
      #   output$outname <- renderText({
      #     self$parameterValues[["cassandraTableColumnName"]]
      #   })  
      #   
      #   output$outtype <- renderText({
      #     self$parameterValues[["cassandraTableColumnType"]]
      #   })  
      # })
      
    }




    
  )
)