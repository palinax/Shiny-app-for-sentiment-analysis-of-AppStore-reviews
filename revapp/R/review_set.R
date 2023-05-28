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
#' set_review <- review_set(lapply(X = sample_apps_reviews$Snapchat$review[1:10], FUN = function(i) review(x = i)))
#' set_review
#' @export
setClass(Class = "review_set",
         slots = list(reviews = "list",
                      words = "data.table",
                      sent_scores = "numeric"))

#' Title
#'
#' @param x
#'
#' @return
#' @export
#'
#' @examples
review_set <- function(x) {
    words <- lapply(X = x, FUN = function(i) data.table(proc_word = i@processed))
    words <- rbindlist(words)[, list(how_many = .N), by = "proc_word"]
    new(Class = "review_set",
        reviews = x,
        words = words,
        sent_scores = unlist(lapply(X = x, FUN = function(i) i@sent_score)))
}

#' Title
#'
#' @param review_set
#'
#' @return
#' @export
#'
#' @examples
setMethod(f = "show",
          signature = "review_set",
          definition = function(x) {
              message(paste0("Number of reviews: ", length(x@reviews), "\n"))
              message(paste0("Most common words: '", paste0(x@words[order(-how_many)]$proc_word[1:3], collapse = "', '"), "'\n"))
              message(paste0("Mean sentiment score (standard deviation): ", mean(x@sent_scores, na.rm = T), " (", sd(x@sent_scores, na.rm = T), ")\n"))
          })

#' Charts for set of reviews
#'
#' @param x object of class \code{review-set}
#' @param br breaks for establish whether review is negative or positive
#'
#' @return charts
#' @export
#'
#' @rdname review-set-charts
#'
#' @examples
#' set_review <- review_set(lapply(X = sample_apps_reviews$Snapchat$review[1:10], FUN = function(i) review(x = i)))
#' sentimentDistributionPie(set_review)
#' sentimentDistributionHist(set_review)
sentimentDistributionPie <- function(x, br = c(-Inf, -0.1, 0.1, Inf)) {
    res <- data.table(sent_score = x@sent_scores)
    res[, lab := cut(x = sent_score, breaks = br, labels = c("negative", "neutral", "positive"))]
    res[is.nan(sent_score), lab := "couldn't determine"]
    res <- res[,.(l = .N), by = "lab"]
    pie(res$l, labels = res$lab, main = "Sentiment distribution")
}

#' @name review-set-charts
sentimentDistributionHist <- function(x) {
    hist(x@sent_scores, main = "Sentiment distribution")
}

#' Title
#'
#' @param x
#' @param br
#'
#' @return
#' @export
#'
#' @examples
#' set_review <- review_set(lapply(X = sample_apps_reviews$Snapchat$review[1:10], FUN = function(i) review(x = i)))
#' sentimentRatio(set_review)
sentimentRatio <- function(x, br = c(-Inf, -.1, .1, Inf)) {
    res <- data.table(sent_score = x@sent_scores)
    res[, lab := as.character(cut(x = sent_score, breaks = br, labels = c("negative", "neutral", "positive")))]
    res[is.nan(sent_score), lab := "couldn't determine"]
    sum(res$lab == "positive") / sum(res$lab == "negative")
}

#' Title
#'
#' @param x
#'
#' @return
#' @export
#'
#' @examples
sentimentSummary <- function(x) {
    res <- na.omit(x@sent_scores)
    list(mean = mean(res),
         sd = sd(res),
         min = min(res),
         max = max(res),
         dec = quantile(res, probs = 1:10 / 10))
}
