## code to prepare `Reviews` dataset goes here
library(appler)
library(data.table)

sample_apps <- list(
    'Snapchat' = '447188370',
    'Tinder' = '547702041',
    'Spotify' = '324684580',
    'Binance' = '1436799971',
    'Notion' = '1232780281'
)

sample_apps_reviews <- lapply(X = names(sample_apps),
                              FUN = function(x) {
                                  message(sample_apps[[x]])
                                  Sys.sleep(5)
                                  dt <- data.table(get_apple_reviews(id = sample_apps[[x]], all_results = T))
                                  dt[, review := ic_utf8(review)]
                                  dt[, title := ic_utf8(title)]
                                  return(dt[])
                              })
names(sample_apps_reviews) <- names(sample_apps)
usethis::use_data(sample_apps_reviews, overwrite = T)
