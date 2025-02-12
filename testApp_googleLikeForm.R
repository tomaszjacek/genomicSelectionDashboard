library('shiny')
library('shinyjs')

fieldsMandatory <- c("name", "favourite_pkg")

labelMandatory <- function(label) {
  tagList(
    label,
    span("*", class = "mandatory_star")
  )
}

adminUsers <- c("john", "sally")

appCSS <-
  ".mandatory_star { color: red; }
    #error { color: red; }"

fieldsAll <- c("name", "favourite_pkg", "used_shiny", "r_num_years", "os_type")

responsesDir <- file.path("responses")

epochTime <- function() {
  as.integer(Sys.time())
}

shinyApp(
  ui = fluidPage(
    shinyjs::useShinyjs(),
    shinyjs::inlineCSS(appCSS),
    titlePAnel = ("mimicking google like forms"),
    div(id = "form",
      textInput("name",labelMandatory("Name"),""),
      textInput("favourite_pkg",labelMandatory("favorote pkg")),
      checkboxInput("used_shiny", "idid used shiny before",FALSE),
      sliderInput("r_num_years","i did used R for many years",0,25,2,ticks=FALSE),
      selectInput("os_type","operatin system in use",c("win","linux","mac")),
      actionButton("submit", "Submit",class="btn-primary"),
      wellPanel(
        h2("previous records - adminaccess only"),
        actionButton("downloadBtn", "downloadResponses",class="btn-primary"),br(),br(),
        DT::dataTableOutput("responseTable")
      )
      #downloadButton("downloadBtn", "Download responses"),
      #uiOutput("adminPanelContainer")
    ),
    shinyjs::hidden(
      div(
        id = "thankyou_msg",
        h3("Thanks, your response was submitted successfully!"),
        actionLink("submit_another", "Submit another response")
      )
    )  
  ),
  
  server  = function(input,output,session){
    print("SESSIONUSER")
    print(session$user)
    
    isAdmin<-TRUE
    # isAdmin <- reactive({
    #   !is.null(session$user) && session$user %in% adminUsers
    # })  
    

    
    observe({
      mandatoryFilled <-
        vapply(fieldsMandatory,
               function(x) {
                 !is.null(input[[x]]) && input[[x]] != ""
               },
               logical(1))
      mandatoryFilled <- all(mandatoryFilled)
      
      shinyjs::toggleState(id = "submit", condition = mandatoryFilled)
    })
    
    formData <- reactive({
      data <- sapply(fieldsAll, function(x) input[[x]])
      data <- c(data, timestamp = epochTime())
      data <- t(data)
      data
    })
    
    saveData <- function(data) {
      fileName <- sprintf("%s_%s.csv",
                          humanTime(),
                          digest::digest(data))
      
      write.csv(x = data, file = file.path(responsesDir, fileName),
                row.names = FALSE, quote = TRUE)
    }
    
    # action to take when submit button is pressed

      observeEvent(input$submit, {
        shinyjs::disable("submit")
        shinyjs::show("submit_msg")
        shinyjs::hide("error")
        
        tryCatch({
          saveData(formData())
          shinyjs::reset("form")
          shinyjs::hide("form")
          shinyjs::show("thankyou_msg")
        },
        error = function(err) {
          shinyjs::html("error_msg", err$message)
          shinyjs::show(id = "error", anim = TRUE, animType = "fade")
        },
        finally = {
          shinyjs::enable("submit")
          shinyjs::hide("submit_msg")
        })
      })
  
    
    humanTime <- function() format(Sys.time(), "%Y%m%d-%H%M%OS")
    loadData <- function() {
      files <- list.files(file.path(responsesDir), full.names = TRUE)
      data <- lapply(files, read.csv, stringsAsFactors = FALSE)
      data <- do.call(rbind, data)
      print(data)
      data
    }

    daneZplikow <-eventReactive(eventExpr = input$downloadBtn , 
                                valueExpr = {
                                  loadData()
                                }

    )
    
    output$responseTable <- DT::renderDataTable(
      daneZplikow(),
      rownames = FALSE,
      options = list(searching = FALSE, lengthChange = FALSE)
    ) 
    
    observeEvent(input$submit_another,{
      shinyjs::show("form")
      shinyjs::hide("thankyou_msg")
    })



  }
)