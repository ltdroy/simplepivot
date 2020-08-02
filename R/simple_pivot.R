#' Simple Pivot Data Transformation
#'
#' @param df Data frame object to transform
#' @param row_vars Character vector naming the row variable(s)
#' @param col_vars Character vector naming the column variable(s)
#' @param value_variable Length 1 character vector naming the column with the value to summarise in table cells
#' @param value_function Function that takes a single vector of values as first (and only required) argument and returns a single summary
#' value (the base r 'mean' function, for example). Used to summarise the 'value variable' (by row/column group).
#'
#' @importFrom dplyr "%>%"
#'
#' @return a tibble/data.frame with the pivot operation applied to it
#' @export
#'
#' @examples
#' simple_pivot(df = mtcars,
#'  row_vars = c("gear"),
#'  col_vars = c("carb"),
#'  value_variable = "mpg",
#'  value_function = sum)
simple_pivot <- function(df,
                         row_vars,
                         col_vars,
                         value_variable,
                         value_function){

  # Input validation tests

  ## Check that the inputs have the required types
  testthat::expect_is(object = df, class =  "data.frame")
  testthat::expect_type(object = row_vars, type = "character")
  testthat::expect_type(object = col_vars, type = "character")
  testthat::expect_type(object = value_variable, type = "character")
  testthat::expect_is(object = value_function, class = "function")

  ## Check that variables are available in the dataframe
  testthat::expect_true(all(row_vars %in% names(df)),
                        info = "row_vars variable(s) not found in df")
  testthat::expect_true(all(col_vars %in% names(df)),
                        info = "col_vars variable(s) not found in df")
  testthat::expect_true(value_variable %in% names(df),
                        info = "value_variable not found in df")


  # expected_count_groups <- purrr::map_dbl(
  #   .x = c(row_vars, col_vars),
  #   .f = function(x, df){
  #     return(length(unique(df[[x]])))
  #     },
  #   df
  #   ) %>% prod()

#  print(expected_count_groups)

  df %>%
    dplyr::group_by_at(c(row_vars, col_vars)) %>%
    dplyr::summarise(
      val = check_function_output(
        value_function(!!as.symbol( value_variable ))
        )
      ) %>%
      tidyr::pivot_wider(
        names_from=col_vars,
        names_prefix=paste0("(", paste0(col_vars, collapse=", "), ") "),
        names_sep = " ",
        names_sort=TRUE,
        values_from="val"
      ) %>%
     dplyr::arrange_at(row_vars)

}


#' Check output is length 1
#'
#' @param output Output of the value function
#'
#' @return output
#'
#'
#' @examples
check_function_output <- function(output){
  testthat::expect_true(length(output) == 1,
                        info = "\nThe value_function that you supplied returned more than 1 value per-group!\n\n")
  return(output)
}

