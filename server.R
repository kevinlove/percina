library(shiny)
library(ggplot2)
library(dplyr)
library(magrittr)
library(tidyr)
library(ridigbio)
library(jsonlite)

shinyServer(function(input, output,session) {


 datasetInput <- reactive({
  qry <- parseQueryString(session$clientData$url_search)
  qry <- jsonlite::fromJSON(qry$rq)
  idig_data <- idig_search_records(rq=qry,fields="all")
  })
 datasetInputTrim <- reactive({
  qry <- parseQueryString(session$clientData$url_search)
  qry <- jsonlite::fromJSON(qry$rq)
  idig_data <- idig_search_records(rq=qry)
  })
  
  output$table <- renderTable({
    datasetInputTrim()
  })

        output$queryText <- renderText({
            qry <- parseQueryString(session$clientData$url_search)
            if (length(qry)) {
                qry <- jsonlite::fromJSON(qry$rq)
                idig_time <- system.time(hol <<- idig_search_records(rq = qry, fields = "all"))
                if (nrow(hol) > 1) paste("Time taken:", idig_time[1], "\nNumber of records:", nrow(hol),"\nSome data columns have been ommited for easy viewing","\nUse the download button to view all of the data") else "problem"
            } else {
                "You need to specify a query"
            }
        })
  
  output$downloadData <- downloadHandler(
    filename = function() { paste('data', '.csv', sep='') },
    content = function(file) {
      write.csv(datasetInput(),row.names=FALSE, file)
    }
  )
})
