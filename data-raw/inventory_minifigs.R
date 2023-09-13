## code to prepare `inventory_minifigs` dataset goes here
inventory_minifigs <- readr::read_csv('https://shinyprod2023.us-east-1.linodeobjects.com/lego-data/2023-08-15/inventory_minifigs.csv.gz')
usethis::use_data(inventory_minifigs, overwrite = TRUE)
