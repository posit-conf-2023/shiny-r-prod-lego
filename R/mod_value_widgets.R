#' value_widgets UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList uiOutput
#' @importFrom bslib layout_columns
mod_value_widgets_ui <- function(id){
  ns <- NS(id)
  tagList(
    layout_columns(
      fill = FALSE,
      uiOutput(ns("widget1")),
      uiOutput(ns("widget2")),
      uiOutput(ns("widget3"))
    )
  )
}
    
#' value_widgets Server Functions
#'
#' @importFrom shiny reactive renderUI
#' @importFrom bslib value_box
#' @noRd 
mod_value_widgets_server <- function(id, sets_rv, part_meta_rv){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

    metrics_rv <- reactive({
      derive_widget_metrics(sets_rv(), part_meta_rv())
    })
    
    output$widget1 <- renderUI({
      req(metrics_rv())
      value_box(
        title = "A Total of",
        value = paste(prettyNum(metrics_rv()$n_sets, big.mark = ","), "sets"),
        showcase = tags$img(src = "https://img.icons8.com/external-icongeek26-flat-icongeek26/64/external-Lego-Toys-school-icongeek26-flat-icongeek26.png", width='64', height = '64')
      )
    })
    
    output$widget2 <- renderUI({
      req(metrics_rv())
      value_box(
        title = "Containing",
        value = paste(prettyNum(metrics_rv()$n_parts, big.mark = ","), "parts"),
        showcase = tags$img(src = "https://img.icons8.com/officel/80/plugin.png", width='80', height = '80')
      )
    })

    output$widget3 <- renderUI({
      req(metrics_rv())
      value_box(
        title = "Including",
        value = paste(prettyNum(metrics_rv()$n_minifigs, big.mark = ","), "Mini-Figs"),
        showcase = tags$img(src = "https://img.icons8.com/color/48/lego-head.png", width='96', height = '96')
      )
    })
  })
}
    
## To be copied in the UI
# mod_value_widgets_ui("value_widgets_1")
    
## To be copied in the server
# mod_value_widgets_server("value_widgets_1")
