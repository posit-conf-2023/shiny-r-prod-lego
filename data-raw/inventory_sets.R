## code to prepare `inventory_sets` dataset goes here
inventory_sets <- readr::read_csv('https://shinyprod2023.us-east-1.linodeobjects.com/lego-data/2023-08-15/inventory_sets.csv.gz')
usethis::use_data(inventory_sets, overwrite = TRUE)
