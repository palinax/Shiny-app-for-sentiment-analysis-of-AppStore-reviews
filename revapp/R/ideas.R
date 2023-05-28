# prepare_dt <- function(reviews)
# {
#     oo <- tokenize_reviews(dt = reviews)
#     oo$l <- blank_stop_word(oo$l)
#     agr_tokens(oo)
# }
#
# tokenize_reviews <- function(dt)
# {
#     rbindlist(
#         l = lapply(
#             X = 1:nrow(dt),
#             FUN = function(i)
#             {
#                 data.table(id = dt$id[i], l = tokenize_review(dt$review[i]))
#             }
#         )
#     )
# }
#
# blank_stop_word <- function(x)
# {
#     stops <- c(letters, "is", "the", "of", "to", "and", "for", LETTERS)
#     res <- x
#     res[x %in% stops] <- ""
#     res
# }
#
# agr_tokens <- function(oo)
# {
#     oo[,.(V = uniqueN(id)), by = .(l)]
# }

# set_review <- review_set(lapply(X = sample_apps_reviews$Snapchat$review[1:10], FUN = function(i) review(i)))
# plot_word_count(set_review@words)
# plot_word_count <- function(oo, mn = 10)
# {
#     checkmate::assert_data_table(oo)
#     checkmate::assert_number(mn, lower = 0)
#     rr <- oo[oo$proc_word != ""][order(-how_many)][1:mn]
#     ggplot(data = rr) +
#         geom_col(aes(x = how_many, y = substr(proc_word, 1, 20)))
# }
#
# rescale <- function(x, ab, cd) {
#     (cd[2]-cd[1])*(x - ab[1]) / (ab[2] - ab[1]) + cd[1]
# }
# rr <- c(5,35)
# # dt[, width := systemfonts::string_width(proc_word, size = )]
# ggplot(data = dt[1:4], aes(x = 0, y = 0, label = proc_word, size = how_many, angle = angle)) +
#     geom_text(hjust = 0) +
#     scale_size_continuous(range = rr)
# plot_word_cloud <- function(dt) {
#
# }
# ll <- lapply(X = dt$proc_word, FUN = function(i) {
#     plot.new()
#     rr <- c(graphics::strheight(i), graphics::strwidth(i))
#     dev.off()
#     return(rr)
# })
#
# ll1 <- unlist(lapply(ll, FUN = function(i) i[1]))
# ll2 <- unlist(lapply(ll, FUN = function(i) i[2]))
# dt <- set_review@words
# dt <- dt[order(-how_many)]
# dt$angle = rep(c(0, -90), times = ceiling(nrow(dt) / 2))[1:nrow(dt)]
#
# dt[, recSize := rescale(how_many, range(how_many), rr)]
#
# dt$width = ll2
# dt$height = ll1
# dt[, nextMx := shift(height)]
# dt[, nextMy := shift(height)]
# dt[angle == 0, nextMx := 0]
# dt[angle == -90, nextMy := 0]
# dt$nextMy[1] = 0
# dt$nextMx[1] = 0
# dt[, x := cumsum(recSize * nextMx)]
# dt[, y := cumsum(recSize * nextMy)]
#
# ggplot(data = dt[1:10], aes(x = x, y = -y, label = proc_word, size = how_many, angle = angle)) +
#     geom_text(hjust = 0) +
#     scale_size_continuous(range = rr)
