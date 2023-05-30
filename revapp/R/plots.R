#' Title
#'
#' @param dt data.table
#' @param lw_col color for low values
#' @param hgh_col color for high values
#'
#' @return \code{ggplot2} object
#' @export
#'
#' @examples
#' plot_rating_hour(sample_apps_reviews[[1]])
plot_rating_hour <- function(dt,
                             lw_col = "blue",
                             hgh_col = "red") {
    checkmate::assert_data_table(dt)
    oo <- dt[, list(rating = mean(rating), .N),
             by = .(review_time = hour(review_time))]

    ggplot(data = oo, aes(x = review_time, y = rating)) +
        geom_col(aes(fill = rating), color = "grey70") +
        geom_point(aes(size = N)) +
        coord_polar(theta = "x") +
        scale_y_continuous(expand = c(0, 0), limits = c(-2, 5)) +
        scale_x_continuous(breaks = c(0:23), limits = c(-0.5, 23.5),
                           labels = function(x) sprintf("%02d:00", x)) +
        scale_fill_gradient2(midpoint = mean(dt$rating), low = lw_col, high = hgh_col) +
        theme_minimal() +
        labs(y = NULL, x = NULL, title = "Mean rating by hour of review", color = "Mean rating", size = "No. reviews") +
        theme(panel.grid.minor = element_blank(), legend.position = "bottom")
}

#' Title
#'
#' @param oo data.table with columns 'proc_word' and 'how_many'
#' @param mn number indicating how many words to plot
#'
#' @return \code{ggplot2} object
#' @export
#'
#' @examples
#' ll <- lapply(X = sample_apps_reviews$Snapchat$review[1:10],
#'              FUN = function(i) review(i))
#' set_review <- review_set(ll)
#' plot_word_count(set_review@words)
plot_word_count <- function(oo, mn = 10) {
    checkmate::assert_data_table(oo)
    checkmate::assert_number(mn, lower = 0)
    rr <- oo[oo$proc_word != ""][order(-how_many)][1:mn]
    ggplot(data = rr) +
        geom_col(aes(x = how_many, y = substr(proc_word, 1, 20)))
}
