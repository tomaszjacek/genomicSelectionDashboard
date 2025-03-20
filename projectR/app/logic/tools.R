library(shiny)
library(R6)

genid <- function() {
  paste(sample(letters, 5), collapse = "")
}


cassandraColumnTypes <- c('ascii','bigint','blob','boolean','counter','date','decimal','double','duration','float','inet','int','smallint','text','time','timestamp','timeuuid','tinyint','uuid','varchar','varint')




reactiveTrigger <- function() {
  counter <- reactiveVal( 0)
  list(
    depend = function() {
      counter()
      invisible()
    },
    trigger = function() {
      counter( isolate(counter()) + 1 )
    }
  )
}

counter <- R6::R6Class(
  public = list(
    initialize = function(reactive = FALSE) {
      private$reactive = reactive
      private$value = 0
      private$rxTrigger = reactiveTrigger()
    },
    setIncrement = function() {
      if (private$reactive) private$rxTrigger$trigger()
      private$value = private$value + 1
    },
    setDecrement = function() {
      if (private$reactive) private$rxTrigger$trigger()
      private$value = private$value -1
    },
    getValue = function() {
      if (private$reactive) private$rxTrigger$depend()
      return(private$value)
    }
  ),
  private = list(
    reactive = NULL,
    value = NULL,
    rxTrigger = NULL
  )
)
