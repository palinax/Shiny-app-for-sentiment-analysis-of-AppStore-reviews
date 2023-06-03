#' @name remove_numerical_and_punct
setGeneric(name = "remove_numerical_and_punct",
           def = function(x) {
               standardGeneric(f = "remove_numerical_and_punct")
           })

#' @name remove_stop_words
setGeneric(name = "remove_stop_words",
           def = function(x) {
               standardGeneric(f = "remove_stop_words")
           })

#' @name word_stem
setGeneric(name = "word_stem",
           def = function(x) {
               standardGeneric(f = "word_stem")
           })

#' @name word_tokenize
setGeneric(name = "word_tokenize",
           def = function(x) {
               standardGeneric(f = "word_tokenize")
           })

#' @name pre_process
setGeneric(name = "pre_process",
           def = function(object) {
               standardGeneric(f = "pre_process")
           })
