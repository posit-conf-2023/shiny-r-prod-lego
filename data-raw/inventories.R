## code to prepare `inventories` dataset goes here
inventories <- readr::read_csv('https://shinyprod2023.us-east-1.linodeobjects.com/lego-data/2023-08-15/inventories.csv.gz')

# certain sets have multiple inventories recorded, which are denoted by 
# the version column (integer)
# take the maximum version ID for each set_num so we only have 1 record per set
# inventories <- inventories |>
#   dplyr::group_by(set_num) |>
#   dplyr::slice_max(version) |>
#   dplyr::ungroup() |>
#   dplyr::arrange(id)

# rename id to inventory_id to ease merging with other tables
inventories <- dplyr::rename(inventories, inventory_id = id)

usethis::use_data(inventories, overwrite = TRUE)
