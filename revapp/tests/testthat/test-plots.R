test_that("plot_rating_hour errors", {
    expect_error(plot_rating_hour(dt = 1),
                 "Assertion on 'dt' failed: Must be a data.table, not double.")
})

test_that("plot_rating_hour works", {
    res <- plot_rating_hour(dt = sample_apps_reviews$Snapchat)
    expect_true(is(res, "ggplot"))
})

test_that("plot_word_count errors", {
    expect_error(plot_word_count(oo = 1),
                 "Assertion on 'oo' failed: Must be a data.table, not double.")
    expect_error(plot_word_count(oo = review_set_example()@words, mn = "a"),
                 "Assertion on 'mn' failed: Must be of type 'number', not 'character'.")
})

test_that("plot_word_count works", {
    res <- plot_word_count(review_set_example()@words)
    expect_true(is(res, "ggplot"))
})
