#' Simple Pivot Summary Function: Mean (SD)
#'
#' @param num A numeric vector
#' @param rounding A number, of digits to show
#'
#' @return A string of the form "Mean (SD)"
#' @export
#'
#' @examples
#' simplepivot_mean_sd(c(1,2,3,4,5))
simplepivot_mean_sd <- function(num, rounding=3){
  paste0(round(mean(num), rounding), " (", round(stats::sd(num), 3), ")")
}

#' Simple Pivot Summary Function: Median (IQR)
#'
#' @param num A numeric vector
#' @param rounding A number, of digits to show
#'
#' @return A string of the form "Median (IQR)"
#' @export
#'
#' @examples
#' simplepivot_median_IQR(c(1,2,3,4,5))
simplepivot_median_IQR <- function(num, rounding=3){
  paste0(round(stats::median(num), rounding), " (", round(stats::quantile(num, 0.75) - stats::quantile(num, 0.25), 3), ")")
}


