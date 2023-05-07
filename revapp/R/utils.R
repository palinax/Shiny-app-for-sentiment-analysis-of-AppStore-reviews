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
