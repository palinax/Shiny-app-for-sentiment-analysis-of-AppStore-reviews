library(revapp)

ui <- fluidPage(
  theme = shinythemes::shinytheme("sandstone"),
  shiny::tags$head(htmltools::includeCSS(path = "www/style.css")),
  sidebarLayout(
    sidebarPanel = sidebarPanel(width = 3,
                                conditionalPanel(condition = "input.tab==1",
                                                 summary_ui_side()),
                                conditionalPanel(condition = "input.tab==2",
                                                 wordcloud_ui_side()),
                                conditionalPanel(condition = "input.tab==3",
                                                 sentiment_ui_side()),
                                conditionalPanel(condition = "input.tab==4",
                                                 topics_ui_side())
    ),
    mainPanel = mainPanel(tabsetPanel(id = "tab",
                                      summary_ui_main(),
                                      wordcloud_ui_main(),
                                      sentiment_ui_main(),
                                      topics_ui_main())
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
                 showModal(ui = modalDialog(title = "How to prepare own dataset?", htmltools::HTML(paste0(tt, collapse = "\n"))))
               })
  # data with reviews filtered by app name and dates
  filtered_reviews <- reactive({
    sample_apps_reviews[[input$app_name]][between(as.Date(review_time), input$date_range[1], input$date_range[2])]
  })

  # simple text containing number of reviews
  output$no_reviews <- renderText(expr = {
    paste0("There is ", nrow(filtered_reviews()), " reviews")
  })

  # mean rating by the hour of review
  output$circ <- renderPlot(expr = {
    plot_rating_hour(filtered_reviews(), input$rat_low_color, input$rat_hgh_color)
  })

  # table containing filtered reviews
  output$tab_w <- DT::renderDataTable(expr = {
    dt_f <- filtered_reviews()
    cr_f <- colorRampPalette(colors = c(input$rat_low_color, "white", input$rat_hgh_color))(5)
    res <- datatable(data = dt_f, rownames = F, caption = "All reviews from a given period")
    res <- DT::formatStyle(table = res, columns = "rating", target = "row",
                           backgroundColor = styleInterval(cuts = quantile(dt_f$rating)[-1], values = cr_f))
    res
  })

  # observing pushing a button to process reviews into useful object of specific class
  observeEvent(eventExpr = input$btn_proceed,
               handlerExpr = {
                 isolate(expr = {
                   withProgress(expr = {
                     l = lapply(X = 1:nrow(filtered_reviews()),
                                FUN = function(i) review(filtered_reviews()$review[i], filtered_reviews()$rating[i]))
                     reviewsProcessed(review_set(l))
                   }, message = "Processing reviews")
                 })
                 showModal(ui = modalDialog(title = "Done!",
                                            "Now you can go to other tabs and explore it further!"))
               })

  # 'Wordcloud' tab ----
  # barplot with words
  output$wordcloud <- renderPlot({
    req(reviewsProcessed())
    plot_word_count(reviewsProcessed()@words, input$word_cloud_max_words)
  })

  # actual wordcloud
  output$wordcloud_prime <- renderWordcloud2({
    req(reviewsProcessed())
    tt <- reviewsProcessed()@words[order(-how_many)]
    wordcloud2(data = tt[1:input$word_cloud_max_words])
  })

  # 'Sentiment' tab ----
  # reactive value for breaks
  br_p_n <- reactiveVal({c(-Inf, -.1, .1, Inf)})

  observeEvent(eventExpr = input$sent_breaks,
               handlerExpr = {
                 br_p_n(c(-Inf, input$sent_breaks, Inf))
               })

  # piechart with distribution
  output$sentpie <- renderPlot({
    req(reviewsProcessed())
    validate(
      need(min(input$sent_breaks) != max(input$sent_breaks), "Please select a unique breaks")
    )
    sentimentDistributionPie(reviewsProcessed(), br = br_p_n(), color = RColorBrewer::brewer.pal(4, input$sent_colors))
  })

  # histogram with distribution
  output$senthist <- renderPlot({
    req(reviewsProcessed())
    sentimentDistributionHist(reviewsProcessed())})

  # text about sentiment ratio
  output$sentRatio <- renderText({
    req(reviewsProcessed())
    validate(
      need(min(input$sent_breaks) != max(input$sent_breaks), "Please select a unique breaks")
    )
    paste0("Sentiment ratio is: ", sentimentRatio(reviewsProcessed(), br = br_p_n()))
  })

  # Summary statistics
  output$sentVals <- renderUI({
    req(reviewsProcessed())
    res <- sentimentSummary(reviewsProcessed())
    div(p(paste0("Mean:", res$mean)),
        p(paste0("SD:", res$sd)),
        p(paste0("Min/max:", res$min, "/", res$max)),
        p(paste0("Deciles:", paste0(res$dec, collapse = ", "))))
  })

  # table with sentiment score for each review
  output$sent_table <- DT::renderDataTable(expr = {
    req(reviewsProcessed())
    res <- rbindlist(l = lapply(reviewsProcessed()@reviews,
                                FUN = function(i) data.table(review = i@original, score = i@sent_score)))
    cols <- RColorBrewer::brewer.pal(4, input$sent_colors)
    resDt <- datatable(data = res, rownames = F, caption = "Review with sentiment score")
    resDt <- DT::formatStyle(table = resDt, columns = "score", target = "row",
                             backgroundColor = styleInterval(cuts = br_p_n()[-1], values = cols))
    resDt
  })

  # 'Trending topics' tab ----
  topicRes <- reactiveVal(NULL)
  observeEvent(eventExpr = input$topic_go,
               handlerExpr = {
                 tryCatch(expr = {
                   lda_out <- get_topic_reviews(reviews = reviewsProcessed()@reviews,
                                                no_topics = isolate(input$topic_no_topics),
                                                method = isolate(input$topic_method))
                   topicRes(lda_out)
                 }, error = function(e) {
                   showModal(modalDialog(title = "Something went wrong", as.character(e)))
                 })
               })

  # words most common for each topic
  output$topics <- renderPlot({
    req(topicRes())
    plot_top_from_lda(get_top_from_lda(topicRes(), isolate(input$topics_no_top_words))) +
      labs(title = paste0(isolate(input$topic_method), " for ", isolate(input$topic_no_topics), " topics"))
  })
  # topic vs rating
  output$topic_vs_rating <- renderPlot({
    req(topicRes())
    dt_res <- data.table(tp = topicmodels::topics(topicRes()),
                         rt = reviewsProcessed()@ratings)
    ggplot(data = dt_res, aes(x = tp, y = rt, group = tp)) +
      geom_boxplot() +
      geom_jitter(height = .2) +
      theme_minimal() +
      scale_x_continuous(labels = function(x) paste0("V", x), breaks = 1:max(dt_res$tp)) +
      labs(title = "Distribution of rating in topics", x = "Topic", y = "Rating") +
      coord_flip()
  })
}

shinyApp(ui, server)
