shinyUI(
        navbarPage("iDigBio Download Example",
                   
                   ## Download Tab
                   tabPanel("Download Data",
                            sidebarPanel(
                                    selectInput("dataset", "Choose a dataset version:", 
                                                choices = c("Full Data", "Trimmed Data", "ID's")),
                                    downloadButton('downloadData','Download')                 
                            ),
                            mainPanel(
                                    h3("Download"),
                                    verbatimTextOutput("queryText"),
                                    tableOutput('table')
                            ))
        ))