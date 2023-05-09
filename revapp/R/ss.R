prepare_dt <- function(reviews)
{
    oo <- tokenize_reviews(dt = reviews)
    oo$l <- blank_stop_word(oo$l)
    agr_tokens(oo)
}

tokenize_reviews <- function(dt)
{
    rbindlist(
        l = lapply(
            X = 1:nrow(dt),
            FUN = function(i)
            {
                data.table(id = dt$id[i], l = tokenize_review(dt$review[i]))
            }
        )
    )
}

blank_stop_word <- function(x)
{
    stops <- c(letters, "is", "the", "of", "to", "and", "for", LETTERS)
    res <- x
    res[x %in% stops] <- ""
    res
}

agr_tokens <- function(oo)
{
    oo[,.(V = uniqueN(id)), by = .(l)]
}
