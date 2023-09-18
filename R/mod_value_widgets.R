#' value_widgets UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList textOutput
#' @importFrom bslib layout_columns value_box
mod_value_widgets_ui <- function(id){
  ns <- NS(id)
  tagList(
    layout_columns(
      fill = FALSE,
      value_box(
        title = "A Total of",
        value = textOutput(outputId = ns("widget1_value"), inline = TRUE),
        showcase = tags$img(src = "https://img.icons8.com/external-icongeek26-flat-icongeek26/64/external-Lego-Toys-school-icongeek26-flat-icongeek26.png", width='64', height = '64')
      ),
      value_box(
        title = "Containing",
        value = textOutput(outputId = ns("widget2_value"), inline = TRUE),
        showcase = tags$img(src = "https://img.icons8.com/officel/80/plugin.png", width='80', height = '80')
      ),
      value_box(
        title = "Including",
        value = textOutput(outputId = ns("widget3_value"), inline = TRUE),
        showcase = tags$img(src = "https://img.icons8.com/color/48/lego-head.png", width='96', height = '96')
      )
    )
  )
}

#' value_widgets Server Functions
#'
#' @importFrom shiny reactive renderText
#' @noRd
mod_value_widgets_server <- function(id, sets_rv, part_meta_rv){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

    metrics_rv <- reactive({
      derive_widget_metrics(sets_rv(), part_meta_rv())
    })

    output$widget1_value <- renderText({
      req(metrics_rv())
      paste(prettyNum(metrics_rv()$n_sets, big.mark = ","), "sets")
    })

    output$widget2_value <- renderText({
      req(metrics_rv())
      paste(prettyNum(metrics_rv()$n_parts, big.mark = ","), "parts")
    })

    output$widget3_value <- renderText({
      req(metrics_rv())
      paste(prettyNum(metrics_rv()$n_minifigs, big.mark = ","), "Mini-Figs")
    })
  })
}

## To be copied in the UI
# mod_value_widgets_ui("value_widgets_1")

## To be copied in the server
# mod_value_widgets_server("value_widgets_1")
