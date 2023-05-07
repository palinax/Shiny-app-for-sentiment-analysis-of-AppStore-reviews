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
usethis::use_data(sample_apps, overwrite = T)
sample_apps_reviews <- rbindlist(
    l = lapply(
        X = names(sample_apps),
        FUN = function(x)
        {
            message(sample_apps[[x]])
            Sys.sleep(5)
            dt <- data.table(get_apple_reviews(id = sample_apps[[x]], all_results = T))
            dt[, app_id := sample_apps[[x]]]
            return(dt[])
        }
    )
)

sample_apps_reviews[, review := ic_utf8(review)]
sample_apps_reviews[, title := ic_utf8(title)]
usethis::use_data(sample_apps_reviews, overwrite = T)
