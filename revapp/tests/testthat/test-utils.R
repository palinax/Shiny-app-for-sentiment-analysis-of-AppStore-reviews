test_that("ic_utf8 tests", {
    expect_error(ic_utf8(1), "Assertion on 'x' failed: Must be of type 'character', not 'double'.")
    expect_identical(ic_utf8(c("A")), c("A"))
})
