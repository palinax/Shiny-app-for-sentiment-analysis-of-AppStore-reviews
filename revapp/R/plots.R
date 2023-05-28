#' Title
#'
#' @param dt data.table
#'
#' @return \code{ggplot2} object
#' @export
#'
#' @examples
#' plot_rating_hour(sample_apps_reviews[[1]])
plot_rating_hour <- function(dt) {
    checkmate::assert_data_table(dt)
    oo <- dt[, list(rating = mean(rating), .N),
             by = .(review_time = hour(review_time))]

    ggplot(data = oo, aes(x = review_time, y = rating)) +
        geom_col(aes(fill = rating), color = "grey70") +
        geom_point(aes(size = N)) +
        coord_polar(theta = "x") +
        scale_y_continuous(expand = c(0, 0), limits = c(-2, 5)) +
        scale_x_continuous(breaks = c(0:23),
                           labels = function(x) sprintf("%02d:00", x)) +
        scale_fill_gradient2(midpoint = mean(dt$rating)) +
        theme(panel.grid.minor = element_blank())
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
