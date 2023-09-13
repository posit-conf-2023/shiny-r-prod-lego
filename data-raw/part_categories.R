## code to prepare `part_categories` dataset goes here
part_categories <- readr::read_csv('https://shinyprod2023.us-east-1.linodeobjects.com/lego-data/2023-08-15/part_categories.csv.gz')

# rename id to part_cat_id to ease merging with other tables
part_categories <- dplyr::rename(part_categories, part_cat_id = id)
usethis::use_data(part_categories, overwrite = TRUE)
