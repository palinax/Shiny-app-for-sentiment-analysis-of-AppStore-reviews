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
#' review1 <- new("review", original = "This is a great product.")
#' review2 <- new("review", original = "I'm not satisfied with this product.")
#'
#' review_set <- new("review_set", reviews = list(review1, review2)
#' review_set
#' @export
setClass(Class = "review_set",
         representation = list(reviews = "list",
                               words = "data.table",
                               sent_scores = "numeric"))

review_set <- function(x) {
    words <- lapply(X = x, FUN = function(i) data.table(proc_word = i@processed))
    words <- rbindlist(words)[,.(how_many = .N), by = "proc_word"]
    new(Class = "review_set",
        reviews = x,
        words = words,
        sent_scores = unlist(lapply(X = x, FUN = function(i) i@sent_score)))
}

setMethod(f = "show",
          signature = "review_set",
          definition = function(x) {
              message(paste0("Number of reviews: ", length(x@reviews), "\n"))
              message(paste0("Most common words: '", paste0(x@words[order(-how_many)]$proc_word[1:3], collapse = "', '"), "'\n"))
              message(paste0("Mean sentiment score (standard deviation): ", mean(x@sent_scores), " (", sd(x@sent_scores), ")\n"))
          })
