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
setClass(Class = "review_set",
         slots = list(reviews = "list",
                      words = "data.table",
                      sent_scores = "numeric"))

#' Title
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
                    FUN = function(i) data.table(proc_word = i@processed))
    words <- rbindlist(words)[, list(how_many = .N), by = "proc_word"]
    new(Class = "review_set",
        reviews = x,
        words = words,
        sent_scores = unlist(lapply(X = x, FUN = function(i) i@sent_score)))
}

#' Title
#'
#' @param review_set object of class review
#'
#' @return
#' @export
#'
#' @examples
#' ll <- lapply(X = sample_apps_reviews$Snapchat$review[1:10],
#'              FUN = function(i) review(x = i))
#' review_set(ll)
setMethod(f = "show",
          signature = "review_set",
          definition = function(x) {
              message(paste0("Number of reviews: ", length(x@reviews), "\n"))
              message(paste0("Most common words: '",
                             paste0(x@words[order(-how_many)]$proc_word[1:3], collapse = "', '"), "'\n"))
              message(paste0("Mean sentiment score (standard deviation): ",
                             mean(x@sent_scores, na.rm = T), " (",
                             sd(x@sent_scores, na.rm = T), ")\n"))
          })

#' Charts for set of reviews
#'
#' @param x object of class \code{review-set}
#' @param br breaks for establish whether review is negative or positive
#' @param colors colors for categories
#'
#' @return charts
#' @export
#'
#' @rdname review-set-charts
#'
#' @examples
#' ll <- lapply(X = sample_apps_reviews$Snapchat$review[1:10],
#'              FUN = function(i) review(x = i))
#' set_review <- review_set(ll)
#' sentimentDistributionPie(set_review)
#' sentimentDistributionHist(set_review)
sentimentDistributionPie <- function(x, br = c(-Inf, -0.1, 0.1, Inf), colors) {
    res <- data.table(sent_score = x@sent_scores)
    res[, lab := cut(x = sent_score, breaks = br, labels = c("negative", "neutral", "positive"))]
    res[is.nan(sent_score), lab := "couldn't determine"]
    res <- res[, list(l = .N), by = "lab"]
    pie(res$l, labels = res$lab, main = "Sentiment distribution", col = colors)
}

#' @name review-set-charts
#' @export
sentimentDistributionHist <- function(x) {
    ggplot(data = data.table(x = x@sent_scores)) +
        geom_histogram(aes(x = x)) +
        labs(title = "Sentiment distribution") +
        theme_minimal() +
        coord_cartesian(xlim = c(-5.1, 5.1))
}

#' Title
#'
#' @param x object of class \code{review-set}
#' @param br breaks for establish whether review is negative or positive
#'
#' @return numeric
#' @export
#'
#' @name review-set-summary
#'
#' @examples
#' ll <- lapply(X = sample_apps_reviews$Snapchat$review[1:10],
#'              FUN = function(i) review(x = i))
#' set_review <- review_set(ll)
#' sentimentRatio(set_review)
#' sentimentSummary(set_review)
sentimentRatio <- function(x, br = c(-Inf, -.1, .1, Inf)) {
    res <- data.table(sent_score = x@sent_scores)
    res[, lab := as.character(cut(x = sent_score, breaks = br, labels = c("negative", "neutral", "positive")))]
    res[is.nan(sent_score), lab := "couldn't determine"]
    sum(res$lab == "positive") / sum(res$lab == "negative")
}

#' @rdname review-set-summary
#' @export
sentimentSummary <- function(x) {
    res <- na.omit(x@sent_scores)
    list(mean = mean(res),
         sd = sd(res),
         min = min(res),
         max = max(res),
         dec = quantile(res, probs = 1:10 / 10))
}
