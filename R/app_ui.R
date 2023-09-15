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
            mod_theme_picker_ui("theme_picker_1")
          ),
          accordion_panel(
            title = "Year",
            icon = icon("calendar"),
            mod_year_picker_ui("year_picker_1")
          ),
          accordion_panel(
            title = "Parts Range",
            icon = icon("toolbox"),
            mod_numparts_picker_ui("numparts_picker_1")
          )
        )
      ),
      nav_panel(
        title = "Explore",
        layout_columns(
          fill = FALSE,
          # TODO: Call your value widgets module (UI) function here
          tags$h3("REPLACE with value widgets")
        ),
        layout_columns(
          navset_card_pill(
            full_screen = TRUE,
            nav_panel(
              "Sets",
              plotOutput("sets_plot")
            ),
            nav_panel(
              "Colors",
              plotOutput("colors_plot")
            ),
            nav_panel(
              "Parts",
              plotOutput("parts_plot")
            )
          )
        )
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
