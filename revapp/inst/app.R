library(shiny)
library(revapp)

ui <- fluidPage(
  sidebarLayout(
    sidebarPanel = sidebarPanel(
      selectInput(inputId = "app_name", label = "Select an app", choices = sample_apps),
      dateRangeInput(inputId = "date_range", label = "Reviews between",
                     start = "2023-01-01", min = "2023-01-01", end = Sys.Date(), max = Sys.Date())
    ),
    mainPanel = mainPanel(
      textOutput(outputId = "no_reviews"),
      plotOutput(outputId = "circ")
    )
  )
)

server <- function(input, output, session) {
  filtered_reviews <- reactive({
    sample_apps_reviews[app_id == input$app_name][between(as.Date(review_time), input$date_range[1], input$date_range[2])]
  })
  output$no_reviews <- renderText(expr = {nrow(filtered_reviews())})
  output$circ <- renderPlot(expr = {
    plot_rating_hour(filtered_reviews())
  })
}

shinyApp(ui, server)
