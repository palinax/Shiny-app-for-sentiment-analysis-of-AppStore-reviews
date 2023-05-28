#' review Class
#'
#' A class representing a review.
#'
#' @name review
#' @docType class
#'
#' @slot original The original text of the review.
#' @slot processed The processed text of the review.
#' @slot sent_score The sentiment score of the review.
#'
#' @examples
#' review <- new("review", original = "This is a great product.")
#' review
#' @export
setClass(Class = "review",
         representation = list(original = "character",
                               processed = "character",
                               sent_score = "numeric"))

review <- function(x) {
    prc <- pre_process(x)
    res <- new(Class = "review",
               original = x,
               processed = prc,
               sent_score = sent_score(prc))
    res
}

setMethod(f = "show",
          signature = "review",
          definition = function(x) {
              message(paste0("original: ", x@original, "\n"))
              message(paste0("processed: '", paste0(x@processed, collapse = "', '"), "'\n"))
          })

setGeneric(name = "word_tokenize",
           def = function(x) {
               standardGeneric(f = "word_tokenize")
           })

setMethod(f = "word_tokenize",
          signature = "character",
          definition = function(x) {
              unlist(strsplit(x = x, split = "\\s"))
          })

setGeneric(name = "remove_numerical_and_punct",
           def = function(x) {
               standardGeneric(f = "remove_numerical_and_punct")
           })

setMethod(f = "remove_numerical_and_punct",
          signature = "character",
          definition = function(x) {
              gsub("[0-9[:punct:]]", " ", x)
          })

setGeneric(name = "remove_stop_words",
           def = function(x) {
               standardGeneric(f = "remove_stop_words")
           })

setMethod(f = "remove_stop_words",
          signature = "character",
          definition = function(x) {
              stopwords <- c("the", "a", "i", "and")
              setdiff(x, stopwords)
          })

setGeneric(name = "word_stem",
           def = function(x) {
               standardGeneric(f = "word_stem")
           })

setMethod(f = "word_stem",
          signature = "character",
          definition = function(x) {
              substr(x, 1, 3)
          })

setGeneric(name = "pre_process",
           def = function(x) {
               standardGeneric(f = "pre_process")
           })

setMethod(f = "pre_process",
          signature = "character",
          definition = function(x) {
              checkmate::assert_character(x)
              x <- tolower(x)
              x <- remove_numerical_and_punct(x)
              x <- word_tokenize(x)
              x <- remove_stop_words(x)
              x <- word_stem(x)
              return(x)
          })

setMethod(f = "pre_process",
          signature = "review",
          definition = function(x) {
              pre_process(x@original)
          })

sent_score <- function(x) {
    checkmate::assert_character(x)
    set.seed(1234)
    mean(runif(length(x), -1, 1))
}
