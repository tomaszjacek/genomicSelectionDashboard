box::use(
  shinydashboard[dashboardHeader,dashboardSidebar,dashboardBody,dashboardPage,sidebarMenuOutput,tabItems,tabItem, renderMenu, menuItem,sidebarMenu],
  shiny[bootstrapPage,reactiveVal, observeEvent,div, moduleServer, NS, renderUI, tags, insertUI,wellPanel,selectInput,renderText,validate,need,fluidPage,removeUI,
        uiOutput,sidebarLayout,sidebarPanel,h3,numericInput,textOutput,textInput,conditionalPanel,actionButton,icon,mainPanel,callModule,
        verbatimTextOutput],
  shinyGizmo[modalDialogUI],
  glue[...],
  R6[R6Class]
)
box::use(
  app/view/cassandra/cassandra_column_R6,
  app/logic/tools
)

dynamicUiManagerTemplateUI = R6Class(
  "dynamicUiManagerTemplateUI",
  public = list(
    dynamicUiManagerTemplateUI_UI= function (prefixe){
      ns<-NS(prefixe)
      tagList(
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
    bind = function(){
      callModule(private$module_server, private$id)
    },
    
    dynamicUiManagerTemplate_renderUI= function(){
      fluidPage(
        uiOutput(self$ns("dynamic_ui")),
        actionButton(ns("new"), NULL, icon=icon("plus"), width="100%"),
        textOutput(self$ns("text_out")),
        renderText("aloha")
      )
    }
  ),
  private = list(
    #id = NULL,
    dynamicUiManagerTemplateSERVER = function(input, output, session) {
      output$dynamicUiManagerTemplateUI_UI<- renderUI(self$dynamicUiManagerTemplate_renderUI)
    },
    uiElementsList = list(),
    
 #   scatter_ui_objects <- function(){
 #     for (n in 1:length(self$uiElementsList))
  #  },
    
    server = function(input, output, session){
      print("dynamicUiManagerTemplateContainerServer Start")
      ns <- session$ns
      output$text_out <- renderText({
        input$text_in
      })
      
    }
    
    
  )
)