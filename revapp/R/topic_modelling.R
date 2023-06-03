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
                                 res <- res[nchar(res) > 0]
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
    i <- NULL
    oo$i <- 1
    oo[, i := cumsum(i), by = "variable"]
    oo$beta <- exp(oo$value)
    data.table::setnames(oo, "variable", "topic")
    oo <- oo[i < no_top]
    subset(oo, select = c("topic", "beta"))[]
}
