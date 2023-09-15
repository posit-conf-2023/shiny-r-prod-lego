#' @import dplyr
derive_widget_metrics <- function(sets_rv, part_meta_rv) {
  # number of sets
  n_sets <- length(unique(sets_rv$set_num))

  # number of parts
  n_parts <- sum(sets_rv$num_parts, na.rm = TRUE)

  # number of minifigs
  n_minifigs <- part_meta_rv |>
    summarize(total_minifigs = sum(minifig_ind)) |>
    collect() |>
    pull(total_minifigs)

  return(
    list(
      n_sets = n_sets,
      n_parts = n_parts,
      n_minifigs = n_minifigs
    )
  )
}