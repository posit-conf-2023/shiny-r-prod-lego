#' Number of sets per year
#'
#' @description Line plot of the number of sets per year
#'
#' @return plot object
#'
#' @noRd
#' @importFrom dplyr count
#' @import ggplot2
viz_sets <- function(sets_rv) {
  p <- sets_rv |>
    count(year) |>
    ggplot(aes(x = year, y = n)) +
    geom_point() +
    geom_line() +
    labs(
      x = "Year",
      y = "New Sets"
    )

  return(p)
}

viz_colors <- function(df, type = c("bar", "area")) {
  type <- match.arg(type)

  p <- ggplot(df, aes(x = year, y = n, fill = I(rgb)))

  if (type == "bar") {
    p <- p + geom_col(position = position_fill(reverse = TRUE))
  } else if (type == "area") {
    p <- p + geom_area(position = position_fill(reverse = TRUE))
  }

  p <- p +
    scale_y_continuous(labels = scales::percent_format()) +
    labs(
      x = "Year",
      y = "Pieces (%)"
    )
    theme_minimal() +
    theme(panel.grid = element_blank())

  return(p)
}

viz_parts <- function(df) {
  p <- ggplot(df, aes(x = year, y = num_parts, group = year)) +
    geom_boxplot() +
    scale_y_log10() +
    labs(
      x = "Year",
      y = "Number of Parts"
    )

  return(p)
}