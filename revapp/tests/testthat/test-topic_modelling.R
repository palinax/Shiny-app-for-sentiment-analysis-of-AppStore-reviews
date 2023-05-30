test_that("topic modelling works", {
    expect_class(get_topic_reviews(review_set_example()@reviews), "LDA_Gibbs")
})

test_that("topic modelling errors", {
    expect_error(get_topic_reviews(1))
    expect_error(get_topic_reviews(review_set_example()@reviews, no_topics = -1))
    expect_error(get_topic_reviews(review_set_example()@reviews, no_topics = 3, method = "dummy"))
})

test_that("topic modelling works", {
    topiced <- get_topic_reviews(review_set_example()@reviews)
    expect_class(get_top_from_lda(topiced), "data.table")
})

test_that("topic modelling errors", {
    expect_error(get_topic_reviews(1))
    topiced <- get_topic_reviews(review_set_example()@reviews)
    expect_error(get_top_from_lda(topiced, no_top = -1))
})
