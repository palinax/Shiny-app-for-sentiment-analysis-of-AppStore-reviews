library(revapp)

ui <- fluidPage(
  tags$head(includeCSS(path = "www/style.css")),
  sidebarLayout(
    sidebarPanel = sidebarPanel(width = 3,
                                conditionalPanel(condition = "input.tab==1",
                                                 h2("First, select the app of interest"),
                                                 p("You can select from a data that comes with a package: "),
                                                 selectInput(inputId = "app_name",
                                                             label = "Select an app from package data",
                                                             choices = names(sample_apps_reviews)),
                                                 fluidRow(column(width = 10, p("Or you can prepare file yourself")),
                                                          column(width = 2, actionButton("show_how", "", icon = icon("question")))),
                                                 fileInput(inputId = "data_outside", label = "Own data (to be developed)", multiple = F, accept = ".Rds"),
                                                 dateRangeInput(inputId = "date_range",
                                                                label = "Reviews between",
                                                                start = "2023-01-01",
                                                                min = "2023-01-01",
                                                                end = Sys.Date(),
                                                                max = Sys.Date()),
                                                 p("Once you are ok with the choice, press the button below. It will create the data needed for further analysis"),
                                                 actionButton(inputId = "btn_proceed",
                                                              label = "Proceed!", icon = icon("cog"))),
                                conditionalPanel(condition = "input.tab==2",
                                                 h2("inputs for word plots, for example minimum word freq, color pallette"))
    ),
    mainPanel = mainPanel(tabsetPanel(id = "tab",
                                      summary_ui(),
                                      tabPanel(title = "Wordcloud", value = 2,
                                               plotOutput(outputId = "wordcloud")
                                      ),
                                      tabPanel(title = "Sentiment Analysis", value = 3,
                                               plotOutput("sentpie"),
                                               p("Average sentiment for the app, sentiments destribution (pie), sentimanetdistribution(histogram),sentiment ratio, sentiments stats, table with reviews and sentiments and score assigned to each")
                                      ),
                                      tabPanel(title = "Trending Topics", value = 4,
                                               plotOutput("topics"))
    )
    )
  )
)

server <- function(input, output, session) {
  reviewsProcessed <- reactiveVal({NULL})
  # 'Summary' tab ----
  # displaying modal aobut how to prepare own data
  observeEvent(eventExpr = input$show_how,
               handlerExpr = {
                 tt <- readLines(con = "www/modal_how_to_prep.html")
                 showModal(ui = modalDialog(title = "How to prepare own dataset?", HTML(paste0(tt, collapse = "\n"))))
               })
  # data with reviews filtered by app name and dates
  filtered_reviews <- reactive({
    sample_apps_reviews[[input$app_name]][between(as.Date(review_time), input$date_range[1], input$date_range[2])]
  })
  output$no_reviews <- renderText(expr = {
    paste0("There is ", nrow(filtered_reviews()), " reviews")
  })
  output$circ <- renderPlot(expr = {
    plot_rating_hour(filtered_reviews())
  })
  output$tab_w <- DT::renderDataTable(expr = filtered_reviews())
  observeEvent(eventExpr = input$btn_proceed,
               handlerExpr = {
                 isolate(expr = {
                   withProgress(expr = {
                     reviewsProcessed(review(filtered_reviews()$review[1]))
                   }, message = "Processing reviews")
                 })
                 showModal(ui = modalDialog(title = "Done!", "Now you can go to other tabs and explore it further!"))
               })
  # 'Wordcloud' tab ----
  output$wordcloud <- renderPlot({plot(1:10, 1:10)})
  # 'Sentiment' tab ----
  output$sentpie <- renderPlot({plot(1:10, 1:10)})
  # 'Trending topics' tab ----
  output$topics <- renderPlot({plot(1:10, 1:10)})
}

shinyApp(ui, server)
