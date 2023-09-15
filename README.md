
<!-- README.md is generated from README.Rmd. Please edit that file -->

# brickapp

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
<!-- badges: end -->

`{brickapp}` is a Shiny application that provides statistical summaries,
visualizations, and predictions based on the LEGO inventory metadata
originating from the [rebrickable](https://rebrickable.com/home/) LEGO
parts portal. Throughout the [Shiny in Production: Tools and
Techniques](https://posit-conf-2023.github.io/shiny-r-prod/) workshop at
[posit::conf(2023)](https://posit.co/conference/), the workshop
participants will practice enhancing this application for use in a
production setting.

## Workshop Instructions

The project used for this particular exercise / demonstration is hosted
on [Posit Cloud](https://posit.cloud) in this
[space](https://posit.cloud/spaces/400774/join?access_code=DDgV_peF5WCCCpB5JHjQtMN2aHByWoNF0k5p8Wp7).

After opening the project, perform the following steps to set up the R
environment:

1.  In the R console, the `{renv}` package will begin to bootstrap
    itself into the package library. You will likely see a message
    indicating one or more packages in the lockfile are not installed.
    In the R console, run the following command to restore the complete
    package library: `renv::restore(prompt = FALSE)` .
2.  In the **Git** tab of the RStudio IDE panel, select the
    **modules-exercise1** branch to load the files associated with this
    particular exercise / demonstration
3.  Inspect the application source code and begin updating the
    application code. You will find placeholders for adding code with
    the comments `# TODO:`.

## Exercise Instructions

Your task is to create a new Shiny module that displays three important
metrics to the user: \* Total number of sets \* Total number of parts
among the sets \* Total number of mini-figures

Note that these quantities are dependent on the user selections from the
inputs contained in the left sidebar (theme, year, and parts range).

Keeping with the overall user interface style, you are recommended to
use the
[`value_box`](https://rstudio.github.io/bslib/reference/value_box.html)
function from the [`{bslib}`](https://rstudio.github.io/bslib/) package.
The metrics can be derived using the function below. In the application
code, you will find reactive data frames called `sets_rv` and
`part_meta_rv` which can be used in the parameters of the function
below.

``` r
#' Derive key LEGO data set metrics
#' 
#' @param sets_rv data frame containing sets information
#' @param part_meta_rv data frame containing parts metadata information
#' 
#' @import dplyr
derive_widget_metrics <- function(sets_rv, part_meta_rv) {
  # number of sets
  n_sets <- length(unique(sets_rv$set_num))

  # number of parts
  n_parts <- sum(sets_rv$num_parts, na.rm = TRUE)

  # number of minifigs
  n_minifigs <- part_meta_rv |>
    summarize(total_minifigs = sum(minifig_ind)) |>
    collect() |>
    pull(total_minifigs)

  return(
    list(
      n_sets = n_sets,
      n_parts = n_parts,
      n_minifigs = n_minifigs
    )
  )
}
```

## Code of Conduct

Please note that the brickapp project is released with a [Contributor
Code of
Conduct](https://contributor-covenant.org/version/2/1/CODE_OF_CONDUCT.html).
By contributing to this project, you agree to abide by its terms.
