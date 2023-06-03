#' review_set Class
#'
#' A class representing a set of reviews.
#'
#' @name review_set
#' @docType class
#'
#' @slot reviews A list containing individual review objects.
#' @slot words A data.table containing the words in the reviews.
#' @slot sent_scores A numeric vector containing the sentiment scores of the reviews.
#'
#' @examples
#' ll <- lapply(X = sample_apps_reviews$Snapchat$review[1:10],
#'              FUN = function(i) review(x = i))
#' set_review <- review_set(ll)
#' set_review
#' @export
#' @aliases review_set-class
setClass(Class = "review_set",
         slots = list(reviews = "list",
                      words = "data.table",
                      sent_scores = "numeric"))

#' Constructor of 'review_set' class
#'
#' @param x list of reviews
#'
#' @return
#' @export
#'
#' @examples
#' ll <- lapply(X = sample_apps_reviews$Snapchat$review[1:10],
#'              FUN = function(i) review(x = i))
#' review_set(ll)
review_set <- function(x) {
    checkmate::assert_list(x)
    words <- lapply(X = x,
                    FUN = function(i) data.table::data.table(proc_word = i@processed))
    words <- data.table::rbindlist(words)[, list(how_many = .N), by = "proc_word"]
    new(Class = "review_set",
        reviews = x,
        words = words,
        sent_scores = unlist(lapply(X = x, FUN = function(i) i@sent_score)))
}

#' Example of 'review_set' class
#'
#' @return object of class 'review_set'
#' @export
#'
#' @examples
#' review_set_example()
review_set_example <- function() {
    ll <- lapply(X = sample_apps_reviews$Snapchat$review[1:10],
                 FUN = function(i) review(x = i))
    review_set(ll)
}

#' Show method for 'review_set'
#'
#' @param object object of class review
#'
#' @return
#' @export
#'
#' @examples
#' print(review_set_example())
setMethod(f = "show",
          signature = "review_set",
          definition = function(object) {
              message(paste0("Number of reviews: ", length(object@reviews), "\n"))
              message(paste0("Most common words: '",
                             paste0(object@words[order(-how_many)]$proc_word[1:3], collapse = "', '"), "'\n"))
              message(paste0("Mean sentiment score (standard deviation): ",
                             mean(object@sent_scores, na.rm = T), " (",
                             stats::sd(object@sent_scores, na.rm = T), ")\n"))
          })

#' Set of functions for summary of 'review_set' class in terms of sentiment
#'
#' @param x object of class \code{review-set}
#' @param br breaks for establish whether review is negative or positive
#' @param colors colors for categories
#'
#' @return charts, number and texts summarizing sentiment in a given set of
#' reviews
#' @export
#'
#' @rdname review_set-summary
#'
#' @examples
#' sentimentDistributionPie(review_set_example())
#' sentimentDistributionHist(review_set_example())
#' sentimentRatio(review_set_example())
#' sentimentSummary(review_set_example())
sentimentDistributionPie <- function(x,
                                     br = c(-Inf, -0.1, 0.1, Inf),
                                     colors = c("blue", "red", "green", "white")) {
    checkmate::assert_class(x, "review_set")
    checkmate::assert_numeric(br, len = 4)
    checkmate::assert_character(colors, len = 4)

    res <- data.table::data.table(sent_score = x@sent_scores)
    res$lab <- assign_sent_lab(res$sent_score, br)
    res <- res[, list(l = .N), by = "lab"]
    graphics::pie(res$l, labels = res$lab, main = "Sentiment distribution", col = colors)
}

#' @name review_set-summary
#' @export
sentimentDistributionHist <- function(x) {
    ggplot(data = data.table(x = x@sent_scores)) +
        geom_histogram(aes(x = x)) +
        labs(title = "Sentiment distribution") +
        theme_minimal() +
        coord_cartesian(xlim = c(-5.1, 5.1))
}

#' @export
#' @name review_set-summary
sentimentRatio <- function(x,
                           br = c(-Inf, -.1, .1, Inf)) {
    res <- data.table::data.table(sent_score = x@sent_scores)
    res$lab <- assign_sent_lab(res$sent_score, br)
    sum(res$lab == "positive") / sum(res$lab == "negative")
}

#' @export
#' @name review_set-summary
sentimentSummary <- function(x) {
    res <- stats::na.omit(x@sent_scores)
    list(mean = mean(res),
         sd = stats::sd(res),
         min = min(res),
         max = max(res),
         dec = stats::quantile(res, probs = 1:10 / 10))
}
