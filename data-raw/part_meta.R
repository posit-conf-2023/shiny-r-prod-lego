# create a part metadata set and save to parquet
# need to import following data sets from the CSV files:
# - sets
# - inventories
# - inventory_minifigs
# - inventory_sets
# - inventory_parts
# - parts
# - part_categories
# - minifigs
# - colors

# load packages
library(dplyr)
library(arrow)

# load data sets and perform pre-processing if needed

# sets
sets <- readr::read_csv('https://shinyprod2023.us-east-1.linodeobjects.com/lego-data/2023-08-15/sets.csv.gz')

# inventories
inventories <- readr::read_csv('https://shinyprod2023.us-east-1.linodeobjects.com/lego-data/2023-08-15/inventories.csv.gz')

# rename id to inventory_id to ease merging with other tables
inventories <- dplyr::rename(inventories, inventory_id = id)

# need to perform cleaning
inventories <- inventories |>
    group_by(set_num) |>
    slice_max(version) |>
    ungroup() |>
    arrange(inventory_id)

# inventory_minifigs
inventory_minifigs <- readr::read_csv('https://shinyprod2023.us-east-1.linodeobjects.com/lego-data/2023-08-15/inventory_minifigs.csv.gz')

# inventory_sets
inventory_sets <- readr::read_csv('https://shinyprod2023.us-east-1.linodeobjects.com/lego-data/2023-08-15/inventory_sets.csv.gz')

# inventory_parts
inventory_parts <- readr::read_csv('https://shinyprod2023.us-east-1.linodeobjects.com/lego-data/2023-08-15/inventory_parts.csv.gz')

# parts
parts <- readr::read_csv('https://shinyprod2023.us-east-1.linodeobjects.com/lego-data/2023-08-15/parts.csv.gz')

# part_Categories
part_categories <- readr::read_csv('https://shinyprod2023.us-east-1.linodeobjects.com/lego-data/2023-08-15/part_categories.csv.gz')

# rename id to part_cat_id to ease merging with other tables
part_categories <- dplyr::rename(part_categories, part_cat_id = id)

# minifigs
minifigs <- readr::read_csv('https://shinyprod2023.us-east-1.linodeobjects.com/lego-data/2023-08-15/minifigs.csv.gz')

# colors
colors <- readr::read_csv('https://shinyprod2023.us-east-1.linodeobjects.com/lego-data/2023-08-15/colors.csv.gz')

# rename id to color_id to ease merging with other tables
colors <- dplyr::rename(colors, color_id = id)

# pre-pend "#" in front of rgb values
colors <- dplyr::mutate(colors, rgb = paste0("#", rgb))

# derive unique inventory values for each of the inventory data sets
inv_minifig_ids <- unique(inventory_minifigs$inventory_id)
inv_set_ids <- unique(inventory_sets$inventory_id)
inv_part_ids <- unique(inventory_parts$inventory_id)

# update sets data with inventory IDs and derive set types
min_set_parts <- 1

df_setmeta <- sets |>
  filter(num_parts > min_set_parts) |>
  left_join(inventories, by = "set_num") |>
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

part_meta_df <- bind_rows(
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

# write to parquet file
arrow::write_parquet(
  part_meta_df,
  "inst/extdata/part_meta_df.parquet"
)

# write to csv file
write.csv(part_meta_df, file = "inst/extdata/part_meta.csv", row.names = FALSE)
