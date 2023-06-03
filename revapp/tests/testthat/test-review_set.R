test_that("simple test for review_set", {
    review1 <- review("This is a great product.")
    review2 <- review("I'm not satisfied with this product.")

    set_review <- review_set(list(review1, review2))
    expect_equal(object = length(set_review@reviews), 2)
    expect_equal(object = max(set_review@words$how_many), 2)
})

test_that("plots for review_set - sentimentDistributionPie", {
    expect_error(object = sentimentDistributionPie(1),
                 "Assertion on 'x' failed: Must inherit from class 'review_set', but has class 'numeric'.")
    expect_error(object = sentimentDistributionPie(x = review_set_example(), 1),
                 "Assertion on 'br' failed: Must have length 4, but has length 1.")
    expect_error(object = sentimentDistributionPie(x = review_set_example(), letters[1:4]),
                 "Assertion on 'br' failed: Must be of type 'numeric', not 'character'.")
    expect_error(object = sentimentDistributionPie(x = review_set_example(), colors = 1),
                 "Assertion on 'colors' failed: Must be of type 'character', not 'double'.")
    expect_error(object = sentimentDistributionPie(x = review_set_example(), colors = 1:4),
                 "Assertion on 'colors' failed: Must be of type 'character', not 'integer'.")
})
