## code to prepare `inventory_parts` dataset goes here
inventory_parts <- readr::read_csv('https://shinyprod2023.us-east-1.linodeobjects.com/lego-data/2023-08-15/inventory_parts.csv.gz')
usethis::use_data(inventory_parts, overwrite = TRUE)
