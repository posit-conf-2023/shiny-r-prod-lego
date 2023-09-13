## code to prepare `parts` dataset goes here
parts <- readr::read_csv('https://shinyprod2023.us-east-1.linodeobjects.com/lego-data/2023-08-15/parts.csv.gz')
usethis::use_data(parts, overwrite = TRUE)
