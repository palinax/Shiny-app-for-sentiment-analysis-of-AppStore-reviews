#' Title
#'
#' @param sample_apps_reviews data.table
#'
#' @return \code{ggplot2} object
#' @export
#'
#' @examples
#' plot_rating_hour(revapp::sample_apps_reviews)
plot_rating_hour <- function(sample_apps_reviews)
{
    checkmate::assert_data_table(sample_apps_reviews)
    oo <- sample_apps_reviews[,.(rating = mean(rating), N = .N), by = .(review_time = hour(review_time))]

    ggplot(data = oo, aes(x = review_time, y = rating)) +
        geom_col(aes(fill = rating), color = "grey70") +
        geom_point(aes(size = N)) +
        coord_polar(theta = "x") +
        scale_y_continuous(expand = c(0, 0), limits = c(-2, 5)) +
        scale_x_continuous(breaks = c(0:23)) +
        scale_fill_gradient2(midpoint = mean(sample_apps_reviews$rating)) +
        theme(panel.grid.minor = element_blank())
}