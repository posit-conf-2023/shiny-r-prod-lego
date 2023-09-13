#' part_table UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_part_table_ui <- function(id){
  ns <- NS(id)
  tagList(
    reactable::reactableOutput(ns("tbl"))
  )
}
    
#' part_table Server Functions
#'
#' @noRd 
#' 
#' @importFrom reactable renderReactable
mod_part_table_server <- function(id, df_summary, single_set = FALSE){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

    output$tbl <- reactable::renderReactable({
      req(df_summary())
      parts_table(df_summary(), single_set = single_set)
    }) 
  })
}
    
## To be copied in the UI
# mod_part_table_ui("part_table_1")
    
## To be copied in the server
# mod_part_table_server("part_table_1")
