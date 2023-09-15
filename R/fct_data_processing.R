clean_inventories <- function(inventories) {
  inventories <- inventories |>
    dplyr::group_by(set_num) |>
    dplyr::slice_max(version) |>
    dplyr::ungroup() |>
    dplyr::arrange(inventory_id)

  return(inventories)
}

#' @import dplyr
gen_part_metaset <- function(min_set_parts = 1) {
  # derive unique inventory values for each of the inventory data sets
  inv_minifig_ids <- unique(inventory_minifigs$inventory_id)
  inv_set_ids <- unique(inventory_sets$inventory_id)
  inv_part_ids <- unique(inventory_parts$inventory_id)
  
  # update sets data with inventory IDs and derive set types
  df_setmeta <- sets |>
    filter(num_parts > min_set_parts) |>
    left_join(clean_inventories(inventories), by = "set_num") |>
    mutate(include_minifig = (inventory_id %in% inv_minifig_ids)) |>
    mutate(include_parts = (inventory_id %in% inv_part_ids)) |>
    mutate(set_type = case_when(
      include_minifig & !include_parts ~ "minifig_only",
      !include_minifig & include_parts ~ "parts_only",
      include_minifig & include_parts  ~ "parts_and_minifig"
    )) |>
    filter(!is.na(set_type))
  
  # sets with parts only (no mini-figs)
  df_parts_only <- df_setmeta |> 
    filter(set_type == "parts_only") |> 
    select(set_num, inventory_id) |>
    left_join(inventory_parts, by = "inventory_id", suffix = c("", "_invparts")) |>
    left_join(parts, by = "part_num", suffix = c("", "_part")) |>
    mutate(minifig_ind = FALSE, fig_num = NA)
  
  # sets with mini-figs only (no regular parts)
  df_minifigs_only <- df_setmeta |>
    filter(set_type == "minifig_only") |>
    select(set_num, inventory_id) |>
    left_join(inventory_minifigs, by = "inventory_id", suffix = c("", "_invminifigs")) |>
    left_join(minifigs, by = "fig_num", suffix = c("", "_minifig")) |>
    rename(num_parts_minifig = num_parts) |>
    mutate(minifig_ind = TRUE)
  
  minifig_ids <- unique(df_minifigs_only$fig_num)
  
  df_minifigs_indiv_parts <- inventories |>
    filter(set_num %in% minifig_ids) |>
    select(set_num, inventory_id) |>
    left_join(inventory_parts, by = "inventory_id", suffix = c("", "_invparts")) |>
    left_join(parts, by = "part_num", suffix = c("", "_part")) |>
    rename(fig_num = set_num) |>
    left_join(
      df_minifigs_only |>
        select(set_num, fig_num) |>
        distinct(),
      by = "fig_num",
      relationship = "many-to-many"
    ) |>
    mutate(minifig_ind = TRUE)
  
  # sets with parts and mini-figs
  df_both_1 <- df_setmeta |>
    filter(set_type == "parts_and_minifig") |> 
    select(set_num, inventory_id) |>
    left_join(inventory_parts, by = "inventory_id", suffix = c("", "_invparts")) |>
    left_join(parts, by = "part_num", suffix = c("", "_part")) |>
    mutate(minifig_ind = FALSE, fig_num = NA)
  
  df_both_2 <- df_setmeta |>
    filter(set_type == "parts_and_minifig") |> 
    select(set_num, inventory_id) |>
    left_join(inventory_minifigs, by = "inventory_id", suffix = c("", "_invminifigs")) |>
    left_join(minifigs, by = "fig_num", suffix = c("", "_minifig"))
  
  minifig_both_ids <- unique(df_both_2$fig_num)
  
  df_both_2_minifiv_indiv_parts <- inventories |>
    filter(set_num %in% minifig_both_ids) |>
    select(set_num, inventory_id) |>
    left_join(inventory_parts, by = "inventory_id", suffix = c("", "_invparts")) |>
    left_join(parts, by = "part_num", suffix = c("", "_part")) |>
    rename(fig_num = set_num) |>
    left_join(
      df_both_2 |>
        select(set_num, fig_num) |>
        distinct(),
      by = "fig_num",
      relationship = "many-to-many"
    ) |>
    mutate(minifig_ind = TRUE)
  
  df_both <- bind_rows(df_both_1, df_both_2_minifiv_indiv_parts) |>
    arrange(set_num)
  
  df_parts_final <- bind_rows(
    df_parts_only,
    df_minifigs_indiv_parts,
    df_both
  ) |>
    arrange(set_num) |>
    left_join(colors, by = "color_id", suffix = c("", "_color")) |>
    left_join(part_categories, by = "part_cat_id", suffix = c("", "_partcat")) |>
    left_join(
      select(
        sets, set_num, theme_id, year
      ),
      by = "set_num"
    )
  
  return(df_parts_final)
}

#' @import dplyr
calc_part_totals <- function(df, exclude_spares = TRUE, order_by_parts = TRUE, set_ids = NULL) {
  if (!is.null(set_ids)) {
    df <- filter(df, set_num %in% set_ids)
  }
  
  if (exclude_spares) {
    df <- filter(df, !is_spare)
  }
  
  # if year or theme_id columns are present, need to remove them
  if ("year" %in% names(df)) {
    df <- select(df, -year)
  }
  
  if ("theme_id" %in% names(df)) {
    df <- select(df, -theme_id)
  }
  
  # ensure we have unique rows
  df <- distinct(df)

  # compute total sets by part_num and color_id
  df_totals <- df |>
    group_by(part_num, color_id) |>
    summarize(sets_total = n(), part_total = sum(quantity)) |>
    ungroup() |>
    distinct()

  part_summary <- df |>
    select(-set_num, -inventory_id, -quantity, -minifig_ind, -fig_num, -is_spare) |>
    distinct() |>
    left_join(df_totals, by = c("part_num", "color_id"))

  if (order_by_parts) {
    part_summary <- arrange(part_summary, desc(part_total))
  }
  
  collect(part_summary)
}

calc_part_color_totals <- function(sets_rv) {
  input_df <- sets_rv |>
    left_join(
      select(themes, theme_id, theme_name = name),
      by = "theme_id"
    ) |>
    mutate(num_parts = na_if(num_parts, 0)) |>
    inner_join(
      inventories |>
        arrange(desc(version)) |>
        distinct(set_num, .keep_all = TRUE) |>
        select(inventory_id, set_num),
      by = "set_num"
    ) |>
    inner_join(
      inventory_parts,
      by = "inventory_id",
      suffix = c("", "_inventory")
    ) |>
    left_join(
      colors |>
        rename(color = name),
      by = "color_id"
    )

  color_total_df <- input_df |>
    group_by(year, rgb) |>
    summarize(n = n()) |>
    ungroup() |>
    arrange(year, rgb) |>
    #collect() |>
    tidyr::complete(year, rgb, fill = list(n = 0))

  return(color_total_df)
}

calc_part_year_totals <- function(sets_rv) {
  input_df <- sets_rv |>
    group_by(year) |>
    summarize(num_parts_total = sum(num_parts)) |>
    ungroup()

  return(input_df)
}