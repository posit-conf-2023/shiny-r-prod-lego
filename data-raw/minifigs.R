## code to prepare `minifigs` dataset goes here
minifigs <- readr::read_csv('https://shinyprod2023.us-east-1.linodeobjects.com/lego-data/2023-08-15/minifigs.csv.gz')
usethis::use_data(minifigs, overwrite = TRUE)
