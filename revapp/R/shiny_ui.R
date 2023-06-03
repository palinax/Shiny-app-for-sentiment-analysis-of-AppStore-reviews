#' UI of the app
#'
#' @return \code{tabPanel} or sidePanels with UI for specific sections
#' @export
#'
#' @name shiny_ui
#' @examples
#' summary_ui_main()
summary_ui_main <- function() {
    tabPanel(title = "Summary",
             value = 1,
             p("The goal of this tab is to pick an app of interest and take a quick look at the reviews."),
             p("One could look around and see how many reviews there are, how the rating depends on an hour of a review and what there actually is in each of the selected reviews."),
             fluidRow(column(width = 2, textOutput(outputId = "no_reviews")),
                      column(width = 10, plotOutput(outputId = "circ"))),
             DT::dataTableOutput(outputId = "tab_w")
    )
}

#' @export
#' @rdname shiny_ui
summary_ui_side <- function() {
    list(h2("First, select the app of interest"),
         p("You can select from a data that comes with a package ..."),
         selectInput(inputId = "app_name",
                     label = "Select an app from package data",
                     choices = names(sample_apps_reviews)),
         fluidRow(column(width = 10, p("... or you can prepare file yourself")),
                  column(width = 2, action_btn_mdl("show_how", "", icon = icon("question")))),
         fileInput(inputId = "data_outside",
                   label = "Own data (to be developed)",
                   multiple = F,
                   accept = ".Rds"),
         p("Next, filter out some reviews based on date"),
         dateRangeInput(inputId = "date_range",
                        label = "Reviews between",
                        start = "2023-01-01",
                        min = "2023-01-01",
                        end = Sys.Date(),
                        max = Sys.Date()),
         p("You can chose coloring based on rating"),
         fluidRow(column(width = 6,
                         selectInput(inputId = "rat_low_color",
                                     label = "High rating:",
                                     choices = grDevices::hcl.colors(10)[1:5],
                                     multiple = F)),
                  column(width = 6,
                         selectInput(inputId = "rat_hgh_color",
                                     label = "Low rating:",
                                     choices = grDevices::hcl.colors(10)[6:10],
                                     multiple = F))),
         p("Once you are ok with the choice, press the button below. It will create the data needed for further analysis"),
         actionButton(inputId = "btn_proceed",
                      label = "Proceed!",
                      icon = icon("cog")))
}

#' @export
#' @rdname shiny_ui
wordcloud_ui_main <- function() {
    tabPanel(title = "Wordcloud",
             value = 2,
             fluidRow(column(width = 4,
                             plotOutput(outputId = "wordcloud")),
                      column(width = 8,
                             wordcloud2Output(outputId = "wordcloud_prime"))))
}

#' @export
#' @rdname shiny_ui
wordcloud_ui_side <- function() {
    list(h2("Next, look at the words"),
         p("You can modify several things:"),
         sliderInput(inputId = "word_cloud_max_words",
                     label = "Maximum number of words",
                     min = 1,
                     value = 10,
                     max = 20))
}

#' @export
#' @rdname shiny_ui
sentiment_ui_main <- function() {
    tabPanel(title = "Sentiment Analysis",
             value = 3,
             fluidRow(column(width = 6, plotOutput("sentpie")),
                      column(width = 6, plotOutput("senthist"))),
             fluidRow(column(width = 6, textOutput("sentRatio")),
                      column(width = 6, uiOutput("sentVals"))),
             DT::dataTableOutput(outputId = "sent_table"))
}

#' @export
#' @rdname shiny_ui
sentiment_ui_side <- function() {
    list(h2("Furthermore: sentiment analysis"),
         p("Decide which values represent which class:"),
         sliderInput(inputId = "sent_breaks",
                     label = "Breaks for categories",
                     min = -5,
                     step = .1,
                     value = c(-.1, .1),
                     max = 5),
         selectInput(inputId = "sent_colors",
                     label = "Colors for categories",
                     choices = rownames(RColorBrewer::brewer.pal.info)))
}

#' @export
#' @rdname shiny_ui
topics_ui_main <- function() {
    tabPanel(title = "Trending Topics",
             value = 4,
             plotOutput("topics"))
}

#' @export
#' @rdname shiny_ui
topics_ui_side <- function() {
    list(h2("Last but not least - topic modelling"),
         sliderInput(inputId = "topic_no_topics",
                     label = "Number of topic",
                     min = 2,
                     max = 10,
                     step = 1,
                     value = 2),
         selectInput(inputId = "topic_method",
                     label = "Method",
                     choices = c("Gibbs", "VEM"),
                     multiple = FALSE),
         actionButton(inputId = "topic_go",
                      label = "Go!",
                      icon = icon("pen")))
}
