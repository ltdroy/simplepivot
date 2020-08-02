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
  paste0(round(mean(num), rounding), " (SD: ", round(stats::sd(num), 3), ")")
}

#' Simple Pivot Summary Function: Mean (SE)
#'
#' @param num A numeric vector
#' @param rounding A number, of digits to show
#'
#' @return A string of the form "Mean (SE)"
#' @export
#'
#' @examples
#' simplepivot_mean_sd(c(1,2,3,4,5))
simplepivot_mean_SE <- function(num, rounding=3){
  paste0(round(mean(num), rounding), " (SE: ", round(stats::sd(num)/sqrt(length(num)), 3), ")")
}

#' Simple Pivot Summary Function: Mean (95\% CIs)
#'
#' @param num A numeric vector
#' @param rounding A number, of digits to show
#'
#' @return A string of the form "Mean (95\% CI)"
#' @export
#'
#' @examples
#' simplepivot_mean_sd(c(1,2,3,4,5))
simplepivot_mean_95CI <- function(num, rounding=3){

  mn <- mean(num)
  s_error_multiplier <- stats::qt(0.975, df=length(num) - 1)
  s_error            <- stats::sd(num)/sqrt(length(num))
  paste0(round(mn, rounding),
         " (95% CI: ",
         round(mn - s_error_multiplier * s_error, 3),
         " - ",
         round(mn + s_error_multiplier * s_error, 3),
         ")")
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
  paste0(round(stats::median(num), rounding), " (IQR: ", round(stats::quantile(num, 0.75) - stats::quantile(num, 0.25), 3), ")")
}


