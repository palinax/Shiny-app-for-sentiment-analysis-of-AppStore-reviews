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
#' review <- review("This is a great product.")
#' review
#' @export
setClass(Class = "review",
         slots = list(original = "character",
                      processed = "character",
                      sent_score = "numeric"))

#' Title
#'
#' @param x character containing review
#'
#' @return
#' @export
#'
#' @examples
#' review <- review("This is a great product.")
#' review
review <- function(x) {
    prc <- pre_process(x)
    res <- new(Class = "review",
               original = x,
               processed = prc,
               sent_score = sent_score(prc))
    res
}

#' Title
#'
#' @param review
#'
#' @return printed message about review
#' @export
#'
#' @examples
#' review("This is a great product.")
setMethod(f = "show",
          signature = "review",
          definition = function(x) {
              message(paste0("original: ", x@original, "\n"))
              message(paste0("processed: '", paste0(x@processed, collapse = "', '"), "'\n"))
          })

#' Title
#'
#' @param x
#'
#' @return
#' @export
#'
#' @examples
setGeneric(name = "word_tokenize",
           def = function(x) {
               standardGeneric(f = "word_tokenize")
           })

#' Title
#'
#' @param character
#'
#' @return
#' @export
#'
#' @examples
setMethod(f = "word_tokenize",
          signature = "character",
          definition = function(x) {
              unlist(strsplit(x = x, split = "\\s"))
          })

#' Title
#'
#' @param x
#'
#' @return
#' @export
#'
#' @examples
setGeneric(name = "remove_numerical_and_punct",
           def = function(x) {
               standardGeneric(f = "remove_numerical_and_punct")
           })

#' Title
#'
#' @param character
#'
#' @return
#' @export
#'
#' @examples
setMethod(f = "remove_numerical_and_punct",
          signature = "character",
          definition = function(x) {
              gsub("[0-9[:punct:]]", " ", x)
          })

#' Title
#'
#' @param x
#'
#' @return
#' @export
#'
#' @examples
setGeneric(name = "remove_stop_words",
           def = function(x) {
               standardGeneric(f = "remove_stop_words")
           })

#' Title
#'
#' @param character
#'
#' @return
#' @export
#'
#' @examples
setMethod(f = "remove_stop_words",
          signature = "character",
          definition = function(x) {
              stopwords <- tm::stopwords()
              setdiff(x, stopwords)
          })

#' Title
#'
#' @param x
#'
#' @return
#' @export
#'
#' @examples
setGeneric(name = "word_stem",
           def = function(x) {
               standardGeneric(f = "word_stem")
           })

#' Title
#'
#' @param character
#'
#' @return
#' @export
#'
#' @examples
setMethod(f = "word_stem",
          signature = "character",
          definition = function(x) {
              tm::stemDocument(x)
          })

#' Title
#'
#' @param x
#'
#' @return
#' @export
#'
#' @examples
setGeneric(name = "pre_process",
           def = function(x) {
               standardGeneric(f = "pre_process")
           })

#' Title
#'
#' @param character
#'
#' @return
#' @export
#'
#' @examples
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

#' Title
#'
#' @param review
#'
#' @return
#' @export
#'
#' @examples
setMethod(f = "pre_process",
          signature = "review",
          definition = function(x) {
              pre_process(x@original)
          })

#' Title
#'
#' @param x
#'
#' @return
#' @export
#'
#' @examples
sent_score <- function(x) {
    checkmate::assert_character(x)
    mean(newfinn[match(x = x, table = newfinn$word)]$value, na.rm = TRUE)
}
