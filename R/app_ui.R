#' The application User-Interface
#'
#' @param request Internal parameter for `{shiny}`.
#'     DO NOT REMOVE.
#' @import shiny
#' @import bslib
#' @noRd
app_ui <- function(request) {
  tagList(
    # Leave this function for adding external resources
    golem_add_external_resources(),
    # Your application UI logic
    page_navbar(
      title = tags$span(
        tags$img(src = "https://img.icons8.com/color/48/lego.png", width = "48", height = "48"),
        "Rebrickable Dashboard"
      ),
      sidebar = sidebar(
        title = NULL,
        width = 300,
        accordion(
          id = "accord",
          open = c("Theme"),
          accordion_panel(
            title = "Theme",
            icon = icon("palette"),
            # TODO: Add UI for selecting theme
            tags$b("REPLACE (Theme selection)")
          ),
          accordion_panel(
            title = "Year",
            icon = icon("calendar"),
            # TODO: Add UI for selecting year range
            tags$b("REPLACE (Year selection)")
          ),
          accordion_panel(
            title = "Parts Range",
            icon = icon("toolbox"),
            # TODO: Add UI for selecting parts range
            tags$b("REPLACE (Parts range selection)")
          )
        )
      ),
      nav_panel(
        title = "Explore",
        layout_columns(
          fill = FALSE,
          # TODO: Add value box widgets
          tags$h3("REPLACE with value widgets")
        ),
        layout_columns(
          navset_card_pill(
            full_screen = TRUE,
            nav_panel(
              "Sets",
              # TODO: Add plot for number of sets by year
              tags$h3("REPLACE with plot")
            )
          )
        ),
        layout_columns(
          card(
            full_screen = TRUE,
            card_header(
              "Parts Summary"
            ),
            # TODO: Add parts summary table
            tags$h3("REPLACE with summary table")
          )
        )
      ),
      nav_panel(
        title = "Details",
        layout_columns(
          # TODO: add UI for selecting a single set
          tags$h3("REPLACE (set selector)")
        ),
        # TODO: Add parts summary table
        tags$h3("REPLACE with summary table")
      ),
      nav_panel(
        title = "Prediction",
        # TODO: add UI for prediction of number of parts
        tags$h3("REPLACE with prediction interface")
      )
    )
  )
}

#' Add external Resources to the Application
#'
#' This function is internally used to add external
#' resources inside the Shiny application.
#'
#' @import shiny
#' @importFrom golem add_resource_path activate_js favicon bundle_resources
#' @noRd
golem_add_external_resources <- function() {
  add_resource_path(
    "www",
    app_sys("app/www")
  )

  tags$head(
    favicon(),
    bundle_resources(
      path = app_sys("app/www"),
      app_title = "legobricks.app"
    ),
    # Add here other external resources
    # for example, you can add shinyalert::useShinyalert()
  )
}
