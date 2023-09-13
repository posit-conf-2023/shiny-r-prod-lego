## code to prepare `elements` dataset goes here
elements <- readr::read_csv('https://shinyprod2023.us-east-1.linodeobjects.com/lego-data/2023-08-15/elements.csv.gz')
usethis::use_data(elements, overwrite = TRUE)
