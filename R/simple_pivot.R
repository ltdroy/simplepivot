#' Simple Pivot Data Transformation
#'
#' @param df # Data frame object to transform
#' @param row_var # String indicating the row variable
#' @param col_var
#' @param value_variable
#' @param value_function
#'
#' @importFrom dplyr "%>%"
#'
#' @return
#' @export
#'
#' @examples
simple_pivot <- function(df,
                         row_vars,
                         col_var,
                         value_variable,
                         value_function,
                         col_desc = FALSE,
                         row_desc = FALSE
                         ){


  col_vals <- df[[col_var]] %>% unique() %>% sort(., decreasing = col_desc)

 # row_vals <- df[[row_var]] %>% unique() %>% sort(., decreasing = row_desc)

  summary_table <- purrr::map(
    col_vals,
    get_simplepivot_column,
    df,
    row_vars,
    col_var,
    value_variable,
    value_function) %>%
    purrr::reduce(., dplyr::full_join, by=row_vars)

    names(summary_table) <- c(row_vars, paste0(col_var,": ", col_vals))


  return(summary_table)


}

get_simplepivot_column <- function(col_val,
                                   df,
                                   row_var,
                                   col_var,
                                   value_var,
                                   value_func){

  summary_col <- df %>%
    dplyr::filter(get(col_var) == col_val) %>%
    dplyr::group_by_at( row_var ) %>%
    dplyr::summarise(
        val = value_func(!!as.symbol(value_var))
  )

  return(summary_col)

}


