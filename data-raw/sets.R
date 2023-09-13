## code to prepare `sets` dataset goes here
sets <- readr::read_csv('https://shinyprod2023.us-east-1.linodeobjects.com/lego-data/2023-08-15/sets.csv.gz')

usethis::use_data(sets, overwrite = TRUE)
