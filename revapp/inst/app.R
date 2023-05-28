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
                                                 p("You can modify several things:"),
                                                 sliderInput(inputId = "word_cloud_max_words",
                                                             label = "Maximum number of words",
                                                             min = 1,
                                                             value = 10,
                                                             max = 20)),
                                conditionalPanel(condition = "input.tab==3",
                                                 p("In sentiment analysi once you have to decide which values represent which class:"),
                                                 sliderInput(inputId = "sent_breaks",
                                                             label = "Breaks for categories",
                                                             min = -5, step = .1,
                                                             value = c(-.1, .1),
                                                             max = 5))
    ),
    mainPanel = mainPanel(tabsetPanel(id = "tab",
                                      summary_ui(),
                                      tabPanel(title = "Wordcloud", value = 2,
                                               plotOutput(outputId = "wordcloud")
                                      ),
                                      tabPanel(title = "Sentiment Analysis", value = 3,
                                               fluidRow(column(width = 6, plotOutput("sentpie")),
                                                        column(width = 6, plotOutput("senthist"))),
                                               fluidRow(column(width = 6, textOutput("sentRatio")),
                                                        column(width = 6, uiOutput("sentVals"))),
                                               DT::dataTableOutput(outputId = "sent_table")
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
  # displaying modal about how to prepare own data
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
                     l = lapply(X = filtered_reviews()$review, FUN = function(i) review(i))
                     reviewsProcessed(review_set(l))
                   }, message = "Processing reviews")
                 })
                 showModal(ui = modalDialog(title = "Done!", "Now you can go to other tabs and explore it further!", div(print(reviewsProcessed))))
               })
  # 'Wordcloud' tab ----
  output$wordcloud <- renderPlot({
    req(reviewsProcessed())
    plot_word_count(reviewsProcessed()@words, input$word_cloud_max_words)
  })
  # 'Sentiment' tab ----
  br_p_n <- reactiveVal({c(-Inf, -.1, .1, Inf)})

  observeEvent(eventExpr = input$sent_breaks,
               handlerExpr = {
                 br_p_n(c(-Inf, input$sent_breaks, Inf))
               })

  output$sentpie <- renderPlot({
    req(reviewsProcessed())
    validate(
      need(min(input$sent_breaks) != max(input$sent_breaks), "Please select a unique breaks")
    )
    sentimentDistributionPie(reviewsProcessed(), br = br_p_n())
  })

  output$senthist <- renderPlot({
    req(reviewsProcessed())
    sentimentDistributionHist(reviewsProcessed())})

  output$sentRatio <- renderText({
    req(reviewsProcessed())
    validate(
      need(min(input$sent_breaks) != max(input$sent_breaks), "Please select a unique breaks")
    )
    paste0("Sentiment ratio is: ", sentimentRatio(reviewsProcessed(), br = br_p_n()))
  })

  output$sentVals <- renderUI({
    req(reviewsProcessed())
    res <- sentimentSummary(reviewsProcessed())
    div(
      p(paste0("Mean:", res$mean)),
      p(paste0("SD:", res$sd)),
      p(paste0("Min/max:", res$min, "/", res$max)),
      p(paste0("Deciles:", paste0(res$dec, collapse = ", ")))
    )
  })

  output$sent_table <- DT::renderDataTable(expr = {
    rbindlist(l = lapply(reviewsProcessed()@reviews,
                         FUN = function(i) data.table(review = i@original, score = i@sent_score)))
  })
  # 'Trending topics' tab ----
  output$topics <- renderPlot({plot(1:10, 1:10)})
}

shinyApp(ui, server)
