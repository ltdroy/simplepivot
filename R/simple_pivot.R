#' Simple Pivot Data Transformation
#'
#' @param df Data frame object to transform
#' @param row_vars Character vector naming the row variable(s)
#' @param col_vars Character vector naming the column variable(s)
#' @param value_variable String variable indicating the column with values of analyse
#' @param value_function Function that takes a vector of values for a group (defined
#' by a unique combination of row and column values) and returns a single summary
#' value (the built in 'mean' function, for example).
#'
#' @importFrom dplyr "%>%"
#'
#' @return a dataframe with the pivot operation applied to it
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

  df %>%
    dplyr::group_by_at(c(row_vars, col_vars)) %>%
    dplyr::summarise(
      val = value_function(!!as.symbol( value_variable ))
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



