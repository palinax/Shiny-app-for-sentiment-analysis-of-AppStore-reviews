#' Represetnation of the summary
#'
#' @return \code{tabPanel} with ui for Summary tab
#' @export
#'
#' @examples
#' summary_ui()
summary_ui <- function() {
    tabPanel(title = "Summary",
             value = 1,
             p("The goal of this tab is to pick an app of interest and take a quick look at the reviews."),
             p("One could look around and see how many reviews there are, how the rating depends on an hour of a review and what there actually is in each of the selected reviews."),
             fluidRow(column(width = 2, textOutput(outputId = "no_reviews")),
                      column(width = 10, plotOutput(outputId = "circ"))),
             DT::dataTableOutput(outputId = "tab_w")
    )
}
