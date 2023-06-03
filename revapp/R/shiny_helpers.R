#' Small action button
#'
#' @param ... parameters same as in shiny::actionButton
#'
#' @return shiny.tag object
#' @export
#' @import htmltools
#' @examples
#' action_btn_mdl("show_how", "", icon = icon("question"))
action_btn_mdl <- function(...) {
    res <- shiny::actionButton(...)
    htmltools::tagAppendAttributes(res, class = "btn-modal")
}
