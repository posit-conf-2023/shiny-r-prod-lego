derive_parts_range <- function(grouping = c("all", "small", "medium", "large")) {
  grouping <- match.arg(grouping)

  # in the case of 'all' or 'large', just use a massively large max
  part_range <- dplyr::case_when(
    grouping == "small" ~ c(1, 50),
    grouping == "medium" ~ c(51, 200),
    grouping == "large" ~ c(201, 1000000),
    grouping == "all" ~ c(0, 1000000)
  )

  return(part_range)
}
