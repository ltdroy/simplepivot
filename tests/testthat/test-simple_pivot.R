test_that("means are summarised correctly for 2-way table", {

  excel_mtcar_pivot <- data.frame(
   check.names = FALSE,
   carb = c(1, 2, 3, 4, 6, 8),
   `(gear) 3` = c(20.33333333,17.15,16.3,12.62, NA,NA),
   `(gear) 4` = c(29.1, 24.75, NA, 19.75, NA, NA),
   `(gear) 5` = c(NA, 28.2, NA, 15.8, 19.7, 15)
   )

  simple_pivot_result <- simple_pivot(
    df = mtcars,
    row_vars = "carb",
    col_vars = "gear",
    value_variable = "mpg",
    value_function = mean)

  expect_equivalent(excel_mtcar_pivot, as.data.frame(simple_pivot_result))

})

test_that("counts are summarised correctly for 2-way table with two rows", {

  excel_mtcar_pivot <- data.frame(
    check.names = FALSE,
    cyl        = c(4,4,6,6,8),
    vs         = c(0,1,0,1,0),
    `(gear) 3` = c(NA, 1L, NA, 2L, 12L),
    `(gear) 4` = c(NA, 8L, 2L, 2L, NA),
    `(gear) 5` = c(1L, 1L, 1L, NA, 2L)
    )

  simple_pivot_result <- simple_pivot(
    df = mtcars,
    row_vars = c("cyl", "vs"),
    col_vars = "gear",
    value_variable = "mpg",
    value_function = length)

  expect_equivalent(excel_mtcar_pivot, as.data.frame(simple_pivot_result))

})

test_that("counts are summarised correctly for 2-way table with two columns", {

  excel_mtcar_pivot <- data.frame(
      Class = c("1st", "2nd", "3rd", "Crew"),
      `(Sex, Survived) Male, No` = c(118L, 154L, 422L, 670L),
      `(Sex, Survived) Male, Yes` = c(62L, 25L, 88L, 192L),
      `(Sex, Survived) Female, No` = c(4L, 13L, 106L, 3L),
      `(Sex, Survived) Female, Yes` = c(141L, 93L, 90L, 20L),
      check.names = FALSE
     ) %>% dplyr::mutate(Class=as.factor(Class))

  simple_pivot_result <- simple_pivot(
    df = Titanic %>% as.data.frame(),
    row_vars = c("Class"),
    col_vars = c("Sex", "Survived"),
    value_variable = "Freq",
    value_function = sum)

  expect_equivalent(excel_mtcar_pivot, as.data.frame(simple_pivot_result))

})



