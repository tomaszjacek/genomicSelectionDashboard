# library(shiny)
# library(shinyGizmo)
# library(glue)
# library(magrittr)
# source("tools.R")

box::use(
  shinydashboard[dashboardHeader,dashboardSidebar,dashboardBody,dashboardPage,sidebarMenuOutput,tabItems,tabItem, renderMenu, menuItem,sidebarMenu],
  shiny[bootstrapPage,reactiveVal, observeEvent,div, moduleServer, NS, renderUI, tags, insertUI,wellPanel,selectInput,renderText,validate,need,fluidPage,removeUI,
        uiOutput,sidebarLayout,sidebarPanel,h3,numericInput,textOutput,textInput,conditionalPanel,actionButton,icon,mainPanel],
  shinyGizmo[modalDialogUI],
  glue[...]
)
box::use(
  app/view/cassandra/cassandra_column_Ui,
  app/view/cassandra/cassandra_column_Server,
  app/logic/tools
)

#' @export
server <- function(id) {
  moduleServer(id, function(input,output,session){
    ns<-session$ns
    print("cassandra_panel_Server start")
    my_table<-reactiveVal(NULL)

    observeEvent(input$new,{

      colid<-tools$genid()
      print(paste0("newpressed ",colid))
      insertUI(
        "#variables",
         where = "beforeEnd",
         cassandra_column_Ui$ui(ns(colid),input$name),
         immediate=TRUE
      )
      cassandra_column_Server$server(id=colid)
    })
  
    observeEvent(input$remove,{
      removeUI(
        selector = glue("#{input$which}"),
      )
    })
  
    observeEvent(input$run, {
      print("run selected")
      if(identical(input$nrow>0,TRUE)){
        print(input)
        #my_table(iris[1:input$nrow,])
      }else{
        #my_table(NULL)
        #n_row(NULL)
      }
    }
    )
    
    output$table <- DT::renderDataTable({
      validate(need(!is.null(my_table()),message = "novaliddata"))
      DT::datatable(
        my_table(),
        options=list(paging=TRUE,pageLength=10,searching=FALSE)
      )
    })
    
    

  
  
}

  )
  }


