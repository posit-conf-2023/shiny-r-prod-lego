## code to prepare `lego_sets` dataset goes here
lego_sets <- readr::read_csv('inst/extdata/lego_sets.csv')
usethis::use_data(lego_sets, overwrite = TRUE)
