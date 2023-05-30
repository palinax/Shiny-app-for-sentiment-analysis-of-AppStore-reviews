test_that("review works", {
    res <- review(x = "This is a great product.")
    expect_equal(object = res@original, "This is a great product.")
    expect_equal(object = res@processed, c("great", "product"))
})

test_that("sent score", {
    expect_error(sent_score(1))
    expect_identical(sent_score("This is a great product"), NaN)
})
