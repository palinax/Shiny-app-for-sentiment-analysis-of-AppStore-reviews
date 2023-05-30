test_that("multiplication works", {
    review1 <- review("This is a great product.")
    review2 <- review("I'm not satisfied with this product.")

    set_review <- review_set(list(review1, review2))
    expect_equal(object = length(set_review@reviews), 2)
    expect_equal(object = max(set_review@words$how_many), 2)
})
