library(shiny)
library(DT)
library(revapp)

ui <- fluidPage(
  sidebarLayout(
    sidebarPanel = sidebarPanel(width = 3,
                                conditionalPanel(condition="input.tab==1",
                                                 h2("To begin"),
                                                 selectInput(inputId = "app_name", label = "Select an app", choices = sample_apps),
                                                 dateRangeInput(inputId = "date_range", label = "Reviews between",
                                                                start = "2023-01-01", min = "2023-01-01", end = Sys.Date(), max = Sys.Date())
                                ),
                                conditionalPanel(condition="input.tab==2",
                                                 h2("inputs for word plots")
                                )
    ),
    mainPanel = mainPanel(tabsetPanel(id = "tab",
                                      tabPanel(title = "Summary", value = 1,
                                               textOutput(outputId = "no_reviews"),
                                               plotOutput(outputId = "circ"),
                                               DT::dataTableOutput(outputId = "tab_w", width = )
                                      ),
                                      tabPanel(title = "Word plots", value = 2,
                                               p("what to put in here?")
                                      )
    )
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
  output$tab_w <- DT::renderDataTable(expr = filtered_reviews())
}

shinyApp(ui, server)
