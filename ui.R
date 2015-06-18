shinyUI(pageWithSidebar(
  headerPanel('CSV Download Example'),
  sidebarPanel(
    downloadButton('downloadData', 'Download')
  ),
  mainPanel(
    h3("Query"),
    verbatimTextOutput("queryText"),
    tableOutput('table')

  )
))
