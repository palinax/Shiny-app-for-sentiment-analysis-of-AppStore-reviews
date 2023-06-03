#' Getting topics from a list of reviews
#'
#' @param reviews list of reviews
#' @param no_topics number of topics (integer)
#' @param method method ('Gibbs' or 'VEM')
#'
#' @return LDA_\code{method} topic model
#' @export
#'
#' @examples
#' get_topic_reviews(review_set_example()@reviews)
get_topic_reviews <- function(reviews, no_topics = 2, method = "Gibbs") {
    checkmate::assert_list(reviews)
    checkmate::assert_number(no_topics, lower = 1)
    checkmate::assert_string(method)
    checkmate::assert_subset(method, c("Gibbs", "VEM"))

    tokenized_text <- lapply(X = reviews,
                             FUN = function(i) {
                                 res <- i@processed
                                 res <- res[nchar(res) > 2]
                                 res
                             })
    corpus <- Corpus(VectorSource(tokenized_text))
    dtm <- DocumentTermMatrix(corpus,
                              control = list(removePunctuation = TRUE))
    lda_out <- LDA(x = dtm,
                   k = no_topics,
                   method = method,
                   control = list(seed = 1234))
    lda_out
}

#' Getting top topics from LDA
#'
#' @param lda_out object from LDA
#' @param no_top number of top words for topic
#'
#' @return data.table containing top word for each topic
#' @export
#'
#' @examples
#' topiced <- get_topic_reviews(review_set_example()@reviews)
#' get_top_from_lda(topiced)
get_top_from_lda <- function(lda_out, no_top = 2) {
    checkmate::assert_number(no_top, lower = 1)
    checkmate::assert_string(class(lda_out), pattern = "^(LDA).*")

    oo <- data.table::data.table(t(lda_out@beta))
    oo$term <- lda_out@terms
    oo <- data.table::melt(data = oo, id.vars = "term")
    data.table::setorderv(oo, cols = c("variable", "value"), order = c(1, -1))
    oo$i <- 1
    oo[, i := cumsum(i), by = variable]
    oo$beta <- exp(oo$value)
    data.table::setnames(oo, "variable", "topic")
    oo <- oo[i <= no_top]
    subset(oo, select = c("topic", "i", "term", "beta"))[]
}

#' Plot top terms from topics
#'
#' @param ds data.table object, result of \code{get_top_from_lda}
#'
#' @return ggplot object
#' @export
#'
#' @examples
#' topiced <- get_topic_reviews(review_set_example()@reviews)
#' top <- get_top_from_lda(topiced)
#' plot_top_from_lda(top)
plot_top_from_lda <- function(ds) {
    ggplot() +
        geom_col(data = ds, mapping = aes(x = i, y = beta, color = topic), fill = "white") +
        geom_text(data = ds, mapping = aes(x = i, y = 5e-2 * max(ds$beta), label = term), hjust = 0) +
        scale_x_reverse() +
        coord_flip() +
        facet_wrap(~topic) +
        theme_minimal() +
        theme(legend.position = "none", panel.grid.minor = element_blank())
}
