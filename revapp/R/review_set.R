review_set <- setClass(Class = "review_set",
                       representation = list(reviews = "list"))
setGeneric(name = "tokenize_review_set", def = function(x) standardGeneric(f = "tokenize_review_set"))
setMethod(f = "tokenize_review_set",
          signature = "review_set",
          definition = function(x)
          {
              lapply(X = x@reviews, FUN = function(j) tokenize_review(j))
          })
tokenize_review_set(review_set(reviews = list(review(cont = "a"), review(cont = "b"))))
