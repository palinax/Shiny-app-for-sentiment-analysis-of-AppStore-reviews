library(shiny)
library(revapp)

ui <- fluidPage(
  sidebarLayout(
    sidebarPanel = sidebarPanel(
      selectInput(inputId = "app_name", label = "Select an app", choices = sample_apps)
    ),
    mainPanel = mainPanel(
        plotOutput(outputId = "circ")
    )
  )
)

server <- function(input, output, session) {
    output$circ <- renderPlot(expr = {
        plot_rating_hour(sample_apps_reviews)
    })
}

shinyApp(ui, server)
