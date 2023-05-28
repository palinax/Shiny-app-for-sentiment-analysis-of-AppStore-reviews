#' Sample of reviews
#'
#' @format ## `sample_apps_reviews`
#' A named list of data table with 500 rows and 7 columns each:
#' \describe{
#'   \item{id}{id of an review}
#'   \item{review time}{time of the review}
#'   \item{author}{nick}
#'   \item{app_version}{version of the app}
#'   \item{title}{title of a review}
#'   \item{rating}{rating of an app}
#'   \item{review}{review itslef}
#' }
#' @source appler package
"sample_apps_reviews"

#' Sentiment score usign affin dataset reviews
#'
#' @format ## `newfinn`
#' A data table with 2477 rows and 2 columns:
#' \describe{
#'   \item{word}{word}
#'   \item{value}{sentiment ranges from -5 to 5}
#' }
#' @source http://www2.imm.dtu.dk/pubdb/pubs/6010-full.html
"newfinn"
