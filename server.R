library(shiny)
library(ridigbio)
library(jsonlite)

shinyServer(function(input, output,session) {
        
        
        datasetInput <- reactive({
                qry <- parseQueryString(session$clientData$url_search)
                qry <- jsonlite::fromJSON(qry$rq)
                idig_data <- idig_search_records(rq=qry,fields="all")
                idig_data_trim <- idig_search_records(rq=qry)
                idig_data_id <- idig_search_records(rq=qry,fields=c("catalognumber","collectioncode","institutioncode"))
                switch(input$dataset,
                       "Full Data" = idig_data,
                       "Trimmed Data" = idig_data_trim,
                       "ID's" = idig_data_id)
        })
        
        output$table <- renderTable({
                datasetInput()
        })
        
        output$queryText <- renderText({
                input$dataset
                qry <- parseQueryString(session$clientData$url_search)
                if (length(qry)) {
                        qry <- jsonlite::fromJSON(qry$rq)
                        idig_time <- system.time(input$dataset)
                        if (nrow(hol) > 1) paste(input$dataset, "\nTime taken:", idig_time[1], "\nNumber of records:", nrow(datasetInput())) else "problem"
                } else {
                        "You need to specify a query"
                }
        })
        
        output$downloadData <- downloadHandler(
                filename = function() { paste(input$dataset, '.csv', sep='') },
                content = function(file) {
                        write.csv(datasetInput(),row.names=FALSE, file)
                }
        )
})
