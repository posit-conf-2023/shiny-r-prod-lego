## code to prepare `part_relationships` dataset goes here
part_relationships <- readr::read_csv('https://shinyprod2023.us-east-1.linodeobjects.com/lego-data/2023-08-15/part_relationships.csv.gz')
usethis::use_data(part_relationships, overwrite = TRUE)
