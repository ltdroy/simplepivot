test_that("mean sd summary works", {

  input_vector <- c(1,2,3,4,5,6,7,8)

  expect_equal(simplepivot_mean_sd(input_vector), "4.5 (SD: 2.449)")

})

test_that("mean 95% CI summary works", {

  input_vector <- c(1,2,3,4,5,6,7,8)

  expect_equal(simplepivot_mean_95CI(input_vector),
               "4.5 (95% CI: 2.452 - 6.548)")

})

test_that("mean SE summary works", {

  input_vector <- c(1,2,3,4,5,6,7,8)

  expect_equal(simplepivot_mean_SE(input_vector),
               "4.5 (SE: 0.866)")


})

test_that("median IQR summary works", {

  input_vector <- c(1,2,3,4,5,6,7,8)

  expect_equal(simplepivot_median_IQR(input_vector),
               "4.5 (IQR: 3.5)")

})


