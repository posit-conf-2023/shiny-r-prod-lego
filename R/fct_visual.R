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
    geom_point(color = "#0055bf", size = 2) +
    geom_line(color = "#0055bf") +
    labs(
      x = "Year",
      y = "New Sets"
    ) +
    theme(
      panel.background = element_rect(fill = "#FFFFFF"),
      axis.ticks = element_blank(),
      panel.grid = element_blank(),
      axis.text = element_text(size = 14),
      axis.title = element_text(size = 12)
    )

  return(p)
}

viz_colors <- function(df, type = c("bar", "area")) {
  type <- match.arg(type)

  p <- ggplot(df, aes(x = year, y = n, fill = I(rgb)))

  if (type == "bar") {
    p <- p + geom_col(position = position_fill(reverse = TRUE), color = "black")
  } else if (type == "area") {
    p <- p + geom_area(position = position_fill(reverse = TRUE), color = "black")
  }

  p <- p +
    scale_y_continuous(labels = scales::percent_format()) +
    labs(
      x = "Year",
      y = "Pieces (%)"
    ) +
    theme(
      panel.background = element_rect(fill = "#FFFFFF"),
      axis.ticks = element_blank(),
      panel.grid = element_blank(),
      axis.text = element_text(size = 14),
      axis.title = element_text(size = 12)
    )

  return(p)
}

viz_parts <- function(df) {
  # Using log scale will turn values of (-Inf, 0] into NaN/Inf & cause warnings
  df <- df |>
    dplyr::filter(num_parts > 0)

  p <- ggplot(df, aes(x = year, y = num_parts, group = year)) +
    geom_boxplot(fill = "goldenrod") +
    scale_y_log10(labels = scales::label_comma()) +
    labs(
      x = "Year",
      y = "Number of Parts"
    ) +
    theme(
      panel.background = element_rect(fill = "#FFFFFF"),
      axis.ticks = element_blank(),
      panel.grid = element_blank(),
      axis.text = element_text(size = 14),
      axis.title = element_text(size = 12)
    )

  return(p)
}