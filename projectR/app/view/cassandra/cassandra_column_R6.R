source("app/logic/tools.R", local = TRUE)


cassandraColumnUI = R6Class(
  "cassandraColumnUI",
  public = list(
    cassandraColumnUI_UI= function (prefixe){
      ns<-NS(prefixe)
      tagList(
        uiOutput(ns("cassandraColumnUI_UI"))
      )
    }
  )
)

cassandraColumn <- R6Class(
  "cassandraColumn",
  public = list(
    id = NULL,
    ns =NULL,
    parameterValues = NULL,
    
    initialize = function(input,output, session,id){
      self$parameterValues=list()
      self$id = id
      self$ns = NS(session$ns(id))
      private$parameterValues[["cassandraTableColumnType"]]<-NULL
      private$parameterValues[["cassandraTableColumnName"]]<-NULL
      callModule(private$cassandraColumnSERVER, self$id)
      private$server(input, output, session)
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
        textInput(self$ns("cassandraTableColumnName"), "Column Name",value = name),
        selectInput(
          ns("cassandraTableColumnType"),
          label="Column Type",
          choices=tools$cassandraColumnTypes
        ),
        textOutput(self$ns("outname"), inline =TRUE),
        textOutput(self$ns("outtype"), inline =TRUE)
      )
    }
  ),
  private = list(
    
    #id = NULL,
    

    
    cassandraColumnSERVER = function(input, output, session) {
      output$cassandraColumnUI_UI<- renderUI(self$cassandraColumn_renderUI(  ))
    },

    server = function(input, output, session){
      print("cassandra column server start")
      output$outname <- renderText({
        input$cassandraTableColumnName
      })  
      
      output$outtype <- renderText({
        input$cassandraTableColumnName
      })  
    
      observeEvent(input[["cassandraTableColumnType"]],{
        print(paste0("column type ",input[["cassandraTableColumnType"]]))
        private$parameterValues[["cassandraTableColumnType"]]<-input[["cassandraTableColumnType"]]
      })

      observeEvent(input[["cassandraTableColumnName"]],{
        print(paste0("column type ",input[["cassandraTableColumnName"]]))
        private$parameterValues[["cassandraTableColumnName"]]<-input[["cassandraTableColumnName"]]
      })
      
    }




    
  )
)