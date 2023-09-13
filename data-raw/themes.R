## code to prepare `themes` dataset goes here
themes <- readr::read_csv('https://shinyprod2023.us-east-1.linodeobjects.com/lego-data/2023-08-15/themes.csv.gz')

# rename id to theme_id to ease merging with other tables
themes <- dplyr::rename(themes, theme_id = id)

usethis::use_data(themes, overwrite = TRUE)
