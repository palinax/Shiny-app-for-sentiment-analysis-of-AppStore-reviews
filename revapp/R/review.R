review <- setClass(Class = "review",
                   representation = list(cont = "character"))
setGeneric(name = "tokenize_review", def = function(x) standardGeneric(f = "tokenize_review"))
setMethod(f = "tokenize_review",
          signature = "review",
          definition = function(x)
          {
              unlist(strsplit(x = x@cont, split = "\\s"))
          })
tokenize_review(review(cont = "a"))
