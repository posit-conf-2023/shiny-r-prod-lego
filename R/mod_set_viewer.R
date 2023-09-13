#' set_viewer UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList uiOutput
mod_set_viewer_ui <- function(id){
  ns <- NS(id)
  tagList(
    uiOutput(ns("image"))
  )
}
    
#' set_viewer Server Functions
#'
#' @noRd 
#' 
#' @importFrom shiny renderUI
mod_set_viewer_server <- function(id, set_url, width = "400px", height = "auto"){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

    output$image <- renderUI({
      req(set_url())
      tags$img(src = set_url(), style = glue::glue("width: {width}; height: {height};"))
    })
  })
}
    
## To be copied in the UI
# mod_set_viewer_ui("set_viewer_1")
    
## To be copied in the server
# mod_set_viewer_server("set_viewer_1")
