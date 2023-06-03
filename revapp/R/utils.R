#' Converting string to UTF-8
#'
#' @param x character string
#'
#' @return
#' x with UTF-8 encoding
#' @export
#'
#' @examples
#' ic_utf8(c("Andy", "Bob"))
ic_utf8 <- function(x)
{
    checkmate::assert_character(x)
    res <- x
    res[Encoding(x)!="UTF-8"] <- iconv(x[Encoding(x)!="UTF-8"], "CP1250", "UTF-8")
    res
}

#' Assigning labels for sentiment score
#'
#' @param x numeric vector
#' @param br breaks for score
#'
#' @return character vector of labels
#' @export
#'
#' @examples
#' assign_sent_lab(3)
assign_sent_lab <- function(x, br = c(-Inf, -0.1, 0.1, Inf)) {
    checkmate::assert_numeric(x)
    checkmate::assert_numeric(br, len = 4)
    res <- as.character(cut(x = x, breaks = br, labels = c("negative", "neutral", "positive")))
    res[is.nan(x)] <- "couldn't determine"
    res
}
