## code to prepare `colors` dataset goes here
colors <- readr::read_csv('https://shinyprod2023.us-east-1.linodeobjects.com/lego-data/2023-08-15/colors.csv.gz')

# rename id to color_id to ease merging with other tables
colors <- dplyr::rename(colors, color_id = id)

# pre-pend "#" in front of rgb values
colors <- dplyr::mutate(colors, rgb = paste0("#", rgb))

usethis::use_data(colors, overwrite = TRUE)
