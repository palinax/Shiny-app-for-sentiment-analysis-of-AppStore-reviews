#' review Class
#'
#' A class representing a review.
#'
#' @name review
#' @docType class
#'
#' @slot original the original text of the review.
#' @slot processed the processed text of the review.
#' @slot sent_score the sentiment score of the review.
#' @slot rating rating assigned to the review
#'
#' @export
#' @aliases review-class
setClass(Class = "review",
         slots = list(original = "character",
                      processed = "character",
                      sent_score = "numeric",
                      rating = "numeric"))

#' Constructor for 'review' class
#'
#' @param x character containing review
#' @param rt rating of a review
#'
#' @return object of class \code{review}
#' @export
#'
#' @examples
#' review <- review("This is a great product.", 5)
#' review
review <- function(x, rt) {
    prc <- pre_process(x)
    res <- new(Class = "review",
               original = x,
               processed = prc,
               sent_score = sent_score(prc),
               rating = rt)
    res
}

#' Print method
#'
#' @param object review object
#'
#' @return printed message about review
#' @export
#'
#' @examples
#' print(review("This is a great product.", 5))
setMethod(f = "show",
          signature = "review",
          definition = function(object) {
              message(paste0("original: ", object@original, "\n"))
              message(paste0("processed: '",
                             paste0(object@processed, collapse = "', '"), "'\n"))
              message(paste0("rating: ", object@rating))
          })

#' Tokenize words in a character string
#'
#' This method tokenizes the words in a character string by splitting it on whitespace and handling contractions.
#'
#' @param x object to tokenize
#'
#' @return A character vector of individual words.
#' @export
#' @rdname word_tokenize
#' @examples
#' word_tokenize("I don't like it")
setMethod(f = "word_tokenize",
          signature = "character",
          definition = function(x) {
              x <- gsub(pattern = "n’t", replacement = "n not", x = x)
              unlist(strsplit(x = x, split = "\\s"))
          })

#' Remove Numerical and Punctuation Characters
#'
#' This method removes numerical and punctuation characters from a given character vector.
#'
#' @param x A character vector.
#' @return A modified character vector with numerical and punctuation characters removed.
#' @export
#' @method remove_numerical_and_punct character
#' @examples
#' remove_numerical_and_punct("Hello, 123!")
#' @rdname remove_numerical_and_punct
setMethod(f = "remove_numerical_and_punct",
          signature = "character",
          definition = function(x) {
              gsub("[0-9[:punct:]]", " ", x)
          })

#' @title Removing stop words from a character
#'
#' @param x character
#'
#' @export
#' @rdname remove_stop_words
setMethod(f = "remove_stop_words",
          signature = "character",
          definition = function(x) {
              stopwords <- tm::stopwords()
              setdiff(x, stopwords)
          })

#' @title Stemming words
#'
#' @param x character
#' @export
#' @rdname word_stem
setMethod(f = "word_stem",
          signature = "character",
          definition = function(x) {
              tm::stemDocument(x)
          })

#' @title Preprocess character
#'
#' @param object An object to preprocess
#'
#' @export
#' @rdname pre_process
#' @export
#' @return returns processed character, that means after removing emojis, converting to lowercase,
#' removing numeric values and punctuations, tokenizing, removing stop words and stemming
#'
#' @examples
#' pre_process("HellO")
setMethod(f = "pre_process",
          signature = "character",
          definition = function(object) {
              checkmate::assert_character(object)
              # remove emojis
              x <- gsub("[^\x01-\x7F]", "", object)
              x <- tolower(x)
              x <- remove_numerical_and_punct(x)
              x <- word_tokenize(x)
              x <- remove_stop_words(x)
              x <- word_stem(x)
              return(x)
          })

#' @export
#' @rdname pre_process
setMethod(f = "pre_process",
          signature = "review",
          definition = function(object) {
              pre_process(object@original)
          })

#' Calculates sentiment score for a sentence
#'
#' @param x character vector
#'
#' @return single number with mean sentiment with afinn dictionary
#' @export
#' @source http://www2.imm.dtu.dk/pubdb/pubs/6010-full.html
#' @examples
#' sent_score(c("great", "product"))
sent_score <- function(x) {
    checkmate::assert_character(x)
    mean(newfinn[match(x = x, table = newfinn$word)]$value, na.rm = TRUE)
}
